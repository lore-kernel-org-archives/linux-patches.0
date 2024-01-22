Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B91312A17F;
	Tue, 23 Jan 2024 00:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968889; cv=none; b=p01SbRY8Dv13yPlGz1tNnhbwU/+U0AOVlFX79QeumYMKjqtCG2ZcIPjEs2YzEHZvQ4xtZFUWqrnL6/tMXc9E80+d0Sefcg/pwDrZs9YVADuTO+1KbHowDa/BTIx1iUeLCaK19RkhbN/7z1/f+eDE6MmDthYGe0Q5Ufo+e1dupXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968889; c=relaxed/simple;
	bh=dAIUzhptMwX+wTMslwuFzgX/QFmrRnjHfc42jX/Mc2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6156hxaTDN6T+uNpITFkLdeTBxfsladESyoUsP7OIq6DUa6eZpbK7vaWM2o4UTaVr3uwhefD+5Nx7S0ob7+4wtmUiuPkctP56PwT0aUjmKSylKP7cWo8svW+HfneVGSLAxWJ92OrGvn7sTplnrG0r3kJRvHyFILWEq/2l/17cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06uA0a7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06uA0a7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF426C43390;
	Tue, 23 Jan 2024 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968889;
	bh=dAIUzhptMwX+wTMslwuFzgX/QFmrRnjHfc42jX/Mc2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06uA0a7VDB5f0GA9pt+H6PT2acIpzp7yXaEJ3MSjCepGqIHfQNHR+MnqM4vQEu3Nw
	 waEmazN+bZTvEMDhTYFZp63TwTL1bugtJq7Dq+nkEd70YiL3Vfntxln5Cm7K+QqxcP
	 pHjzPiAnc1V9NsKBwRK9/U0/FX4//acUx4OnRDjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/194] wifi: libertas: stop selecting wext
Date: Mon, 22 Jan 2024 15:56:52 -0800
Message-ID: <20240122235722.768281022@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b9fe598130c3..38347a2e8320 100644
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
 	---help---
-- 
2.43.0



