Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019155;
	b=BDYoMnEiKRn9YA5T7MU0zUlAe4I5yHBYvGbqk76E4NYBT131quL0RTYzdNgkWhN0/Nwn
	 T8YYPi/osIcQZvjJjYciuuFaQ9K7iEPbrUrX8G7MeTdYA0ojNRSlnZNsACeZ4LHPIHzPt
	 vxiv6KQUIaS6l9QqHdjL8Unzrg/R1eXgQhChyKAQUlrfKotI/zaKL+pF3IESbcw7EbzPO
	 6QCl3CWdFZgUv0qclQx41nbPiNLLYs7DdjRbLwWgYN2A/Qxmc00KBuVAnV5bzSQkHqgNc
	 N4AkgNH9IoP5yB+cTk6l/yxmA/mBMTxP5ZxBZP7whMoSJivnpUBHMhJi8UDM+4XbyNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wx6HbSFhJtasAM8FA9PKc5jqqMmcy6WKrK2uDiaUM98=;
	b=DgfwXxanTO8Av9ZJdsRfXBIyu5Ye7eVq1H53IOm3GWrq+Uh7CUy5Un/XmjTNixRbk5NP
	 rPhdMWS8irTo5NckYZIyvX5D2kx2+yOZsWE3BbHaVpcAWLrZTRozrn8a7PmX3A+Fh+/yK
	 DHvn2I4pyXU6Ubp518kRQToPD8CQaI9i+OofFbQ85mtgJWv71KmTUBxtmZUXgMG8KtQ7I
	 lEx2vLjQsBAplJu+2aF4FwTpvPMO9h7emQNwc7OeKav0c9bypb/sWsW2RmNikOPpp9GPC
	 e0d0AH/o85Get5AT/fmBrsYDZXT03PfqavH1xN5CQRFIi+cTpnMLZc6dTZUh6yvIWBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJ3QzaM9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0B3606A335;
	Wed, 18 Nov 2026 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJ3QzaM9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682731F000C4;
	Wed, 18 Nov 2026 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019154;
	bh=Wx6HbSFhJtasAM8FA9PKc5jqqMmcy6WKrK2uDiaUM98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJ3QzaM9gcaeaufVLxFrxqAIgszmd4BISGyQ2wvDEIVEby9Ol6yTV0SRx/807FD/m
	 EFYsZ6XoITGuI5s0L7eN7hgjyKjwirRTocM2gwkdkkYl43CmJjo/vnG0mquZNL3Rcb
	 v9Kzfjpq/alv0C+Bxr5iu4M0rUkSBQ2ZndcleJrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Caleb James DeLisle <cjd@cjdns.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1496/2651] clocksource/drivers/timer-econet-en751221: Fix clock reference leak
Date: Wed, 18 Nov 2026 15:45:36 +0100
Message-ID: <20261118150341.877446765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 36790ef57803400339d8ea4081d85483264dbd6c ]

timer_init() obtains the timer clock with of_clk_get() and only reads
its frequency with clk_get_rate(); the clock is never prepared nor
enabled. All four return paths after the acquisition (of_iomap()
failure, clocksource_mmio_init() failure, cevt_init() failure and
success) return without clk_put(), leaking the consumer reference.

Drop the reference with clk_put() right after the frequency has been
read. The clock enable state is untouched.

Fixes: 3b4c33ac87d0 ("clocksource/drivers: Add EcoNet Timer HPT driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Tested-by: Caleb James DeLisle <cjd@cjdns.fr>
Link: https://patch.msgid.link/20260915054552.1729612-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-econet-en751221.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/timer-econet-en751221.c b/drivers/clocksource/timer-econet-en751221.c
index 4008076b1a210..1859335345b59 100644
--- a/drivers/clocksource/timer-econet-en751221.c
+++ b/drivers/clocksource/timer-econet-en751221.c
@@ -181,6 +181,7 @@ static int __init timer_init(struct device_node *np)
 	}
 
 	econet_timer.freq_hz = clk_get_rate(clk);
+	clk_put(clk);
 
 	for (int i = 0; i < num_blocks; i++) {
 		econet_timer.membase[i] = of_iomap(np, i);
-- 
2.53.0



