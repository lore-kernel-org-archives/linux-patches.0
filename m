Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043392;
	b=AZ/fEbGKpzxjIp5nT0gbzaheseo3eL58CipA4xmp/H0TaXHxHydHEyr9ebUnS55Q3dNt
	 QKjxwFLCea17G/2dUm8SRqIk1KDK+klG6YowQF0SEAU5ZRu0XTPICY/VamWblr2k9Tghf
	 THPZhZt1psbkqcATNNvIKq3RUgRQUKsOVPImsb3f4gxMDdss8F/kBePmaqZ0D1iMNiou7
	 Sq3qcT08shWmlfUIyWa8Dd6aPvD6AfRDCL3SwknncwJmHnBqzJ7q8uLKZYTs4Qw23B+Oj
	 1KdAnl5OvszjNnq/2/dQYnaNVCbPYOZ1U+f1P9CtwRCGdQR5IA6wSLCPIPw3HbzEJmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+P+VOcMDH7cHqArPJjunSYRq+iIhKxJ8sr1yWhZFU9A=;
	b=CSbDFQT/HZaukUVrrmPoTTD8P5lGtl5pI72F6UF71h89s/PiLz8UO6Az1dgJ1F+wjef2
	 myD63u0DPnSJ6U4GuwJDLAHqQLfednsekbAdfmWZzSECHKHaESjTs3MrX6xjEEKwGChmD
	 pYnVLd68xpXKfaPFgWVdWXCUOy6u/KhLneh0t/u0af0Q41mt+IbEe6tciDDQY5Aq2SoS5
	 zbAnQ0gvWz9Ohp9Vsr5R63C1MyAXfYnCv2kmTDZvsH0Sap+Tl0JNjTL/Mst7AtxE000ye
	 nWagjslhIQ9EV85Aa0/bb/PoWKfPL9Nx2jrYJW5VmT2lW33lWogB4dF9Ryr8erKs8oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YelYeWVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDDD606A325;
	Wed, 18 Nov 2026 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YelYeWVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6211F000C4;
	Wed, 18 Nov 2026 23:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043392;
	bh=+P+VOcMDH7cHqArPJjunSYRq+iIhKxJ8sr1yWhZFU9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YelYeWVC2fb1xVCk8yojqSEXggBAJPcP8n7gwrv7UFwIGphtiT6OEFAZPIy3/OblQ
	 MWQOex0dLezWMkF4N4+TjwOzw7vdj376YZRHr5ts5VrjaHs7bIUmpneEuOhik0BE/g
	 s6FxD+zjM05ZkZzRaECjK0aqQh7+IqyHFrMtZZ94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0152/2857] fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records
Date: Wed, 18 Nov 2026 15:19:46 +0100
Message-ID: <20261118150206.818218426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e31886cb6e0e14cf65e27da0bf1a422ff419d893 ]

When $MFT's ATTR_BITMAP attribute is heavily fragmented, its run list
can span multiple MFT extension records (attribute list entries with
vcn > 0). The non-primary segment handler in ntfs_read_mft() only
processed ATTR_DATA extension segments for MFT_REC_MFT, silently
skipping any ATTR_BITMAP segments. This left sbi->mft.bitmap.run
incomplete, causing wnd_init() to fail with -ENOENT when wnd_rescan()
tried to look up a VCN not covered by the truncated run list.

Observed on a 16 TB NTFS volume (0xFFFFFEFF total clusters) whose MFT
bitmap run list was split across 97 extents in extension records.
wnd_rescan() successfully looked up VCNs 0-122 from the runs loaded
from the base record, then failed at VCN 123 (the last cluster of the
bitmap) whose run was only present in an extension record.

Fix by extending the MFT_REC_MFT special case to also handle
ATTR_BITMAP extension segments, storing their runs into
sbi->mft.bitmap.run the same way the primary segment does.

Signed-off-by: Senjin <senjin@hatchling.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index e38f8fac1130b..ba1395c78313c 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -125,10 +125,16 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	if (le && le->vcn) {
 		/* This is non primary attribute segment. Ignore if not MFT. */
-		if (ino != MFT_REC_MFT || attr->type != ATTR_DATA)
+		if (ino != MFT_REC_MFT)
+			goto next_attr;
+
+		if (attr->type == ATTR_DATA)
+			run = &ni->file.run;
+		else if (attr->type == ATTR_BITMAP)
+			run = &sbi->mft.bitmap.run;
+		else
 			goto next_attr;
 
-		run = &ni->file.run;
 		asize = le32_to_cpu(attr->size);
 		goto attr_unpack_run;
 	}
-- 
2.53.0



