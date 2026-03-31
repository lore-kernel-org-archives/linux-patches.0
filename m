Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4892D77F5;
	Tue, 31 Mar 2026 17:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976409; cv=none; b=ba7BzRoTXKPGygssEJk0O+40+B5F+QRclOmyi2ohy4ffVKeYlLra/y8JIJyLb1k6t9Sx9bwO8RcfdBFtD2FBbeFknEc+7Waoli9a5tKPOLrVnw2sC1IfbVvtWa2LZrkRNRgdFWo3j6ONkaJwNAbdbY31T4oJ66B44DQIOjR59FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976409; c=relaxed/simple;
	bh=dlZbDEcZLWw80HPcGbEUA0vNRBlAqq+wcQb3SnsVfAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvsLHaMwFiSHKYZmAjg2oalOyZlLpz3l9X8vIUy/ctHnPlo30ygzbqsceabwAiV8aVqSkyzhKiLNE0/idaoDPv5l5nCt90w+tW/HBlgDuVymulog0vNNeOnSDu3eg7aSv73k8n+YzZ2njbOmOzEk+EpLm7lVgxvFn5sg+yPOrFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xS+CfiaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xS+CfiaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61829C2BCB3;
	Tue, 31 Mar 2026 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976409;
	bh=dlZbDEcZLWw80HPcGbEUA0vNRBlAqq+wcQb3SnsVfAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xS+CfiaEWp4gzbMfFXev5EDmJWyxBGGvXexWxjWsVqiCKMn1cUFqfiJbaOe2PYcr/
	 6FU6O9hu9RFSlbziFP9vsKgj1Pkg+uElanpfb1+4RTW8m1xxbgFEC6CCMOifZbNOhZ
	 bM2FUWWh9j6SNFta26G7oLKjzs9qrk7T2/4tu75k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/309] pinctrl: stm32: fix HDP driver dependency on GPIO_GENERIC
Date: Tue, 31 Mar 2026 18:19:44 +0200
Message-ID: <20260331161756.468469977@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit c8cfeb4b9dda2cdfce79519aee4aaff16310a7b6 ]

The HDP driver uses the generic GPIO chip API, but this configuration
may not be enabled.
Ensure it is enabled by selecting the appropriate option.

Fixes: 4bcff9c05b9d ("pinctrl: stm32: use new generic GPIO chip API")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/Kconfig b/drivers/pinctrl/stm32/Kconfig
index 5f67e1ee66dd9..d6a1715230121 100644
--- a/drivers/pinctrl/stm32/Kconfig
+++ b/drivers/pinctrl/stm32/Kconfig
@@ -65,6 +65,7 @@ config PINCTRL_STM32_HDP
 	select PINMUX
 	select GENERIC_PINCONF
 	select GPIOLIB
+	select GPIO_GENERIC
 	help
 	  The Hardware Debug Port allows the observation of internal signals.
 	  It uses configurable multiplexer to route signals in a dedicated observation register.
-- 
2.51.0



