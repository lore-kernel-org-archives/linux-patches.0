Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E1F143C6C;
	Tue, 23 Apr 2024 21:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908565; cv=none; b=NJgjwaPVWnRtQXB+Sj1uwYP5YBuZhZ+kndKFNJvmPrTKLrcRXrzuI1B40uq2ruI5nlMlYi7rrahJwui6To0Soq6k2YA1yiE1TCO4HNmts40gZDnImVR+N3ck8nqjUSm6uqGiSdfhaEDkVh7UQ2TFK17DRooUlz9JRBaUIicGCTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908565; c=relaxed/simple;
	bh=dqm5UxUBmkpbZpP7Ogs3l8R3Al/b6PZ1DQxORuyWMc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QEnZrdLXdlNep0Wx3BwfCVFFgn97qUB1tWqvSUkXiDWKo+gXLDm/XQQp4Xt+6ImsJz6ppUdb/gmmbZZofnVs6p8/5uKQOGAJf3RP57AfF9b1XfJRqo4/UcPKSebTjSDhO2wWhnNff9ogCcmGFV1r7xga2OBESlBRvNZiaRJ8qm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/DObU1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/DObU1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F9AC32781;
	Tue, 23 Apr 2024 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908565;
	bh=dqm5UxUBmkpbZpP7Ogs3l8R3Al/b6PZ1DQxORuyWMc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/DObU1J7IiVY0HA4JNg9Q167Q7YXB9zyCEBnDgsXdAhcFk5kNgcbWw0yZCJ6zVXf
	 NaqHMGIYSe7o5FZt3cw/0c+zzHUMvTkaRTNhXATd8iqIkm68HpO8xA26ldKzIc5bng
	 71/wVp3vi+CaqvH3wigpt1FDH8fsSmLRa5xc+vzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/158] drm/i915: Disable live M/N updates when using bigjoiner
Date: Tue, 23 Apr 2024 14:37:30 -0700
Message-ID: <20240423213856.144037398@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 4a36e46df7aa781c756f09727d37dc2783f1ee75 ]

All joined pipes share the same transcoder/timing generator.
Currently we just do the commits per-pipe, which doesn't really
work if we need to change the timings at the same time. For
now just disable live M/N updates when bigjoiner is needed.

Cc: stable@vger.kernel.org
Tested-by: Vidya Srinivas <vidya.srinivas@intel.com>
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404213441.17637-5-ville.syrjala@linux.intel.com
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit ef79820db723a2a7c229a7251c12859e7e25a247)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 7e135ed8e1d75..ccc47cf4d15d8 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2148,7 +2148,11 @@ intel_dp_drrs_compute_config(struct intel_connector *connector,
 		intel_panel_downclock_mode(connector, &pipe_config->hw.adjusted_mode);
 	int pixel_clock;
 
-	if (has_seamless_m_n(connector))
+	/*
+	 * FIXME all joined pipes share the same transcoder.
+	 * Need to account for that when updating M/N live.
+	 */
+	if (has_seamless_m_n(connector) && !pipe_config->bigjoiner_pipes)
 		pipe_config->update_m_n = true;
 
 	if (!can_enable_drrs(connector, pipe_config, downclock_mode)) {
-- 
2.43.0



