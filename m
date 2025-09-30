Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A412F39C0;
	Tue, 30 Sep 2025 15:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245394; cv=none; b=B9Zxk2xRz9RhA3G8Ym1OoDH65+Yf8oJDgqk7Vw2gmBRo0ZPb7iO6dj+kEz25AP3j81JUVVy94/Vslbr4zyMZ9IUYVJ7gfp3SZ84lE99pc2obaPQE1Nf6XdRr7E1pSMwHu96IKaPN/c6v+/uxTuLMOjq2uTBWba48JpNpYlrthV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245394; c=relaxed/simple;
	bh=8oiZdLu4qJ9qJyx62cT0mqLfVcQTbtm3vLn6nmDiIXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPPqo+9xkFHV8hwJIdWNH/Ne9qGUSxdGQqSQbM+JDteenXi08nhlISAdXQes5oO898v66+sbvk6LA86T5uh0J9+NsnlPnpabihq80966iSlxjASJg4sVHOET+YYNgi7JI+J5f7IpcAey+DIwoD2gDakbzsVPjg2EGm5H0zJAces=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wi6ypYXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wi6ypYXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E8DC4CEF0;
	Tue, 30 Sep 2025 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245394;
	bh=8oiZdLu4qJ9qJyx62cT0mqLfVcQTbtm3vLn6nmDiIXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wi6ypYXvDKc2qRpK+ZEOPB+dN2+E/dweRH2nkA+m9SnGKueqNjnzclChihnJRgmh1
	 kufB4q89s2100blwiIarR17zbLBpWXRrnVKXrPFHdjX3e011fws9q/VMiAro4ZndDI
	 4F4LY+KJBgFSltcmONYjfCZgK6ySHZjANwWLXrZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?St=C3=A9phane=20Grosjean?= <stephane.grosjean@hms-networks.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/151] can: peak_usb: fix shift-out-of-bounds issue
Date: Tue, 30 Sep 2025 16:47:37 +0200
Message-ID: <20250930143832.663599661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6107fef9f4a03..11ca70173fb57 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -89,7 +89,7 @@ void peak_usb_update_ts_now(struct peak_time_ref *time_ref, u32 ts_now)
 		u32 delta_ts = time_ref->ts_dev_2 - time_ref->ts_dev_1;
 
 		if (time_ref->ts_dev_2 < time_ref->ts_dev_1)
-			delta_ts &= (1 << time_ref->adapter->ts_used_bits) - 1;
+			delta_ts &= (1ULL << time_ref->adapter->ts_used_bits) - 1;
 
 		time_ref->ts_total += delta_ts;
 	}
-- 
2.51.0



