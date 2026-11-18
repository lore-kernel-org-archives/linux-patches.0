Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043301;
	b=iijT6dqpkseHH1W3h99oehHfO+wwHcEzKPOBlGi7EdYhdBbnqPIqfl3JFrCD6qZEycKi
	 1LAWwIjc9eVZh5JuOKwNS3KjqKHzcQ8pS5im8AvazoohTu6HFd3H7tFbFboJ1QslFdQA8
	 h8PSr594lfKcet31DaBvZauWGeFTzj2DmNa8VfjxRbdZ6KBWa0H6A6b+GAuEGXL5OrsNP
	 5J8p94JeVkHZTwlwnj9nVSG1WC1Gs33joKSeh3FDqJUtPDgMdZCoNWNEnJEscBEoRNSoS
	 7SLN8EzDJCYIcNts6FUOhqaVVkv0OurSAwah02ne+0xgbemoysB7PDnJhbKMfXSZDgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hJ/5f5YlWVqkKsWnxVEEuoKBcf04Vow+iZFCb+/6WcU=;
	b=Ldu0BBrmB69gyhFa2TNoVbpTWQ+9pks6J/opF+36qJ8X/NbSur0lSX4XEa9oCic8FIhM
	 upUPuVy3L+ez/KCuQLEXOoqhoHujhXyfP3Fdgd9fnvvv1z3sql+ptJV8EuVMg792IUAmc
	 FDZDuElBw8N1JS/1C2zT5zrvY87RTtwPo8ERvhXdRFa4M53qIl/bRk00E3D/sYNgxMtDA
	 PE6EPB9s/CKrP89WcJ9INhS0bSrBLY7dC7Al6e9V6TSfgEXqLyc+MsS9fdojvMRkyxp2r
	 wwklgGJQdvj3AxzeVO/zWsOtqE3KWTkregD09oNpAR0uBH0ToKv/yWHQFHwwWRH/46w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T39zLMcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56269606A325;
	Wed, 18 Nov 2026 23:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T39zLMcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43DA1F000C4;
	Wed, 18 Nov 2026 23:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043301;
	bh=hJ/5f5YlWVqkKsWnxVEEuoKBcf04Vow+iZFCb+/6WcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T39zLMcgKxMjxR0FBwpVj6PjdPlQw3qnu299cOb+q5VZD8l+ItVt0rPBmUA4rbp5q
	 mINvD5WvW0wMAv9zZUnQNH2/hj0HS0RA+Dk6+eY0hbhVbU34+r860swh911ERdhGb6
	 Qcjelb4c2F6wuNtVgcP5vyREWCohm771IK8466NE=
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
Subject: [PATCH 6.1 0163/2857] clk: tegra: support 48MHz clock for pll_p_out1
Date: Wed, 18 Nov 2026 15:19:57 +0100
Message-ID: <20261118150207.221156604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



