Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A8D19E7F9;
	Mon, 23 Jun 2025 22:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716962; cv=none; b=kUGLrFyTYmEPq1iizuqQeikuJJ9iwlxfcvifjd6kz+7cD8p6PHMHPV0y3hCXZs+mkU+7DVLF6VotU68fKuBzgaUs3VJTO3VxVokgN2TUIShQzyhyeCG/s6QP5A1wqCPWmVEYMANUeCgRyxUrKCuMC/n/WeNbcuxNDzt6DbWlVY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716962; c=relaxed/simple;
	bh=KmttV/bXLL+nB6sEkXZBWZIqJOaLR7X5oBA2eK0jmmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwqHUymLI21vZuspuiiYFPKUmXLV7SkTY6kjTBnMJPQ3hz89fqNsUbCDXFbVFcprQ7gukQ3D/pujLHbYJRK/8jT+2F10YOKZzzlKBlfP/lrkBeWudgPiF2KsLhePc2rFbJ9XVJZ5ezPDgC33ZMf35Ejr6N0s/4l9dK+MqbkDbZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI7uDSPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI7uDSPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B7BC4CEEA;
	Mon, 23 Jun 2025 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716962;
	bh=KmttV/bXLL+nB6sEkXZBWZIqJOaLR7X5oBA2eK0jmmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI7uDSPMDwErtK2I7tPS0xoFQvbtnaNd6Pmjb9D/lvXXLWCwRJVlxc3Zx74DjCcFK
	 YQOYhYQNP6fT4nQ8ubLu66cDjXMR9gnp8wlnfXSaoy9enc4ftVlExF/FjNegyYmoNv
	 FUNnX/X0zInMo1UOSga9h7pmZDgvxHwss7Y4AA+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 6.1 349/508] clk: meson-g12a: add missing fclk_div2 to spicc
Date: Mon, 23 Jun 2025 15:06:34 +0200
Message-ID: <20250623130653.937300543@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3969,6 +3969,7 @@ static const struct clk_parent_data spic
 	{ .hw = &g12a_clk81.hw },
 	{ .hw = &g12a_fclk_div4.hw },
 	{ .hw = &g12a_fclk_div3.hw },
+	{ .hw = &g12a_fclk_div2.hw },
 	{ .hw = &g12a_fclk_div5.hw },
 	{ .hw = &g12a_fclk_div7.hw },
 };


