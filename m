Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031607;
	b=w5DhX1QeVObKugy5ni/s4H6y4m2062AAYN5hO5GNgkJSgiCZNwzDTY4bgD0ccgMcQjL/
	 KHTg5WyfsewwZycBSqQW7BUmIgbWlknDYG+/VPDjc+B8//ZM95M4TcJw2cKwfqfgrh4xx
	 PPTEwihB310dijD/s1jiDOKlAo5l9ws/bW9Jv2NNjGG5ZmdlzNemukKG0LKu+yVOvnsUc
	 8d12rsrUU6NEt6S+ogKSMOZk13otk+e16D7nzXq8kuY04UfFMq2WBjKmgHgKqDhKq1RcN
	 rUPONb2EhLXXIVFJjVJDOGYsYI5NSBwEShn56ukpYR4vwvb1C/aHztCLeQn2ua/Mc2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6YIL0s9aOhGV8u4vCRUjoyiMAuvjlzWqQF09O2EKLg=;
	b=RObrGa7atEroMZMZ36FEgK058gmdWTT7afakWH7teiQql1zJ9AgTIHsc0iPSXJy225FT
	 bbyJACNaWd9cEvWiuF9vw21T1aQzRCoDf1B37BLCIdBTTovIoOpf+PxaxviftNjeXxWv8
	 SZkKd+3eBnNrsTHstyVHCY3ekicE0mBKEDhEb2TJkijGoa1RujSpEMKxUi7zQplmz+rJ/
	 HPJXW+qdZTjFPrSTuhNGKFrx0H59o/ZmK6ag6isb9ccI+pz6E77fRlpqbuY0G+njvMs+z
	 VbQ8eGRLwX/cslfq2DU1pqOMjzCCMmw4vO7aoGzod/Z0ph4Z8BOS1CHJfzpVCTHMQ5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5b4Hxg+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31476606A320;
	Wed, 18 Nov 2026 19:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D5b4Hxg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA771F000C4;
	Wed, 18 Nov 2026 19:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031607;
	bh=v6YIL0s9aOhGV8u4vCRUjoyiMAuvjlzWqQF09O2EKLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5b4Hxg+QGMqgyNVkxelIP04eb4nvoHq2OQHVqaxm3VNMWskZ2zalktR9iQjOy6Uk
	 BYp3WA896jJgEp8Cbe2JJb+YU/iZSw/+mGOqhZ7JYtnNc8uG9T36DShyLreyMK6ms3
	 duNag/au+vifTHr7UmCQj8Gv288RqscE9Qqo9C8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Ferguson <ethan.ferguson@zetier.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1118/1756] ntfs3: add FS_IOC_GETFSLABEL ioctl
Date: Wed, 18 Nov 2026 15:54:05 +0100
Message-ID: <20261118150054.638205778@linuxfoundation.org>
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

[ Upstream commit e4dff970091118f2ecf66146d0b286979078b5cc ]

Add support for the FS_IOC_GETFSLABEL ioctl.

Signed-off-by: Ethan Ferguson <ethan.ferguson@zetier.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 80218408836f ("fs/ntfs3: do not mark frame pages uptodate on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 13f7d8acecf90..fd46160f48484 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -49,6 +49,14 @@ static int ntfs_ioctl_fitrim(struct ntfs_sb_info *sbi, unsigned long arg)
 	return 0;
 }
 
+static int ntfs_ioctl_get_volume_label(struct ntfs_sb_info *sbi, u8 __user *buf)
+{
+	if (copy_to_user(buf, sbi->volume.label, FSLABEL_MAX))
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
  * ntfs_fileattr_get - inode_operations::fileattr_get
  */
@@ -144,6 +152,8 @@ long ntfs_ioctl(struct file *filp, u32 cmd, unsigned long arg)
 	switch (cmd) {
 	case FITRIM:
 		return ntfs_ioctl_fitrim(sbi, arg);
+	case FS_IOC_GETFSLABEL:
+		return ntfs_ioctl_get_volume_label(sbi, (u8 __user *)arg);
 	}
 	return -ENOTTY; /* Inappropriate ioctl for device. */
 }
-- 
2.53.0



