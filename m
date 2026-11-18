Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045082;
	b=2Bw94jqCdvO974XBdT15jwZPbbwz1zU/O/1S2RIzfoDqhQyfSHzs0dIDZoDzjLVXrcJ+
	 GFg9v7wG+oTdg3xd23GH5E0sCWD6YqrSCaxJp5IqeiGx1StAWGPxYG/e7/YJf+t1G06WB
	 oTwHPEemuke7BHCTbWIDrgNsvTBtfBS1YF/Fm1ujGG/KPYTAEXeWmKBN1Kqa+GZcp4KWA
	 VjHObpMZY4gSAsI6vOjketrVMi463wgJOjji3CyIkR81MuNDpTKpWOoDJTm6w4t5uLGw0
	 oJ6281k49kKqHX1KOfvACRAMgw3IXxHTsn04GaeYzywrg0Zrn9pQAlYky2Hyws3E2Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4OXEYcltw71HlhZ95//6NVFuME3VDMZeMq/AQXS3OTk=;
	b=0YhV0DnQNazHtaX0qzFKFvcWDR2n1+48CDH0YF+w5OS0NGqmOU4tqGgbNvf+mkxoWejj
	 VanGSVvJzsnxQdehh2Kd2i60S/mhfVy9+vuqz1vdsLDsooM1177yoRapU9IcRTVuVgDKa
	 DbyyMKW/0AhU+522OmkWgs+pFapSQXKBB6Wwskc8fvOxpahgLkGxhPanXCxjFqLrGZCJW
	 iIYv0uLZRhHDGtnugo6fRn0meaYtvE3Vd4l3/V3uPHSRvkADSorOP/ymiOY9pw0Fde/eG
	 xyYEd50JjHwP8K76/lcbSrazISniekkdvQWGT3mfynuSM+S/VR+hSuHI8vqrHPRYCwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhNf53tc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BF2606A330;
	Wed, 18 Nov 2026 23:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bhNf53tc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BBB1F000C5;
	Wed, 18 Nov 2026 23:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045082;
	bh=4OXEYcltw71HlhZ95//6NVFuME3VDMZeMq/AQXS3OTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhNf53tc4t/ngowSIEzhP6tN5ruRXbxJzSd+ynClR7kRI3qLdMuh4F80LtKHii1ax
	 9Dsoflh9wyHccYntm5XTeIfYUro+sNGLuwJfpMdutlx1BTneud1ytf75WIPc+K4cOu
	 9K3UkL/c1b0XRw/qS1/RKmz0JaFUSjazCFwJAn4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0798/2857] md: validate bblog_size when loading v1.x badblocks metadata
Date: Wed, 18 Nov 2026 15:30:32 +0100
Message-ID: <20261118150230.308671008@linuxfoundation.org>
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

From: Yuchao Zhang <ndaugoing@gmail.com>

[ Upstream commit ae5f89b23cb88667cfa1273b42d6a551db9c651e ]

In super_1_load(), when the on-disk feature_map does not have
MD_FEATURE_BAD_BLOCKS set but sb->bblog_offset is non-zero,
rdev->badblocks.shift is initialized to 0 without validating
sb->bblog_size.  The same field is validated in the
MD_FEATURE_BAD_BLOCKS branch ("sectors > (PAGE_SIZE / 512)"), but this
branch bypasses that check.

A forged on-disk superblock (malicious storage device or crafted
image) can therefore carry an oversized sb->bblog_size.  When bad
blocks are later recorded, super_1_sync() sets bb->size from
sb->bblog_size and md_write_metadata() issues a bio larger than the
single rdev->bb_page, reading beyond the page and leaking kernel
memory contents to disk.

sb->bblog_size is never modified by the kernel between load and sync,
and the MD_FEATURE_BAD_BLOCKS branch already validates it, so checking
it in this branch is sufficient to cover both paths.

Fix this by rejecting an oversized sb->bblog_size with -EINVAL,
matching the existing check in the MD_FEATURE_BAD_BLOCKS branch.

Fixes: 2699b67223ac ("md: load/store badblock list from v1.x metadata")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Link: https://patch.msgid.link/20260922044606.30774-1-ndaugoing@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 712789d386dd4..b60321f1e808f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1749,8 +1749,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 			if (badblocks_set(&rdev->badblocks, sector, count, 1))
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset != 0)
+	} else if (sb->bblog_offset != 0) {
+		if (le16_to_cpu(sb->bblog_size) > (PAGE_SIZE / 512))
+			return -EINVAL;
 		rdev->badblocks.shift = 0;
+	}
 
 	if ((le32_to_cpu(sb->feature_map) &
 	    (MD_FEATURE_PPL | MD_FEATURE_MULTIPLE_PPLS))) {
-- 
2.53.0



