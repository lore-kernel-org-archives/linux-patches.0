Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8233472B;
	Mon, 18 Aug 2025 13:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525414; cv=none; b=BaedFlVOlEaPzOuLWVJ5J8P8bR3MhUT6JNhL64buJjfHTT6kr6UPXbT/Fw1a/SIp7rk3VHTwOr7iAPCD/ttZglbHPFSB1HNv1v02n0k8fl4C7giNl1gP410qpAuQhd0As0BamquRt0Zq1F7IUpsg5ZGisFTeflPSrJro9vL7pyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525414; c=relaxed/simple;
	bh=tBb5AIKA0NtBGSMHidLGZuJNGyuY4jvcvnfrnR5qVWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIlGa5S3T2ZETOVfsyCOA+HWf/JuvcS2Wu+gYNfxcGRaek3EGVmsTSzIsaRhSr36A06HxbXZB06AbElzrAWOE8xEBxOchsCVMgNqHVlZ2n9OE8CP2R7NT2TF9VhXsag8EIpqtTpmWCv3KB2eC64DCe54WVwVdFYaawo59EAe5vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpVTc4Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpVTc4Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D17C116D0;
	Mon, 18 Aug 2025 13:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525414;
	bh=tBb5AIKA0NtBGSMHidLGZuJNGyuY4jvcvnfrnR5qVWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpVTc4ZhQgUmz4fzF1QfN93429+kge93ViTWRFogTTIQmmIWQoPTPtfMUo60OJ78S
	 bj1OnaCBQyHIrxbj135P+MQyvb0I3o1tbyJd77T2b53df/ozo5lE8TTfrO7ZD4nN7n
	 wJnUgUM3y0u7K6W0QVh6uPMRear7QBy7WDqqrM4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 238/570] can: ti_hecc: fix -Woverflow compiler warning
Date: Mon, 18 Aug 2025 14:43:45 +0200
Message-ID: <20250818124514.991251388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 7cae4d04717b002cffe41169da3f239c845a0723 ]

Fix below default (W=0) warning:

  drivers/net/can/ti_hecc.c: In function 'ti_hecc_start':
  drivers/net/can/ti_hecc.c:386:20: warning: conversion from 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from '18446744073709551599' to '4294967279' [-Woverflow]
    386 |         mbx_mask = ~BIT(HECC_RX_LAST_MBOX);
        |                    ^

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250715-can-compile-test-v2-1-f7fd566db86f@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/ti_hecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 644e8b8eb91e..e6d6661a908a 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -383,7 +383,7 @@ static void ti_hecc_start(struct net_device *ndev)
 	 * overflows instead of the hardware silently dropping the
 	 * messages.
 	 */
-	mbx_mask = ~BIT(HECC_RX_LAST_MBOX);
+	mbx_mask = ~BIT_U32(HECC_RX_LAST_MBOX);
 	hecc_write(priv, HECC_CANOPC, mbx_mask);
 
 	/* Enable interrupts */
-- 
2.39.5



