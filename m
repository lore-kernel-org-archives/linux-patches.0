Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C917B1D0F61;
	Wed,  2 Oct 2024 13:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876386; cv=none; b=gPw0QXtdBM3yKrF0tdoehaAICgscoGktXiZ9jkcpj1QLz9FLm4g/aNoRduzq2p108/Ub8L9HY9UhGhRsmCaeu5/OJVNDi6CZCEs0KlrBs30SDsi5o78H42snPcqtGLNS/SY/6VA9bhqvpnBtsObJ1yvdElPJK4fJxrblXegiqDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876386; c=relaxed/simple;
	bh=xXUwodvPMRR5RR7ESFBJZZC39r7uPIabR8SY9QCNOF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYo+ITNrr91s7wgelVcQZRidoV+XGl0XJ4ILtS/M1add+vIK+LsSXG1y2Q3k5M8n8GjSQcVbkwHG1+/KtzbsUbDOPAcJ9ti/RnBZq8CQxnB08VHMTBXMyqrJT1wrZPt++lPkeVNDrOpHTMPf32S3/CX/FejJ1htE4gDRXSnpzxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHMit5C7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHMit5C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDEFC4CED6;
	Wed,  2 Oct 2024 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876386;
	bh=xXUwodvPMRR5RR7ESFBJZZC39r7uPIabR8SY9QCNOF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHMit5C7vZIPNeC74YUKSIt84cohFhAuzo5fa6Md20HRaJYEJWYJAuh6FO61RldKK
	 kSTdoF0XAfnt4PCmOBRLD/w8KrI+/3j4IKU1J+MhiiCgqm0pc/b4zQJrLLxISKYONd
	 qdvXT78Gw6+TdsVqzokmUPoVmpwV7WxvTmSpuR4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 395/695] clk: rockchip: rk3588: Fix 32k clock name for pmu_24m_32k_100m_src_p
Date: Wed,  2 Oct 2024 14:56:33 +0200
Message-ID: <20241002125838.223553861@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <eagle.alexander923@gmail.com>

[ Upstream commit 0d02e8d284a45bfa8997ebe8764437b8eb6b108b ]

The 32kHz input clock is named "xin32k" in the driver,
so the name "32k" appears to be a typo in this case. Lets fix this.

Signed-off-by: Alexander Shiyan <eagle.alexander923@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Fixes: f1c506d152ff ("clk: rockchip: add clock controller for the RK3588")
Link: https://lore.kernel.org/r/20240829052820.3604-1-eagle.alexander923@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/rockchip/clk-rk3588.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3588.c b/drivers/clk/rockchip/clk-rk3588.c
index b30279a96dc8a..3027379f2fdd1 100644
--- a/drivers/clk/rockchip/clk-rk3588.c
+++ b/drivers/clk/rockchip/clk-rk3588.c
@@ -526,7 +526,7 @@ PNAME(pmu_200m_100m_p)			= { "clk_pmu1_200m_src", "clk_pmu1_100m_src" };
 PNAME(pmu_300m_24m_p)			= { "clk_300m_src", "xin24m" };
 PNAME(pmu_400m_24m_p)			= { "clk_400m_src", "xin24m" };
 PNAME(pmu_100m_50m_24m_src_p)		= { "clk_pmu1_100m_src", "clk_pmu1_50m_src", "xin24m" };
-PNAME(pmu_24m_32k_100m_src_p)		= { "xin24m", "32k", "clk_pmu1_100m_src" };
+PNAME(pmu_24m_32k_100m_src_p)		= { "xin24m", "xin32k", "clk_pmu1_100m_src" };
 PNAME(hclk_pmu1_root_p)			= { "clk_pmu1_200m_src", "clk_pmu1_100m_src", "clk_pmu1_50m_src", "xin24m" };
 PNAME(hclk_pmu_cm0_root_p)		= { "clk_pmu1_400m_src", "clk_pmu1_200m_src", "clk_pmu1_100m_src", "xin24m" };
 PNAME(mclk_pdm0_p)			= { "clk_pmu1_300m_src", "clk_pmu1_200m_src" };
-- 
2.43.0



