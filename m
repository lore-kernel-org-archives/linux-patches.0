Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705770;
	b=jr1M5pgqW6zKNXsz0w6XZUALUbuyLPvOSpV5AQ+mM/lla3nLHcjRGxJsGQJM8WEOJRKD
	 iP2kbDvDHv1MlnwBBzdy9tpsC5fU5iYBZe3Smu7X0mgr+rtDt29R9PTVlVKIRnW0Gdyl3
	 En3gSHBwBBJie+Xas4Ii3pmDE0hSQ2cgeDblnBRax3fYhFP4bd6LzXwGiZTQkhkgJscmc
	 itMpLXPA5hYXhQZRaFZGi9Z7b23aB+iC9IReZR4LFWHqDAQF5BH5+9ygPZoldZe0edL1p
	 vPQwAXd+hhta8OlV5eR63F/qTN9Y8tqRk4KBaqXu6uuYDxDKBwIzdtaEXmjJnzdjiug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+h4cobPJWWqBYYUSxjCLSWOWaL1KAZ4K8cTWf81XG3k=;
	b=MiXnd9RzYmJVc4kxbdYaYW5zb0FiNDIvrEBRy5H3wFaVz04jBHBWlPS5fKWWGdAQThQF
	 dwg1do/4YCqm5Ut0R6xU3fj6s0OAuFC2VODKdhwiUnqYYI0S9YfbX4d6u6jGX2g8yC2Er
	 Cqdmv/o6kefZJRss7s6Ez2SS0wY9J8P9gjLJQwsaqhQelRij2jsgaEuDLrFNw6/RCvyPu
	 AA+SsgCoDVSO3lZYcGkMyDryciurjpjf2gSClW1ULQdPHf/PaYq++hc40/IW3C7IEX82J
	 D7afWGMpsl1oOMgUo/jeURgO8pl92VhyI0nvgDeQCiCOIhQdhznZy5EWlpxX+Z9NTRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfpW2Kw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E583606A32D;
	Thu, 26 Nov 2026 15:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfpW2Kw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CADE1F000D8;
	Thu, 26 Nov 2026 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705770;
	bh=+h4cobPJWWqBYYUSxjCLSWOWaL1KAZ4K8cTWf81XG3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfpW2Kw0HXyaoDPqof7FyVdPKSaJ7vMgfih5hQ1xB0QUpBSWmPKsI19zPaAqemZyY
	 ZjdjSH8V9OX89HCjP/5Ou3LDtSfseUNVopW41kkz8M0IaXZLOeC7/tMcuC1w8DPgHC
	 8wiCDfq9ZfFUuFOi5ZeReFBU/g6CacJim85iEwik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sarmanow <as@discnull.de>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 307/319] iio: light: vcnl4035: Fix reversed ALS mode bit
Date: Thu, 26 Nov 2026 15:41:15 +0100
Message-ID: <20261126144013.686293090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sarmanow <as@discnull.de>

commit 6bcabc30b89f31e2925647d1ffa5a0e4b7919829 upstream.

According to the datasheet (table 2) the ALS_SD bit behaves the opposite
way the current ALS mode defines are set, writing 0 powers the sensor
and writing 1 shuts it down.

The current driver thinks the ALS is up while it's actually shut down
and it's down when the systems powers it up.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sarmanow <as@discnull.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -46,8 +46,8 @@
 #define VCNL4035_DEV_ID_MASK		GENMASK(7, 0)
 
 /* Default values */
-#define VCNL4035_MODE_ALS_ENABLE	BIT(0)
-#define VCNL4035_MODE_ALS_DISABLE	0x00
+#define VCNL4035_MODE_ALS_ENABLE	0x00
+#define VCNL4035_MODE_ALS_DISABLE	BIT(0)
 #define VCNL4035_MODE_ALS_INT_ENABLE	BIT(1)
 #define VCNL4035_MODE_ALS_INT_DISABLE	0
 #define VCNL4035_DEV_ID_VAL		0x80


