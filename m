Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89AE5187CA;
	Wed, 30 Sep 2026 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791359; cv=none; b=a9Ux56ZSLipVv1qd5b4Jr1vpQrYbdqsc1drhKDCpEMgOu02LZUORphtHHe8bAx6tF1MWMj1Vm2UQ4VWtv1sQGU86VHSmBMGmsqiezH2MUUZFVSj3Qv1J3F4RF8iRKmYxAjo9CkNCe+Ow0cNGrwvcmPA+jYn2WUd4AlskHYVNg60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791359; c=relaxed/simple;
	bh=8FHtO/3MByBN7EWRCg7ZWzH0R/fBs4ztpx55MB8ilNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0Y8y7Iogy5iHkossQiE/uuRrT6qb2VhLXe5hq8AJFA0FjxVY9Vo1fa90qvX8kIszlcT7LnUfQSHJ+ZVX9On6ef+zHRoZ/hSyZa0Hmvp5saM70zK7YlsfRvTddDghn+Mx60scouQqFT+Hqlg7eyWhXmizrODpXTewFjWEVAV+CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3QeWw/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3QeWw/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BBA1F000FF;
	Wed, 30 Sep 2026 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791357;
	bh=VL9GLH0cO5QmD6NPCiet+1D346q4JM6vuHxJ/IcVJio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3QeWw/u+nU7a4bOEYb/OPbvT3t0aOtd1xMy4Xc2rp1+JKdTAd20QHUqwglIjH1+B
	 Ppdone6aRfQ+SgcRfXQQ853KW9J5nnfPsSlPiuI/YWLltfMCnhf/xqXdMIgj3DWKYV
	 Mb6gYrsXPOwBvcbKzAMtLOlonKxbh67Ege5rDIiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/752] clk: at91: pmc: #undef field_{get,prep}() before definition
Date: Wed, 30 Sep 2026 17:21:39 +0200
Message-ID: <20260930152403.216782276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit dbfe51513aae6bace00cc390e11cb486a64a63d2 ]

Prepare for the advent of globally available common field_get() and
field_prep() macros by undefining the symbols before defining local
variants.  This prevents redefinition warnings from the C preprocessor
when introducing the common macros later.

Suggested-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/pmc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index a49076c804a9a..0469ae58376ad 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -98,7 +98,9 @@ struct clk_pcr_layout {
 	u32 pid_mask;
 };
 
+#undef field_get
 #define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+#undef field_prep
 #define field_prep(_mask, _val) (((_val) << (ffs(_mask) - 1)) & (_mask))
 
 #define ndck(a, s) (a[s - 1].id + 1)
-- 
2.53.0



