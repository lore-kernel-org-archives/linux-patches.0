Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065123;
	b=hQUv6pT6WBxCJR7EJ+23flH5cFhTtu5ZS44DoWcWlUjU5J6/jJ7L/lpI1t11Ua4CjuD1
	 KNXmPdAp/qTXzwq9rA+zZ/ReJy9Uv6omjL9XduKSrR9SShkWA86AIFOdjAJ1BrR1dEz8Z
	 qz/Bw9oiEzEeX2h3ZxrsvkndjhxinHKkfMbBIP+j0A3O4eIER4tzKV8xDJysCKe4nKxQH
	 TVgKZks4EFvU4kChuIdDFls9QA+zye2FpQJvTyd1iui0Y/UUwAjSW5fJI5trqRDaDlCwK
	 MQizkSXFrujh5lVQqMZgRdnFzSrYRGkaJ+5V0hUzQuxHH9AdrHMuuQh3WIH2KRvcNEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gOFP/OZbO3MCVCgQWmvX4ys2mEyrg8xB0scXSALvqjQ=;
	b=EkKnVISRwjajmLEpqtJqrrYqY8uPWEvI3Hvbx6grGsfv9PF7MnZFXZ1CHEW/A9s+kXwl
	 r+2de4uAdMkV3dQAal4kxpkpAwjIDmTJSEBr1k3ENGxjlxg4z5bm70a1E87Gt3XFJ7Ne4
	 XdCNaHUcrOtvcCbqbxPsqFyri1RSdT7rqSHvdTtrBwhY3MiDeBn/KTRjD3VKRI4KscbU2
	 ikE9osw6GUwsl3YnNS70yl9bm9+UHZrg5bnPPWK0s/bgHng9Oe9CVzRnMeAmJhofHaNJ2
	 FsezyjQ+Pd07KSg0+W7ssoXRoefUec5axNLnHKMSO7lan0TraXOzy06q520ucH52hKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvEjzlaH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D76606A32E;
	Sat,  7 Nov 2026 15:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvEjzlaH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259611F0089F;
	Sat,  7 Nov 2026 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065123;
	bh=gOFP/OZbO3MCVCgQWmvX4ys2mEyrg8xB0scXSALvqjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvEjzlaHFtv4k/u2BomlalFXH3hjONeXH8vTLCSBiORaRo8HOWnqtSE5/YoeHZsyN
	 FdEYnyb9irKiO7apWOXadj9A5RqCh7rocwxWLPrhdY5osXcznIzV9+Dw0cUERaEs3K
	 Jt51mUOdMOiWwz4vqhTk8yhP1/TMcjQuwN7wQucY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0947/1257] gpio: davinci: Clear interrupt status in every bank on suspend
Date: Sat,  7 Nov 2026 08:54:03 -0500
Message-ID: <20261107135005.503491196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit 800d7627f552bbf602a1736b638aee0ada3fbf87 ]

davinci_gpio_save_context() saves the registers of each 32-GPIO
register bank, but clears interrupt status only after the loop. At that
point g refers to the last bank, so pending status in all preceding
banks is left uncleared.

Move the interrupt-status write into the per-bank loop so that the
existing suspend-time clearing covers every register bank. Single-bank
controllers retain the same behavior.

Fixes: 0651a730924b ("gpio: davinci: Add support for system suspend/resume PM")
Cc: stable@vger.kernel.org
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Link: https://patch.msgid.link/20261018170622.3406158-1-sahaj123.sc@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-davinci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index cccbaea1dec24..fc2b9bef7efc8 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -611,10 +611,10 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
 		context->set_data = readl_relaxed(&g->set_data);
 		context->set_rising = readl_relaxed(&g->set_rising);
 		context->set_falling = readl_relaxed(&g->set_falling);
-	}
 
-	/* Clear all interrupt status registers */
-	writel_relaxed(GENMASK(31, 0), &g->intstat);
+		/* Clear stale interrupt status for this bank. */
+		writel_relaxed(GENMASK(31, 0), &g->intstat);
+	}
 }
 
 static void davinci_gpio_restore_context(struct davinci_gpio_controller *chips,
-- 
2.53.0



