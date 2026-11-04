Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829728;
	b=PlolwavIE6fikOfOhRStcK9SpP3phDcMChGlMDb5igunnIYPDGSswPObeY75vb4WsN+j
	 C+b3FVKOZqtnrCetnS7pbXSzZnEc7scPfDSowpdX8j8NDcvDS7yPxrfXEZ4/mklGoLfyP
	 6tQ8sgjp8758jmeiErWgqXbwmoM+R2BBvDH8jQ8U+FRDZJBayXCgmfY0o/sX/Ds1K4E/U
	 hBRZ94qtDpA6iUxRNuyEKAHYn3jR9gKRBv3babsVJJHaw8S1KdaidpjvFRQ7rjuX2Eqy3
	 daZpAxFTr0+bzSVjMqGVTZjcdaYvmNqf+tynyeI1S1KdbkWz0u8cz34YC28Hm1Bo2IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+6L4XgcqIPeF4nLUp4WtF5x8OFrDhZApDVx8gBRg23o=;
	b=cUhB0CDCYpKz1a23h/7uJ12w5NLK5wbfPNGNC+dpcQOc4VwQK+2pLlIsUAUJhZam6Kgy
	 y23O+AIh2FDswmNlKxE2ab6Zb7JxDo/gWBh//t3v5czuJP3KqLVR/JAd8Rp0oQbOIxUEH
	 hdGnLJ5Z5xGBzY2B+nAGgLGisLPncHCsuaVRwWwcIQpLbN4Y1pawfX9DGH8VjwJ1nMUPo
	 9vnB8IPt1WAPAql83f026BQsrrQcsn/3xaEHclfOPzgpWTHAfa1DiW7XAkYs80eIj0DvA
	 IeVHAphstK257y/glHpV0k1EyxbuqzvTWRbrYSvQJ3Hil0EEmfW3QFxHW/SXcLomg0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyB6ZB+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386B1606C90F;
	Wed,  4 Nov 2026 22:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OyB6ZB+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F961F000C1;
	Wed,  4 Nov 2026 22:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829728;
	bh=+6L4XgcqIPeF4nLUp4WtF5x8OFrDhZApDVx8gBRg23o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyB6ZB+WTn9QGQIHY5unJlS4Me2JwBi2Hdf2i9s7VcDaH3oV8OFVcAYba6qdRpT6L
	 g5v0/yUAZ+AHCuW26ORORz8haEwLWhmAOMuAFw0gQNMZurGmv7fuvkMRuIzC6YXgFz
	 aj1ki1RH3sDMeEV+ivc6mizee18Q+PJ8NjphRmXs=
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
Subject: [PATCH 6.18 0266/1005] clk: tegra: support 48MHz clock for pll_p_out1
Date: Wed,  4 Nov 2026 15:59:59 -0500
Message-ID: <20261104211051.324691254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 591b9f0c155a0..e48ca3f4b5f86 100644
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



