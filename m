Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDA1233730;
	Mon, 10 Mar 2025 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628277; cv=none; b=Umsqa9UgvFd9vxNZ52ObWcrI5qlJUCixfeRTHR8Zsm3kjW9jBp6piR0QDDwqcAxrbGXCpulLqrMvgnEPwaB13DasQO23zjbmrC40sv8omuiWEX7RAjCVxo1p5Y1keEDH7zw/kVdPgZwd1Rzdc9jvJSAs7O1hBTlYd5RkLoizcHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628277; c=relaxed/simple;
	bh=wUbxtYKpBEtVWNbuOvOc+blsTi9FyeecZ/dBT5oO6D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpYP0wzPtm3mEZ/5tVmfzhmbGf4nptu6DdGflsdInldsHtwL72m50OvjpObpEeoZGwM9oG0746LiwxzuGFYVlyq6Rz4hR7LyHOXtwOD85zbZ1YZKEVnqH/p6CNuvTvQBbZVcMPM9r2dE3vQ1sjde8VLvQ6pWvNMy9ONK9j5ZTg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ng60YzHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ng60YzHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D12C4CEEC;
	Mon, 10 Mar 2025 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628276;
	bh=wUbxtYKpBEtVWNbuOvOc+blsTi9FyeecZ/dBT5oO6D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ng60YzHgcyos6SO4yzC9g5+DkHYtwU+imtnVoTxR4xoV1k4zUl96HC23/Gr4SeWiT
	 gNYdebg4jRjmHy/EceA/RsyF5JmoVhFtp0zzoI4aiVoyUA0m+LYSyiXEigh1Fh/hsT
	 fB4bkbmMvLkMxoiSI0BTDxIgSigrBPQVnnF0q3tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.6 137/145] drm/i915/dsi: Use TRANS_DDI_FUNC_CTLs own port width macro
Date: Mon, 10 Mar 2025 18:07:11 +0100
Message-ID: <20250310170440.285686100@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 879f70382ff3e92fc854589ada3453e3f5f5b601 upstream.

The format of the port width field in the DDI_BUF_CTL and the
TRANS_DDI_FUNC_CTL registers are different starting with MTL, where the
x3 lane mode for HDMI FRL has a different encoding in the two registers.
To account for this use the TRANS_DDI_FUNC_CTL's own port width macro.

Cc: <stable@vger.kernel.org> # v6.5+
Fixes: b66a8abaa48a ("drm/i915/display/mtl: Fill port width in DDI_BUF_/TRANS_DDI_FUNC_/PORT_BUF_CTL for HDMI")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214142001.552916-2-imre.deak@intel.com
(cherry picked from commit 76120b3a304aec28fef4910204b81a12db8974da)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Imre: Rebased on v6.6.y, due to upstream API changes for intel_de_read(),
 TRANS_DDI_FUNC_CTL()]
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -797,8 +797,8 @@ gen11_dsi_configure_transcoder(struct in
 
 		/* select data lane width */
 		tmp = intel_de_read(dev_priv, TRANS_DDI_FUNC_CTL(dsi_trans));
-		tmp &= ~DDI_PORT_WIDTH_MASK;
-		tmp |= DDI_PORT_WIDTH(intel_dsi->lane_count);
+		tmp &= ~TRANS_DDI_PORT_WIDTH_MASK;
+		tmp |= TRANS_DDI_PORT_WIDTH(intel_dsi->lane_count);
 
 		/* select input pipe */
 		tmp &= ~TRANS_DDI_EDP_INPUT_MASK;


