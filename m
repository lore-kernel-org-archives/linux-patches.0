Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136A11754B;
	Mon, 27 May 2024 19:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836595; cv=none; b=UNGCKoEVDFxl3aJvwWWyfyzWDUBQS2H6HVaH6bBbOvEbGbMCNkC7xE4STqXN581m+vR2u+8AYuq6LrWnNo0ZFC1Tdxn4wh1jSTyC0PhaXt+E2ApYDJddUuxonLw+JpPrCyPN5FbS/q33uVfFpDFnIj64Uz3EIP4K891L7JXISBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836595; c=relaxed/simple;
	bh=TN0QdzCNMGNzhWfmIa2+PJSUWUa/riqKweqTVOZPVZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3mEpWLpxfja6HJNsguqWmpMB+XGPk8FHItGjoE0RgkE9yN48V2T5I0VV7krf0Y0WZFn8JMayLRqoxqiPT4t6YsFCLm4WQuEj5OalGPYnBadjqR1RgmTHBzs0G4MdVvb4yQXsiIj1QnQUWS8GSVZVU/CatoyS3sZv7e/hm0EvJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvTOuNff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvTOuNff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FC8C2BBFC;
	Mon, 27 May 2024 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836594;
	bh=TN0QdzCNMGNzhWfmIa2+PJSUWUa/riqKweqTVOZPVZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvTOuNff/pcNLSTZ3fkh9fN2YeTrCZT5pmeYsDGkJdDsosR1EyGoPl5RT5FGoNWcS
	 D8fYPpUg4j60Bbt8IqlglwRUo+DGVpfeh7yGXydYis+M/WuehCs2+LUhWWewkl7DpV
	 Fr9ba6n7jn20ovPlMYb3PmoPP/SEPXpyrvkcD0Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 115/427] enetc: avoid truncating error message
Date: Mon, 27 May 2024 20:52:42 +0200
Message-ID: <20240527185612.532510486@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9046d581ed586f3c715357638ca12c0e84402002 ]

As clang points out, the error message in enetc_setup_xdp_prog()
still does not fit in the buffer and will be truncated:

drivers/net/ethernet/freescale/enetc/enetc.c:2771:3: error: 'snprintf' will always be truncated; specified size is 80, but format string expands to at least 87 [-Werror,-Wformat-truncation]

Replace it with an even shorter message that should fit.

Fixes: f968c56417f0 ("net: enetc: shorten enetc_setup_xdp_prog() error message to fit NETLINK_MAX_FMTMSG_LEN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240326223825.4084412-3-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 9f07f4947b631..5c45f42232d32 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2769,7 +2769,7 @@ static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
 	    priv->num_tx_rings) {
 		NL_SET_ERR_MSG_FMT_MOD(extack,
-				       "Reserving %d XDP TXQs does not leave a minimum of %d for stack (total %d)",
+				       "Reserving %d XDP TXQs leaves under %d for stack (total %d)",
 				       num_xdp_tx_queues,
 				       priv->min_num_stack_tx_queues,
 				       priv->num_tx_rings);
-- 
2.43.0



