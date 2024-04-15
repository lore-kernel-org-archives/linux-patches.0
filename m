Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389EB811EB;
	Mon, 15 Apr 2024 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191492; cv=none; b=iy1z5daONaGr1qApxy/KvTIcb7BacMYf5RMQTFaFIDIOaihGLBjJXCeIjYbq55TjhXnI7wvdGZITzgSSKXcLuLcgyh/D5NSt3QZ5c5Vr6YsvDA25izQPfuNslhImukCcUvEuTAk8h9Zbn1i71kR87euWpMl0MAFqRK+743twIAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191492; c=relaxed/simple;
	bh=uoSLwY9RvpbUdbw6bY2bZX4zLHVWCmLE3ZzYYQ3Jx6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YhcE1baNsbnJJR9PY7MstaTKGSrdKp1N9RQ+3tC+l51etw3rY1dIXBuopnKHmvZH4kDPff9eOAeKQJdiW15s8/OL2M/f/qvt4xnoRGqj9H2r+++5+RQQbWbW9POtSWpPnZmuZCZoCcGaaufTdz0STbqtgvOpM5S1ZYpzU7t4x/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyzR4u6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyzR4u6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F65C113CC;
	Mon, 15 Apr 2024 14:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191492;
	bh=uoSLwY9RvpbUdbw6bY2bZX4zLHVWCmLE3ZzYYQ3Jx6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyzR4u6pqPTleJAkzjCduV5D69QYU+apIuiMDsPGS62/x8gYY05KEAduIeO3Qw1MD
	 mOpxMqewlTCAvncmp9iAFgw/XMt7P/lxowXA6/eA0l5huJ/FmKoTavSd5J/AZ+V3x2
	 dl3lfzUJ3cNlmVQvNHziILlvVIkVs7QanjN80jHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun R Murthy <arun.r.mruthy@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 160/172] drm/i915/psr: Disable PSR when bigjoiner is used
Date: Mon, 15 Apr 2024 16:20:59 +0200
Message-ID: <20240415142005.217364899@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit e3d4ead4d48c05355bd3b99c8162428f68c3c1a5 upstream.

Bigjoiner seem to be causing all kinds of grief to the PSR
code currently. I don't believe there is any hardware issue
but the code simply not handling this correctly. For now
just disable PSR when bigjoiner is needed.

Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20240404213441.17637-3-ville.syrjala@linux.intel.com
Reviewed-by: Arun R Murthy <arun.r.mruthy@intel.com>
Acked-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit 372fa0c79d3f289f813d8001e0a8a96d1011826c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1368,6 +1368,17 @@ void intel_psr_compute_config(struct int
 		return;
 	}
 
+	/*
+	 * FIXME figure out what is wrong with PSR+bigjoiner and
+	 * fix it. Presumably something related to the fact that
+	 * PSR is a transcoder level feature.
+	 */
+	if (crtc_state->bigjoiner_pipes) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "PSR disabled due to bigjoiner\n");
+		return;
+	}
+
 	if (CAN_PANEL_REPLAY(intel_dp))
 		crtc_state->has_panel_replay = true;
 	else


