Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043809;
	b=aE5wPJZv7B/7J3l1mEFOp/kdERLQFpjQT4v5ni6NQwkRDgTkloAXavGbjZpMegjYT0oM
	 lLtZnANm3B+VPwLgy117y6MIQcXMwPJxw1gp2GTR2wkFutQFvkjPVASt9zwPKaFlb9XJE
	 rNXqyQFBukXoqj1eTldiSLhB+vPDGLgCjjWOgKDs2e6IYHhoN6tuHRmnBk2LgJtVGTQDD
	 SYSOfiInHIREe5GwIfT4dEsMsJMn4/n67zgC4TWy8yPVvfJOmvu1RSJ3qFsfbtHxP5ujL
	 rRDkHSTUUP9IPNiRcY25h4e+4r3SeWMSEIxUyFVATbQMqUw0IRgfscqBIsyZ42OW9+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7vSQiDuOrQyDT6uhUiqcL3Ju/pcRzgQQ7/zXWY7Jtac=;
	b=JPoJSfntCQodRWazof/QNud2GoBGefhqGI5eApr/KW7GJ6KT99aVkg5o2a/yDJfr8Wj/
	 T5QRQFXXABay/j9d/0AWiLa1OH78J8UYP6L27a/WBvD1tcTqqMKsSArQjseeBFwaoeQu3
	 B9aqv4FZAM96tbMBZEQmbloB1YyNQIrvs0pfbrrnyd5hjiy7lT+S+lxFXBMXVaKA5ZDNa
	 sZra+wfINrLZw9S1WDIQoMdqRkf8yBDGacdkdG3xqzp5A5wdwak1Es0RuIUFCtz9C4cXv
	 5/PeQlHV+/vCYbOX7n6Jj9JBwerVnNbWkenZwrD4yRR6aDmnQhDfDmoWB/96wZcty9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJkdqNdm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BA3606A31C;
	Wed, 18 Nov 2026 23:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJkdqNdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367A41F000C4;
	Wed, 18 Nov 2026 23:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043809;
	bh=7vSQiDuOrQyDT6uhUiqcL3Ju/pcRzgQQ7/zXWY7Jtac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJkdqNdmHYXdgcx09Nor1NZo8kYqkuECTinDTDeJYTtlAZB1BFbVMJbX9BU7U72yU
	 0XbM1S2H0AOsUWYQsEwNCG5PC29btLRJ74xHVATThqxjiPZS5c6aZ7zxeDntel6f23
	 jJzFfqsccTBnejzIT/yqrTltkv3A7SMxGlTmJ4FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Kursad Oney <kursad.oney@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0343/2857] spi: bcm63xx-hsspi: disable clocks on resume failure
Date: Wed, 18 Nov 2026 15:22:57 +0100
Message-ID: <20261118150213.790529666@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 3b0cee02664041aea7e4f787c66cb86c82eb4e97 ]

bcm63xx_hsspi_resume() enables the HSSPI clock, and optionally the PLL
clock, before restarting the SPI controller queue.

If spi_controller_resume() fails, the function currently reports success
and leaves those clocks enabled. Propagate the error and disable the
clocks before returning.

Fixes: 142168eba9dc ("spi: bcm63xx-hsspi: add bcm63xx HSSPI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Kursad Oney <kursad.oney@broadcom.com>
Link: https://patch.msgid.link/20260804072017.860974-1-pengcan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Adapted the call to the older spi_master_resume(master) naming, which maps to spi_controller_resume(), instead of upstream's spi_controller_resume(host). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 7d8e5c66f6d17..8822dd21486af 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -511,7 +511,13 @@ static int bcm63xx_hsspi_resume(struct device *dev)
 		}
 	}
 
-	spi_master_resume(master);
+	ret = spi_master_resume(master);
+	if (ret) {
+		if (bs->pll_clk)
+			clk_disable_unprepare(bs->pll_clk);
+		clk_disable_unprepare(bs->clk);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.53.0



