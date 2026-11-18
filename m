Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029466;
	b=fKbwOFRSZ4lESvjoiANghTgTL9XzwesTlGW8rU/F1NQMTvaUfIs+gqfbGi5PIDeucMvn
	 05acWwXG6nh0Iv4qRq6qedOQYNKpGC0apK8iDvV7pDuhJre0kGmM1pyz9Zp6PAzYyOUk/
	 xAvZHFxSdRDdwMKmxSuh6GeeROIL8FFTX4ZeEnyzrp/KlMZR1ao5ED3XWk/r0HWDR1YnY
	 jbflYEE9qVZrSgD2tHTtb49yJSI+TAlLeoaJalIcmqKgsKp7QfYrQIdBz3yHIf/GbEl8/
	 2/Gw1LBBKUSHtsiq2sZ0m3MWHAoOy1UfRIczspxLTtcJNSGRu7tg6//aVhzU/WU3CfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z0dGXnel06dtUhDxvGOyuqEWy/dzRGk7jCuJ+xUw/V8=;
	b=DwLE6YhGNsaGI7Hq2BpLZo1j7DzoD2gcITV8QAbguZKLwI40viPqfnlF8wGa362+jelB
	 hCe9cs1ubFByJkx9zk9L3f/ICN850TsJQVIT+S4o2cnIhZCuNN2zZe8Ioh6fHP/NCUpQH
	 zwKFnS7THQWm71hl2h/CPeOZN3Jia/SxnSvXpQ2rmNrTbrhEfiTEDvUod7shICDXXdZuO
	 IYctZTaigQsFt8jmiJ9814RWf2aAQL8AkwIAR0GKmLEOUJsmTykKU/O6YD7W6k4yldBtO
	 Zp4Ot2pVY7CPM4+e5iu4bteShLTpuAIXJz7Nfw7eVnbYefcsWrWXxZvGNtzH+ChRjOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IS1ug+FT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C5E606A32C;
	Wed, 18 Nov 2026 19:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IS1ug+FT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259911F000C4;
	Wed, 18 Nov 2026 19:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029466;
	bh=Z0dGXnel06dtUhDxvGOyuqEWy/dzRGk7jCuJ+xUw/V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IS1ug+FTCV5pFmopV8hXsJVZtvk46/DzQen30NOvW4M8XXLg4bDwQa3FZD+OcFtLZ
	 fpu41H9gQot3IxgRkU+TUXKiAbx6PfmqMdzEekZWEyI6Y6ypsOwl5Pk68oBBy+ZIL0
	 UTxb/V4ikrrWGIhYyMrcZlVE2fuIyMY55ueFBHPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0323/1756] RDMA/hns: Limit gmv_entry_num to avoid memory waste
Date: Wed, 18 Nov 2026 15:40:50 +0100
Message-ID: <20261118150021.148910728@linuxfoundation.org>
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
index 9036593857397..8774715174b3e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2165,8 +2165,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 					 caps->gmv_bt_num *
 					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
-							  caps->gmv_entry_sz);
+		caps->gmv_entry_num = caps->gid_table_len[0];
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
 
-- 
2.53.0



