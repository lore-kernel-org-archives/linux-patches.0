Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617961;
	b=DQM8fKSIAzighNJ5My7vfcDCuYUiawF5twfSojvrkeD81z822AzqxhS1Q8GpUKUU5TSC
	 TopUTcV7BfJ0afk6ZeXTLpBd0clkleCmubF4VH2nghqlxBpDfz7cEILazxjkyQ3chh1Va
	 jCDIvIKa8964ODROK5YW9Ice3Vcldfoi7Fr4/wZUD8N4aI1Ig1sz8A4ZcMzfM5mtkXLO6
	 a50uU0PN1aJMUX4kHZ8uL1Zj31BEflqf+knt8zdT5+Ko8TMeI/ELPyekbmOjc3pJhSjMz
	 sCqGPCOrhz3pwEeST9RhkAGMsT2OzlMHptzJcf3zXJOwL12vd3qERYsBmOcALb53UKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yNNYis46Pa6H/wcZnNAkQAy1hoWIcN1c7M6rAojjcxM=;
	b=SBOh99th3KPw3FkmhkivQjazgujRbz+m+VTYlSWsxudUSdhfSUphPEkeNZxUlr0EMVdA
	 miKBdtIX44s806lGgXLBLfsNst/dtAHkZvxRxY2ze8kB7SQHI11DvGZunO0cRFLtO9r5y
	 SZwIJKJI2v05LPf/WlRCy42gIR/Y6CTYhAL6aTx8kQs8Vr4tHc9iL+sXIIzRU4I5cDs00
	 O8sOpNEg+r1v6/xUdqAfLpILZ2prV6YhJ9dt/Pb1LqUsZnO+buXnlVA8Hqsph4JSAx+9D
	 5Ut5LCy+beTiEvLDBRAPCDwvzctW4oCuYGF+S3esyNJxA2eTXN6Jneu5aycgp+7RQAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGBSzkxw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67876606A31E;
	Wed, 25 Nov 2026 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xGBSzkxw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10A71F000CA;
	Wed, 25 Nov 2026 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617960;
	bh=yNNYis46Pa6H/wcZnNAkQAy1hoWIcN1c7M6rAojjcxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGBSzkxwE7mVwYvzisHMzcba1ReMJhAaE3dv7nOGAnENAMWTWr0/vrST9LGzpfXXC
	 F2b0JjHCb3H9FoT8nJl0PFEa2WnnRfF/XMIau/dcxsFHzKmsn6wRaGL7HqYkOzjY1A
	 I08KH3RUKWDVUm5MnpTpiHW60qyWDFMWmHOy4ru0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0130/1005] gpio: shared-proxy: Drive the default value when no votes are cast
Date: Wed, 25 Nov 2026 15:24:28 +0100
Message-ID: <20261125143824.784483084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 0bc45604403176722e634e670f5e38de0aa42a9b ]

A consumer that requests a shared line with GPIOD_ASIS never calls
direction_output(), so def_val keeps its initial value of 0. If the
line was left high, for instance by the bootloader, a later
gpiod_set_value(0) from that consumer matches def_val and the proxy
treats it as withdrawing a vote it never cast. It returns success
without writing the hardware, and the line stays high.

The consumer has no way to tell. Its request to drive the line low is
silently ignored until it first votes for high and then withdraws
that vote.

When the requested value is the default and no votes are
outstanding, write it to the hardware instead of returning early.
With votes outstanding the request remains a no-op, as the line must
stay at the voted value.

Do this for all lines, not only GPIOD_ASIS ones. A line configured via
direction_output() can be left at the non-default value as well: when
a proxy releases the line and restoring the default fails, its vote is
dropped regardless, leaving votecnt at 0 with the line at the voted
value. The write lets any remaining user bring it back to the default.
In the common case it is a redundant write of the value the line
already has, and it only happens when a proxy that has not voted sets
the default.

Fixes: e992d54c6f97 ("gpio: shared-proxy: implement the shared GPIO proxy driver")
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20261028123448.510401-4-shengchao.guo@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-shared-proxy.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-shared-proxy.c b/drivers/gpio/gpio-shared-proxy.c
index 4eae3c9a5168e..75d0d617941f2 100644
--- a/drivers/gpio/gpio-shared-proxy.c
+++ b/drivers/gpio/gpio-shared-proxy.c
@@ -85,9 +85,16 @@ gpio_shared_proxy_set_unlocked(struct gpio_shared_proxy_data *proxy, int value)
 	}
 
 	/* Desired value is the default. */
-	if (!proxy->voted_change)
-		/* We didn't vote for change previously, nothing to do. */
+	if (!proxy->voted_change) {
+		/*
+		 * With no votes outstanding the line should be at the
+		 * default, but a GPIOD_ASIS line may have been left at the
+		 * opposite value. Drive it there.
+		 */
+		if (!shared_desc->votecnt)
+			ret = gpiod_set_value_cansleep(desc, shared_desc->def_val);
 		goto out;
+	}
 
 	/* We previously voted for change. */
 	if (shared_desc->votecnt == 1) {
-- 
2.53.0



