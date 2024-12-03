Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEB91362;
	Tue,  3 Dec 2024 15:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241244; cv=none; b=imY3v7v3CdgQCSfEpRNPlaOZfEXAK29HGcN4nRyQ/46uEySJdCytb7mgTscAafdOebNodbODUK9Qu62WqOzOHrGMDCyglzJz2tVDPOXv/HXO0ALQTmQOgfsk5ljwPK6mcEahMmPVlhaj5FjKvIjJRXYrfi5RFXvfYSyjqDpDrr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241244; c=relaxed/simple;
	bh=MVR32JMcRrNyrCKD3fpSK95t4sjMrmhKgTXiZx38QQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2tJsfLu5evlpLTKdHd30jrkK7E/IRx7oV3A/pZ9vjASVy5hy1tVQ3KvOqIbEC7YZRraWH9m/Vwc57DR5kU0nPNKYDogUVM1LJMLg4N0pvKtSQakJ3M+FMs08nJKujjSeLjLQSeza0YGFmYmXAfaQzg/wKQmQdp3jt4ZvpUMGrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWy6TgCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWy6TgCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6422EC4CECF;
	Tue,  3 Dec 2024 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241243;
	bh=MVR32JMcRrNyrCKD3fpSK95t4sjMrmhKgTXiZx38QQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWy6TgCG9Uvi4KC2X4nOm9npj/xGyJ+N8DXbcWMTQ84Hsm8rxor5mygPcHDok52I6
	 GB5R9dL2TsQdhi4xFbSXFWa9T+SUeK6rvJ9cJX0VrfF6t4YrNsRe/TPG1LE3IAXTem
	 YLm4eFEnYBgmc1o2BXwKnDyTfJ9MDdxUnSiQsSfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 365/826] pinctrl: renesas: Select PINCTRL_RZG2L for RZ/V2H(P) SoC
Date: Tue,  3 Dec 2024 15:41:32 +0100
Message-ID: <20241203144757.998182602@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 5dcde519a067ac5c85c273e550dde1873e2199bf ]

Add explicit selection of the PINCTRL_RZG2L config option for the
RZ/V2H(P) (R9A09G057) SoC, ensuring pin control driver is enabled
for this SoC.

Fixes: 9bd95ac86e70 ("pinctrl: renesas: rzg2l: Add support for RZ/V2H SoC")
Reported-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241010132726.702658-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/renesas/Kconfig b/drivers/pinctrl/renesas/Kconfig
index 14bd55d647319..7f3f41c7fe54c 100644
--- a/drivers/pinctrl/renesas/Kconfig
+++ b/drivers/pinctrl/renesas/Kconfig
@@ -41,6 +41,7 @@ config PINCTRL_RENESAS
 	select PINCTRL_PFC_R8A779H0 if ARCH_R8A779H0
 	select PINCTRL_RZG2L if ARCH_RZG2L
 	select PINCTRL_RZV2M if ARCH_R9A09G011
+	select PINCTRL_RZG2L if ARCH_R9A09G057
 	select PINCTRL_PFC_SH7203 if CPU_SUBTYPE_SH7203
 	select PINCTRL_PFC_SH7264 if CPU_SUBTYPE_SH7264
 	select PINCTRL_PFC_SH7269 if CPU_SUBTYPE_SH7269
-- 
2.43.0



