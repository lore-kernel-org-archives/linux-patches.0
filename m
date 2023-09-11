Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1261170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF54C433C7;
	Mon, 11 Sep 2023 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442090;
	bh=pVeuaXFEv9SUUTMr6LrbZf2tuajZxbByDjcbS6eoaxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNYnUIs66LQQaGW5LLxA+y3Q27zJRNVMkoKsDMMZm9QL4dNSMRAam5ur5rgJ3Fhuk
	 lP/YuUS9MYfh/3tgybrtaGXZYiutj2TmTRrePhJY64xYaQ/5sHTr4Nj1G0M/NMgbJz
	 BQffwV9CQbh1zRaixHkfQZxyJkYPLg6bY6EOCdBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 616/739] mfd: rk808: Make MFD_RK8XX tristate
Date: Mon, 11 Sep 2023 15:46:55 +0200
Message-ID: <20230911134708.305154337@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d085c27aa62999e2fe054707ab9da2af65d22b2f ]

There is no reason for MFD_RK8XX to be bool, all drivers that depend on
it, or that select it, are tristate.

Fixes: c20e8c5b1203af37 ("mfd: rk808: Split into core and i2c")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/d132363fc9228473e9e652b70a3761b94de32d70.1688475844.git.geert+renesas@glider.be
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6f5b259a6d6a0..f6b519eaaa710 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1197,7 +1197,7 @@ config MFD_RC5T583
 	  different functionality of the device.
 
 config MFD_RK8XX
-	bool
+	tristate
 	select MFD_CORE
 
 config MFD_RK8XX_I2C
-- 
2.40.1



