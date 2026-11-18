Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021916;
	b=k3g5Yi+doKBLuO2z8TzVhaD/qUI1fnfouFIqVxMZGyz2zzmniUpdoPOzFBbB4jurjxGJ
	 Z9dU/NBsB7xfnRnlEiYqwh5uNxL2O9vdD0HRyefVdj5vt7B71DQFDc2F3haqTdqJfjlFn
	 YkeS/qVTmCbo+j1vkYTgsh85dUuGXfljyHHBmWnIVzlZSOcQg1m6NOuspa/DwFs1LA0R1
	 ieZQbdS9esW/eNPOqPAEsnwM38FJe4RhPdUejI8t6gBeGEcME77PvSBEZBSFSVkkh3BPE
	 NGFU0HIfN8HwmzyfwvjaW83rLcCmxPWbfTQL3K0jdYl3EKYuXvvPJ8WBnbK0lXZGAGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nFYoQYs21r5nwadXCLjD0Kr1XpvnkWc1E5exXGkZ9tc=;
	b=AWYwt3JBdSia2Pf7OfsVQjvenwYNMfVdO/IxIbsVXzI9hMnYieAxYfb3vmKpskKef4Mm
	 9uvoNu1fHLR2WUIzvfBarSJPMaph9MHOyteyWB2aEC2tHDC6tdZLzE3/KBhFkSJrm5dw9
	 ero55uVOQC4mZ3MPH6kzMLkCmpE8tCTzn3jrQv+H2iSkcBgEoBU9IY5d1o9uSZQB7bwuk
	 tlVgSpYMZCzMEbmAMSVdH7ZAlKmGj+T9QmYs02WVHt//t09XWH5v3hPdGxLIDydXF5ZN/
	 gmLj3U2PQQq1432fuQUpqfcqyOytF2L3SbZ0XeVqI6gW3qjp5kD6yuqsnYrANr0UfYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5xQEDKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82B8606A33D;
	Wed, 18 Nov 2026 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5xQEDKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD6C1F000C4;
	Wed, 18 Nov 2026 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021916;
	bh=nFYoQYs21r5nwadXCLjD0Kr1XpvnkWc1E5exXGkZ9tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5xQEDKnEOAvIUfzclAJ5GtT3qc++8A01IhShaSvx5njSyt0bFQ00UnSDd+COMDqI
	 gZZWyAR4h1X2Dvcc4yHrTcWiTs7mO0JN770TKgqp+aUJGNyt4Nvbqlvcng+TOIAph0
	 +azUQx6XwQ7fRRzkbsd2EJ+uwwx4Z8eM+jtDoDvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2450/2651] clk: lmk04832: Handle reset GPIO lookup errors
Date: Wed, 18 Nov 2026 16:01:30 +0100
Message-ID: <20261118150413.317579724@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 5c7c0cbf81bba69695efa12e451f0f2ecd4b92a5 ]

devm_gpiod_get_optional() may return -EPROBE_DEFER or other errors,
but lmk04832_probe() currently ignores them.

Check the return value and propagate errors from the reset GPIO lookup.

Fixes: 3bc61cfd6f4a ("clk: add support for the lmk04832")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261006110501.57051-1-phucduc.bui@gmail.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-lmk04832.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk-lmk04832.c b/drivers/clk/clk-lmk04832.c
index f9a0684d2628e..81801ccb26758 100644
--- a/drivers/clk/clk-lmk04832.c
+++ b/drivers/clk/clk-lmk04832.c
@@ -1410,6 +1410,9 @@ static int lmk04832_probe(struct spi_device *spi)
 
 	lmk->reset_gpio = devm_gpiod_get_optional(&spi->dev, "reset",
 						  GPIOD_OUT_LOW);
+	if (IS_ERR(lmk->reset_gpio))
+		return dev_err_probe(lmk->dev, PTR_ERR(lmk->reset_gpio),
+				     "failed to get reset GPIO\n");
 
 	lmk->dclk = devm_kcalloc(lmk->dev, info->num_channels >> 1,
 				 sizeof(struct lmk_dclk), GFP_KERNEL);
-- 
2.53.0



