Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046670;
	b=HrMyaL86zc6pefU5lpIrfMPnAWAYq4tbBcO2kGiHgF1jrEOHXXdcWZDWiDGadyqbN+eX
	 jnR0neoPHfitf07PsW6qJ2lgT+0v/LOa36s0Nx4kYlQ5KKZJJvE7VPGH3yZiWiKxqryBH
	 23jFUlUwOxYFYb964M0hNHxY1yTXv4CN1SIbc7YaksTTlDv3BAM+5cebRroVYI24hKxAZ
	 IARq6bhkCaq8089xDu4jozmqZltBIn4ReYrAr9C0f5FGYBnQDpDKgKEXcx+9h7wBSxG2n
	 ev6rRrcx6YR23EX1hv0yy/UArhOSwLnbS26721wiHH43QjXAyD2nkNr+Z2sOybBtljQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vzla6xm273iMd2+92v/oMnTous07ChGYwDlP+vMc14=;
	b=uTF0tdwudU3I2iudNyRPkaeog4GVKqe0YBUT/QN3ohazHXVXL7F6+yrLh6RMvgemyqf/
	 m5SG2xrtIKySndU79yaTiWEhFTRU0ivuu8+IwaQbyzJkzW0cu+dOUrflzty0VWlyxRmuh
	 Q2Ze66lKCG3Um/qcBS4D6EjAJOQQgTiJV6s18+jZ8GNswy9AmZ5cji41c96kes6ySX0rp
	 nZKAVAHtd2B5PQe0MSo/9az/VfUzA2adSMhSHllA8f/4xYKNKZ8gdUhYVK3phEYx+i7+n
	 XZmgyauO0b08XNtxkfpJIYvhvi3Vmuorznff9oNBL+uCWijk5DlMLKdAdBeimaLcHEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lI7c3u9P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE3606A32A;
	Thu, 19 Nov 2026 00:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lI7c3u9P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9421F000C4;
	Thu, 19 Nov 2026 00:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046670;
	bh=/vzla6xm273iMd2+92v/oMnTous07ChGYwDlP+vMc14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lI7c3u9PIYEV8elVEKO8ph2qPJo4PV/kJByEBBbJ4J+qUJFLDogOH50J2V49uMljh
	 v34t11KSLi3rNOxlf6t2j12h39OjGTC3JD7lYbuFkWgpf686ikXmvgYXKipg/DVUyS
	 kPhzmlUm5m6cwRKV1sWIBzQFMdudpdfJdngv/sEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1363/2857] media: microchip-isc: dont sleep in the clk .is_enabled callback
Date: Wed, 18 Nov 2026 15:39:57 +0100
Message-ID: <20261118150250.480300005@linuxfoundation.org>
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
[ sashal: Added true as the second argument to pm_runtime_get_if_active() to match the older API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-clk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-clk.c b/drivers/media/platform/atmel/atmel-isc-clk.c
index 2059fe376b00e..54065c2cf1817 100644
--- a/drivers/media/platform/atmel/atmel-isc-clk.c
+++ b/drivers/media/platform/atmel/atmel-isc-clk.c
@@ -98,15 +98,14 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 status;
-	int ret;
 
-	ret = pm_runtime_resume_and_get(isc_clk->dev);
-	if (ret < 0)
+	/* Runs in atomic context, so must not sleep to resume the ISC. */
+	if (pm_runtime_get_if_active(isc_clk->dev, true) <= 0)
 		return 0;
 
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
-	pm_runtime_put_sync(isc_clk->dev);
+	pm_runtime_put(isc_clk->dev);
 
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
-- 
2.53.0



