Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798F663B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CFFC433EF;
	Mon, 20 Feb 2023 13:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901213;
	bh=vjubX3ox9Al8peVNpy84zqtDLCSPmFHwCsqY/zAaXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mN7WWHHLdbMuwTCTY86d3dLSePQ9rf4UGSsJfUEiZhRLR3G+9W8IJ0DUvDpraBonU
	 OAjcRpf3Gy3teVD8NfHRtxqJuCZ7c0hDBH8EWzzs5U075ewfVkR+WCK5K2gdMmpUHd
	 tTBY5EgFproGDL0hFo6JW9qbiuhGzYbkNPI0z0w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Raviteja Goud Talla <ravitejax.goud.talla@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 73/83] drm/i915/gen11: Moving WAs to icl_gt_workarounds_init()
Date: Mon, 20 Feb 2023 14:36:46 +0100
Message-Id: <20230220133556.227603934@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raviteja Goud Talla <ravitejax.goud.talla@intel.com>

[ Upstream commit 67b858dd89932086ae0ee2d0ce4dd070a2c88bb3 ]

Bspec page says "Reset: BUS", Accordingly moving w/a's:
Wa_1407352427,Wa_1406680159 to proper function icl_gt_workarounds_init()
Which will resolve guc enabling error

v2:
  - Previous patch rev2 was created by email client which caused the
    Build failure, This v2 is to resolve the previous broken series

Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Raviteja Goud Talla <ravitejax.goud.talla@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211203145603.4006937-1-ravitejax.goud.talla@intel.com
Stable-dep-of: d5a1224aa68c ("drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 6b5ab19a2ada9..0dda8f6da4230 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1049,6 +1049,15 @@ icl_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		    GAMT_CHKN_BIT_REG,
 		    GAMT_CHKN_DISABLE_L3_COH_PIPE);
 
+	/* Wa_1407352427:icl,ehl */
+	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
+		    PSDUNIT_CLKGATE_DIS);
+
+	/* Wa_1406680159:icl,ehl */
+	wa_write_or(wal,
+		    SUBSLICE_UNIT_LEVEL_CLKGATE,
+		    GWUNIT_CLKGATE_DIS);
+
 	/* Wa_1607087056:icl,ehl,jsl */
 	if (IS_ICELAKE(i915) ||
 	    IS_JSL_EHL_GT_STEP(i915, STEP_A0, STEP_B0))
@@ -1745,15 +1754,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
 			    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
 
-		/* Wa_1407352427:icl,ehl */
-		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
-			    PSDUNIT_CLKGATE_DIS);
-
-		/* Wa_1406680159:icl,ehl */
-		wa_write_or(wal,
-			    SUBSLICE_UNIT_LEVEL_CLKGATE,
-			    GWUNIT_CLKGATE_DIS);
-
 		/*
 		 * Wa_1408767742:icl[a2..forever],ehl[all]
 		 * Wa_1605460711:icl[a0..c0]
-- 
2.39.0



