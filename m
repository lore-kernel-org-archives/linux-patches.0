Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C26422969E;
	Thu, 12 Dec 2024 16:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022508; cv=none; b=NKhfJ+e2pVDEOBmtReydcv1VAXh3vfW/sqjI48lzd+ag9mhSE0r7O/WjCnrtraJNd3HwCLNPlfOx31lxVoE06qTraUOkn3thkeFFImnXbM3JBaBqyFbAwF2jWJ+Ywec3hMTnfpKmJrnjadq5KXAT4v4ROfDv8I9FnNdAkmeMTlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022508; c=relaxed/simple;
	bh=7/5yEE0dDk7ihOEeVIEiSHk9pk7tbk6Q7ldPjUGzrLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhlHgDG8ZourGjhu6K/kooKjVKXYPXfeb5CzluqeegV4DCPi+dpwuACk/Jyi6/FylasT/EiFODJZd5Qh3ifyL7I7BmSIb1mpAhmF/IFVbWEMHIMWIPseAfmm8zb2qjYO71J1kriB8j5R/IIky1fejkpFMNB8MP3onvdDd3jfsp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FetgyeC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FetgyeC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6337C4CECE;
	Thu, 12 Dec 2024 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022508;
	bh=7/5yEE0dDk7ihOEeVIEiSHk9pk7tbk6Q7ldPjUGzrLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FetgyeC1GgvobRUkOeV02sjjgWYQpT10faNgpVCYJAXyisdZIHmRuaYEIq5WkEJ+y
	 +agmdsFSoUKq50dEHogXbLgBvXmI3efEopAIoo0RMyWIurnRUS58WiteJHP9eS2Z5m
	 zlDHJDJTw2+eKS/ZXrG3HJL5pfe/1finV5eLECxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/565] m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x
Date: Thu, 12 Dec 2024 15:57:28 +0100
Message-ID: <20241212144321.476714228@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



