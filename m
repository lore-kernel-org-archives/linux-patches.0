Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A31611C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADE3C433C9;
	Mon, 28 Aug 2023 10:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218515;
	bh=0ZWCJNhmfDVOQ0JuW1fX5iH0WmLDZslQw4QJoRLJjEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHoeIXRrNs9ZZuIaofdQFbdzJ71qid5li+/2LeBGgIfsTo5RN3ZRa+czwpbmJk+3V
	 OX/nAkOqrQwbClhp6ibZlbsHGsKCZgV/wvLotG03ugi2qAelRMXdMfP3QqKbYes1EK
	 5l4RysXJbbSPD9oOW4FBc2xFoM33uVEMmYFwnDDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/129] Revert "tty: serial: fsl_lpuart: drop earlycon entry for i.MX8QXP"
Date: Mon, 28 Aug 2023 12:13:02 +0200
Message-ID: <20230828101156.591551195@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 4e9679738a918d8a482ac6a2cb2bb871f094bb84 ]

Revert commit b4b844930f27 ("tty: serial: fsl_lpuart: drop earlycon entry
for i.MX8QXP"), because this breaks earlycon support on imx8qm/imx8qxp.
While it is true that for earlycon there is no difference between
i.MX8QXP and i.MX7ULP (for now at least), there are differences
regarding clocks and fixups for wakeup support. For that reason it was
deemed unacceptable to add the imx7ulp compatible to device tree in
order to get earlycon working again.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20211124073109.805088-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e0edfdc15863 ("tty: serial: fsl_lpuart: add earlycon for imx8ulp platform")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 36321d810d36f..573086aac2c82 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2136,6 +2136,7 @@ static int __init lpuart32_imx_early_console_setup(struct earlycon_device *devic
 OF_EARLYCON_DECLARE(lpuart, "fsl,vf610-lpuart", lpuart_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,ls1021a-lpuart", lpuart32_early_console_setup);
 OF_EARLYCON_DECLARE(lpuart32, "fsl,imx7ulp-lpuart", lpuart32_imx_early_console_setup);
+OF_EARLYCON_DECLARE(lpuart32, "fsl,imx8qxp-lpuart", lpuart32_imx_early_console_setup);
 EARLYCON_DECLARE(lpuart, lpuart_early_console_setup);
 EARLYCON_DECLARE(lpuart32, lpuart32_early_console_setup);
 
-- 
2.40.1



