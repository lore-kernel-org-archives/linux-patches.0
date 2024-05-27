Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BDB168C4;
	Mon, 27 May 2024 19:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837886; cv=none; b=SV+FbvSSeARYHKv2CZDKz9iSRxdxI942SbgT+dyyzv8VhOqWYUz8GepPwdKr5hHMy33QHkYKhJun6I4L+A/SboJcmJFG1nw1qjJgyvKJ058F4bIl9Uy5qjpcq9J+QWhvrosN0bY0RorDnFyOurcfb4qfLTr52U5Y7abUYB7msNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837886; c=relaxed/simple;
	bh=AADyVNiO/UnzqonLZsltbI8/DfGFf5vqc274kZjIVYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RN7rgVaKDysIttpyLTuH0ypHKztjdHd2x87sIvHQz4v94NF3CqoQDahZyThAL75gnGh41lmkZHblW2EEZahgBjBf+dd/IyXs0k4XhCvv/ZDwxQoyHXOl8RGsZCr1KqYLrv51r6olKDeIzfWug0KBP7lDRYAawvaTxIywZsBFi8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFvwfWiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFvwfWiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2569C2BBFC;
	Mon, 27 May 2024 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837886;
	bh=AADyVNiO/UnzqonLZsltbI8/DfGFf5vqc274kZjIVYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFvwfWiYZvNPf6UqN6zM4maRLaLKPhJJRDoulh4hcUNI0osjYK16ZsKso1pjwdVFF
	 8Obzms85kJ3OSTNOd0KOSjwidGV0VDQaoK4ZotB2XMs55Z/KiT3wAPyqDHAwXkZrQw
	 yp5cBuARWlVCSBrfMQyF4AufwQXwi1m4sDTLVMhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 184/493] enetc: avoid truncating error message
Date: Mon, 27 May 2024 20:53:06 +0200
Message-ID: <20240527185636.369060950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index bfdbdab443ae0..5e6e1f7196f87 100644
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



