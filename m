Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017803;
	b=QKO4d6zWqCyWFAUXp8drskHTpsbe9zb/Lmc76ERwOIbJtBRc4nykD3+buSa8U/qsrqdT
	 eKQuMe0hVxfoS0NhOZJrk4bzEvpinFbW8yBeWEDiaV34UlLhQYdDlpMq8TfkXU5ZiJ4uK
	 9d2c7ZlkBaQjkcRFfVmr8rYQOnrqjqvLjhKHEZu29B7dVl4rW4OIbMpa0Pt1Z7lU8Zsl4
	 AQIeTVQwsLnuS6meuFEUdk0WirxJQkcOuwuULUyIyyHWGMqKu+0vSKNVMwp2Bf55IQTGO
	 NYcYrAB/7p8wY85yZYB9ES8l5Dg3vGF5thTIQ6Br9uMR3bTIfIF+NMZyrQ52hxw/CuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h8A4zOspJXauypQI6vhf84kX07O8r8cOdOuf3jTiYDM=;
	b=5osgGn1HVbZ1xhMmhplA5FEIAFN8j7Sex9umaKJgiy9o6Z45A0j9H68KrLsPNsl0Gm+j
	 4ep3tGBBYQ8mRAvEOUq4oin7Dg3jfmbfh+4s81qKB5haQb8+C3qlVeTaAEF1e7oFRi3hz
	 a51tk+v1YHS8w8kdoFOaqDbsN3BaZn7fN5nvf5fGRUaF8LOVDHrRH1rw61T4LVc2d5hX8
	 yveHJMV6TMDSyu1bFHVM3zHUiVWi9QrVY7oJjpmLFe+kRgbj3nH+u+ly2uiuwWgBPYkYy
	 Gxy+WEd72oH989qeelm2XH5tLgimeh6S06AEHRYZOJr1Uzosl8WwXfUZep5HIL/+fiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqFl0BQu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D84A606A31C;
	Wed, 18 Nov 2026 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqFl0BQu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343731F000C5;
	Wed, 18 Nov 2026 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017802;
	bh=h8A4zOspJXauypQI6vhf84kX07O8r8cOdOuf3jTiYDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqFl0BQubOYTcIPhpt/87Q6PvSdoqI2+JfORCHeEfqUsx5AoF/OV+phIh6GjfKi3E
	 BTZPmWd8OtfxQxIQRCRqk03hZ+pRiPzdJH42AYpoyYQegxtnqEE8Alq+GZgOHb8EDE
	 vXPXznqw6eEwzqNvtqOJEM6xC0dOXfm/K6KhI0gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1015/2651] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
Date: Wed, 18 Nov 2026 15:37:35 +0100
Message-ID: <20261118150324.467044543@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 7cc8ccb157a4769c8fbce8296532dcb8a8ea0d5e ]

Selecting between BNXT_RE_NUM_EXT_COUNTERS and
BNXT_RE_NUM_STD_COUNTERS relied only on
bnxt_qplib_is_chip_gen_p5_p7(), which doesn't account for the
extended stats capability flag or the PF/VF restriction. Use
bnxt_ext_stats_supported() instead, matching the check already
used to populate the extended stats, so the counter count stays
consistent with what gets filled in.

Fixes: 8238c7bd8420 ("RDMA/bnxt_re: Fix the statistics for Gen P7 VF")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
index 651cf9d0e0c7c..575b97030587e 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -413,7 +413,8 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 	}
 
 done:
-	return bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx) ?
+	return bnxt_ext_stats_supported(rdev->chip_ctx, rdev->dev_attr->dev_cap_flags,
+					 rdev->is_virtfn) ?
 		BNXT_RE_NUM_EXT_COUNTERS : BNXT_RE_NUM_STD_COUNTERS;
 }
 
@@ -423,7 +424,8 @@ struct rdma_hw_stats *bnxt_re_ib_alloc_hw_port_stats(struct ib_device *ibdev,
 	struct bnxt_re_dev *rdev = to_bnxt_re_dev(ibdev, ibdev);
 	int num_counters = 0;
 
-	if (bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx))
+	if (bnxt_ext_stats_supported(rdev->chip_ctx, rdev->dev_attr->dev_cap_flags,
+				     rdev->is_virtfn))
 		num_counters = BNXT_RE_NUM_EXT_COUNTERS;
 	else
 		num_counters = BNXT_RE_NUM_STD_COUNTERS;
-- 
2.53.0



