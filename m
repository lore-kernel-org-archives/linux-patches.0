Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045639;
	b=F+5Up0hlHPcBXQxnozdWN7wqCU4ZW8gxH5uCnvj0655ISz/Txx5/mU9KKGbpCohJiXiN
	 bzpsXB/No+kVrtR2ZUZUN6Fxkh5aUcG89YMqv75uBWOJbxFNk2F6VtfsNIayx88f3ARLL
	 TWRQdJ9IZkjVYZ6GEKW4IsMYxYaKDbrUSgOk2VfwoIAn/mKRxgv4OQOQgOEgXHMBzPZDB
	 UfDOWgFO0hZJtBqnV6NAiMKZjqEBZrnaWIca/0zVA6Fu9u/2bE1S7MHVtqRnoad5BuKiv
	 fg3CKbcR4G/zRauooLZ8ZxyhEhg+9kURTcNBEJ84oK1zRAb1VvZ6957qx9BxKb9uYRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kaT1sIi695+C3nrQDAtLJ/O0/6JZscRlQGNl7Fu/TZg=;
	b=G34E8TVe0QjFWhB1ui9I+49ZXwbIfCgfpZsMQmlKTu3Pc0SlqWSCCYZXugOs4vTCp7rt
	 zJg3ZtfMh1gyn0K8wS5VZ06WRE6zHCjmuzu8fGwHQbmta+RLSbs4NUrhAzlkawEvZ7Qh6
	 AcqkpvBbmepOj9kcjR72LcoAyAgK8Qed1hY2lRJXivck3qm1KNQ+Aif0cjCrc4lNes8Vs
	 Ky9JtpTyR6/Md4txiRn78wtiJEDxbirOkiRSwOIcVBKlEQPk20sxwMot50tbEL3vqTjNV
	 m8FuUZiktNHoOI8SDHpwFzSnxBW+Iob/AkaoYhrxdh8a/n0KJtl2MDBtAUxoArKPfiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN3HARrs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13256606A325;
	Wed, 18 Nov 2026 23:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN3HARrs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5F01F000C4;
	Wed, 18 Nov 2026 23:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045638;
	bh=kaT1sIi695+C3nrQDAtLJ/O0/6JZscRlQGNl7Fu/TZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yN3HARrsgjj+xC2IUt6wjqrfR8juMKNtHQFEzgx5kpZBQQJ8zVNkVRLl6fcxFJbpX
	 0eL14djfcCltmpcmYRjxcOu+zcwshGGwyxBiQpFdvKVnnsiCc3tCzIAygnvojDH8c3
	 ShtxE1dii51LBGZa0JdVw5a3tXY06n8OTHYggdNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0996/2857] gpio: davinci: Clear interrupt status in every bank on suspend
Date: Wed, 18 Nov 2026 15:33:50 +0100
Message-ID: <20261118150237.468282453@linuxfoundation.org>
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
index cac9737b25a50..1e55f4eb0d992 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -648,10 +648,10 @@ static void davinci_gpio_save_context(struct davinci_gpio_controller *chips,
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



