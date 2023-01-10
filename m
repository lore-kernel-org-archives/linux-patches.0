Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B47474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEEFC433F0;
	Tue, 10 Jan 2023 18:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374859;
	bh=blPbxiJS8xaEfUuPdOJp/iP2vaDLqlAVnfXRSlY6OHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXWbCJk7QfMzhj0rqTZ1uwD2xBYw/+QkkLx1EfNZyYpP5KbhOpQkW5hvF3Ox/i5vJ
	 N0JeRU73U2XbeFLmLINCowP3aWQVNbJ0EGfBifPydx64rEoJhjN2qWCkN02rH9iXKO
	 Edoeii1f2xQh0ixlAeblFWVTXbU5U1GrSlLK4UsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 157/159] drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index
Date: Tue, 10 Jan 2023 19:05:05 +0100
Message-Id: <20230110180023.569812671@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jani Nikula <jani.nikula@intel.com>

commit 6217e9f05a74df48c77ee68993d587cdfdb1feb7 upstream.

Due to copy-paste fail, MIPI_BKLT_EN_1 would always use PPS index 1,
never 0. Fix the sloppiest commit in recent memory.

Fixes: 963bbdb32b47 ("drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221220140105.313333-1-jani.nikula@intel.com
(cherry picked from commit a561933c571798868b5fa42198427a7e6df56c09)
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -430,7 +430,7 @@ static void icl_native_gpio_set_value(st
 		break;
 	case MIPI_BKLT_EN_1:
 	case MIPI_BKLT_EN_2:
-		index = gpio == MIPI_AVDD_EN_1 ? 0 : 1;
+		index = gpio == MIPI_BKLT_EN_1 ? 0 : 1;
 
 		intel_de_rmw(dev_priv, PP_CONTROL(index), EDP_BLC_ENABLE,
 			     value ? EDP_BLC_ENABLE : 0);


