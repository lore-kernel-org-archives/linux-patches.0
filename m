Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214391;
	b=T3Mhdr55gDAdve+2H0wwLQYlXAuhQxlQmKFKOliljYleraUspXJavkSQRVLYHKdguRI/
	 Y97sKNt5ZXwUS9Hf4c77YVxuSIomXHg8aKlUbeH4uv2aHPTx2/Fhxm6k9LhR2R8WejtyG
	 lMaWo50LdVtpOrOgz4Xcy64l953bfeNXjPdc4383654ryFjN11NtUT9o0tfAOrc2IOWOQ
	 cF48uiFUEnjMBYYsnoufaqtFHPvmtu5hKhjZxk51wWnltCPMWjQcxS5+u4LuLiEMb7i3s
	 5QQnEFBa7WTZrgQPHtk2tu7uxdb1UthUQcvjUoBAaDuHNur0/lh8dxPhRTfAh5Z2hkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWPHpwhl7DuOQ58gW+2EFVz0wsMdp11uq466hXEnRMk=;
	b=KEkqjYZHF9jdYkUNIo5WHcNP7BWHf0UQUe7FCpRiXIsJ7T1mFIEGWfe6DcSZtujpdA2d
	 ByHOZDgfVWh2YpbWeVDIZmV3UmDKZYyoSIsEdX/vDS5IIDb8D4ZjPyEN/iJ8Sm2qOB8fq
	 c4qk4QMMkMi6F9wKXUB2RhNmhIgszafmBwsbI+QDvBe9Ng59RGoajvVydFhp8Kc3JE+xW
	 uUn+lbbxaC1VQjlCGkFEu6HMs6deTIgBpdKMxxSS+ESX32M/Qmb/kKuO/9DC71FEOpk59
	 WiNsmJ2QHOJmU65G+8Y1S0Pfz3ZVJP9a4CPF4zFG/CGJT270NQ8/20nxPY47bvwiRXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZESZ81j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16300606A323;
	Wed, 28 Oct 2026 19:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZESZ81j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE611F01825;
	Wed, 28 Oct 2026 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214390;
	bh=XWPHpwhl7DuOQ58gW+2EFVz0wsMdp11uq466hXEnRMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZESZ81j4iR9wH93g9LbQL1a9sfcbv7qyPZoUXraQnFMkiFFAHifi8GDznomD82sP
	 acBfnpznZ/GuuYYQELXGmRbnlAchEVfQvSA8ABiVhs4OH59MKXdvWwyxnisSRZgqu/
	 Nyugez1sZF5I5ba5UYd9574amcrzikqeuIpQKSR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0841/1887] bnxt_en: Fix memory corruption when FW resources change during ifdown
Date: Wed, 28 Oct 2026 17:48:57 +0100
Message-ID: <20261028170518.565343544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 2747328ba2714f1a7454208dbbc1dc0631990b4a ]

bnxt_set_dflt_rings() assumes that it is always called before any TC has
been created.  So it doesn't take bp->num_tc into account and assumes
that it is always 0 or 1.

In the FW resource or capability change scenario, the FW will return
flags in bnxt_hwrm_if_change() that will cause the driver to
reinitialize and call bnxt_cancel_reservations().  This will lead to
bnxt_init_dflt_ring_mode() calling bnxt_set_dflt_rings() and bp->num_tc
may be greater than 1.  This will cause bp->tx_ring[] to be sized too
small and cause memory corruption in bnxt_alloc_cp_rings().

Fix it by properly scaling the TX rings by bp->num_tc in the code
paths mentioned above.  Add 2 helper functions to determine
bp->tx_nr_rings and bp->tx_nr_rings_per_tc.

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250825175927.459987-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 24 ++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index de7bef33641a8..7da32225cc165 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10520,6 +10520,20 @@ static int bnxt_reinit_after_abort(struct bnxt *bp)
 	return rc;
 }
 
+static int bnxt_tx_nr_rings(struct bnxt *bp)
+{
+	int tcs = netdev_get_num_tc(bp->dev);
+
+	return tcs ? bp->tx_nr_rings_per_tc * tcs : bp->tx_nr_rings_per_tc;
+}
+
+static int bnxt_tx_nr_rings_per_tc(struct bnxt *bp)
+{
+	int tcs = netdev_get_num_tc(bp->dev);
+
+	return tcs ? bp->tx_nr_rings / tcs : bp->tx_nr_rings;
+}
+
 static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
@@ -13471,7 +13485,7 @@ static void bnxt_trim_dflt_sh_rings(struct bnxt *bp)
 	bp->cp_nr_rings = min_t(int, bp->tx_nr_rings_per_tc, bp->rx_nr_rings);
 	bp->rx_nr_rings = bp->cp_nr_rings;
 	bp->tx_nr_rings_per_tc = bp->cp_nr_rings;
-	bp->tx_nr_rings = bp->tx_nr_rings_per_tc;
+	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
 }
 
 static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
@@ -13502,12 +13516,12 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		bnxt_trim_dflt_sh_rings(bp);
 	else
 		bp->cp_nr_rings = bp->tx_nr_rings_per_tc + bp->rx_nr_rings;
-	bp->tx_nr_rings = bp->tx_nr_rings_per_tc;
+	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
 
 	rc = __bnxt_reserve_rings(bp);
 	if (rc && rc != -ENODEV)
 		netdev_warn(bp->dev, "Unable to reserve tx rings\n");
-	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 	if (sh)
 		bnxt_trim_dflt_sh_rings(bp);
 
@@ -13516,7 +13530,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		rc = __bnxt_reserve_rings(bp);
 		if (rc && rc != -ENODEV)
 			netdev_warn(bp->dev, "2nd rings reservation failed.\n");
-		bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+		bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 	}
 	if (BNXT_CHIP_TYPE_NITRO_A0(bp)) {
 		bp->rx_nr_rings++;
@@ -13550,7 +13564,7 @@ static int bnxt_init_dflt_ring_mode(struct bnxt *bp)
 	if (rc)
 		goto init_dflt_ring_err;
 
-	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 
 	bnxt_set_dflt_rfs(bp);
 
-- 
2.53.0



