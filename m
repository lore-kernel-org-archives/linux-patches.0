Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388433376A5;
	Tue, 26 Aug 2025 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215818; cv=none; b=hGTwfCtFBTAtI/q2qZFW/cw6MXQXG0C+EnxHqO+mWQxA2YV4rIrMld/DuVb9+rkSz9TVAKhdAx4JlpDqplW+1bODLtEmBI4JXR1h7nJ9YrgULTgqFui5/cGaIRLq0qpVsSmjTaGAzCGtK3eV8crlKXouqRbdfN6g/IgluAek3Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215818; c=relaxed/simple;
	bh=TIBUCoxstQCpW8hcTsLWUzu8z8y25JdJtgnemvKBWzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK5SQBslsumZa5mrekADhK9RAdi9d0xvjKhGXMpCTi5NoPzB96l+ztPdw4CGDnTpjV8PRQnavwvFUocO8ztpBQ3j6NMxAYJMV4uXFZYIDaeCzZPBhr+IxjCINS2a4CViIAOZkrbsQeVSPQXhT5k3ExqYF/SRCEQok8OPuMLqnco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyRmThcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyRmThcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE225C4CEF1;
	Tue, 26 Aug 2025 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215818;
	bh=TIBUCoxstQCpW8hcTsLWUzu8z8y25JdJtgnemvKBWzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyRmThczvjeWEdmN8rKrmQoTDVkA3SFlRuqpGEzQt+l/JCO+nAoBwFuhg8+ZPGT0S
	 O1tlV8moukA9txblCKkvjSiLXgSEi54y/mieIRJuBRigIJtH902yttMPrhE+oecKzg
	 OJS8bjb4l3odh/1WiE9U/r9RdqtvIlo3jFv/S19Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/644] can: kvaser_pciefd: Store device channel index
Date: Tue, 26 Aug 2025 13:04:11 +0200
Message-ID: <20250826110950.442400623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 26bc8c7ad75b..23c6632319a1 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -955,6 +955,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->err_rep_cnt = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



