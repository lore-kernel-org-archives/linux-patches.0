Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB22F6FB1;
	Tue,  5 Dec 2023 03:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Apcxm8OE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16473C433C8;
	Tue,  5 Dec 2023 03:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747320;
	bh=iMzpTau+b4L5peMdaGtgjiseO+ErAq+qgUI5UBpF/5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Apcxm8OEuNtF7uc13xm8SUunLV9yhPMsDny1ZOCbWK2d9VO/8i46rveU5C1W6Mjsn
	 5Aj6wQjFqn88uCsZoKxjhXQDtM80AnPPepg/SrE/8gk1NeAUhbwHudxxnR6PlzZxHW
	 BClE6IDaD6e6PRF174mo8Uy2Cx6/0x2vd1GZKWLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hilman <khilman@baylibre.com>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/135] tty: serial: meson: retrieve port FIFO size from DT
Date: Tue,  5 Dec 2023 12:15:28 +0900
Message-ID: <20231205031530.963225077@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 27d44e05d7b85d9d4cfe0a3c0663ea49752ece93 ]

Now the DT bindings has a property to get the FIFO size for a particular port,
retrieve it and use to setup the FIFO interrupts threshold.

Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20210518075833.3736038-3-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2a1d728f20ed ("tty: serial: meson: fix hard LOCKUP on crtscts mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/meson_uart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/meson_uart.c b/drivers/tty/serial/meson_uart.c
index bb66a3f06626c..c44ab21a9b7dd 100644
--- a/drivers/tty/serial/meson_uart.c
+++ b/drivers/tty/serial/meson_uart.c
@@ -765,6 +765,8 @@ static int meson_uart_probe(struct platform_device *pdev)
 	of_property_read_u32(pdev->dev.of_node, "fifo-size", &fifosize);
 	has_rtscts = of_property_read_bool(pdev->dev.of_node, "uart-has-rtscts");
 
+	of_property_read_u32(pdev->dev.of_node, "fifo-size", &fifosize);
+
 	if (meson_ports[pdev->id]) {
 		dev_err(&pdev->dev, "port %d already allocated\n", pdev->id);
 		return -EBUSY;
-- 
2.42.0



