Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A883F20E8;
	Sat, 12 Sep 2026 10:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207681; cv=none; b=aK14d9DpB/RXakMmiuKUuou4aVFDuNzcJTWqTKHxKHPxT9JCWtPkCtY/JLvwh9B+8ul66qDinwu5HxWjgSl0RrLdwuDSbsNYvH4Nudhg8FCH5FjaqCMGsFVfCMcC2AGbY8YXiy2djjf4vic9Txo2xsw+jdJfrXiQp6JCMtBVEow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207681; c=relaxed/simple;
	bh=GIUvkmRpq/pPGqqR1OcDnRIHomknAFZENWhJqWrO5yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHffqPzNCMHbZqMYTrP0ZC68AME/KlCnbm+n6tZghIXkkHtJw0o9SOPfNWfSGcBSxnfNNhvkVOBtEO5phL9Blzx7Uzn3YL0QtI49Z/BK5KWlZKfRHbl0fJiijhw5aXFjX3lGBQsnqEfOA4iv2UDvpgQKdJYC0rbB5V5ufUaQiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKQ/7erT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKQ/7erT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BB91F000FF;
	Sat, 12 Sep 2026 10:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207680;
	bh=pgoR/GuAH6N8CH0ezn42d4WgVs+5t4qXs79YCY3ITTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKQ/7erTkdianRFjRO5L8wJGfCOOsLNc7tARMeKFrrekMIMEDCQdJNaJEve5bCQMU
	 gxvilvtbqYJL2I42sthbVyynqU6jvfJVitSBdgPy4woihh6joiLH2odK1PzBLDwPdD
	 5l63BH1ezWJpmYsQh+HniLKQgTGZm75B2ccR8owk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0419/1518] soc: renesas: r8a78000: Drop duplicate "default ARCH_RENESAS"
Date: Sat, 12 Sep 2026 08:43:08 +0200
Message-ID: <20260912065632.929232081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 07231087d5e24c4d9c578c824b96f8af913f7324 ]

The Kconfig entry for ARCH_R8A78000 contains both "default y if
ARCH_RENESAS" and "default ARCH_RENESAS", which are sort-of duplicates.

Drop the latter, to restore consistency with the other ARM64 entries.

Fixes: 5284d0b09d1bdc69 ("soc: renesas: Identify R-Car X5H")
Reported-by: Marek Vasut <marek.vasut@mailbox.org>
Closes: https://lore.kernel.org/a069d50d-030d-4189-ae9d-37f989829da4@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Link: https://patch.msgid.link/64de6e95719a6dec7412cf7e917a42749e738b99.1783593775.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soc/renesas/Kconfig b/drivers/soc/renesas/Kconfig
index 340a1ff7e92b4..f151b05fbb8fa 100644
--- a/drivers/soc/renesas/Kconfig
+++ b/drivers/soc/renesas/Kconfig
@@ -355,7 +355,6 @@ config ARCH_R8A779H0
 config ARCH_R8A78000
 	bool "ARM64 Platform support for R8A78000 (R-Car X5H)"
 	default y if ARCH_RENESAS
-	default ARCH_RENESAS
 	select ARCH_RCAR_GEN5
 	help
 	  This enables support for the Renesas R-Car X5H SoC.
-- 
2.53.0



