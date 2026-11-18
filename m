Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023695;
	b=Syt25cG/HuqSdqOWIkYPHiqT4kyArmKQhRqphN3Hhq0FeBhpg+6xgMvgDpnkxrLvGC83
	 kG73urg+HKKObFbCmvjn0FfqIdO2Ws7PlzdMIftTbuPvbguY50egkZxEx8fQshWlCv3Cr
	 W/hk/lmH2PiW1R+Zo85SjZErJ0LuqNN9VFCwlp8WJJcBYdUqFvELbSCkEY2ap3SwfuKo/
	 kggicsig9GajC7Fl61eIKrLt/4vvNo7FgppRa756NlFeTo6twWZWcanwnOF6QIkuKzuS1
	 cV7fujdZGi+DLFd32XRaagRwtzIvVx2Q+D8yrah+5n0we0d5SP0EVIHkIq3boImITJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qYWDAV1DdQPw7DlWFwVE8ZHEZmQhD+u/t5bnrQsXsXo=;
	b=P9TAI06LlyfamajxPzhxp7ahMKUlDCcCrbZ7HtZSti3oa+P2SXhBOFo33LT9hpcT9OFD
	 bm4EIe7VtRl2PkI3YX9JVB2RCtpnHGqvVIuxqcaxG2LBGLnDPnrGg8dYp19EHEtIIdFEl
	 nE+N8/q74VBCWLDLKOMl2f3H8puIjCz5M8gl9gUUj0NQqSFcCjzlaiyeINVYhhgwK1CS+
	 UwCEWL9PJiKwV1mq2kWATwOYgX+E++Lkvl1Llcx2d4q3H0m7T2PUHgO0Xu8sp7jTyD+/R
	 +3MjlxewaXjwQeqGmGizeM43LPA64yq3R/9UhUJc4/VAMsZw4lHWc0Yw1Idw28RQ2mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxcoq0Op;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C991E606A320;
	Wed, 18 Nov 2026 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mxcoq0Op
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1988C1F000C4;
	Wed, 18 Nov 2026 17:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023695;
	bh=qYWDAV1DdQPw7DlWFwVE8ZHEZmQhD+u/t5bnrQsXsXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxcoq0Opj9hbF9h0D2AHGQFb9ftzMu671D3j6tYRmdosgiZqnqJHObi+MY6fHjV5H
	 IM0Ghi+XMiFUf7r4Ot4bDfnMtJk1zGP8UhXbHpv4GIQ6wSEYV46sVVNWQ7uuiSTD0s
	 QSs0M+7gP+rBPCuSLkhe8wahcNyisxHwwcX7rxew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0460/2151] fs/ntfs3: reject FS_IOC_SETFSLABEL on readonly mounts
Date: Wed, 18 Nov 2026 15:36:35 +0100
Message-ID: <20261118150138.782905816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 5d3e03b70d05162ca49830efcd8b1cd2746a86a3 ]

FS_IOC_SETFSLABEL does not check for readonly mounts and
can report success without persisting the label change.

Return -EROFS on readonly mounts.

Fixes: 21dc07ac9c25 ("ntfs3: add FS_IOC_SETFSLABEL ioctl")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 13d623560120c..d5cd8fe6dd868 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -65,6 +65,9 @@ static int ntfs_ioctl_set_volume_label(struct ntfs_sb_info *sbi, u8 __user *buf)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (sb_rdonly(sbi->sb))
+		return -EROFS;
+
 	if (copy_from_user(user, buf, FSLABEL_MAX))
 		return -EFAULT;
 
-- 
2.53.0



