Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF8219CC11;
	Mon, 23 Jun 2025 21:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714674; cv=none; b=cnlaYsk6vRDm8tU8bS+BA9lnJ9w7VXxb7aYDaWsp2/ggXCJZY0fQUEtAT82/pha6wT2qO/DNh/UCwkX+sdZ1Kt3JeIGyySBvSwpWd4dTIvrif7K00zUMXmw1JEBtBNfyNS3iYAVgVVl7tDENBPC6Aqe8B/mMJ16XNymBbtW2Uqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714674; c=relaxed/simple;
	bh=yoqLCYWZ+OosKlIkxFGCk0Pf/G4hGLMitzLKLPylGEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjjEcOd2jcSJ4SujxEeRoGI/JPjnCSEXO2TAzIz1yvgGYg1twJPzVWgDqRxq/GVfBHaUerkSrZsJgCHWmQMQQ/eZwDYH3/ydyxRIvtH7iTKMnw8FXSWTC3o/FDwbBB4EGeFeZdWBQeTZNQ+UhEMTLRFEooT/vbRa+N8i01tzzMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnB2BKSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnB2BKSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAFEC4CEEA;
	Mon, 23 Jun 2025 21:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714674;
	bh=yoqLCYWZ+OosKlIkxFGCk0Pf/G4hGLMitzLKLPylGEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnB2BKSylaKsapFQD3nEX60eynHt1D2JuHRe+onM0oA4Iu53+W5cyflzHhdUojjVY
	 RjLe+kRyKKWDVj8HJAsSUDO+ch+JlaoebN3EZ72p+G1bNmDT5s9dGBi9fAj80u7A/J
	 odq1tZbNJo6EfplFbmcvThIPuHUeGVlLh/nvh1+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 6.12 113/414] clk: meson-g12a: add missing fclk_div2 to spicc
Date: Mon, 23 Jun 2025 15:04:10 +0200
Message-ID: <20250623130644.912770055@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Da Xue <da@libre.computer>

commit daf004f87c3520c414992893e2eadd5db5f86a5a upstream.

SPICC is missing fclk_div2, which means fclk_div5 and fclk_div7 indexes
are wrong on this clock. This causes the spicc module to output sclk at
2.5x the expected rate when clock index 3 is picked.

Adding the missing fclk_div2 resolves this.

[jbrunet: amended commit description]
Fixes: a18c8e0b7697 ("clk: meson: g12a: add support for the SPICC SCLK Source clocks")
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Da Xue <da@libre.computer>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250512142617.2175291-1-da@libre.computer
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/meson/g12a.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/meson/g12a.c
+++ b/drivers/clk/meson/g12a.c
@@ -4099,6 +4099,7 @@ static const struct clk_parent_data spic
 	{ .hw = &g12a_clk81.hw },
 	{ .hw = &g12a_fclk_div4.hw },
 	{ .hw = &g12a_fclk_div3.hw },
+	{ .hw = &g12a_fclk_div2.hw },
 	{ .hw = &g12a_fclk_div5.hw },
 	{ .hw = &g12a_fclk_div7.hw },
 };


