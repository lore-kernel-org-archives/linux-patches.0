Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A6D5EE82;
	Tue, 23 Jan 2024 01:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974413; cv=none; b=CtbQxhgvrXOyKnBopmORBeWWxdq9cwr1mmIcXQw0jhL1wJr0CzbYy5nH1HIYnekVXoZ9foqW2KI2GzsaqViOLrpYBprz3pQUm7ZNRED5sH1mRYbz81hAMqG4jXw4YnlgArIcHwjWlXbKmrBgfqNM68PVPPpniyRHQyhBuUpjHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974413; c=relaxed/simple;
	bh=NhCCrmzB8D0/ZnMbnL+nBNLU/obDF2enl9vDvky8EOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCSyIUuWKadsmW5bJhV+7QOsVthV5htnUkGgjBptgp3fZhhaPZxav1SpnaxplZakPIdITSIL2NwdLQWrHoxRb7Uz9e3j/wpv3QzrUelFglVXfUxw+PoyTYCVu5Rxj3RuZlTxyJS3cYeRLw7giKSu4ZdYNlOMSe4DpV2JmU/PofI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNfOha4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNfOha4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE22BC433F1;
	Tue, 23 Jan 2024 01:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974413;
	bh=NhCCrmzB8D0/ZnMbnL+nBNLU/obDF2enl9vDvky8EOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNfOha4MjPfP9pe6YyDBaCP9YOkcOI40Jd6OTjekC58vb9MTdG0u4jQrPEtjqWIhc
	 ugq/HwKpE+XbH/a5puJdzhuYl7Wt9QP3yS5jZADgVqv2Zu6mVc5tWmVAOYi28JrQvz
	 ORdh/Iul9yMHALogyvoCjKxDx2FN5C7k9+/QiBXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/583] wifi: libertas: stop selecting wext
Date: Mon, 22 Jan 2024 15:52:22 -0800
Message-ID: <20240122235814.949725808@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8170b04c2c92eee52ea50b96db4c54662197e512 ]

Libertas no longer references the iw_handler infrastructure or wext_spy,
so neither of the 'select' statements are used any more.

Fixes: e86dc1ca4676 ("Libertas: cfg80211 support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231108153409.1065286-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/Kconfig b/drivers/net/wireless/marvell/libertas/Kconfig
index 6d62ab49aa8d..c7d02adb3eea 100644
--- a/drivers/net/wireless/marvell/libertas/Kconfig
+++ b/drivers/net/wireless/marvell/libertas/Kconfig
@@ -2,8 +2,6 @@
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on CFG80211
-	select WIRELESS_EXT
-	select WEXT_SPY
 	select LIB80211
 	select FW_LOADER
 	help
-- 
2.43.0



