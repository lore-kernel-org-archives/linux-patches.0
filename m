Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033292;
	b=elovUEtOA0UhNLN3ZTgexeyxsom7qGi/8BYvK/Mn+GZjSC45z03/stK4p9/4MP47zYMb
	 sJkh0zUTVhwM0WRS3QTD5JMHwGl2/6+bU7DZ1pHGbVnH6n6i+BENup8coZwlJi3gyHpN0
	 Hr8oqGJG+xwyrwr8X2VsWjk4Syy17USlatyOiFjBy4lituDweXBbrjrkuV89MdX/FiOBr
	 AALdQP9jCM/N7sJUtSfl7jmBj0nXS5EcOOQEfaSAcTzDq8WAVmKly9S2qJib3WbJE37yO
	 J0WQTMyglZhxrp1Y1ygHwvPICr/n1dNOspGzJ9IQ+fDbbUTluw4ImYAnZItXJja2r4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2z8YwWO/eXdMoL/IGOtIgBaItN00O59Vz6KUL7FgNR0=;
	b=oQWxPjGnUVrFoMCT0Y7VjAw+TP15LHdHscPhlc+hTTwx2QOG+7CghWAVp4fK3bfRCLEL
	 o3zDk4J0lJsV6F3oma92rxx7sBoI2ML4Rq3TybRBsk4DfcKK9/guLuM33qwUxxEyD17Nq
	 bIZnHlZCOFaChuVDqk3OYL/8CmKSZyky/SFydCWKJ1IgWyvxZ7+E0EdE6wbGpP3qejwwF
	 3j4UjUTLYOkCLh9WCwBO3bnyuwdup+/dNb/Yr19mO8TMiYQy3eNWuOIAOpSicQnNGpWaW
	 1eAeD9/iiMnld+LAYHJ/f7/BN/tFCV0bbjq80L+SIAcegDpQ3FFH1bPuKUw039S568w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q66VinSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8FC606A31C;
	Wed, 18 Nov 2026 20:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q66VinSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47BC1F000C4;
	Wed, 18 Nov 2026 20:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033292;
	bh=2z8YwWO/eXdMoL/IGOtIgBaItN00O59Vz6KUL7FgNR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q66VinSalTra8GaT9KgYEjdP9F1Nu7vQtvFlIRZe41uFkoo/t4F7G4dSfWJlSUMde
	 1xWsSRigWxkF4Bf6A9HXzmyCUl0nHPkZgUNJvdqdIOismrSZ8c4dhMnX9M1+uB/7Ur
	 v/RjIiNTzEJGujO4fTM6WU9dQuAWbt38ZwDAjQGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8420e667af06b1709c00@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1717/1756] minix: reject rmdir of a directory with a corrupted link count
Date: Wed, 18 Nov 2026 16:04:04 +0100
Message-ID: <20261118150117.954630442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit fc9577079df8a44ccbf39d2f06634017d286e4f0 ]

minix_rmdir() calls minix_unlink(), which drops the victim's link
count once, and then drops it a second time for the "." entry. An
image where an empty directory has i_nlink < 2 makes the second drop
hit drop_nlink() with i_nlink == 0:

  WARNING: fs/inode.c:408 at drop_nlink
   minix_rmdir+0xe9/0x150
   vfs_rmdir
   filename_rmdir
   __do_sys_unlinkat

The parent's link count is already validated; do the same for the
directory being removed and fail with -EFSCORRUPTED.

Reported-by: syzbot+8420e667af06b1709c00@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8420e667af06b1709c00
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20261016115851.14276-1-ngocthang2710.1999@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/namei.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 35e3e5947be7a..3e4102bb8fbf5 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -167,6 +167,10 @@ static int minix_rmdir(struct inode * dir, struct dentry *dentry)
 		minix_error_inode(dir, "inode has corrupted nlink");
 		goto out;
 	}
+	if (inode->i_nlink < 2) {
+		minix_error_inode(inode, "inode has corrupted nlink");
+		goto out;
+	}
 
 	err = -ENOTEMPTY;
 	if (!minix_empty_dir(inode))
-- 
2.53.0



