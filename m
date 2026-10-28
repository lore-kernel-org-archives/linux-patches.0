Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210028;
	b=3nwPlcUgTfCkwuW7eRWDM5V4bxVG/6+h9LF1ebwSUvQKPyzQ8FX8+49Rdn9IRCu88uOn
	 WPNFPVv+aJAD2OGPFO06vBViaKZW4Jkv3zjAbd5SRpSZHq0rVkKn+ZscmwL0nshYYQc0Y
	 jHMyhT/ZOHKJWJGxZluTrDvVCWwE3H/gsFL0Avh8cAPvLDDEor7SBc3jVa2Z2Gjdki0O3
	 mJ2bwKjovj9azZ9LVAUhzsrua48HMBSw9qkxxx023gMJc+WaRX5z2+amEA0D0mgAGXTuj
	 0qxpHRd+sEJKyQ+NoMbjA1qPJw/UJ7wgZ+rLgoI5JMcLG46g4NfS9zCzrxX97D4VVtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGW02zW4af5SaYbPk4JYGeBdADCseeCCMEB2AGSXN+M=;
	b=0yAHJeBIEFdEmTnb+tHvY4zGpM2Vgu1px3c7v/c8mlxEJVd+o0oNo0gJ4nhEo92ldC9d
	 ZjlNLgRnJUsZfpqLRz931+Fc7Q7QAuv0NJDdOrPNjAGfE6nB3saFYmzHj81uC/YOeVjaH
	 Pk3Nvze8O3ZdS/ZsPd0Pzl+DdU2NvG7gb33aJLAYF0146f+/rD/IU6B27+QRJUDbGDmhY
	 s5Ni1fikjYU5NNy8GBxs40+xjyNEG1YPbRVqQLZ3E8ApqXQGnvDQltNGHNRZZQWPC1oF/
	 dfy+OcBYE/XVFquNYvt2OyJyG8CvWVI1WS46KwbrOFP4+wChFRc2WG0W+wqJ0yCr/WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ysNq1RG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E353F606A323;
	Wed, 28 Oct 2026 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ysNq1RG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEBC1F01825;
	Wed, 28 Oct 2026 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210027;
	bh=SGW02zW4af5SaYbPk4JYGeBdADCseeCCMEB2AGSXN+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ysNq1RGgbxONS5NwTaVgCK0c47N8DJnGob6WHziYyv8qFINYmc4NRik93jAhsu25
	 I7qz1LRSa6wf56f42vGdcPvGGV5fWhbKBLgBtgZX3qsBZcfVh9UNfhhcjALAodDAqJ
	 SWTmSYCG7BY7D/9Buvy73WBWHcvB7tZvmmk+QRRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/168] power: supply: ds2780: Fix ds2780_get_capacity() returning raw value
Date: Wed, 28 Oct 2026 17:59:02 +0100
Message-ID: <20261028165943.244463292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit a58cbc8b36ec0cd00d2ba3de7d003de818a27523 ]

ds2780_get_capacity() returns the raw register value instead of 0 on
success.  The capacity is already stored in *capacity, so the function
should return 0 to indicate success.

Fixes: 275ac74629c4 ("w1: add Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC support")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20260901072954.1953121-1-luoxueqin@kylinos.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ds2780_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ds2780_battery.c b/drivers/power/supply/ds2780_battery.c
index 1e7f297f6cb18..7219ee3def5ad 100644
--- a/drivers/power/supply/ds2780_battery.c
+++ b/drivers/power/supply/ds2780_battery.c
@@ -304,7 +304,7 @@ static int ds2780_get_capacity(struct ds2780_device_info *dev_info,
 		return ret;
 
 	*capacity = raw;
-	return raw;
+	return 0;
 }
 
 static int ds2780_get_status(struct ds2780_device_info *dev_info, int *status)
-- 
2.53.0



