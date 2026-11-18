Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057432;
	b=4NhkAnPCUxawEMqbMx09W5NaBmHLDmBrJ7S2ff7seskHohYYTB6MREQ9CcNhYVc3wz9S
	 msja47Uv/K6GA3vCyOS306TZJbkhVRvFafhlNJ08d6CmiVVlFa74IBkWTXJnV43Gwh2fA
	 6fse4XnTPHMmJsemSjcy60tjHT4VfpdU0FSlYce8yf5YvqS44spLb9z/eWpZFzDGKih9x
	 gm4a0BkkX5fVrLLeRPrFgBJt/YPhW7qeT6zHhbuHn52z/N71MPdXLiAEl/WsZW7bpwwst
	 xuBkc00WKu3KNCDMqEg8Zela9ooX/SQtPNDxTojTAMcVtx6DFKQhBun2gooMND1JA7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wDwOumBOurZvnp3Qx8zEIsk0yVJJrjd7/TLZYd1H2A4=;
	b=FzNx0mByQSK0TEwsOIWidhaBRG12PRcbupgQCTHeZ3UL6B2gYhtd8EZa1SZMT4CQnzCc
	 YzU9gHgs3JxyQu46hpntNPevj8j45mWRrpV/jbex5uclDMii0x2yC6oFAWUiGrUWH9FLq
	 /i2WOfP2jO2sUL9PE8ycJWRRvEz3n6OXu2sswbqD9AOZutsR1qSzh4xFHS2oTqZutVHvd
	 4lBmN8XoP5VbKqnJblU+yrB8iWB4T2s5WcTbq3i4U4xeUCXZwQPNprMc/9vnbpEkysYtR
	 SJo9xh099Mqf/qeNTzBdDBAanMo5Q8Zhw7NfPR4uauZPMdRqprEG5QXt8+s2FEa5foA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GD6yax82;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1A560A2612;
	Thu, 19 Nov 2026 03:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GD6yax82
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E4F1F000C4;
	Thu, 19 Nov 2026 03:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057432;
	bh=wDwOumBOurZvnp3Qx8zEIsk0yVJJrjd7/TLZYd1H2A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GD6yax82fxu9pYDX9FDT8kXylMMZDbGDfcNdYWcJXTs3i4nlLS4JV/eDRaZ7tNmEl
	 hyCOMADpHvfOl4JjlLQwN6OPmq7RoOrLU5yhk4FXdcur4u8FvZHaGwBswlITysjwX9
	 dE0sizWmdIh9yWPyd9AD1dSVIo4OrRrlSBZdCQ2I=
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
Subject: [PATCH 5.10 0127/1848] clk: tegra: support 48MHz clock for pll_p_out1
Date: Wed, 18 Nov 2026 15:36:05 +0100
Message-ID: <20261118145916.420523546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d709ecb7d8d7e..fa5f1ffacda01 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -572,6 +572,7 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 		break;
 	case 9600000:
 	case 28800000:
+	case 48000000:
 		/*
 		 * PLL_P_OUT1 rate is not listed in PLLA table
 		 */
-- 
2.53.0



