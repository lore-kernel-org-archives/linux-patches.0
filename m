Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272842686B1;
	Tue,  8 Apr 2025 11:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110036; cv=none; b=GGOS3YXqYicJnYEgD5H7kgS3bNPUGn18jJmCuCv1EmfH7eOR3R265y3pkp1L2nRUoNtD3+vAvoyxZx4E1PSsNF5O+2qVF/bmKtYrniJfS15j7HVHYi7wD82K3j92ELAb912oj97EPYW0IY+YHtcjtLGr515wxv8Iu5z6UUevXNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110036; c=relaxed/simple;
	bh=m4roogYVKSfvncYiL2xcMdD2hoUxBfvqgAPZs0pDSl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWEkF23Hb2cw+LdRTqlvgRepE8zxjv89SqsJ9Xcq0nb0juN7HWsQ/duNXMOlx9eu0Ujc85owFxV5kb3KhoOwNg4ImFuKw/t03dJAWnFD/C9p7+jY4QhVqw2DqzzMIbq7lqAhuKBBbpLyVC0qYH85dgUAoxLoUYCgRuZv6cTUmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yziu7nc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yziu7nc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55793C4CEE5;
	Tue,  8 Apr 2025 11:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110035;
	bh=m4roogYVKSfvncYiL2xcMdD2hoUxBfvqgAPZs0pDSl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yziu7nc9p2Gh9O5alZMMdIPmjXsoUMkSWqjhSyWEPG/pFmGa9MwEDAY1UjXPgBCxG
	 xrhUIhdg03g/+qtH4nCRpkoMLNdnVjL5Di0O2vpNZh2Z3JqmlpEUX9W/uh8Z3t/jU9
	 rO+Tb9+0jXzUX13g1YFWFkAClaXwb2qYkQ17MMoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 144/227] clk: amlogic: gxbb: drop incorrect flag on 32k clock
Date: Tue,  8 Apr 2025 12:48:42 +0200
Message-ID: <20250408104824.625274897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d42551a46ec91..a6428823371bf 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -1309,7 +1309,7 @@ static struct clk_regmap gxbb_32k_clk_div = {
 			&gxbb_32k_clk_sel.hw
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT | CLK_DIVIDER_ROUND_CLOSEST,
+		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.39.5



