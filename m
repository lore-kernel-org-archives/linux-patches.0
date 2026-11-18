Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031610;
	b=GC3PDjf7rDSYtWDhYcJmGtCl1X3USST7u7dIJCMw+eTHu4BTqf2Hd5LH588ln4rzvkXD
	 yf/KmsWkNX7nZVLMQyTVdZNBc5OQ7ebySXCApXVwU3F0/o+v+IWv3JDYs/LOxFcvkJgHB
	 Pu9hAvsWwIrI7AsQPFcvw1PyEC67f2mVT1Q04NpcYg66AEcSbIfj8S23HEh3ID4kcQQ/R
	 aU+T78h8qHUfRn92OJQfuy6XFtic4iwvSNxctb/bAOZWQovVwrR4S+BYJQOrVXYcSSL3L
	 feSC0Ly5DI/fuC1PE6KrZgHKbDNerlkuo9jgrRhKZejYyCanmfv+g22LYHlZdq1uzXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OY6EL2cGEQFnTiBP7BUe1Iv7ybXptmCUoHw+C+SO8pg=;
	b=Ik+yXFglwrKUW0oDU6bmYbde8PNrWXuW8WdMV2eg5Ka3pB2mdgKoFM9KDd+1JFSuYyrv
	 dGxZNBqdzNuq5seMKJ4N0JSiPMqb+MC1HV7sWGJo34aPOArJT/UAt00PDssglIE7ugAZn
	 HUyi7BcNgYOTw/6ofo75TM23Uw8MFjh+H22mjng76fIgHK/iTaVLZi6xFtKIrwhjU4g/m
	 VUmQWKLpUvwB0AfsK7nH/ypIxjI/idmKZ1Bm3wPsbiSIN0xMTU80/RJGw8qeujzEond6p
	 7JWILrCiP455w8yYvDCP8mWTe0XRGKiETu2pIeGnPGE9u3kVAlWVypTRl8NJXFITRew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZh40wAi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E34606A330;
	Wed, 18 Nov 2026 19:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MZh40wAi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE371F000C6;
	Wed, 18 Nov 2026 19:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031610;
	bh=OY6EL2cGEQFnTiBP7BUe1Iv7ybXptmCUoHw+C+SO8pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZh40wAi57fCEnWqQA3h2XkQm6k14tuA5Teb+pf6ldM5AnODRJ4Jez6DDhGM8DNWv
	 g9ZfwUXv7u5Wcklsf0fc/oFQUoCrguiJk+rOYIZ3MzI5UdBzmqDdEjeetQkoSyz3Fw
	 kGoWEUcbD3MHoncspEwen/RVJGEFZlEmQTrzw/q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Ferguson <ethan.ferguson@zetier.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1119/1756] ntfs3: add FS_IOC_SETFSLABEL ioctl
Date: Wed, 18 Nov 2026 15:54:06 +0100
Message-ID: <20261118150054.670363536@linuxfoundation.org>
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

From: Ethan Ferguson <ethan.ferguson@zetier.com>

[ Upstream commit 21dc07ac9c25f01ab2023e3e8605861d8fd6e00c ]

Add support for the FS_IOC_SETFSLABEL ioctl.

Signed-off-by: Ethan Ferguson <ethan.ferguson@zetier.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 80218408836f ("fs/ntfs3: do not mark frame pages uptodate on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index fd46160f48484..b33648f109781 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -57,6 +57,22 @@ static int ntfs_ioctl_get_volume_label(struct ntfs_sb_info *sbi, u8 __user *buf)
 	return 0;
 }
 
+static int ntfs_ioctl_set_volume_label(struct ntfs_sb_info *sbi, u8 __user *buf)
+{
+	u8 user[FSLABEL_MAX] = {0};
+	int len;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(user, buf, FSLABEL_MAX))
+		return -EFAULT;
+
+	len = strnlen(user, FSLABEL_MAX);
+
+	return ntfs_set_label(sbi, user, len);
+}
+
 /*
  * ntfs_fileattr_get - inode_operations::fileattr_get
  */
@@ -154,6 +170,8 @@ long ntfs_ioctl(struct file *filp, u32 cmd, unsigned long arg)
 		return ntfs_ioctl_fitrim(sbi, arg);
 	case FS_IOC_GETFSLABEL:
 		return ntfs_ioctl_get_volume_label(sbi, (u8 __user *)arg);
+	case FS_IOC_SETFSLABEL:
+		return ntfs_ioctl_set_volume_label(sbi, (u8 __user *)arg);
 	}
 	return -ENOTTY; /* Inappropriate ioctl for device. */
 }
-- 
2.53.0



