Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018631;
	b=nGpK4mZGm6uzEYZZhRu9ujENgavSd81lHUT6gUPpm8MiUOIVcjJhoQ6MJEVErK8k+TiA
	 dhurM3FFRmiNZ98wiPTvM/Y42t1bCsFRrB7Xtnwn2q2E92RUdBWEqouOY7l4fCCooSIG3
	 vrHevPcEPm6d6XZjNC/4zwdFyds1+iIuqifung/hB5X+CtTVRuy75FUHUSdF95SKHZDqX
	 AWflg5gcswrhAEbDSUuMTa4JsdV8bkHDstwl9CfwCWbGzRzU6h1eiXSjUizL0dbQGW7Ki
	 A2t0K5AXVNwWTJnaDetT5Ab4z6+G0R6tpL1UOT5q5NoL1CKiK+xeXQy+UCJcSOHqxqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0TnmeKJeWZ+ZvcMpGdZ6Sro/3LvTjRrh7tr9J+nA1sw=;
	b=ajw0ygfpwYVr58O8HmIdR1yQZiFEgtLRHPvCx+umvjRLg5nlFcsdjG3Aq8p5E+oLQnUO
	 TJT1SdShXqSaWlwY5reisoycPkFgoqJTMEMe6uBh3v72gRKhL9inBLfIgwTdfoNS7xP9s
	 JlwrqrPU1Qo3Nxm0t98r0ZbL5ApRY6eMQGX5kRD3aQ4CxvbJpbQcIa5dRN/Izk8vw8Zd5
	 7LGU6ADmGp5SderzO9J/pvmUHvXGU3VSXPeqKuElqKLiFqPV0hPFGXZfmyULZbqO62kVo
	 Ls/3ybb8lRbEz57qIwawrpTRHGYWi/7As6a/YSai9gqhnjAkXdd7VWjUC4BqgrRpo/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dBxdE+t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6726E606A31C;
	Wed, 18 Nov 2026 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0dBxdE+t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E551F000C8;
	Wed, 18 Nov 2026 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018631;
	bh=0TnmeKJeWZ+ZvcMpGdZ6Sro/3LvTjRrh7tr9J+nA1sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dBxdE+te6w0pTcrODXT0Sn8Poqpo7pJs6nFMEBh4dHav0ynaSdYVTiXI2nUcfx6k
	 nkjb0sGTCkijrlw4EPDJGp0i1coHPxRwr9AOKh/r0T2fyXyHuMYowiKn/Gitanw/yV
	 E+/hXfzAXePL7a1PeKzhr13kRcnSn6tI9qc1LJRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1267/2651] power: supply: ab8500: Preserve battery termination current
Date: Wed, 18 Nov 2026 15:41:47 +0100
Message-ID: <20261118150333.581807609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 3b33eda4067494658d51db0792377fef98787e3f ]

The battery-info parser uses a negative value for an unspecified
termination current. Testing the value as a boolean instead replaces
every valid positive current from the battery description with 200 mA.

Apply the default only when the property is unspecified so batteries
retain their described charging termination current.

Fixes: 9c20899da46b ("power: supply: ab8500: Standardize termination current")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-6-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_bmdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_bmdata.c b/drivers/power/supply/ab8500_bmdata.c
index 19ed528528048..9e95bd6e4ae67 100644
--- a/drivers/power/supply/ab8500_bmdata.c
+++ b/drivers/power/supply/ab8500_bmdata.c
@@ -174,7 +174,7 @@ int ab8500_bm_of_probe(struct power_supply *psy,
 	if (bi->constant_charge_voltage_max_uv < 0)
 		bi->constant_charge_voltage_max_uv = 4100000;
 
-	if (bi->charge_term_current_ua)
+	if (bi->charge_term_current_ua < 0)
 		/* Charging stops when we drop below this current */
 		bi->charge_term_current_ua = 200000;
 
-- 
2.53.0



