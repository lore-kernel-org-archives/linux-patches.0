Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D58226CF7;
	Tue, 30 Sep 2025 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244028; cv=none; b=Xuh9axPgS8C1CHI2jnvwHMcE/11G6jogn7rws53aTxAPgFCwq4EZGRkdt/vNZQMwsJXL4E0Jk/GcpHjyU6OuokLmDM+Auhpz8ThAeo1BnNEtDeBi+xvncbp91PB0Kd6iwgDcT/bo819rmKRPdjjVyLQ6zYrltCwvN+BQRojNB7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244028; c=relaxed/simple;
	bh=vf3cOISipHGwYuo+sROoR5ZjjYPA89mOcrITUihpRFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSoO6ORcrWL29x8iPvT3egb9TNmbcpkuVQbar30IM+9yMgheeJBm1gzQ5UMVziZX/bAez4q3XEq3QT3PnTwuj2B1Y8uAaPlsgzJzUwfFXAWGrj0gKu76wrp+IwPah/RYQJm/cCUPPja7YusVK7HCFJjmr6xQHqB4upCpXRuikSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTZBmn2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTZBmn2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6351C4CEF0;
	Tue, 30 Sep 2025 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244028;
	bh=vf3cOISipHGwYuo+sROoR5ZjjYPA89mOcrITUihpRFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTZBmn2tMDZD0DTfqCWTlpwGh0JNNX42inLbLua5rH92K1/H6JL6M0tgtX6/AUqpo
	 1/EXtpqHDbFbNh/tCTUbhbT3DsL5vK9iQHbriBFnifLe3PORxQGfi77yKTl97bYahK
	 uOM+dCXFFdbeYk2rSH8mZZ9WrsP1foRf6HptE76w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?St=C3=A9phane=20Grosjean?= <stephane.grosjean@hms-networks.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 68/81] can: peak_usb: fix shift-out-of-bounds issue
Date: Tue, 30 Sep 2025 16:47:10 +0200
Message-ID: <20250930143822.534941809@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stéphane Grosjean <stephane.grosjean@hms-networks.com>

[ Upstream commit c443be70aaee42c2d1d251e0329e0a69dd96ae54 ]

Explicitly uses a 64-bit constant when the number of bits used for its
shifting is 32 (which is the case for PC CAN FD interfaces supported by
this driver).

Signed-off-by: Stéphane Grosjean <stephane.grosjean@hms-networks.com>
Link: https://patch.msgid.link/20250918132413.30071-1-stephane.grosjean@free.fr
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Closes: https://lore.kernel.org/20250917-aboriginal-refined-honeybee-82b1aa-mkl@pengutronix.de
Fixes: bb4785551f64 ("can: usb: PEAK-System Technik USB adapters driver core")
[mkl: update subject, apply manually]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 4b18f37beb4c5..14e9b1052c5c6 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -84,7 +84,7 @@ void peak_usb_update_ts_now(struct peak_time_ref *time_ref, u32 ts_now)
 		u32 delta_ts = time_ref->ts_dev_2 - time_ref->ts_dev_1;
 
 		if (time_ref->ts_dev_2 < time_ref->ts_dev_1)
-			delta_ts &= (1 << time_ref->adapter->ts_used_bits) - 1;
+			delta_ts &= (1ULL << time_ref->adapter->ts_used_bits) - 1;
 
 		time_ref->ts_total += delta_ts;
 	}
-- 
2.51.0



