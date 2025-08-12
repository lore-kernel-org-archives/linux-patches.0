Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F842FE569;
	Tue, 12 Aug 2025 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021329; cv=none; b=mja+olV1XDKQdiyhQBMZkYSrISmpFAo2WV+W22XEe7M+LsmoQOllHi9lVjffj0XT6as9k2/TZ9MUyZmU7SigE/py9FrPVP/cXgVqUn7YV6oH337s0ypFTuX+72JantF8nSvCgdwUQ98qXIZRiPQgsMEGqooASGZkk0Ktlyrx9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021329; c=relaxed/simple;
	bh=vSfhYmUwMqqFWE5B83NkzPrnI46ujqDKrG96u26DvNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buv9Z6ygbQ5IiOVpMv9FXLtjDXv+AaORcfa1yrs4Ay3lVR4FS/VTwe1/waFf9Jlt4ddkExHfCDZLHSW2+oDmiNRFCGQwG0qjohfvwigejaDSC8ECpCb9M3DqefPBjf1VOCeozltkIJeMUBkL+pSbdVx/uLjsKTyybxFdDzGBK9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mraCItc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mraCItc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B70C4AF09;
	Tue, 12 Aug 2025 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021329;
	bh=vSfhYmUwMqqFWE5B83NkzPrnI46ujqDKrG96u26DvNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mraCItc/RU07xMbUoVnVn4XPqbnryLXGYXic2WYtyjrIh+T1jVxARvuWpeZ6roLQf
	 jbv4naLjM+EJ21ZYMVAPe5eIMpCIPtDxOJWH7qHnayGhPT/rapwFgEUKYUmJGjtDVW
	 yeql2sKX8eCnGs+or4NqcH+VUocvgB0vQfSgpVKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/262] can: kvaser_pciefd: Store device channel index
Date: Tue, 12 Aug 2025 19:28:04 +0200
Message-ID: <20250812172957.162538469@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit d54b16b40ddadb7d0a77fff48af7b319a0cd6aae ]

Store device channel index in netdev.dev_port.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250725123230.8-6-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 73b448cd00f2..0b74b79b08f0 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -927,6 +927,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->err_rep_cnt = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



