Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270431944F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILekZtRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611ADC433C7;
	Mon, 16 Oct 2023 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446314;
	bh=M6PPYZnovKUe7LLl/984rTCZsohWyxkuBfHbflnLxT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILekZtRo5NP4gIg+5LVIwDJpp/MASTrWZnNZM0Ql+CdtNoK8b9Av2PcsR2vBqk/Bf
	 DepFlR0ifaAjlhaHh4BKtl2TrUVQhsSfUvA9tAQ0VCfAFgNZ/7oIEQVKrR6cjpfQIc
	 e1R1L8lXe2FJh2wdYX5U5cBqu2vU/9GrIRFwNdsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>,
	=?UTF-8?q?Tapani=20P=C3=A4lli?= <tapani.palli@intel.com>,
	Mark Janes <mark.janes@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/131] drm/i915: Dont set PIPE_CONTROL_FLUSH_L3 for aux inval
Date: Mon, 16 Oct 2023 10:39:46 +0200
Message-ID: <20231016084000.144614991@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 128c20eda73bd3e78505c574fb17adb46195c98b ]

PIPE_CONTROL_FLUSH_L3 is not needed for aux invalidation
so don't set that.

Fixes: 78a6ccd65fa3 ("drm/i915/gt: Ensure memory quiesced before invalidation")
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.8+
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
Cc: Tapani Pälli <tapani.palli@intel.com>
Cc: Mark Janes <mark.janes@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Acked-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Tested-by: Tapani Pälli <tapani.palli@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230926142401.25687-1-nirmoy.das@intel.com
(cherry picked from commit 03d681412b38558aefe4fb0f46e36efa94bb21ef)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen8_engine_cs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
index cc84685368715..efc22f9b17f07 100644
--- a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
@@ -235,8 +235,17 @@ int gen12_emit_flush_rcs(struct i915_request *rq, u32 mode)
 		u32 flags = 0;
 		u32 *cs;
 
+		/*
+		 * L3 fabric flush is needed for AUX CCS invalidation
+		 * which happens as part of pipe-control so we can
+		 * ignore PIPE_CONTROL_FLUSH_L3. Also PIPE_CONTROL_FLUSH_L3
+		 * deals with Protected Memory which is not needed for
+		 * AUX CCS invalidation and lead to unwanted side effects.
+		 */
+		if (mode & EMIT_FLUSH)
+			flags |= PIPE_CONTROL_FLUSH_L3;
+
 		flags |= PIPE_CONTROL_TILE_CACHE_FLUSH;
-		flags |= PIPE_CONTROL_FLUSH_L3;
 		flags |= PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH;
 		flags |= PIPE_CONTROL_DEPTH_CACHE_FLUSH;
 		/* Wa_1409600907:tgl,adl-p */
-- 
2.40.1



