Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215327;
	b=cNk2D6qw08oCtblxYp6GE0GruOCjHMl68DCCPDAhUZm+UZAe/oF4D4TFtei32ex889bs
	 tqH6SovBboXnHpBdITJNBvaEJLjSRuynRK0UXTzMjCB0U0pAXYLCeA9S6Hqefad9BL5fi
	 /38qJl+CGnm2BcaaGPHdTFubcU8vAPQgEI2gLatQUTzDw2UkQ79aXZvid0hiI4qECEget
	 ySWik9r84S8SLH/u2xtkx9971B6XT1ImrC3Qrk5YwZBtYVNA45smvOkThPP0nATwxRyHi
	 LZr5wVR6m/5vcNWBNo1jwVmertStyMNEi7WF/FQsG9wWB2895xola7xVKC3PgSzo9Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/8We1i3UCbKQa+DjcWM0NGsxHNKskO9p01Y213NhDZE=;
	b=hAfHY/2oJkvGBTxEdwuL2Lp4fTe2kAq7RNvJnj4w6ZXOxCUQung9r1fT5O6nM8P4RIfd
	 5M1Kgh8K1yodWiyUUAegsJJ1XQH71Q8KV733YQrFwKPNsPxw9DAfakDuITlw0rECMbybB
	 Gd+7SSveD0sayfz25XDpPsEmox2YA7kZLyWj9p0RXkYIzki+P66CN/DvczjOQKl9nua5Q
	 G3n8aJPe/0a7MM9dcC1wfg2b898+181ATNmRkONEkR8YW8ns6htlh52l+yjvAUEqJSz/I
	 cLobrmbAjOm+hqKvDRVSO3JNPjDS9f/OitCZqXG1XNH5/s2wzOAna+chylrr05sCTBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D76QwfCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD995606A31A;
	Wed, 28 Oct 2026 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D76QwfCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1034C1F01829;
	Wed, 28 Oct 2026 19:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215326;
	bh=/8We1i3UCbKQa+DjcWM0NGsxHNKskO9p01Y213NhDZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D76QwfCCrmNy/t7ewJTsZX+gg3Gp0ca2BCrzEN+Z1/kazcmNrFYOpY+esQOUJ4Grb
	 /PgxRinXeBuC46144OCgYATb2fof+hT4gmBlGXzAOSH5jauuRXWM4v6585vZJqtyoC
	 qB1wBIB7YC/wSnu1QQFjXpmkDTOniWEIECAMMMas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1171/1887] drm/i915/mst: limit DP MST ESI service loop
Date: Wed, 28 Oct 2026 17:54:27 +0100
Message-ID: <20261028170526.049996666@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 005771c18c5b2c98cb4e7517661aea460990fd3f ]

The loop in intel_dp_check_mst_status() keeps servicing interrupts
originating from the sink without bound. Add an upper bound to the new
interrupts occurring during interrupt processing to not get stuck on
potentially stuck sink devices. Use arbitrary 32 tries to clear incoming
interrupts in one go.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Note: The condition likely pre-dates the commit in the Fixes: tag, but
this is about as far back as a backport has any chance of
succeeding. Before that, the retry had a goto.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 3c0ec2c2d594 ("drm/i915: Flatten intel_dp_check_mst_status() a bit")
Cc: stable@vger.kernel.org # v5.8+
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260625142204.1078287-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit b4ea5272133059acb493cc36599071a9e852ec2e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index a538db3870cfe..b092649f01f56 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3864,10 +3864,11 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 {
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	bool link_ok = true;
+	int tries = 33;
 
 	drm_WARN_ON_ONCE(&i915->drm, intel_dp->active_mst_links < 0);
 
-	for (;;) {
+	while (--tries) {
 		u8 esi[4] = {};
 		u8 ack[4] = {};
 
@@ -3900,6 +3901,11 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 			drm_dp_mst_hpd_irq_send_new_request(&intel_dp->mst_mgr);
 	}
 
+	if (!tries) {
+		drm_dbg_kms(&i915->drm, "DPRX ESI not clearing, device may be stuck\n");
+		link_ok = false;
+	}
+
 	return link_ok;
 }
 
-- 
2.53.0



