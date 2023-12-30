Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9188821;
	Sat, 30 Dec 2023 12:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzC1KXiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB695C433C7;
	Sat, 30 Dec 2023 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937811;
	bh=e61Oqmwic90DzW+97ScCaOLBgOduYy1ZJkPoFwU2Pes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzC1KXiNgpB3RFzw1qpZ7zy1WHoCf6SIjIoHMDuIDpZ+63HHEsYyJbyKlbWIM0mzz
	 wq2VQ30aClARFzLvCxMEhbDfUasHG0ixnq7VGwKiazVEfC5deIgCGnWLUY8debZ+To
	 TtWaSDDTCujvpSG8Hh1TIr6DTvOO4C6DXHQ1Akq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Kahola <mika.kahola@intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/156] drm/i915/mtl: Fix HDMI/DP PLL clock selection
Date: Sat, 30 Dec 2023 11:58:45 +0000
Message-ID: <20231230115814.676026540@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit dbcab554f777390d9bb6a808ed0cd90ee59bb44e ]

Select the HDMI specific PLL clock only for HDMI outputs.

Fixes: 62618c7f117e ("drm/i915/mtl: C20 PLL programming")
Cc: Mika Kahola <mika.kahola@intel.com>
Cc: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Reviewed-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231213220526.1828827-1-imre.deak@intel.com
(cherry picked from commit 937d02cc79c6828fef28a4d80d8d0ad2f7bf2b62)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_cx0_phy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_cx0_phy.c b/drivers/gpu/drm/i915/display/intel_cx0_phy.c
index 80e4ec6ee4031..048e581fda16c 100644
--- a/drivers/gpu/drm/i915/display/intel_cx0_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_cx0_phy.c
@@ -2420,7 +2420,8 @@ static void intel_program_port_clock_ctl(struct intel_encoder *encoder,
 
 	val |= XELPDP_FORWARD_CLOCK_UNGATE;
 
-	if (is_hdmi_frl(crtc_state->port_clock))
+	if (intel_crtc_has_type(crtc_state, INTEL_OUTPUT_HDMI) &&
+	    is_hdmi_frl(crtc_state->port_clock))
 		val |= XELPDP_DDI_CLOCK_SELECT(XELPDP_DDI_CLOCK_SELECT_DIV18CLK);
 	else
 		val |= XELPDP_DDI_CLOCK_SELECT(XELPDP_DDI_CLOCK_SELECT_MAXPCLK);
-- 
2.43.0



