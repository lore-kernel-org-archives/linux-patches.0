Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774381;
	b=xokhEb+KPXyaQskm/lCMV5tB7hHPiH8yHiJs4Eb20dZIpwYCHJJpqJJV2CT6GmffFDUt
	 a0jDyp5RJCqZLDGV+DGjrqNzqVOK4mx0L+J/DAcvHcpidVXyg55mV4kjAncLZf2/PaNjg
	 yYBCY5fowvOEBr5L3ViolRQOVWeaAnWbtYf5QCcaU0kaYd6qgzYtGWLQfOneJ6ReC1y9Y
	 5dD2gjOxpqKEMDKaW5EFfycfYvzwVraY7fbMImgXpMexczcgArhc/Kcaeeq2qJwyWi6E1
	 K6drxFy9wuOAETp5yIbN6ModMhElvDdeeI97Hcd/y5AxIzFptCVTy/Kuzfx1Oy1c4gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eqV7QEakWkIK/oS6GDqL64vYEytLvNAhqHISrKd+TkE=;
	b=JGaOOzO2ZXLQ4SqaryEc2vD8llnWb7ELOSV72RZTL597XRF93JippInTBqKZyaRX8Q8s
	 HBRCy5+O75o0IIzewUDu55bFBUzOYlNgDh+bHnGWe3wMedUAKacCmcbBIZOVwbjo8gRvh
	 g7vPyPlMhdYOG8vzppYY8RPI6dmRjlDhgQH+2RZmUH4/IujgmjrvDA+EZDMAHh3hbhd76
	 TEWRfxFJJl4m7vSOoqHpi55KE5hdPCxlmYz4x2sG1YaeELkX9gGW3WjJ4/PGIESjfXP9Z
	 CkuE9MP7FqOZ/kzcWYtY3Mq2EwTRsZ1PoV5IOEOQOcnQ0DS/22A1Lvn4up/2F3JgaMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FsGhl2Ld;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A39606A31A;
	Fri, 23 Oct 2026 16:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FsGhl2Ld
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62981F01825;
	Fri, 23 Oct 2026 16:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774380;
	bh=eqV7QEakWkIK/oS6GDqL64vYEytLvNAhqHISrKd+TkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsGhl2LdprN3gWvBar1ajChJSjTUyuoBfc+qvEnC8dwc/EkU/Mn1wy8BWfEg1R90Z
	 6LjCRrfmsrM2X920K7yn7qF++rATfINyFuz8Jp9hSXY8KlOniCfrMgeVcpC2COg7Dj
	 TKQ/hMN8DegmatPi/aUO5yYk3nnHli1BYNwvk1Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 022/242] power: supply: generic-adc-battery: Fix temperature IIO channel conversion
Date: Fri, 23 Oct 2026 18:37:44 +0200
Message-ID: <20261023163714.307253684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 6bca94e64255053ab2aa56f2588fda73d399b790 ]

Temperature IIO channel data is provided in milli-degrees, while
POWER_SUPPLY_PROP_TEMP is expected to be in deci-degrees. Adjust the
existing logic to reflect this conversion properly.

Fixes: 33088c0513818 ("power: supply: generic-adc-battery: add temperature support")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Link: https://patch.msgid.link/20260926142905.206215-2-clamor95@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index f5f2566b3a32d..c69c9b9fa0eba 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -90,12 +90,17 @@ static int gab_read_channel(struct gab *adc_bat, enum gab_chan_type channel,
 	int ret;
 
 	ret = iio_read_channel_processed(adc_bat->channel[channel], result);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&adc_bat->psy->dev, "read channel error: %d\n", ret);
+		return ret;
+	}
+
+	if (channel == GAB_TEMP)
+		*result /= 100; /* Convert from milli- to deci-degree */
 	else
 		*result *= 1000;
 
-	return ret;
+	return 0;
 }
 
 static int gab_get_property(struct power_supply *psy,
-- 
2.53.0



