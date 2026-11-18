Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059694;
	b=TiVaBC6EOL4VIm18LKF29YgERVDj/Jxria8o6+PkGRZXxsmSiB+oozzYj8CzrfPdKdjw
	 YbKGBLXJ9AvaHQdgZBK7vzg0jIXLLWsWN75IpxqIWQs38XrHklm/hwIOyoV/n2CAPLNcE
	 zvldUPjSA0o5yOU1oZSmRI7pWL72EwDKazO91sUTaEYJN90i+gT7cpQVe55MEzaN3ESq0
	 0ZHI5TGT4YEYqp8I6VpW5i7dXbylozH1GQuEUCd4SgkNWzYAyfpB75kwXe+CUywHubrCu
	 Q4Q+CpQwoHJ1z9TMczurLvNJkxriuG6bASyZrwmPvD5d4fvRVcvKvZSp4072rMf4whw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MTlssfWsPAWzMESbO/54jGx/MQ9ODmKhSqBD8344Ons=;
	b=teUkTZE99KfrMH+Rx6Myg2XbB/ijno6AnvqPw1IOEOetBjU/MdfBkVsB6LH9wNM1eB/j
	 q/MnjGeUob1H/hga/KIidPfwjXtqxAZVpK+PRU6EyuQBakn6yUDm2W+Kqem/RlV4geMoR
	 jbudhvB9POkMvqqHN2iBnlNvb40OukdOSnCWgQC+aGcxCCiUFcWpyq7thhKHFlFTkqR1h
	 ++PNZliYuGnPDs3boKXsCOohJROlweOfMvOzQ7DfypsoXsB5aGnPbQ78m8xpirPK4Bt/r
	 d4VaobQFiUey7bjWzAMtfZ1ZiMXkWk9FsStsHtfoGNOUiYgs9qnewHZoYs7Ruw3iodA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fKXAJYft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C17606A334;
	Thu, 19 Nov 2026 03:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fKXAJYft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC571F000C4;
	Thu, 19 Nov 2026 03:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059694;
	bh=MTlssfWsPAWzMESbO/54jGx/MQ9ODmKhSqBD8344Ons=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKXAJYftG7/Po0+mqRLS6A+9BUMv6hHewbH+bcn96V99JuG1aTiRjmTl/0n88RxUY
	 haVV/dK70d5xZBZSUE5TmwwCKyRUPMUHnxvyT/G7b3Q6xLMR+zwss44BV91EeRpIgS
	 WZvCyK2c4q9YCJ7qUNPMOFmlH04ktcr//2BnhtLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Jacob Chen <jacob-chen@iotwrt.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0892/1848] media: rockchip: rga: fix clock cleanup
Date: Wed, 18 Nov 2026 15:48:50 +0100
Message-ID: <20261118145953.860056789@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 254f3337ce2575bf94f1fb40cc40fdbc70371116 ]

Fix this smatch warning:

drivers/media/platform/rockchip/rga/rga.c:734 rga_enable_clocks() warn: 'rga->sclk' from clk_prepare_enable() not released on lines: 734.

The reason is that aclk should be disabled/unprepared before
sclk, instead of the other way around.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jacob Chen <jacob-chen@iotwrt.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: a875c43dd95e ("media: rockchip: rga: quiesce IRQ before releasing m2m state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index bcbbd1408b368..02c2ea2b42a50 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -717,10 +717,10 @@ static int rga_enable_clocks(struct rockchip_rga *rga)
 
 	return 0;
 
-err_disable_sclk:
-	clk_disable_unprepare(rga->sclk);
 err_disable_aclk:
 	clk_disable_unprepare(rga->aclk);
+err_disable_sclk:
+	clk_disable_unprepare(rga->sclk);
 
 	return ret;
 }
-- 
2.53.0



