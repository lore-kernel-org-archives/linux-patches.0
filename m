Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044137;
	b=DsXiy5G6ECdk7BN5VrL3eWQKsD/TgOYMrUzxOBjjJXygwbEqdKhO5YgpUFQsJ0Z10umv
	 X/ZqgtWrVVTsU3yqZFwGNvQs7U4Y6u73rnJ4PfqRIjtY1s836rv29+vc6mNXFQ6NZlaAX
	 D05wne0jDG0ERXPY0hQVNecaRKmxMMcTD8KKK8BE/ZD0eQJlzi4IWbCFXHO378o/YJeeb
	 6UNwOgqxx46/R9uvZZvSEmYIXOrN8PRjfjaNCm6R+jxloVcOlxBbqvuIPZN/Sprdqu1SV
	 5QLTxVV8VJY7UQpB4QFaV30slRwDaIwzC++kkkQRTuGqExnVu4wT6AY84ccpeaOKB5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=QIk5OXufl+Lzm415K80XRXPM0DAcb3xdrW4l6ZizG3M=;
	b=WVVw5SzqB/uwyGuZZuMLuvnXwlqbrT1zt5zAgKDd3IGLT4he+ZR7IniUUFWMUNUw9UGD
	 5xFHVCMRXvA8WqfeJWs0NateiIJsF1v5tDz1J8mgXmMOYEXcRdePij3/Tt6gsDJwj7CwA
	 L+RRv9RmaVVeCjykd1N+Q0hfawJPAqyLlDg7QGJIilILoYIZbMaO6Rse+L5mrR2I0C1Q7
	 1f4XMNiaccdrh1U5QeAwhxtM4ZFsb7D9b/HdhDOoHz1AYndgXeV9IcFhpUlcXak2R8IC+
	 OUxaUC5cwUOAw65K2yAuWUP4sH4rQNFfD5BunuaVthUTZOCYWz0h4pmc+TCSfQDAwgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B/n7DACy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A7F606A31C;
	Wed, 18 Nov 2026 23:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B/n7DACy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123A41F000C4;
	Wed, 18 Nov 2026 23:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044136;
	bh=QIk5OXufl+Lzm415K80XRXPM0DAcb3xdrW4l6ZizG3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/n7DACy5rWyUVAscAo1ye3cznNL2oaG2oWZk3mZY8K+9Nd2xsnFEM1bO1QKJy+26
	 sjj1DyMRcoPc5q+G9mD0iCd5tknXwFuWgkEO2BgcEU+nh1jRNkHPGR6+L5uTHFm8d4
	 JRJMJWqzTHH+YTOBmG7VUuOG7j0c6C3I2V3DOHCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0458/2857] drm/amd/display: Whitespace cleanup
Date: Wed, 18 Nov 2026 15:24:52 +0100
Message-ID: <20261118150217.912676624@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 3335a13535312c9fad4d8d1307a621e6617d6ed8 ]

Commit 075e2099c32c ("drm/amd/display: Fix race condition in DPIA AUX
transfer") was backported to stable, which I noticed because of git
saying

	linux-6.1/.git/rebase-apply/patch:37154: space before tab in indent.

while applying patch-6.1.21. While fixing the code location that issued
that warning, improve in few more places.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c5fd4eaad50d ("drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 14f2cfcba5f65..2aec7ddd5a725 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2336,9 +2336,9 @@ static int dm_late_init(void *handle)
 	 */
 	params.min_abm_backlight = 0x28F;
 	/* In the case where abm is implemented on dmcub,
-	* dmcu object will be null.
-	* ABM 2.4 and up are implemented on dmcub.
-	*/
+	 * dmcu object will be null.
+	 * ABM 2.4 and up are implemented on dmcub.
+	 */
 	if (dmcu) {
 		if (!dmcu_load_iram(dmcu, params))
 			return -EINVAL;
@@ -7087,13 +7087,13 @@ static uint add_fs_modes(struct amdgpu_dm_connector *aconnector)
 	/* Standard FPS values
 	 *
 	 * 23.976       - TV/NTSC
-	 * 24 	        - Cinema
-	 * 25 	        - TV/PAL
+	 * 24           - Cinema
+	 * 25           - TV/PAL
 	 * 29.97        - TV/NTSC
-	 * 30 	        - TV/NTSC
-	 * 48 	        - Cinema HFR
-	 * 50 	        - TV/PAL
-	 * 60 	        - Commonly used
+	 * 30           - TV/NTSC
+	 * 48           - Cinema HFR
+	 * 50           - TV/PAL
+	 * 60           - Commonly used
 	 * 48,72,96,120 - Multiples of 24
 	 */
 	static const u32 common_rates[] = {
@@ -7719,7 +7719,7 @@ static void update_freesync_state_on_stream(
 		return;
 
 	spin_lock_irqsave(&adev_to_drm(adev)->event_lock, flags);
-        vrr_params = acrtc->dm_irq_params.vrr_params;
+	vrr_params = acrtc->dm_irq_params.vrr_params;
 
 	if (surface) {
 		mod_freesync_handle_preflip(
@@ -8274,7 +8274,7 @@ static void amdgpu_dm_commit_audio(struct drm_device *dev,
 		if (!drm_atomic_crtc_needs_modeset(new_crtc_state))
 			continue;
 
-	notify:
+notify:
 		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 			continue;
 
@@ -9303,7 +9303,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 skip_modeset:
 	/* Release extra reference */
 	if (new_stream)
-		 dc_stream_release(new_stream);
+		dc_stream_release(new_stream);
 	new_stream = NULL;
 
 	/*
@@ -10699,7 +10699,7 @@ int amdgpu_dm_process_dmub_aux_transfer_sync(
 	if (!dc_process_dmub_aux_transfer_async(ctx->dc, link_index, payload)) {
 		*operation_result = AUX_RET_ERROR_ENGINE_ACQUIRE;
 		goto out;
- 	}
+	}
 
 	if (!wait_for_completion_timeout(&adev->dm.dmub_aux_transfer_done, 10 * HZ)) {
 		DRM_ERROR("wait_for_completion_timeout timeout!");
-- 
2.53.0



