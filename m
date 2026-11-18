Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030398;
	b=YXYV0P9A4yuOMt2jEGuVT0rL6uzxlHeAquAZp14ZfCqHeNcV29jbynEkW0BqHxG5u6XU
	 vnjfH3mScxm3oJJZF96O5vPFs9tlSPVLmeYqiy3OdfzwbjTl3va8Sexzi5N/Plaeq17Ug
	 akniTt8S93vF5xhbmSXAepUpM7UxzSwg9w3MaHSg0qsUsOcwYiPqHczhBcsHm+D+Pe0FS
	 41BREdj1/lU80f8OE4YEbGpbaJxQinb5Qql7lGNxRDG/LGd0BCWHQJ3bMerciTak3cEYp
	 rfkneIa9w05H3hmtp4Dr1ll9jblRioaS+j9jZTeKvrmKUUHJhyHhWUi0S5f6LNrnbLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t+H915xg53HaCnpl8EuLcxjJvqJehRxI2mDYqHmV1pU=;
	b=D4SJkpluRTuOqWu62LHbvchuiOCWgV6bsAYsmhYPwmKiSbWLAB/pbVrFGFqAfXGTK0fE
	 ZwPvcxEhbQ1G+N6tQKiQ4fJJLoINW6sNij9+5YwsROKohuUqh+yb/W1SN0F4L4HZ+wILE
	 jLcDcu7+ohtYRtE9LtmCAP+47YrUUsUXfs+Ump5xRGuIkVXFXiAybhvXGMM8+QiEfgs//
	 FptNf69ANrGMEODg704ckwWfMQtagsnsnKWQD8O9fAERI3wAfThkeC+JwozkyYtcu0gZV
	 bwIDNX0s2pG3gnxT1+p9pKADXlObIdPNbQyvDsklBW+awUVwCQs3hN9lDhA5ueKaFug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vs1wKMQy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BD2606A336;
	Wed, 18 Nov 2026 19:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vs1wKMQy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4911F000C4;
	Wed, 18 Nov 2026 19:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030398;
	bh=t+H915xg53HaCnpl8EuLcxjJvqJehRxI2mDYqHmV1pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vs1wKMQyCuXrCzzB8vddhdpUHfzSG7NnfTcaSfXwVHv2Iy14BSdPSs5bJw2QFwc3y
	 f5wAeznpeJsFKQPCmTFqzXY3tAC4NUCw2JlKwFF4OMUQxVTIYqP+VFbcCkSLrdgia1
	 Qk7h/hGtUisTakmrgdG61UtZW8NjWsJJSPVLUVbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0688/1756] RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selection
Date: Wed, 18 Nov 2026 15:46:55 +0100
Message-ID: <20261118150036.607459583@linuxfoundation.org>
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
index f51adb0a97e66..699ef8537e4eb 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -371,7 +371,8 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 	}
 
 done:
-	return bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx) ?
+	return bnxt_ext_stats_supported(rdev->chip_ctx, rdev->dev_attr->dev_cap_flags,
+					 rdev->is_virtfn) ?
 		BNXT_RE_NUM_EXT_COUNTERS : BNXT_RE_NUM_STD_COUNTERS;
 }
 
@@ -381,7 +382,8 @@ struct rdma_hw_stats *bnxt_re_ib_alloc_hw_port_stats(struct ib_device *ibdev,
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



