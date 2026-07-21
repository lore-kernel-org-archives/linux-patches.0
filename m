Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920E746F4AB;
	Tue, 21 Jul 2026 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661270; cv=none; b=jmi4xqVk4f1vOge8WAFhbuYbGGv+QJNltTtRd3SWtnJ17VzT4QHj+k6g3VKo+wYE0FW+bDQwbA7M45dCPNGTFOlR5g0frl1mQSd0Cop0Uw6jvv45Dd5caB7jAH7Kl+6G3NqeV0zPSQRfWDAJvp15fU85X/ecHzOnyNuZaPNe9aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661270; c=relaxed/simple;
	bh=TyUBCijT6osOl8xqS2iswZ14akdzQ/6PfKlN3owNapE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFDBQb8T+osSyGeh24WZAU/ZFmYqsj2Mc0Q//Wd5x9fwjzNDDyBNyqnvCivSe8YDcIAlumubfoCCP+4B2Ch03sc6mAvtfKC0GMUu1/QXgPfoi4XaKZh9/hGnyp2hfwqx+GuggD15aJPflPk3VXYg9mVzB2jASNKqdyPxuPdxpkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKM6ljd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKM6ljd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F421F00A3F;
	Tue, 21 Jul 2026 19:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661269;
	bh=PRRM5D9jY1x76BL8KQoOdd5X53HHhzUA6nV/I0NM49g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKM6ljd6Xr/GZIslxEVgu4CAf5EYxIwkXocxU7EVryZW3iqQhRx2CCGDR8t+riP1h
	 z7yz6npYXc3IUf7Eg4qW5hRi2ngaLqqfquQDRXVNVx2jdZR8UIYjMrsk1UPAOo2Abt
	 +v8I8VgXBFDJ2dFx13GojuXWuqPFIPZwm8b6eo6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oder Chiou <oder_chiou@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1242/2077] ASoC: rt5575: Use __le32 for SPI burst write address
Date: Tue, 21 Jul 2026 17:15:15 +0200
Message-ID: <20260721152622.108280815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit d0c415f0076b71b956f62ff6f31de885f0fa2489 ]

The addr field in the SPI burst write buffer represents on-wire
little-endian data. Define it as __le32 so that the assignment of
cpu_to_le32() is type correct and avoids sparse endian warnings.

Closes:
https://lore.kernel.org/oe-kbuild-all/202606230139.rFZUVpCa-lkp@intel.com/

Fixes: 420739112e95 ("ASoC: rt5575: Add the codec driver for the ALC5575")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://patch.msgid.link/20260623102514.2422990-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5575-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5575-spi.c b/sound/soc/codecs/rt5575-spi.c
index 9a349965435b64..d5b3a57c886664 100644
--- a/sound/soc/codecs/rt5575-spi.c
+++ b/sound/soc/codecs/rt5575-spi.c
@@ -17,7 +17,7 @@
 
 struct rt5575_spi_burst_write {
 	u8 cmd;
-	u32 addr;
+	__le32 addr;
 	u8 data[RT5575_SPI_BUF_LEN];
 	u8 dummy;
 } __packed;
-- 
2.53.0



