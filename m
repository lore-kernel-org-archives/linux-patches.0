Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9EF30274D;
	Wed, 28 Jan 2026 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615544; cv=none; b=sesJAkFa3HVNplinDwDzTNWA/kRWoTU3YoWYmouBfjV0F/9PaYdg2N2kwmhE1opZj5oBMGyvV7DGqQ0b/X8TlMZJm3NlEIsfslvK/y27uv/afT822gMwszraDEblwnlPa3HeSbKCh7Tp+F1GbHvNisUpPkmmkhRzrkUij25pXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615544; c=relaxed/simple;
	bh=+OedOJJHn+/7yk5Irre3oYBuR2oYVNEEBas18I9owls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9vbTr13Ci5o057jfnbW2kK/FGo0xQW0B0eKCQeaxgJzA7a+xs7XaJ+qTEPWi5u3BJ+cMOpUpJk5uENSRs3v6NxlkGmwdbAxJbqXI3AHfEov1A5yvquSD4Hh2BBqiSEQ47xpL+KcxIYzESvcBplZeYSQGv52bsR+l4b5qYyXUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKKn9ov6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKKn9ov6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BF0C4CEF1;
	Wed, 28 Jan 2026 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615544;
	bh=+OedOJJHn+/7yk5Irre3oYBuR2oYVNEEBas18I9owls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKKn9ov6klTgW3Mns5pgvUcC2+x8kDL5jWFZ4cEMxZ0KAx2/gPFj2MIfwcVN0ATcE
	 gq4mKTXjc5PHasVp1KRnbWOeYeisK61okMRdRUDhS6w9KdjD2AgegEtMaFwmY89yLv
	 Fcr8nSui78xZ0zIROKGVaAgTbsy1qFpVDvTVLHBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Genoud <richard.genoud@bootlin.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/227] pwm: max7360: Populate missing .sizeof_wfhw in max7360_pwm_ops
Date: Wed, 28 Jan 2026 16:21:26 +0100
Message-ID: <20260128145345.821180776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@bootlin.com>

[ Upstream commit 63faf32666e03a78cc985bcbae196418cf7d7938 ]

The sizeof_wfhw field wasn't populated in max7360_pwm_ops so it was set
to 0 by default.
While this is ok for now because:
sizeof(struct max7360_pwm_waveform) < PWM_WFHWSIZE
in the future, if struct max7360_pwm_waveform grows, it could lead to
stack corruption.

Fixes: d93a75d94b79 ("pwm: max7360: Add MAX7360 PWM support")
Signed-off-by: Richard Genoud <richard.genoud@bootlin.com>
Link: https://patch.msgid.link/20260113163907.368919-1-richard.genoud@bootlin.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-max7360.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-max7360.c b/drivers/pwm/pwm-max7360.c
index ebf93a7aee5be..31972bd00ebe9 100644
--- a/drivers/pwm/pwm-max7360.c
+++ b/drivers/pwm/pwm-max7360.c
@@ -153,6 +153,7 @@ static int max7360_pwm_read_waveform(struct pwm_chip *chip,
 }
 
 static const struct pwm_ops max7360_pwm_ops = {
+	.sizeof_wfhw = sizeof(struct max7360_pwm_waveform),
 	.request = max7360_pwm_request,
 	.round_waveform_tohw = max7360_pwm_round_waveform_tohw,
 	.round_waveform_fromhw = max7360_pwm_round_waveform_fromhw,
-- 
2.51.0



