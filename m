Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052524;
	b=WOML5Sd8NIyZDAoblxs8zykI2HAGokXDXhA75/zpZ7HTr8c7iW9m6oTepVwMR/yXHeeX
	 Epvhp6A5Kms1cuq+WCJQEqawGke9sMXXZ2Vp1Blm6Y1wyeaT0h1PHPajsAs3biD/Pb1ch
	 GXqpko8N3waeNoff28d3Nvkv9X0JV77ySj2utg9HcJI5TUuaRdmkSxgxoYn/lx2BI2fyr
	 POgIjjUa+8ScNLUWooIkm3kGcGXt6Kv8BDQqG61N0/MkvfffTDDU6hOPdIXWic9NsaPCd
	 kgl5I1RzEzZSyNPFyqJmxXJrfE1uZffLrQB6UKHoPN8d9l1kgLZo2p92omIiImRr/8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iGAvEaI9YQGl0Op7F0J8h/iUDPSr8FtSmUuunzRe3z4=;
	b=qfuedF4kNtl2aIADqRhyWRgADfancGDae2cd3Bq0yyZWQo2feJc0fWhPdAoMy2nWUhNR
	 XsfViRS29o/3E08wz4JOGXMZzjhF4B87fCik/fIApBPbkWCDMeEXEidnjBaJkPa5dZufH
	 3Iqjn+LcT7O6DpwYlGNC87/9GW2sfSvAXk6dzj3nKONuN52QrMbrVowDCs+N1VtvGRV0V
	 jSv+4H9KhG45+Adf6ADMXzbuoE84OUGke3axObh1aljHW83d/I69x79B1Z6T00E15opu8
	 2idREaIcsxZomUU9vLRaimcOy8ZGWaHqgCyVLCeHZ7Xshj0x2OuZ7i39mVN+MvluM4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=045OI6vk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF6E606A320;
	Thu, 19 Nov 2026 01:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=045OI6vk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB76C1F000C4;
	Thu, 19 Nov 2026 01:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052524;
	bh=iGAvEaI9YQGl0Op7F0J8h/iUDPSr8FtSmUuunzRe3z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=045OI6vk6vGcqPfmTMh8KYYtFm1phk5lSF6mxRro/edP6LFVJ55VHW+TnSw72OWfU
	 tYPggVtxwYcqJdQGKjPw9OURTlMuJq6wdN9LxDKcmSAMsBftVZss6OA9VKeEKmclKW
	 QGdGQc6UZGgyYSFrV0vKp3sEMT10nf76SPBl/iOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0594/2214] clocksource/drivers/fttmr010: Fix clk reference leak in error paths
Date: Wed, 18 Nov 2026 15:37:50 +0100
Message-ID: <20261118150034.692889015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 126fb1f259b28..0003d49768f62 100644
--- a/drivers/clocksource/timer-fttmr010.c
+++ b/drivers/clocksource/timer-fttmr010.c
@@ -292,6 +292,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		pr_err("failed to enable PCLK\n");
+		clk_put(clk);
 		return ret;
 	}
 
@@ -432,6 +433,7 @@ static int __init fttmr010_common_init(struct device_node *np,
 	kfree(fttmr010);
 out_disable_clock:
 	clk_disable_unprepare(clk);
+	clk_put(clk);
 
 	return ret;
 }
-- 
2.53.0



