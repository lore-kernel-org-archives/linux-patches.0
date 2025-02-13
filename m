Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFDA70830;
	Thu, 13 Feb 2025 14:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457230; cv=none; b=IwZpsrGwZVrzy7qyesB4omDUlBPz9pyKPeB7sjqrVyGLEDgYipEd0NGLitv1zN4JW8T/8psKAck6Ki3WF0io9raxhKzTaS8dvTJsE4FPK8mZ8iyHwM+jhQCDt8oLXbYM/cMqd4TkPV94R668ej23VeUDTr8dENg4rhwxiIHM9uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457230; c=relaxed/simple;
	bh=Tg+PcGOpSerrPzRvNgb9XcYOklqFrb/xpAL9hCoOCjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PW4QatGCNpGsY+nUAY4WwMuS4ZpD7GYFNcBjpYbVFYP7HlHkYb5tIQxmgBsKE8r7KjxoAawkcXy9lXYKZ63CA37dfb8QJsmj+UEmv8ZssSmgt7C+3r0hq5xQmxRCvLvhx3LMZxRWTzBEuzJk1sM6mp0i/BAezz5YF5siu6AVIto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dk8liOxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dk8liOxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54082C4CEEB;
	Thu, 13 Feb 2025 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457229;
	bh=Tg+PcGOpSerrPzRvNgb9XcYOklqFrb/xpAL9hCoOCjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dk8liOxkhNVj+POzoSM+tyV4WG1kdl6HmSCou5i4Gg5nLTHQCd/hzA0vFOPYVNWLl
	 7xQkJUnKL82eUGZ3HpkLLXkS5sDYnRPgxQGPcGLSDDc+2A75HyzwP5dA4xYOtrYtW6
	 Q5zWzMeBVhFdcV8yOaQYhfc+iFRgGkZAfZrD2/44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/422] mmc: sdhci-esdhc-imx: enable SDHCI_QUIRK_NO_LED quirk for S32G
Date: Thu, 13 Feb 2025 15:23:20 +0100
Message-ID: <20250213142438.532228995@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>

[ Upstream commit 0202dfbdc5dea70e213205aa42ab49a1a08aad3a ]

Enable SDHCI_QUIRK_NO_LED quirk for S32G2/S32G3 variants as the controller
does not have a LED signal line.

Signed-off-by: Ciprian Marian Costea <ciprianmarian.costea@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Message-ID: <20241125083357.1041949-1-ciprianmarian.costea@oss.nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index ef3a44f2dff16..d84aa20f03589 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -303,6 +303,7 @@ static struct esdhc_soc_data usdhc_s32g2_data = {
 			| ESDHC_FLAG_HAVE_CAP1 | ESDHC_FLAG_HS200
 			| ESDHC_FLAG_HS400 | ESDHC_FLAG_HS400_ES
 			| ESDHC_FLAG_SKIP_ERR004536 | ESDHC_FLAG_SKIP_CD_WAKE,
+	.quirks = SDHCI_QUIRK_NO_LED,
 };
 
 static struct esdhc_soc_data usdhc_imx7ulp_data = {
-- 
2.39.5



