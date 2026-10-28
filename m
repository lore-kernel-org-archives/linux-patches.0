Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214748;
	b=igFby/goBv7e/VzQDzoIaluulSBfMBBoDwuxS2JVaftQhIVJWeT9oPB6u6Kt0OdTkCZT
	 VY+DDcqA73PL7c0mLx9ZcC5KDgIsnTDMu1OqLGtP+MwxLn655FnrUPZ86O32XNJSVDUUq
	 Lgw7QLJG500IYEOMm8FC2bZsELI/an+oLAjwfDYkMjNP/elFumrLq2M7vlsYyb41L3Wkj
	 lWDoE0mWmN9P1ZNpaaAkO6MVjXfgjJZ54dXh1hoQflX3Nmh1l1viwvlxa9cglWiorgi2n
	 7OiFdpz+1MP3TLmtFp6Y3jzYVncwIQqtf5iAEjAUZWoCkYwBvh8tAQG1hLcgoqbhN4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ih+K+snXb+TEktm3bW3P+oHZefW0QiWUxFH0ec4alc8=;
	b=ze2Zf5C07tNX88PBw2sdbdmBBl9AgrfDVDcQc1SKa6+TVCNjTBwTNSy0goaudYp5a/iT
	 ys656OT+8CvTHTg5f7B6oIw6s/X0g/1SHt0y8hl5cfhCyOB9xTWKvdRTZFl/mV88b30Zf
	 2Od/gAhX2mBZ1P29pUazFkUVm6R1hB/ZrLPfXmlq4eq4fXuzvf3jzhIax3/Da6aIfKSfi
	 M8FcVyBglgAyPvf/FmrM5H+P2R5L1Yz5se+fruWxLmuD1llmLesfAzs6CA/xcCwIFUvP3
	 /XOzFRgZJ96bRA5ezanb0PtDP7dAQZzk6gAp7tTCcTzf3LnAeqXmRflEbgHMwPE3A+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvAsXwbH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFC9606AB3F;
	Wed, 28 Oct 2026 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvAsXwbH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6861F01825;
	Wed, 28 Oct 2026 19:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214748;
	bh=Ih+K+snXb+TEktm3bW3P+oHZefW0QiWUxFH0ec4alc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvAsXwbHawUBOXE3ujDswPhDg2868g9DV2e7x/bgT3FLkz1PIMpj/lBStVhnaopzZ
	 ubql+Ql/X5UMkCf9nQ2zuYCmUVYw/fxrIyB+oON5gFRr0217aOegRAeFFVYjkdUCWN
	 uekRqFb6rYshVre7PaopLdDmtgiKsVz1prS8G8GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0968/1887] drm/i915/dsi: Dont do DSC horizontal timing adjustments in command mode
Date: Wed, 28 Oct 2026 17:51:04 +0100
Message-ID: <20261028170521.438393954@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 4dfce79e098915d8e5fc2b9e1d980bc3251dd32c ]

Stop adjusting the horizontal timing values based on the
compression ratio in command mode. Bspec seems to be telling
us to do this only in video mode, and this is also how the
Windows driver does things.

This should also fix a div-by-zero on some machines because
the adjusted htotal ends up being so small that we end up with
line_time_us==0 when trying to determine the vtotal value in
command mode.

Note that this doesn't actually make the display on the
Huawei Matebook E work, but at least the kernel no longer
explodes when the driver loads.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12045
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260326111814.9800-2-ville.syrjala@linux.intel.com
Fixes: 53693f02d80e ("drm/i915/dsi: account for DSC in horizontal timings")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 0b475e91ecc2313207196c6d7fd5c53e1a878525)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index f7422f0cf579d..1134d01629219 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -913,7 +913,7 @@ gen11_dsi_set_transcoder_timings(struct intel_encoder *encoder,
 	 * non-compressed link speeds, and simplifies down to the ratio between
 	 * compressed and non-compressed bpp.
 	 */
-	if (crtc_state->dsc.compression_enable) {
+	if (is_vid_mode(intel_dsi) && crtc_state->dsc.compression_enable) {
 		mul = crtc_state->dsc.compressed_bpp;
 		div = mipi_dsi_pixel_format_to_bpp(intel_dsi->pixel_format);
 	}
@@ -1518,7 +1518,7 @@ static void gen11_dsi_get_timings(struct intel_encoder *encoder,
 	struct drm_display_mode *adjusted_mode =
 					&pipe_config->hw.adjusted_mode;
 
-	if (pipe_config->dsc.compressed_bpp) {
+	if (is_vid_mode(intel_dsi) && pipe_config->dsc.compressed_bpp) {
 		int div = pipe_config->dsc.compressed_bpp;
 		int mul = mipi_dsi_pixel_format_to_bpp(intel_dsi->pixel_format);
 
-- 
2.53.0



