Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A563179DAB;
	Wed, 21 Feb 2024 13:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523538; cv=none; b=TPr43MS9R84IPjS4Wh4bK5MN+tNObUsu8knGnOpNMsQmI4AuxcY/hju+5mZ2wH1b7rFIOrA+I2qSHaNT+61t3LKEdQLLbiVUCTyTLUPQPyTdgqbTfIWVkKY+uDCwJ9AuK96re7RoAErs8guiSKdHmbT4TWyQIQy1e0jZ1FD0axQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523538; c=relaxed/simple;
	bh=5vmLuHXKwEEPIVPMPM4NztaAjI+ep5OFuUCqPu3YyiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1bqgZPDGe0A1PvRXtGZf9E/iFI6gkllENG4axeDsQ2NVsdcnD3+Wmn3DPVCRiWg4+gJdNZLykR3Nnw/ZoTwL01dv0Q4g+VAGQAVaEvydJvM+lXPWQwTKPm+3Lh8/wH3at1k5uf3h7l41sh/tBNLIdHPIPRCCBDrYehgUcq002k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKYboy2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKYboy2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D79C433F1;
	Wed, 21 Feb 2024 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523538;
	bh=5vmLuHXKwEEPIVPMPM4NztaAjI+ep5OFuUCqPu3YyiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKYboy2AAZGnjxmR14UQ92QZ+jGCES9fpe9yBDIoZuUs1m5PLu+JDJwcosaXN8F5J
	 29PJcC+7rH0EPd+axHlD06zHCi2g0QL0k4ixxkOIihqrOZ3bhsGmYQIVkIxbEzsC/M
	 fc9m8UtPRaXfAjWSTsD2nSTFlnEyofBCjcx0CKpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.15 467/476] drm/msm/dsi: Enable runtime PM
Date: Wed, 21 Feb 2024 14:08:38 +0100
Message-ID: <20240221130025.296608763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 6ab502bc1cf3147ea1d8540d04b83a7a4cb6d1f1 ]

Some devices power the DSI PHY/PLL through a power rail that we model
as a GENPD. Enable runtime PM to make it suspendable.

Change-Id: I70b04b7fbf75ccf508ab2dcbe393dbb2be6e4eaa
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/543352/
Link: https://lore.kernel.org/r/20230620-topic-dsiphy_rpm-v2-2-a11a751f34f0@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 3d07a411b4fa ("drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -752,6 +752,10 @@ static int dsi_phy_driver_probe(struct p
 		goto fail;
 	}
 
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
+
 	/* PLL init will call into clk_register which requires
 	 * register access, so we need to enable power and ahb clock.
 	 */


