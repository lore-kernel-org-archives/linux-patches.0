Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060832;
	b=tOmK9mt8lYP4ST1S9Sx6lpoCU6fzS/WBO57JsmI/7/aeSb0N7UxW/2DG2uRAvc8YfMp8
	 sNVtIR6t2uSZjn+7XRG4WPKWl7ItEsrZad5y3qDth5yKlSOeutGWsvtTz6ZNfLDOuxfVd
	 dQVdwruv1ypnIffuiG9rFatC5XeDPWhRLWNBh3YVYsRcwT+EyZN5IIwvRJxZdOcyuo11k
	 +Kc50Tx3uLZJNeC4IknHVE9Zta5m3G4Spsel/HTP0hysCY+LtsQZaXc/K070SmdSWMy8D
	 2yb83Y8wPMM509sOT6IKEEOjQH96Su5jpsr7DVvFrr3Lw80snA0juVxoEyDNsKQyHmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iZR/BBqEPWnAGwf94IqEZieX8HcJNEFkpDWK3wpXr3U=;
	b=yPV2yAMS1aDEVre3U4OANmGJdbUZWDbbFIfE+/OtDNMQNrgj/ThGrmS6cR2CiInJrP2T
	 u/GU0coMm83JmZOfTPczpSC8TTnu4OMHso+/BLjhq9BlUmEq1lgMukQj8OHJko3lpp50d
	 4Wn2SOU9139Fkk6xNIFJ3OaLJIx+oTBy8e2/LH08oEQ0o7D3j1ctFAn0EGnILVRb3XLyf
	 GAPuFkd3DZ08GqxeFJ+proshfFQPXGCJb9V7WhuJp79Dy1j2Qd0vXnj6LHE3sFChZMAb5
	 j4XF2yhBg4iHdG3c4sprBP9BCRbNa5FnNHNssAR7NTrMQxoohat22WZaogSjzF5wFhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uODZmrLl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7816D606D80B;
	Sat,  7 Nov 2026 14:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uODZmrLl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A61F008A5;
	Sat,  7 Nov 2026 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060832;
	bh=iZR/BBqEPWnAGwf94IqEZieX8HcJNEFkpDWK3wpXr3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uODZmrLljh5xMHlwB7lGNIXK6UXCJYD2W23ykIVYDo5iqKRLnsPQ/pm/zKyWy43qm
	 xE9tjga7dupZstvFb6vrfGSsQm6aUIJDt7pxmh6xydG3MfoEqEWmS8u088lVZQ5hop
	 5XsYUWcjFamBirY+DsGRcvAdkrawdE+FCWi0Obpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Dmitry Osipenko <digetx@gmail.com>,
	=?UTF-8?q?Jonas=20Schw=C3=B6bel?= <jonasschwoebel@yahoo.de>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0225/1536] clk: tegra: support 48MHz clock for pll_p_out1
Date: Sat,  7 Nov 2026 08:37:21 -0500
Message-ID: <20261107135003.986290903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 46e31d69a547530fbef499bde888b6bb45a1deac ]

UEFI on Surface2 sets pll_p_out1 to 48MHz which is not supported by kernel
and causes BUG() early on. Add 48MHz clock support for pll_p_out1.

Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Jonas Schwöbel <jonasschwoebel@yahoo.de>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 100b5d9b7e26e..976feb8f41277 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -575,6 +575,7 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 		break;
 	case 9600000:
 	case 28800000:
+	case 48000000:
 		/*
 		 * PLL_P_OUT1 rate is not listed in PLLA table
 		 */
-- 
2.53.0



