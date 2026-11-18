Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058437;
	b=stJriB7ocRKmSzusLitdqDeJ9azrArukhbGEAD+GCiC+WWMtso9PM5E3DltC4T8ieZOu
	 au4KIrPSZmltlL0mIkHzbP1LRv12jjUud0BuZ4MOfI9UOXFmNPz9A3GDVFNCrZeDasfyS
	 jZIrkvsJJk3pbQyYGyxg0+uhANR0hpjP4VXzNwq2Ek7kQAsf0JYARTon/AWdEpcbGxsFZ
	 C8e85JiIE4qQabb/fiI/4EjqO0XgigqJy1Cgu0PR8JkLmJguaXYxPSYWeFr0FkSMDe1uO
	 q2hRvLrO5lZNVoW4dW18VXHwKKD0n9u7BTRE8Id+7gvhsJyUITNfVDMxdps2wRK28Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hKV94+TEcW0LVyHXDlXK2H2R4tjKT988DDJEICt7JTY=;
	b=zz/Nl9mzxYC5YzIa8LE3o7yNInCGxSpITsSdrCix89YInYpKsUSKK7hgczPqB5xrnQrB
	 R5gafKm6y8m9UrrDCCK9+xmz4PqKBXpBQbCluMI9D/5rFzb13RaqYYeK+JRB2ALZLVvku
	 fko2X+DSzVJywFtaPg5O390rNEW3bWabADKYmravpOwqH/yP2Ax5HKeoUJXe6xebcALp5
	 mgh6DYfBW5Fi12vTWdCoqrKrqMg9KUw5pjxx6EOGVeNp1gtQ/57wpo+jEVIGvXbDe727v
	 gLiZ/AQFhND/9odzCaXNexryToBcwnaKkqkIaWPJyBWFc2Dqz8DCOve9q//xkVoMRsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRM2+YT+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0A5606A332;
	Thu, 19 Nov 2026 03:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xRM2+YT+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4B01F000C5;
	Thu, 19 Nov 2026 03:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058436;
	bh=hKV94+TEcW0LVyHXDlXK2H2R4tjKT988DDJEICt7JTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRM2+YT+nm5EX+mKQf83OxOMlAPPpyBVFzjXpK8kw/V3kfpTark8/cq9zqdXsp1oe
	 LvOcSUuUE3igJGHM7Fvn5FDQeiYMEoSLN25m3Gdxl91PrRqc9xfovztaKEgdhOJvY8
	 Chee2LU1e/bHnTwuY5WS0rUo/MxABj1eqmGMoEUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0483/1848] clocksource/drivers/fttmr010: Fix clk reference leak in error paths
Date: Wed, 18 Nov 2026 15:42:01 +0100
Message-ID: <20261118145934.419962754@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 277e5657237a92e279ee28da2f5c07902cc6aa0b ]

fttmr010_common_init() obtains the PCLK reference with
of_clk_get_by_name() but never calls clk_put(). If clk_prepare_enable()
fails the reference is leaked directly, and every error path that jumps
to out_disable_clock only calls clk_disable_unprepare(), which releases
the prepare/enable state but not the reference obtained from
of_clk_get_by_name().

Add clk_put() to the clk_prepare_enable() failure path and to the
out_disable_clock label so the clock reference is no longer leaked. The
success path keeps PCLK enabled for the lifetime of the timer and is
left untouched.

Fixes: dd98442e17a6 ("clocksource/drivers/fttmr010: Drop Gemini specifics")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260915045426.1726805-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-fttmr010.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/timer-fttmr010.c b/drivers/clocksource/timer-fttmr010.c
index edb1d5f193f5d..8be9fc8ea91f4 100644
--- a/drivers/clocksource/timer-fttmr010.c
+++ b/drivers/clocksource/timer-fttmr010.c
@@ -294,6 +294,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		pr_err("failed to enable PCLK\n");
+		clk_put(clk);
 		return ret;
 	}
 
@@ -426,6 +427,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	kfree(fttmr010);
 out_disable_clock:
 	clk_disable_unprepare(clk);
+	clk_put(clk);
 
 	return ret;
 }
-- 
2.53.0



