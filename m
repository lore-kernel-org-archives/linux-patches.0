Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050666;
	b=zBou/+hfxuBRuH9xIEd+jgk4BzFPNX41uUO4J5ZFuxTdRdIvbIopKENw2Ql5qomqWBNb
	 bgv1UDKvzTLbXsvFSJkP/fUQwYDZIV1OAbC9hRjdYgVSoErt22c/plrckxhCvap2K3eS1
	 J9eBLT2LZZFYvC9AdE3AUfpVaYtR4Ld17zc0nqEdjVtIyfbcif28MSEM1YT3mqHCXe6Tk
	 J2H/Y5oBiZFir2SxZMEMSWRURbyrbP46cK3MKuw4W5B2S0ZtVmu58VLdQyvne2uCPbOdq
	 LPNa8FZw7NGb5CbHc+ro5mPFFStmP1XkdCLfbbNnttxzE4T2xRH4Mf35p5FeZ/df/Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pr6avv2QzL5ttRpcTsKcUQlKw7b0h9mdJxSXBpMiirc=;
	b=Jm1dCdlXyZG5VHf1SHIvTFxGlYCSENuq64UnT2hVVb4XoRIkof71BqeqB54nJkb2y/J0
	 qBTtTIFo0ni/uuyWAxLkEsh2qStgDuyHlrXXJAeXoPUphgjzwYDYOKtE10NBSiNb8j1on
	 UjvKL6qrbf7K3rIL26Vl417KM1g/NoxBoCe6XUnD2Pvn39327V1igYLCsMZ1OztcfQLQr
	 XzehtiyO7bhUmw+Gn4zsBp6q/0HabaRDr6NfrzNZHqbNyFbzK6E6DUdnlGeDeFouIDEia
	 7MD7bHZjoqULvturaUpGoSG7jszGOFlguwnJoKBwql212qarJMu9JSGnghjORsEp4mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMVKlwsB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ADD606A320;
	Thu, 19 Nov 2026 01:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMVKlwsB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DD61F000C4;
	Thu, 19 Nov 2026 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050665;
	bh=Pr6avv2QzL5ttRpcTsKcUQlKw7b0h9mdJxSXBpMiirc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMVKlwsBQThdCpjDzMj+mDfA8wDGvCBLv01/1Gq2m+k9m0mdzmA3DtOqQuKVjEXGd
	 DEnbWf7Akxb0KEET7AzPp7Bmc+5vWh9APkxL+D3lKKc7LVuw57J1uRD5feDsTz9drO
	 7x0BeHn14F8UKEyoLw642mDFqCy5rqOp3Ptggazc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 2788/2857] ice: cleanup allocations in ice_ptp_alloc_tx_tracker
Date: Wed, 18 Nov 2026 16:03:42 +0100
Message-ID: <20261118150341.984592373@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit c1f3414df2e86e63d603712f81443af6cf07f8a3 ]

The ice_ptp_alloc_tx_tracker function must allocate the timestamp array and
the bitmap for tracking the currently in use indexes. A future change is
going to add yet another allocation to this function.

If these allocations fail we need to ensure that we properly cleanup and
ensure that the pointers in the ice_ptp_tx structure are NULL.

Simplify this logic by allocating to local variables first. If any
allocation fails, then free everything and exit. Only update the ice_ptp_tx
structure if all allocations succeed.

This ensures that we have no side effects on the Tx structure unless all
allocations have succeeded. Thus, no code will see an invalid pointer and
we don't need to re-assign NULL on cleanup.

This is safe because kernel "free" functions are designed to be NULL safe
and perform no action if passed a NULL pointer. Thus its safe to simply
always call kfree or bitmap_free even if one of those pointers was NULL.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 50870d621160 ("ice: set in_use only after preparing Tx timestamp index")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 364e07186c694..aa8981423bffa 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -766,17 +766,21 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 static int
 ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 {
-	tx->tstamps = kcalloc(tx->len, sizeof(*tx->tstamps), GFP_KERNEL);
-	if (!tx->tstamps)
-		return -ENOMEM;
+	struct ice_tx_tstamp *tstamps;
+	unsigned long *in_use;
+
+	tstamps = kcalloc(tx->len, sizeof(*tstamps), GFP_KERNEL);
+	in_use = bitmap_zalloc(tx->len, GFP_KERNEL);
+
+	if (!tstamps || !in_use) {
+		kfree(tstamps);
+		bitmap_free(in_use);
 
-	tx->in_use = bitmap_zalloc(tx->len, GFP_KERNEL);
-	if (!tx->in_use) {
-		kfree(tx->tstamps);
-		tx->tstamps = NULL;
 		return -ENOMEM;
 	}
 
+	tx->tstamps = tstamps;
+	tx->in_use = in_use;
 	tx->init = 1;
 
 	spin_lock_init(&tx->lock);
-- 
2.53.0



