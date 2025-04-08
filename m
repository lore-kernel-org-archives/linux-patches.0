Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C1A94A;
	Tue,  8 Apr 2025 11:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113183; cv=none; b=VjtadIfaYMhwHDncVZS96yX+/hf98pFVNMxONSlN3pAsqarHCGmjPKiVc9PMINS35SxDLDWaBC9y2BS8ZSDDSaokf5zEMZvd/mfZnS/uXddDQqB4SXSPxXzXTgkjwJu9i2IUuejT84w7/9DMou6oNUTMck3fb0e4pCRadlN6Tt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113183; c=relaxed/simple;
	bh=SOexQzTcDn3ZxNfb91pA0gSBFBujpl3wEJqwkSTTXWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwCje6k4prKNRlNv8N2CqMOq0/eX+oN1/9DN2Pywgx3gXeB3jX7OpiEBoNyGR1VyCcT6Tm/LdV4sjELsoaGbZlohFJnxZfh6S4EdXXOU6ZBMXVzjkvwsutKpBa4mdwB4x9VfTR0QeuwZ1Bhdm28VvsfGGbYPGyE8g2AixHoGclw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FffC0C5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FffC0C5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BA7C4CEE5;
	Tue,  8 Apr 2025 11:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113183;
	bh=SOexQzTcDn3ZxNfb91pA0gSBFBujpl3wEJqwkSTTXWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FffC0C5GZqH59w6Qi89+zc3h/di+D3bIaOb2Qj3v03yieU48eH6KTciHQY0YnSIEU
	 H6BSSK9nzqY5wQMxvDm1YUjrTZxl0tx1JAQIxw5ffqu/jngUOAfs9I1cDvs1U52TBK
	 14ep1Pw8054EczxU4x158ZPqtIuMpVPU3HDUrrwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/268] clk: amlogic: gxbb: drop incorrect flag on 32k clock
Date: Tue,  8 Apr 2025 12:47:53 +0200
Message-ID: <20250408104830.171827927@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit f38f7fe4830c5cb4eac138249225f119e7939965 ]

gxbb_32k_clk_div sets CLK_DIVIDER_ROUND_CLOSEST in the init_data flag which
is incorrect. This is field is not where the divider flags belong.

Thankfully, CLK_DIVIDER_ROUND_CLOSEST maps to bit 4 which is an unused
clock flag, so there is no unintended consequence to this error.

Effectively, the clock has been used without CLK_DIVIDER_ROUND_CLOSEST
so far, so just drop it.

Fixes: 14c735c8e308 ("clk: meson-gxbb: Add EE 32K Clock for CEC")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241220-amlogic-clk-gxbb-32k-fixes-v1-1-baca56ecf2db@baylibre.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/gxbb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/meson/gxbb.c b/drivers/clk/meson/gxbb.c
index 1b1279d94781e..ef89285a86fc0 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -1312,7 +1312,7 @@ static struct clk_regmap gxbb_32k_clk_div = {
 			&gxbb_32k_clk_sel.hw
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT | CLK_DIVIDER_ROUND_CLOSEST,
+		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.39.5



