Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E5F26A0AE;
	Tue,  8 Apr 2025 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116335; cv=none; b=TItu8Uzn8fAjWmMOXw74u2UzTyzz35Z+h0H+sKKgs4H77pEY+uV1OX3LDaeFnNokb1vYnaEdLO5c84MpEOEOd6XMTwYATm9IiD89yL+7Jy3dMyRZauMoGe5mvQKazaGLUiy743jbcoB96YFGz5ygEZSCrTTq26ki1F8dLorRb/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116335; c=relaxed/simple;
	bh=6axMUNjEwx4TkdkciFRVrNemV+luIUM+zKTWjoSqV6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+STC4gTRsRuvKI5gFkwg8ks8VRhqY4xifuUnn8ZPbVUWWcY6fZma6ZecDbGPEl/X+N4C5hrvmYoHbrRevbS9iGrlRAkcgB7Gu+qSPHh5AzbinNXwjD4EZycLhC+HW0JhnNOr2AIUndqLA5L1OQgIUzXxPlQndfJEUGSyvH6OjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlZLlSa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlZLlSa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8C8C4CEE7;
	Tue,  8 Apr 2025 12:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116334;
	bh=6axMUNjEwx4TkdkciFRVrNemV+luIUM+zKTWjoSqV6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlZLlSa2Lq1MYhhG2Yg3GDGxvIJHZgroZHnK2sNIiqCUc9jt0ytFqasSlpIy/YSF/
	 8EkkMMHOEtVqi2yX7jSbhgIfqE2LyFruzBexzWPx4oxfLNssEjDNj1jtZO4EwtICsB
	 VB3276e+sbcuak3UGbDvtVTOhxRT99vUhtZGB4rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/423] clk: amlogic: gxbb: drop incorrect flag on 32k clock
Date: Tue,  8 Apr 2025 12:47:09 +0200
Message-ID: <20250408104848.135024560@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f071faad1ebb7..738317b3e274d 100644
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



