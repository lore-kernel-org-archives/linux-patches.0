Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059353;
	b=q4fGuUaN5w31ndDRyQufCASb+kabXqdR2l5OkBxIt4zaZmhlberQLHAHsbLWLdvs8k1C
	 0bZn1eQkj7S82b6ic0TEoW0a72Z5JjqAlwr+ZV/RnmCpFxg4Y65tC3X6PmNoG1BhF4+wY
	 kpEKRezUFd/Xbgi0Tvb41MS+fBeezGvGBqdxRhdiXyD4eldMFd+YhbCuhr+92EsMKtTvG
	 TwA+fgQe/Jya1xjVlg8kbs3f3VoTO7Y1JT12rROhtb+w7KQ6FLIYZWvsrekogo+9H585L
	 FNwuMlGQMN83evWl5m/PS5K8gE30+5fijIbBLUkk/h92+DZoyK34QYyrkxfNtpzRcmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UuKoPlc7FM60uVxNtrmCuQso2fzFPmLZPL7efJ/89Tg=;
	b=fNMST1+Ybkd+0g0xkuWT6dzkmyWTbcpTorKkmEmqWuuFZPdsutaElAGD0zS9oTHEMLd3
	 wZd9SwozRIVgwmILfAGU3YUk68xJrnTz4qTLg27l5CiKYn83hLBYEV6Rl/c9e6Lltrlxt
	 lGFiKXUxHxio11u8tzIQ+PYtVlrNlj0FnCPCByTW/uQ649l84sJBSMTj+z6CKBIPg3/gE
	 F12RBjrkbj7M+v6TgVmgkQFwgs2gt8fnY3Xo6YVOS3Esd5pXwoqJx6N74w8orVswCiDv2
	 E1hzj6dBPSnjQOpIUC+f7BvrcNQyGfiFChYqJTjn2maWLv4QDtT7CTRXIpYREROhHwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZCoORPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960A6606A31C;
	Thu, 19 Nov 2026 03:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZCoORPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA64F1F000C4;
	Thu, 19 Nov 2026 03:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059353;
	bh=UuKoPlc7FM60uVxNtrmCuQso2fzFPmLZPL7efJ/89Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZCoORPEDdHczPMUE014LBRBbFgUVH8Vakh6TSTgMiVrFP2cTWogju3jD7R2uPgOs
	 aZqwophrNHawWmTTmkoFh9hxB0wcH4urgmCPCxjWqbRKBttCTJAYygQpOpffXot4np
	 h3h4v30UJa6FTwhre4c7ovtkKEdX74iJ7QqQDpP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0812/1848] media: microchip-isc: dont sleep in the clk .is_enabled callback
Date: Wed, 18 Nov 2026 15:47:30 +0100
Message-ID: <20261118145950.290695404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 61490ff518c7b3ea3ff1cd16bbc012e9e4f1ab74 ]

isc_clk_is_enabled() calls pm_runtime_resume_and_get() and
pm_runtime_put_sync(), which can sleep and are not safe here, as
.is_enabled must run in atomic context. clk_disable_unused() calls it so
at boot, and CONFIG_DEBUG_ATOMIC_SLEEP reports a "sleeping function
called from invalid context" BUG.

Use the atomic-safe pm_runtime_get_if_active() and pm_runtime_put()
instead. A suspended ISC has its clocks gated, so report the clock
disabled when the device is not already active.

Fixes: 01192aa1c5c2 ("media: atmel-isc: Enable the clocks during probe")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adapted the existing ISC_ISPCK-only PM handling to use the older two-argument pm_runtime_get_if_active(dev, true) API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index 20de76b3c74b0..056876130b931 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -355,13 +355,15 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 status;
 
-	if (isc_clk->id == ISC_ISPCK)
-		pm_runtime_get_sync(isc_clk->dev);
+	/* Runs in atomic context, so must not sleep to resume the ISC. */
+	if (isc_clk->id == ISC_ISPCK &&
+	    pm_runtime_get_if_active(isc_clk->dev, true) <= 0)
+		return 0;
 
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
 	if (isc_clk->id == ISC_ISPCK)
-		pm_runtime_put_sync(isc_clk->dev);
+		pm_runtime_put(isc_clk->dev);
 
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
-- 
2.53.0



