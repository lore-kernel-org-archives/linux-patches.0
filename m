Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11EAFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295CFC433EF;
	Mon, 15 May 2023 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172771;
	bh=eqUZbI1YaPBpvFLCUAgAJrsNgkCNGt71KiebwEyHQao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcWJmIhiAsFvf3eCmSgz3sCRiWgw72RPz9GAj+jlNRWgW9j7TcchPVb59X8ZkVe/6
	 YMmdO/1lu2x0Lpy5iUoEIlpDoSwNxmfAchN4/BuBUTPi3NSxLR41GtdElWwSOTKANj
	 p4QAnOa9xrzHQlk6IoDT30rTx6+Md3Kex5JtUD2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/381] leds: TI_LMU_COMMON: select REGMAP instead of depending on it
Date: Mon, 15 May 2023 18:28:33 +0200
Message-Id: <20230515161748.571721080@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a61079efc87888587e463afaed82417b162fbd69 ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: 3fce8e1eb994 ("leds: TI LMU: Add common code for TI LMU devices")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230226053953.4681-5-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 56e8198e13d10..ad84be4f68171 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -871,7 +871,7 @@ config LEDS_SPI_BYTE
 config LEDS_TI_LMU_COMMON
 	tristate "LED driver for TI LMU"
 	depends on LEDS_CLASS
-	depends on REGMAP
+	select REGMAP
 	help
 	  Say Y to enable the LED driver for TI LMU devices.
 	  This supports common features between the TI LM3532, LM3631, LM3632,
-- 
2.39.2



