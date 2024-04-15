Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B72180BFF;
	Mon, 15 Apr 2024 14:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191501; cv=none; b=a4CQv3O8CpBy2PHJZD6OOLkGXmLjIoaCOR72AWuiYuBAllC+EJzinG5TUbDHKKcFGxhHLf1h9hszrZ5ZsxWDCWu8XDtwpl65cFE4Ef0e2l9pNAFwb9xKlB/qE/GSjTMb9gMmBiikIDSXidR8zWSbeaTHxZpOjsdTtrtw6LvKoYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191501; c=relaxed/simple;
	bh=//VueV5QYHGq3JYncIb+kNnNNPcYoq+L67/2D11gj90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aa3LmpDoBLgeooCsq+Pl3f3EhDTo3W2N2ekHk71VsQXp7zO1zysS4Z/gmJ10IqcVhSGWVGIxmYCCU6QA53FWEHmDZUQX7YZroFc9uiKuoYij4VZ5I9wWJIcHDblpy2OWQPqkEAlE2nARr3VpZpWtk4+xcLOgCWCXaBKbBQzAck0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrK/UZQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrK/UZQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D6BC113CC;
	Mon, 15 Apr 2024 14:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191501;
	bh=//VueV5QYHGq3JYncIb+kNnNNPcYoq+L67/2D11gj90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrK/UZQw5JOilQXcrpJfvA/A6mruDg6aiVA8UTXO6HgNi8rxwDKUzsUtV0TmAUtdl
	 odqtzYxjEOU9DOOPkoLX1Z+g6eO9hl3xJ/DP78JowQmqpyMeZd7FOSDuuuXMhzyKwa
	 WSjnpk7Tl0QdNR+ig8PauGThNl4nRXRFgSyvpSUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 162/172] drm/i915: Disable live M/N updates when using bigjoiner
Date: Mon, 15 Apr 2024 16:21:01 +0200
Message-ID: <20240415142005.275555921@linuxfoundation.org>
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

commit 4a36e46df7aa781c756f09727d37dc2783f1ee75 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2756,7 +2756,11 @@ intel_dp_drrs_compute_config(struct inte
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


