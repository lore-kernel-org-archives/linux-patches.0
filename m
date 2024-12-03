Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55461DA3D;
	Tue,  3 Dec 2024 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239180; cv=none; b=q0fsiJxVyJ5LT1AwXuOoOFmi/D1Q/2CDF/e+oB8FVQcBD08QZY10bkPkewuVkao3+WfRsl+H67WFv9AOb2Lw4VmJmm/3InppREQbZ3fVlbiitaWGHs9gIZ9L3aeSHYb3m/wo6cFWHwiXVHipAnbd2rLfRd0mrCxoKJDy201f9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239180; c=relaxed/simple;
	bh=9xqeSS25R0bJ6U4IJ3nXayA3AEx7Q0X0Ke9URNd8who=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFbQJ1oltKnYJTUHjVmfSg4115BzvtoxBd3Z80P9tT3LujzPI9Tp2koYX1uAHktoquT70/YMnYZT1cnzQ6GNW38kCNOo5hjqpY2A9h5iRQo65/8Ad/ucyXZX+UN6JE6RB4v3Z2wfNwxbheYITUBhTwxzR4uLsmlGtG0bRun0GJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCkXHvnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCkXHvnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F726C4CED6;
	Tue,  3 Dec 2024 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239179;
	bh=9xqeSS25R0bJ6U4IJ3nXayA3AEx7Q0X0Ke9URNd8who=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCkXHvnGYnEj2YPMFJQVeLjQy/5Dzr9ZM3taURkWciVWhmPQRZz2PGqjSTl88a8KO
	 aq0QlrRf6PuPXCnaRCPc8TxImL+o29L/uwP45MYvEQmdAkmC8KCgKvLEQ9xMknEQ1K
	 CiecJFKWJcmC5sIMQhktorzD/iF7Utuaosnawl5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	Greg Ungerer <gerg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 526/817] m68k: mcfgpio: Fix incorrect register offset for CONFIG_M5441x
Date: Tue,  3 Dec 2024 15:41:38 +0100
Message-ID: <20241203144016.429730271@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 019f244395464..9c91ecdafc453 100644
--- a/arch/m68k/include/asm/mcfgpio.h
+++ b/arch/m68k/include/asm/mcfgpio.h
@@ -136,7 +136,7 @@ static inline void gpio_free(unsigned gpio)
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



