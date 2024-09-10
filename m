Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A665A17C22F;
	Tue, 10 Sep 2024 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962219; cv=none; b=pVhb50xbUjC8FRsCm3BweW741Xob2/260amF6/HjQnznx3nmRsCOOGFoj60JbodYKUgl+2bVkqDo541AlM8vSM3uG6XlkfWBccvgioldACbeLQO11EZSMVD2RN6bL8Hw2AfzAytTLG7QssnaEdrmHTm7vL7+W+rqSb8gTna41tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962219; c=relaxed/simple;
	bh=wLCRd7h07Jf4/i0cSDPsWfAB9JcldxbRmSyN7LV9f9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcB/OL+J1jPLOJtBRu+mKu/XGH8iyUR+/QP4eWJl7CEYjNebfu+z0cTGu4SpBo1gpz6eploDy81exqh66xrn0ATPfoRNcpfqlrCyQA00iqgi18u9ZAZ9VF9JZ23ccjuOj/WFzDDkmzMxMIP6NPeOD2tyiOuyqwot9JT3wnn9io4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWlKjGF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWlKjGF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24627C4CEC3;
	Tue, 10 Sep 2024 09:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962219;
	bh=wLCRd7h07Jf4/i0cSDPsWfAB9JcldxbRmSyN7LV9f9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWlKjGF73AdWg3lPjZUWNbKPODM+sAYjPUGfH5CwQZ8ObDJDLaaYRff5QfYAlDIJU
	 452qVoU/8u703VnHl81CyZZzWbh0wi1MDfM558yiznpAbfXnEywWJkLQ535oM4kjlz
	 QeyU03lpuHBdbA+9UG7iW7cULQpuqZGlZgTDda1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bommu Krishnaiah <krishnaiah.bommu@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 335/375] drm/xe/xe2lpg: Extend workaround 14021402888
Date: Tue, 10 Sep 2024 11:32:12 +0200
Message-ID: <20240910092633.833297760@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bommu Krishnaiah <krishnaiah.bommu@intel.com>

[ Upstream commit b196e6fcc71186134b4cfe756067d87ae41b1ed9 ]

workaround 14021402888 also applies to Xe2_LPG.
Replicate the existing entry to one specific for Xe2_LPG.

Signed-off-by: Bommu Krishnaiah <krishnaiah.bommu@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240703090754.1323647-1-krishnaiah.bommu@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 56ab6986992ba143aee0bda33e15a764343e271d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 303f18ce91e6..66dafe980b9c 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -485,6 +485,10 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_RULES(GRAPHICS_VERSION(2004), FUNC(xe_rtp_match_first_render_or_compute)),
 	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, SLM_WMTP_RESTORE))
 	},
+	{ XE_RTP_NAME("14021402888"),
+	  XE_RTP_RULES(GRAPHICS_VERSION(2004), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(HALF_SLICE_CHICKEN7, CLEAR_OPTIMIZATION_DISABLE))
+	},
 
 	/* Xe2_HPG */
 
-- 
2.43.0



