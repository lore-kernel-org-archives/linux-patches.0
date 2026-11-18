Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016331;
	b=ZhEL1I0WE1AGuAfUqFHGYNzvkKZn2WbsUQfV5f5erg5UPvcB14fQWVwgAUT0dayraW6c
	 tMHjJ/EY92KQ8Alojx+UEZnnif5RUyqsU1WiyK8oqba+eqHeIJ2XWDmwBYioagh6lFFZk
	 Wj/GF9xnfvK24rGpQgWhD2qMojwn9mRPJ2EXahIXNMEw0qTjgnYc+YkV41PLZPCyFIZS0
	 vxUOs9Q0D+z7x1GDGI10YxypcIwbE8tsTiFAlrWQ2O0z3or9tWZbE7tW/HnZRKVxjVIHQ
	 ivQ4glAEmlEqMJx6ZAQCMNxq519f0cEMNHwyqFRj3OE05I9vgAKLgggEwMeIONg2AJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E5pJT6V78glft4BZt0JQuD/0HMGyeMcHI3aZkLFP9o0=;
	b=zCwkJpOU6F5OgDcMB2W+GY7I0IFtqXxkGFTJyl09sl3KC3Sd+lBTj2Ma3CpRcaToTByb
	 T2a0AmJ9clE8wBwOdZBTirwE/AEgLMr9LTySJ7jmRtscU3ftUCmuJBcHu2Rr8D/ZjgmWX
	 +qPuMR2KX0q2NCC5ZPAVFMkKRIy6Hi8/ntB8HHk0RC1e9GXPw0PhFCXmMN3WCZ08mPv44
	 EaOVZ59CVUxBJqkaQm9IYXIGsvP5Kzp+oaZi4Q4cbc+Nru4gF1yeChZSuTOfHQWwc9zzp
	 vkzAziTYe1tpx0sfQME5PISF/rAmC/R2GQaSb/avnZt4vELVoJwKkpsrpeuvROGPQ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obpuy1mP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC341606A330;
	Wed, 18 Nov 2026 15:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obpuy1mP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAEA1F000C4;
	Wed, 18 Nov 2026 15:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016331;
	bh=E5pJT6V78glft4BZt0JQuD/0HMGyeMcHI3aZkLFP9o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obpuy1mPywKt+7Qkfspr4MaClssO3QH5z+ASoDv91/yn6YJlmPvqu9P4nOHjRL4a/
	 8LmUlWB6cY5kRQxxuGjlF/e/wAz+4drcy+dXNE/Se50qTs2UwtNMfdDKJiK9eNBlsL
	 TOfQmsftoLcxUQhaNpySctronUURC1Au5TqhxqhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0491/2651] fs/ntfs3: reject FS_IOC_SETFSLABEL on readonly mounts
Date: Wed, 18 Nov 2026 15:28:51 +0100
Message-ID: <20261118150305.456407629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2abf334bfa0cf..95dfe68788605 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -183,6 +183,9 @@ static int ntfs_ioctl_set_volume_label(struct ntfs_sb_info *sbi, u8 __user *buf)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (sb_rdonly(sbi->sb))
+		return -EROFS;
+
 	if (copy_from_user(user, buf, FSLABEL_MAX))
 		return -EFAULT;
 
-- 
2.53.0



