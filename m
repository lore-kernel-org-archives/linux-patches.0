Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE972FDC51;
	Tue, 12 Aug 2025 17:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020666; cv=none; b=CGiAH4V04GYheZBeQdwo1s7XL6rO0xO71ikrHYwVaS4gCl70Tv0AnlpUySLT+egw5UvK7mwclu/GP4Boq+a+BfKyo/WABmn/fDOoLhMHYL7gkiIs/buIFLyOA+fOXcN17nCYN4zDXMjBHqkQMBc4VjM+EFI+OViuJJZIDO/alSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020666; c=relaxed/simple;
	bh=ptbrkg0TyrcTEdQUO4mBWlEOtuvoFRNe7v+4K9Y7IKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1XmNdDQJA+41/C1Dmw3oKwATTs6f9F8c+n+ShUQuMWsTQDukwYTIDV4hZ7xgEvqZybYBziXawwmdarhrglhFGWPEVevgW7JkJnQhZGiO5agTFsQ139NYQI8wADMl/7SEr1qs1b3qGMn69AWUkVsZXoISQTbCE8VKx1mhHr+Ch0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YiZLWMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YiZLWMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23146C4CEF0;
	Tue, 12 Aug 2025 17:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020666;
	bh=ptbrkg0TyrcTEdQUO4mBWlEOtuvoFRNe7v+4K9Y7IKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YiZLWMR9gMJ5bYeno2bgvxqtPm5QHL3GlwEY0+GJgkjWeL8CX2bShupWYndE+c0D
	 D1VtW7d2rHb3c3VbWxNTC5kkEO/8b9XMoQOgBHolQ2XfOoZ8UvAlAX4GGekpTnXtlr
	 V+g/45v1yGe1fAYdQ2xSkYZBr0PJwWbNGETbntWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/253] can: kvaser_pciefd: Store device channel index
Date: Tue, 12 Aug 2025 19:28:38 +0200
Message-ID: <20250812172954.232383241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74a47244f129..c6406fc1b0d5 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -966,6 +966,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->err_rep_cnt = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



