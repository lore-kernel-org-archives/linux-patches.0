Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5550E26A0FC;
	Tue,  8 Apr 2025 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114605; cv=none; b=cZJi7I3z0Fn/HJjV+tardLuEtfG/lpSuuuqqKXPfdQXVG/sMvHmwZL8WXFNi0rlXpL9Mw5qFbIFo5mkux2ZHeVQFuKqBXMCPl9iv0WGQvREMHdzMWxk/TNOUHl3/1HDdTpaGKNdNQKdO1F9aM6RHXVHtWG2BqjRW9irLP+OBjWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114605; c=relaxed/simple;
	bh=njLIv1B+qS0JRK40Yf+SY/X4FarncjJSpyg7mT75eOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUnEEitppni6875QS2OEjzh8+2GOEl5Fs50xOXjDV/LqgaZXDZHdQm2HiMJRr8JnrxlvZNhDJbdtFVstSw4v8CNlzlO5CoMKpMHNcuKEGV2Ce0J2HgqnF26OzFBhTGwNzgl4bYMdtjLGeIyq0Af59BqxnEQa8R5NDXwUEu+Joc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reuZngZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reuZngZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D55C4CEE5;
	Tue,  8 Apr 2025 12:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114604;
	bh=njLIv1B+qS0JRK40Yf+SY/X4FarncjJSpyg7mT75eOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reuZngZ+rh0wUEvDvTxA/PyAt+wpMIKj+6JyKjifw3i9YpUfkp8KeGjA+El72LMD+
	 C3hpV8O6tlXZSmToZDaTX+ROEqn8U3ob0FpZUBK7aEDCrOInPb2/seWdJqHrRYaFp2
	 UPFaTc0tOyEWMki/kC5TCVbGkDJidFqFmGGkAoP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 129/499] clk: amlogic: gxbb: drop incorrect flag on 32k clock
Date: Tue,  8 Apr 2025 12:45:41 +0200
Message-ID: <20250408104854.411462965@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8575b84853859..df9250de51dc8 100644
--- a/drivers/clk/meson/gxbb.c
+++ b/drivers/clk/meson/gxbb.c
@@ -1306,7 +1306,7 @@ static struct clk_regmap gxbb_32k_clk_div = {
 			&gxbb_32k_clk_sel.hw
 		},
 		.num_parents = 1,
-		.flags = CLK_SET_RATE_PARENT | CLK_DIVIDER_ROUND_CLOSEST,
+		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.39.5



