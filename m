Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023382;
	b=xCBwZaCtJ5JSwK13jIBFlOcWDvrw8qzxA0CXp9sK/iO85ArtjobOGX2aDBPj39nAdcFD
	 a9dwnSkwYito6OIZx/7oY2SYOD9M69s9gK2eu+N2CBFwaCoLu15FNU/fjn3z0fnJRFTdl
	 DvVka4n4qAzD1of9/EZvfIeWLENyobjE/5xKx4NBr2xq7BpkCm30gH3e1XGeHrLb+Li7Y
	 g5YDKBAfYV4f/awfm1eYJyDAugFh41ZOL5wYJ65EA2mAJ5cX4f6bU45Zhht6M4gDqWfjY
	 bY/xKTblxjShmqntGfi0EnQ/JnHRz8bVYkVyBfbbimtSY8c/Vh+8g40xGpuToNwsN9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y3K/HdCGMqjeslpsiXRDQAVwYCHQWYpnQY/6PBaj3n8=;
	b=EuwaSvJjM6RIyrBQR6W7xyRW/37hb5v/Cm3jmOyGM6+nkCve+fRd4WNjbE+2sbA+Dgrj
	 E0lhssDT8lJ/4CMmbZioNCfDS5Hrj3FgjlABIRDyUZSBahRE1f45DTqGJE2Jfi3SrRuu5
	 AUdHJUn7VOfPW4D3csX9jSfb7Tp7DDNj5cfNTNkMXR4oZnxGxM78RUSAVbk5xuNzMphSx
	 R77dORFqMkh+A3O9GjqM8YGsPHFUe3R0r5kP2SDAbiB2Bs+Daj1hU2t1EgOjBa7rizeDx
	 3OqB4Y4i64euZTXxrNHaSogDDTj2DTMSKEZl3CtE2Flqntnesafz6XbTTEeMEzMiGAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wBEf6/Wl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF876606CA6D;
	Wed, 18 Nov 2026 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wBEf6/Wl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C2E1F000C4;
	Wed, 18 Nov 2026 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023381;
	bh=y3K/HdCGMqjeslpsiXRDQAVwYCHQWYpnQY/6PBaj3n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBEf6/WlFXzqcsuVYDG3FvquSKKnluxp4cH2wUTKgRgG7bHoZa6RdTz0uzBI7lsIl
	 efErza6g2Aiozgs6jy3b1JtsgTUhPjbbP03/SPAODLnqqdHJ60LL2iQ30e0DKgmdu+
	 oh114QSPbT//QCbnPzNbGCIQruK/BoHUw1wS9Iic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0350/2151] RDMA/hns: Limit gmv_entry_num to avoid memory waste
Date: Wed, 18 Nov 2026 15:34:45 +0100
Message-ID: <20261118150134.853464850@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit bb464eeadd301c3a53e9f92a2a472b73c42b74c4 ]

The GMV entry is a HW object corresponding to a GID. Since gid_table_len
is already limited to a maximum of 256, there is no need to allocate
memory for those extra GMV entries as they will never be touched.

Fixes: 7243396aaf12 ("RDMA/hns: Add a max length of gid table")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260907084901.2420703-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2336079daa1e0..92a15be234068 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2180,8 +2180,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 					 caps->gmv_bt_num *
 					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
-							  caps->gmv_entry_sz);
+		caps->gmv_entry_num = caps->gid_table_len[0];
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
 
-- 
2.53.0



