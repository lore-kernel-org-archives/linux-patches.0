Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA64A14A4C2;
	Tue, 23 Jan 2024 00:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969213; cv=none; b=iR9cbd5nn64vdnzJhIAaWQAjnE4Qwzet+poUWz4y8yojm56iZ5Mp5wwqMW+Pt5Re8OmmjZTYW1gYywD2eV8Tp9vhWhg02JhOJFFvTCWKIZn3aFoH0rmODR9lnR2KCw7NjCLzduBSuG3pyRf6i5bLKjgbzRA8mTzmBLh6PbdsZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969213; c=relaxed/simple;
	bh=dTvoyuzPbVvZJlrvqvna5VAPOPcn6SuGOcg7ivkFvR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUXL4y+Dk3eyXIyp+B4fXp2vCDeeVjD2yOJImvTO+gKY+PBx84lrBwi8DxHo5mSGrSSh96whQGVDsEzODPFwnPdc+r3Du4d14Pw7jm3UdcxgHoUlR5UN6tDMvK4pQewW9JUIw7ptxcCtvW/RUGOFEbWgCREViVnjMM1eizE3rmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qb1IGKm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qb1IGKm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539C7C433C7;
	Tue, 23 Jan 2024 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969213;
	bh=dTvoyuzPbVvZJlrvqvna5VAPOPcn6SuGOcg7ivkFvR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qb1IGKm2pdapw+xNJXcgu9HZhSGrMKHSeQn29c0tJDe+m85Ki0IkwdHVm9MqUXDR8
	 gmHNAH56R6N7I9+T+g1mbfw52mwOEVpQ8RagG6Azpz+/cx6tLqBHiI1ZojNBNRNTgy
	 Pw6DA3Q1KTaXfXakOzL+jTqfrOV24/9J5SExMVts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 102/641] wifi: libertas: stop selecting wext
Date: Mon, 22 Jan 2024 15:50:06 -0800
Message-ID: <20240122235821.228247318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



