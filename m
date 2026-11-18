Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045503;
	b=BiUIYWbID2TGZ1y+Hxa7OSTtSwgHCrBXbunnS+vQ2LSWisyBhp3fQ5e0iKjrrIdNzajQ
	 ndQcmm0uvQuDZzpKDKQKtgcFQlDdbN/tqmSGNb8330uK3esR07/Q09JXldu24+h805ms0
	 Vi3V/LQ5yGy5hHqnGtPLcVu9aH0wXL7QulA+s44UzsEO1n3koSQh48iaomQE0s51Vm2vx
	 9b2JhfmBBbrnA63czkczkb6hle6lbL5V4BvenyzTjqduWKPwqYh6zQiP3+6pUok0okD01
	 yrePxeVNh0lBsA7DcLVVchaA+4NZCcORt8LCxRWQIW9rS+y7UcPm/lqJSnHP+W3/Xsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mD8454tPC5zcMPhSTg4UO+mRetXtD8C/vmVX8basgUY=;
	b=Yi65I59bk/vTQlXI2PVMB4RtazXalFjqow51VfxBEwjAx40jamuv+dN5APcK/SGlEYdZ
	 d/2mHr567HEWWfDhASFareemnpYuFKWqhD4bpfjVr0f0G4HeAD/x0H2MAQJm5+fg7GZV9
	 M0Jm0p0WuOEGusRxk7io4DwRUtu46g/5z7I951JVOPcxIQuB9ugW/gWmg5c8luJkOYCsk
	 wAuvqqLHTvtwGv5fFYJedfQvYh1HqfzDZWG4uDZY3VRI5DK7oAMo7H1F0MUjlvV22IIBL
	 XWNhzHw010cC3AkpxQ8XKVJff3fBxKb5VYuRn15xJzY1j63OLNb4RgMmFEWz22w0ZfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/eT5BYK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E331F606A31C;
	Wed, 18 Nov 2026 23:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/eT5BYK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D06A1F000C4;
	Wed, 18 Nov 2026 23:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045502;
	bh=mD8454tPC5zcMPhSTg4UO+mRetXtD8C/vmVX8basgUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/eT5BYKlRS3by+/XxcjKmg1c+FLQN5FAGXQCm22C+vLz2cY1YlRMM+ArmU53On7I
	 P+fYTRPuVmGG/hjCOG9pq/T1Cz3Sr4nzUZzLl82+JyuIsNF7+UU05lk4oaTtg4rLH1
	 wrZPwNl4m7l9yW4ugME0X+wUsdrr4EgioIVlGrIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0897/2857] clocksource/drivers/fttmr010: Fix clk reference leak in error paths
Date: Wed, 18 Nov 2026 15:32:11 +0100
Message-ID: <20261118150233.858428929@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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



