Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08171158A33;
	Tue,  9 Jul 2024 11:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524211; cv=none; b=KsKIxI+UbF5uc3eV99fJfhSrAj6N47DlkmTCpkoyJJ0NzEaa7KBUpCiRpAHxYJeWy9Z0A3B7MBSfcuuBrVzaz3LLvwp6K31S7Nl5U89x4kflL6RAJtzBKb00MNHrjs+qc0m3LPl3+D2Uhfri+EzdmZBJKtVk6UgedauVaiRTByg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524211; c=relaxed/simple;
	bh=XabdlViLYPHXsVENkTGJe3TnyNbkE0jmVbLCbtcQIlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrtvcBhNm5iZ52/64AmPvs/EnL29l90tXQVt3nBNBK6KEgf08vh9rmuzupKFvUBz7zjcFFIWn9Fqf3K8YaytR+QgZNl7d9M8QnG7F3ksfMGgSA99d/VQSdGidbb1HUr9FRCx/X8aMvZjSXliqFhZ4wzgZXJHn47kCYyBDEh8KuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Okvsq+Em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Okvsq+Em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81938C3277B;
	Tue,  9 Jul 2024 11:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524210;
	bh=XabdlViLYPHXsVENkTGJe3TnyNbkE0jmVbLCbtcQIlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Okvsq+Em91a6q6EsMmtp+5hnpsciIZOVtOWosUsUCrv+F0i7tuLCrvYtSgbqXk9VJ
	 QispAMmgPE5RaQc62khnqbA1WYY3VxknwDLNSGgTlT87bkrWS+veuqYfbskeTnlJzG
	 WRlKXd41gvoh3rVUM60P7Paiei30vCidoHiJyHyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 108/197] net: phy: aquantia: add missing include guards
Date: Tue,  9 Jul 2024 13:09:22 +0200
Message-ID: <20240709110713.137631182@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 219343755eae6536d1fcb9184e6253ade4906aac ]

The header is missing the include guards so add them.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: fb470f70fea7 ("net: phy: aquantia: add hwmon support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://patch.msgid.link/20240701080322.9569-1-brgl@bgdev.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia/aquantia.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/aquantia/aquantia.h b/drivers/net/phy/aquantia/aquantia.h
index 1c19ae74ad2b4..4830b25e6c7d3 100644
--- a/drivers/net/phy/aquantia/aquantia.h
+++ b/drivers/net/phy/aquantia/aquantia.h
@@ -6,6 +6,9 @@
  * Author: Heiner Kallweit <hkallweit1@gmail.com>
  */
 
+#ifndef AQUANTIA_H
+#define AQUANTIA_H
+
 #include <linux/device.h>
 #include <linux/phy.h>
 
@@ -120,3 +123,5 @@ static inline int aqr_hwmon_probe(struct phy_device *phydev) { return 0; }
 #endif
 
 int aqr_firmware_load(struct phy_device *phydev);
+
+#endif /* AQUANTIA_H */
-- 
2.43.0



