Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619218;
	b=wISGbzlo5Hthfo/cBev+NVcGpDm+vXu2Zw6vE+yV9MhQogUYMQ4vUHXI46jPS50QLcK5
	 xPlKc9XulCuvpi+ZRirq4MbXzO5IynpqbwF2GUtfMcj6sK/5EBEWLP1uf1rIKbSsC+Oi4
	 HDTmBWl2sIdgy7Kd9vUMAceMUFUCyxNeTD/DquKa2LagzWlIqfBfRelv1XL48LNBR3DN9
	 TLyXvNEuMEkEddPLQW+IbP6LuriS1mDw3HiuMGZ+IqLBByermRlTljRDlc/Z4vH3Nb+M1
	 WlBS3SzFRVxNLjTBlOPOtSJWdAYkVX6VpSljoxhz/iZXIx0x69uU8lDVk/nKkEZWxiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gx5yhCaFLs6MbW3udcbu6yyuQ0cOKaPC1bpzZr5ACmY=;
	b=kBX/2Efb2HyrcJm7QpZHWwh6YY7uqfDFk2C55cKbQb49pUzha0BnGDblQZpCJ1lBgpAF
	 i395P7SGDKPqJ3Im2NS8zTallyHCmP5ftzyVPnPb0I5Xs2A7dyQHRqyVooDKauz7/bMAl
	 fZpUlWrYGofncAmpyTVAXIFrQTd2GWBvLC8adxkX2a7eWyeus8IHD/HOWEQyCavsmai0O
	 r/NNL2S7gRcMIqMj3C9lj36h8ngXlmOn1LBdlfzP+l1+caiALjzpBm4DqlJsmGvY9BPP/
	 gg+6a/d27VnCHfJMyY2GIRnlrNQ8g56Q9/oGmAbDk9fV7tMDZGgo/Z2trFfnNU4FoQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2bKPUul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3596A606A31E;
	Wed, 25 Nov 2026 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P2bKPUul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622021F000C4;
	Wed, 25 Nov 2026 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619217;
	bh=Gx5yhCaFLs6MbW3udcbu6yyuQ0cOKaPC1bpzZr5ACmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2bKPUulw0+BZS4O4220kOWK7wGZtV2QAx5+2J7Fz65TLFU0/XGhFQPWEqrYEg8cZ
	 bBRHM+3XU3uu+5wyG9czNV2xQ47PxZKZovNFr1zM6bscOcl5Nj9LmZEtYIivujwab9
	 Bh0IUpOiKHIOi3d0lfTbxSo+NTLasmTAz97WnsFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Charles <daniel.charles@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0527/1005] drm/xe/pm: Apply tile workarounds after PCODE initialization
Date: Wed, 25 Nov 2026 15:31:05 +0100
Message-ID: <20261125143834.091718029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Daniel Charles <daniel.charles@intel.com>

[ Upstream commit a17c5ed0dc715d2e39d00e33372cb094209ac8ef ]

Tile workarounds program SoC registers through MMIO. Wait for PCODE
initialization to complete before applying them during system resume,
since MMIO access may be blocked until SoC initialization completes.

Also apply tile workarounds after PCODE initialization on D3cold runtime
resume, so their register settings are restored after power loss. Keep
both paths ordered before early GT resume.

Fixes: 0d0534750f9d ("drm/xe/wa: Apply tile workarounds at probe/resume")
Signed-off-by: Daniel Charles <daniel.charles@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20261103021418.654723-2-daniel.charles@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 641ffb2132839242e49a158d2aea579a75fa2e8e)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 06ff27641ad19..45a953c0a48f5 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -239,13 +239,13 @@ int xe_pm_resume(struct xe_device *xe)
 	drm_dbg(&xe->drm, "Resuming device\n");
 	trace_xe_pm_resume(xe, __builtin_return_address(0));
 
-	for_each_tile(tile, xe, id)
-		xe_wa_apply_tile_workarounds(tile);
-
 	err = xe_pcode_ready(xe, true);
 	if (err)
 		return err;
 
+	for_each_tile(tile, xe, id)
+		xe_wa_apply_tile_workarounds(tile);
+
 	for_each_gt(gt, xe, id)
 		xe_gt_idle_disable_c6(gt);
 
@@ -666,6 +666,7 @@ int xe_pm_runtime_suspend(struct xe_device *xe)
  */
 int xe_pm_runtime_resume(struct xe_device *xe)
 {
+	struct xe_tile *tile;
 	struct xe_gt *gt;
 	u8 id;
 	int err = 0;
@@ -681,6 +682,9 @@ int xe_pm_runtime_resume(struct xe_device *xe)
 		if (err)
 			goto out;
 
+		for_each_tile(tile, xe, id)
+			xe_wa_apply_tile_workarounds(tile);
+
 		for_each_gt(gt, xe, id)
 			xe_gt_idle_disable_c6(gt);
 
-- 
2.53.0



