Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035846;
	b=Q/WhNwTHz8oYSk6iihJQvZVKgFlufcfAjb/XEJ5eX8Ff17nytQzU6BN94bixLDmpaoEZ
	 546jnTCb0ouGW8viKgUEnVkqLmNMQy6GFO96mgDxp6NvZvemNCw24OOLfhUSQG0icgtxW
	 BmGTAOlW1E3ZpZSnXhMqtxhI32u1EOyAa1evqE/GUiVoawOr3imS4oan7C9meeQhJZUWi
	 bVHmdGkTUBRFA/t+cH2xJo16A74HP4S0yabGK1CSh7K/JfWQb6eiDSCCDb2APAzoBaImf
	 kQMuFgOx3UrVTaTWYamTiLPr4l5CACDGlJ+xwHnaTUlpZrE6+VsyfpzMGCanXzq1KAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lIUFuQlF0p16DCXVx4GukGfxJr67Hbcgk516iEoCohw=;
	b=UVLClSesHF93pg8FUDG2aVOUF/3rFXrnzfbH0hIF+UExz+TTkQubD59ahCeolVvNvqEg
	 e7UB6/U7M9QRjbKxsPPZTqORJcc5kMBUae3FXg7Eq0nglksZEaBm0nH2UGQzGeB2DTGq9
	 sBB8EVHzwve4IP8kWlc2u2IOAp2gTsDP6Lg5wqWwnkkcrPT/CZDpxYl5KmCxWjXnpggwi
	 okzFAf+F825PcztERGWzsd5S8tQx3XIbOU9dXfthKVyzzu/iNdxlyyHsJ3iYgjybxDYM2
	 ZnUR+wIxUUXxz0DDc/lrBHEOO6ifF8mSRWFyVpOqTtiqcf9h2KaFCRvISp0Y3GE+WFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4CkScFS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D625606BE08;
	Wed, 18 Nov 2026 21:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4CkScFS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09F61F000C5;
	Wed, 18 Nov 2026 21:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035846;
	bh=lIUFuQlF0p16DCXVx4GukGfxJr67Hbcgk516iEoCohw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4CkScFSShzboPSBVcy2T2WtRf4ubVxrVcgkGPkRB4MbRpX/1cPctZ8VouF3ZL+Fv
	 v051BnShvqOKFI0GHrHv1dBv4TRYfwyMnqRhu0algi8N/NN0mbIFVoXSexwHRa3DHC
	 38CEF4NjLJ9D27vJo8edE4hbe5ZQyFz3gLIRZbWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0849/3318] media: microchip-isc: dont sleep in the clk .is_enabled callback
Date: Wed, 18 Nov 2026 15:24:31 +0100
Message-ID: <20261118150344.680012806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/microchip/microchip-isc-clk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-clk.c b/drivers/media/platform/microchip/microchip-isc-clk.c
index 24358d804e75d..66dc522a61908 100644
--- a/drivers/media/platform/microchip/microchip-isc-clk.c
+++ b/drivers/media/platform/microchip/microchip-isc-clk.c
@@ -98,15 +98,14 @@ static int isc_clk_is_enabled(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
 	u32 status;
-	int ret;
 
-	ret = pm_runtime_resume_and_get(isc_clk->dev);
-	if (ret < 0)
+	/* Runs in atomic context, so must not sleep to resume the ISC. */
+	if (pm_runtime_get_if_active(isc_clk->dev) <= 0)
 		return 0;
 
 	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
 
-	pm_runtime_put_sync(isc_clk->dev);
+	pm_runtime_put(isc_clk->dev);
 
 	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
 }
-- 
2.53.0



