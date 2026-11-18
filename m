Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024831;
	b=Bt0Ua+GzcZIhcRCySfWTMf/+EIhrt+sjOXn/1THof+whP+VnXSO4thSQ9qfbBrq0PqFz
	 12hC+oO+10GpnaLMY80ppzUrR+nYcU1YgOgEcdaCq0IVEqUzLZLWnG2HDh5yaVQmOacqU
	 jHrxPb5obnatxLTvQkjD28n64LBBgBsayrsl11CvhTEBCsJYjoyD5/ZoxzewsSsmFmNbQ
	 lIOv8g6h/W65iCC+r9Nd7jD9ZUuooMT6ofd7QLBCcx0xDGPHK5LvSnETvtoBdKGyHZtfF
	 hNKAnlSWxX/5+1O9QSUqIwQwyaiQaMLZQYvhJQieJhj/rTxxIixX3AMrexYfvpkWjkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UfwkSyx8L5AuG2LhyyHiBzvVQqdYnnGhiLi9Xs2pHUI=;
	b=EPVXNPBhas5l+2kWhwRNEz+4DQ7YPC0UbUg4oVT654YMRU6Yw1yFVJiL9X4A/sue0IcS
	 e/OVKln0rAFJOkgQ+D6V/spxQ+UTCLDuBqKbrGtCojsgYeqBr4sMoy/2u8sxN2/q9am4+
	 2RpMPJs28UY6RsZjhZQjdeMvc7SKGusMTTAVd6pi8NvEImBuovFhN3K5+3QKOXMCpLwP9
	 RxA5VvH7b03Ttg9OaPMbZGh8KrH3Bt8g1cRzADXRf+s3CO+kR+3TMpgcNPDbjVFbZbAkl
	 9ZNjZ5iO8rbxSGNC980IMPpWP9aGU5tsce9FivF++u0L1ITEi4BSLVjqCxX/DRz5LmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeLB6JFs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF841606A32A;
	Wed, 18 Nov 2026 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeLB6JFs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5521F000C4;
	Wed, 18 Nov 2026 18:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024830;
	bh=UfwkSyx8L5AuG2LhyyHiBzvVQqdYnnGhiLi9Xs2pHUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeLB6JFs9B95E7B8i8m1Z/2NMfDeSFfA+SvezdGCmRFpPR5w2BsrMeciUn85finw/
	 /kVxx0nwUtWaN1ItK1LbMTca4dRtX9OsymFC1Fz5TOg7wwFlePj+MQtiGhK0DUDTs0
	 D/hpfWnjTe1K6is1Eu/ianPq1SdXsbnFOvxB8Jv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0862/2151] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
Date: Wed, 18 Nov 2026 15:43:17 +0100
Message-ID: <20261118150153.626847081@linuxfoundation.org>
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



