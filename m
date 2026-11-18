Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016273;
	b=dfrkEIGAf26kiKLLhN4teQszNy0tQ3jl3E9loIlGdrc2iUUGDzruhpLbHUt6VMTQ2eZO
	 NfFQ3jJyC65PSdxL8MHMvgBrVg1VG3MMrw5dOQcsr5KYd6YT17CLd9U7V8jddwf+3cS1H
	 3oJ2B3YwRjqR8yHNxNuC1Z8X677phud7644+gzXz8qCp5Y4k5vW2OFNYlyIKMuQH5ym3R
	 8ydrEBR9Oh6Z86f0pcaLk2EopyfKfeCzVDIFM2fZfaK6wQh4s4GnYaZm+qDRLUb7LPcME
	 Q6lODTDJ7GQBRdd2JfKIutYbXmL95hlFPtO+I2LT5R7UZS6UtHg2wPSvRpLVVxdYP3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=05EdumEgkUfsBeuFxsvMv10nEGhFNfozWIOR7rELMKA=;
	b=H4j7kAt4mSK1PwNNiqtAOO8KDq3mTI5+TB0bhptYkSd2O6IRReP6BRS4JWObNxLel6u9
	 TfnZ5OOHyvtqtlJo3V2Q/Y7oYnsW1nbO4zM5hpuCjm7Lm32E3V2GsVdJPaVc95lvgZMJS
	 RM7y1vfIa+WLauJY9KzxnpmzRpjsJI1iUCheF3P05TwgDGvBigCJerXYGfafflf4QJgLs
	 CeduYDZUeOxiqPXhnSR0PqzCe3mmvw8B2sj+mV/P9dbOpuhcXnkQtmTfOE5wL/J+zeE/f
	 fJ/iEYgbU7USCY5+BT8DltOfXZiYrxc1Yxo5TYQPmKwm1frFzvrTWd0lg1mXWkwbkTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b7/rXKW1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AA760A3817;
	Wed, 18 Nov 2026 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b7/rXKW1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F9D1F000C5;
	Wed, 18 Nov 2026 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016272;
	bh=05EdumEgkUfsBeuFxsvMv10nEGhFNfozWIOR7rELMKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7/rXKW1EzCSurT9H4zihoNUEqPs9bfjhPMbezpVGvDAG3N6k2F5EqCIkP1UV9sYk
	 fWVg48/l12ZrA/lTNeZu5KNLdNRtBallAbJxnhsn80wWy2d4YCHcW/vjfb6xUILUvL
	 I8kXNl3mwL1ABY3PsgB34cM4a94GQwZ28ExSW59Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nemesa Garg <nemesa.garg@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0468/2651] drm/i915/psr: Clear stale sel fetch enable bits on sel fetch disable
Date: Wed, 18 Nov 2026 15:28:28 +0100
Message-ID: <20261118150304.645198897@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nemesa Garg <nemesa.garg@intel.com>

[ Upstream commit a4c0e7f80429eda6990960971aebd4e4b9533cc6 ]

Selective fetch is dropped while pipe CRC is active, and the planes keep
their SEL_FETCH_PLANE_CTL / SEL_FETCH_CUR_CTL enable bit set in hardware
over that. A plane disabled while selective fetch is off never gets the
bit cleared, as the disable path is guarded by enable_psr2_sel_fetch.
Once selective fetch comes back the hardware resumes fetching for a
plane that is no longer enabled and keeps its DDB range reserved.

Clear the bits as selective fetch is turned off instead. Atomic check
has both the old and the new crtc state, so record the transition there
and let the plane and cursor arm paths write the registers to 0 for that
commit.

v2: Drop the old_crtc_state->hw.active check. [Jouni]

Fixes: b1f5279b5981 ("drm/i915/psr: Move plane sel fetch configuration into plane source files")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8739
Assisted-by: Copilot:Claude-Opus-5
Signed-off-by: Nemesa Garg <nemesa.garg@intel.com>
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260909110332.3528029-3-nemesa.garg@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 7aaf5b4d35035..01c36ea315fa6 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2899,6 +2899,19 @@ int intel_psr2_sel_fetch_update(struct intel_atomic_state *state,
 	bool full_update = false, su_area_changed;
 	int i;
 
+	/*
+	 * Selective fetch is not always usable, for instance it is dropped
+	 * while pipe CRC is active. The planes keep their selective fetch
+	 * enable bit set in hardware over that, and a plane disabled while
+	 * selective fetch is off never gets the bit cleared. Once selective
+	 * fetch comes back the hardware would resume fetching for a plane that
+	 * is no longer enabled and keep its DDB range reserved, so have the
+	 * plane update drop the bit for every plane of the pipe as selective
+	 * fetch is turned off.
+	 */
+	crtc_state->clear_psr2_sel_fetch = old_crtc_state->enable_psr2_sel_fetch &&
+		!crtc_state->enable_psr2_sel_fetch;
+
 	/*
 	 * Selective fetch is not always usable, for instance it is dropped
 	 * while pipe CRC is active. The planes keep their selective fetch
-- 
2.53.0



