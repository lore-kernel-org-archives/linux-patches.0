Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829631;
	b=As9mGN+d9i1KNKxQdUn4F6n4fSazNC8W17MEBN97tytbM0qS26mc518Z/9QdEJJotr0N
	 k5Gy6+hviYpl/9NRfplrSTW0E1hF/MmBfUOOaf6TLefyv/MMcYmaGrqSRewolwuMNDd16
	 NaRn/0YuFevzlAlt+wpIs5sIebAhycGznDUEBb9E5yovepPng5DAaqkIngVdwX7YZBXPL
	 hvWw3T1GUc3NrXG+CFlr99befd1XATn7Q1zjfzln4jl6c9GvVvWlcTPDdpJpOSGaHhCl1
	 cfhwVMmAFkMk/Q/SJaqfhk4W4dEL13Xj2LE/0HTUB0sTXN0nOfZX7QeujaHOYkUQNLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+jvXRFUtiXyR9YbdQxNAPkSMuEBXfvLBp8RlDLNKoNQ=;
	b=X1TEsqYftaQGNzyuVWsKrVXLWLEFjvAYb49Pxjtsd1BJZIOOLUZI1dlfhv64G6vPeC5k
	 cLmUUTiBiVDBgo463I2YIU9xeWw95SuwJGumwRm+JTzls4JXF/jE/v97T6ordr1m7oAPE
	 wpjvmk0n2YpyeiQxbU54aW/jNgp7L1ymjQou5ypBW1WOe96zy+5LnZmBjQA1++bJYjv1h
	 qKahGk3O5MVmpuJwX7fYyhzHtMMyKAWxXwiMHH7Q+Z1a175uWAo5HZtuhc+iW16wA1yS1
	 aEDGr8SDprXHwiBE8rFadKeUW6BvrNX6kbTKoyzMnAzo8osWx4nfninD5ozQCpkItBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ul6cAa/G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07033606AC14;
	Wed,  4 Nov 2026 22:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ul6cAa/G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897161F00A16;
	Wed,  4 Nov 2026 22:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829630;
	bh=+jvXRFUtiXyR9YbdQxNAPkSMuEBXfvLBp8RlDLNKoNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ul6cAa/GIAT7DwRIjZcXi6e5FUJqajadv1oqGQpwG4tXhbfHEK62iHDPienn6nXst
	 t9q+iygclDzo9mJqHHnWWulxR7F+X0AymIjcqye3T1Wqm5MHAhxuKT5zY6Z9+0q0Wd
	 gLtZbo9YfZkeuo7weUUDi1FA2KTNOXiGlFEzXEKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0245/1005] fs/ntfs3: load ATTR_BITMAP run extents from $MFT extension records
Date: Wed,  4 Nov 2026 15:59:38 -0500
Message-ID: <20261104211050.723406304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 120691bc71ee9..99fdba7b403cb 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -126,10 +126,16 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
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



