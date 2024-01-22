Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3309F38DCC;
	Tue, 23 Jan 2024 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970630; cv=none; b=LGBNUcIafNmX66GbJZPHD2qZofqhmgasqXlHsSAHa1DcO02LcqQPdzZX/idVs2sq3Z27jRzplejJ3MRZph6H14bbbNVpScNdupX4ZOxq7ZcYQH2d+Qz4ynqN9slc8zoIVhqg+MyDlxxFztu6kMqJK1F46Hb1Z4pOYgB6UsoJSuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970630; c=relaxed/simple;
	bh=8QVensG15CVagcYt1WJ357Fz2QluUNo/Apo10LyiMr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rji4efn1libEF0t1CGNZ22gAQ/Wqqb3exsSYy0182M9jwZDZfAr/KuT8LV6gMaeYm93SVWxUCm8SAFkYXfhcLSA/NuHCCEco8w5GXyh6WbSChry31o+o/O5iZJxpu3bgfrY8o2jVFCe6D/udeq5uIdpmLWUwaFKaf1sFKHUwzuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYJJcSuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYJJcSuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D050EC433F1;
	Tue, 23 Jan 2024 00:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970630;
	bh=8QVensG15CVagcYt1WJ357Fz2QluUNo/Apo10LyiMr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYJJcSuMGDeYr3XJ4gZ+Ac6YFt4y5dNAjQu3mdlHOoeUSxzNltVOT0gPqraWLgF9L
	 jCBj4Uv4xTvGuBaGZtiXe1lzTZtPaRs3EWQVtxD9OE4eCt9k5GjdQ55FatlPLUuWJo
	 MHS11F6DytoSuuqMYXZ3TdkNP7/PTIz4AnXAIscY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/417] wifi: libertas: stop selecting wext
Date: Mon, 22 Jan 2024 15:54:01 -0800
Message-ID: <20240122235754.242502666@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



