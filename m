Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1012EF672;
	Thu,  3 Jul 2025 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555375; cv=none; b=E9A/vjloKKpI6PfHr8KvLmsVCFXrinTP8HP6eg2d+M1hGjVnrlZQhhR48ewO2VKCHAOiZYKCb0rOMwHVHi2lw5TfsuvtfeiTpDwC91dQgUwKBhoitlteQFwtpHkzrU4mpU4g5DOmBwUa6e+OEnFP0LQMSkTRv3RzGw3ioh/Nv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555375; c=relaxed/simple;
	bh=mFe4qYb50uoh0cjxFuTWfs9ps05sb7dd0eta27FqhZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POE/I6cVV6V0P0DFXaYmTm0jfQIjPr+VPbiClFT9wFiPgkTPGggIsfyGntZfDAu0KNrHhLHf3RVn1y9XmXuUFMVDNBgQn6fN0szbHfh10ss6pq6GM2Ek9YQhslK7OSyM1sCRGHw3CMmSW4V6TfIgDepLlBQQTCdrVEJ04x2GGzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOxURZn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOxURZn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F3EC4CEE3;
	Thu,  3 Jul 2025 15:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555375;
	bh=mFe4qYb50uoh0cjxFuTWfs9ps05sb7dd0eta27FqhZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOxURZn/rg1bR/oJvxsWYHVs+b9k98SNulwfxcOyFEX/YjGsZE+kvauQeSv4qQyUr
	 PACKgwVgUBhPULXDKPHaqLd3FnEftvOf0UI+3vl/WcRs75Tmw9dJzr6fqh6qNAjvAV
	 DkaFa+/iYJ5SQ0Q3HCLpi0jmbiiMslXISU5k41R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.15 229/263] drm/amd/display: Check dce_hwseq before dereferencing it
Date: Thu,  3 Jul 2025 16:42:29 +0200
Message-ID: <20250703144013.580488627@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit b669507b637eb6b1aaecf347f193efccc65d756e upstream.

[WHAT]

hws was checked for null earlier in dce110_blank_stream, indicating hws
can be null, and should be checked whenever it is used.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79db43611ff61280b6de58ce1305e0b2ecf675ad)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1222,7 +1222,7 @@ void dce110_blank_stream(struct pipe_ctx
 	struct dce_hwseq *hws = link->dc->hwseq;
 
 	if (link->local_sink && link->local_sink->sink_signal == SIGNAL_TYPE_EDP) {
-		if (!link->skip_implict_edp_power_control)
+		if (!link->skip_implict_edp_power_control && hws)
 			hws->funcs.edp_backlight_control(link, false);
 		link->dc->hwss.set_abm_immediate_disable(pipe_ctx);
 	}


