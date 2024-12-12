Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAEC13C918;
	Thu, 12 Dec 2024 17:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025361; cv=none; b=VILbnOgzC4satY/vF1sQFa45ULmPVMq1E75OCjQ0SbfUA1FNkYfXcWtO64F7vDfcQfBdHBG/0Q3IKvmfJgUhqk2OpVXAwR3AualA2jo8pP0mi3Cnz+R6a8py6z5v1GaruJVP6W+W+EALZtIWH41yIxolC5QV7Px5/Ms7p2Al7zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025361; c=relaxed/simple;
	bh=I1jTAh5liROYeu5kS8s3I2SCUCc5y9CsiM+yiL8PRc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmqzBnaLl1MYeFCeDeda7h99nnd8L8xPBsXrd78K1Wu9pM/U1MZlW9jMJErrW6fWPOtwe1ooQSDf1+YKy/EtmyNsUi93KRAXAiliiKWuuZaZFZFzyg6Z0IiK2d/b8dZV0+kuK9FkPdx96ErEtiBOXrOeXWZ/D6t7DSmgmsPxL8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=an0Se2SC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="an0Se2SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64417C4CED3;
	Thu, 12 Dec 2024 17:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025360;
	bh=I1jTAh5liROYeu5kS8s3I2SCUCc5y9CsiM+yiL8PRc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an0Se2SC/sK87xkW1oEn+uJqgtUqtrMirDq1M4wE0iCaiU/eYisERjl06EeXKAaFX
	 Y/4tj2NDYGQh6TtchAwKc1nn8J3F/bRWXViCELRuTFVh0aVOq7+qJNjKNujsuF6lyg
	 1Gw6OBTvJsMgvE/xsP26gji54u/Mx3EHiyVhupaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/321] m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x
Date: Thu, 12 Dec 2024 16:00:32 +0100
Message-ID: <20241212144234.486870169@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>

[ Upstream commit f212140962c93cd5da43283a18e31681540fc23d ]

Fix a typo in the CONFIG_M5441x preprocessor condition, where the GPIO
register offset was incorrectly set to 8 instead of 0. This prevented
proper GPIO configuration for m5441x targets.

Fixes: bea8bcb12da0 ("m68knommu: Add support for the Coldfire m5441x.")
Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Signed-off-by: Greg Ungerer <gerg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/mcfgpio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/mcfgpio.h b/arch/m68k/include/asm/mcfgpio.h
index 27f32cc81da6b..02049568198c9 100644
--- a/arch/m68k/include/asm/mcfgpio.h
+++ b/arch/m68k/include/asm/mcfgpio.h
@@ -144,7 +144,7 @@ static inline void gpio_free(unsigned gpio)
  * read-modify-write as well as those controlled by the EPORT and GPIO modules.
  */
 #define MCFGPIO_SCR_START		40
-#elif defined(CONFIGM5441x)
+#elif defined(CONFIG_M5441x)
 /* The m5441x EPORT doesn't have its own GPIO port, uses PORT C */
 #define MCFGPIO_SCR_START		0
 #else
-- 
2.43.0



