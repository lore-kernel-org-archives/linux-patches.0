Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE735680;
	Tue, 23 Jan 2024 00:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968414; cv=none; b=MyZi+7GLbVsNRETnU9hiv7Wa830IWmI+NEFmbc4NoL8fWTDMckLojf92vTHIXHbe7MiiR92GmoROC+VTCYEfalmBb2LNinmcq+MGJuVG5qLIGu9aFaUKHYVkgM1R1wtRfX00X+A1PtTuzcL04Vy6aV6GCc3fU+N8Cbmv/TgiEsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968414; c=relaxed/simple;
	bh=c3QV8F4uFjhqKWN1Ajma9+uXnf84a1jBVnKS0BilwBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7jHXI8COWm230DWTPFmHJGsELt/xXQcrCJrLjoPS1Su93ZHG/UjeLhr1qfmb5DeHkCsVzYEilGnl8Rb6aoKd0R4TpT5ZSd14lLaN9IJKbxjSBKENKL6jYEN2CgI+8T4HckyhoU+tPrLTm+vIy5yX+O8QrCEPoOSlNaXv0zUwPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyYWSkFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyYWSkFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334A0C433C7;
	Tue, 23 Jan 2024 00:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968414;
	bh=c3QV8F4uFjhqKWN1Ajma9+uXnf84a1jBVnKS0BilwBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyYWSkFLYA9QpG4ovsw4DsEGcIf6f8yQJWQSN5uDhPFaUK6DLw6wWs26+pASJORv1
	 7ungiagL8V3yyBjFgHn3Kwg/vJydgIS6uzP+LXm2MlSIrWOFS7Jkb3P4jfqKhqHMig
	 s1/+1tEESdNA70/QSVSWw36EA2qyqdIvDax/zAXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/148] wifi: libertas: stop selecting wext
Date: Mon, 22 Jan 2024 15:57:01 -0800
Message-ID: <20240122235715.020032620@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e6268ceacbf1..28985cdac541 100644
--- a/drivers/net/wireless/marvell/libertas/Kconfig
+++ b/drivers/net/wireless/marvell/libertas/Kconfig
@@ -1,8 +1,6 @@
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on CFG80211
-	select WIRELESS_EXT
-	select WEXT_SPY
 	select LIB80211
 	select FW_LOADER
 	---help---
-- 
2.43.0



