Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046921;
	b=N4h2d+lPUXk60Usy4PrUrF9oXR8qJIAagApoExkcyyoYRTR/WzUDLAVMZwCEkWqCV6qK
	 Cn+dEpudRxPRhOxNHseO27gieASWaJ/O891MnSXPFPMJ9B1vJ9sLxxVLqbWSXElD31l/W
	 Ko6stZe1d5pjuN/rvkMiYxUlhVKFSdZva+ie+D+Dt+uYIuYD2550DWsvnill6ecg+uS+5
	 tk+YlHftSREL14NVwGnN3ZvFuemb4/Mw2P9hh3A3R6gv2vHh3wPeQSEI1yW2Tm3bAmDsJ
	 hTDBzuhd5687YcOio0WBMryENtgjDNNhK2hXgMWOpd0A7Ao4S2sn1fk0FKwK4f85KUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oXQWcHH/CZKGVxeytzIE2aob4M/ssk2SJ81UM1CxnHE=;
	b=uoK/+eqvOYQSqEpAGWaBiJJRAvMjB+bOtA3wcD/MO7pV9OQNuYYxDQlf1vUNi5JcnA/P
	 BXH78hAUfGitJjReYzefZYCEqFnoXndaItP1uhuAwyrNVF6MEO0iEgEGqj639+vlypEwY
	 ajXFV774po9KVUI0IHN7b5lrhL9z0Zp1WFHUSyX8rpDjwZWTQrdBobB8Wol9pB6x8PURN
	 vj302c4COD3SD9839N3eGlrx4A7cNQrx1od53gaivjPb6jY130S2mzLkOygTy925xaFDA
	 O/vSUZgQTKi84PYw2GuYptdBnEs1hlAKyFPStAvIu7wfLlR+QTLmf2R/7d1vVKPkUEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwjInL9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A663606A31C;
	Thu, 19 Nov 2026 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LwjInL9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB6B1F000C4;
	Thu, 19 Nov 2026 00:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046921;
	bh=oXQWcHH/CZKGVxeytzIE2aob4M/ssk2SJ81UM1CxnHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwjInL9GbGtBeiDfaTZZnXWzhiaR9bEYXiqD+Xu6d3kM4/YYBUyjvlGhnDwE+NjHi
	 XDJoEQBRl0Nwv5y8c35G/x+dUdPqmQHHilfNp4M+Lj3LubMfIWzyZUq5QjBJ/1edo+
	 5KOrr0DGNCeIU68rS+lEzLxPSv07JOvm+W/u762k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Jacob Chen <jacob-chen@iotwrt.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Michael Tretter <m.tretter@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1453/2857] media: rockchip: rga: fix clock cleanup
Date: Wed, 18 Nov 2026 15:41:27 +0100
Message-ID: <20261118150253.637208436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 254f3337ce2575bf94f1fb40cc40fdbc70371116 ]

Fix this smatch warning:

drivers/media/platform/rockchip/rga/rga.c:734 rga_enable_clocks() warn: 'rga->sclk' from clk_prepare_enable() not released on lines: 734.

The reason is that aclk should be disabled/unprepared before
sclk, instead of the other way around.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jacob Chen <jacob-chen@iotwrt.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Reviewed-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: a875c43dd95e ("media: rockchip: rga: quiesce IRQ before releasing m2m state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 9b20cef5afc61..4c4e8eabdbdbf 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -717,10 +717,10 @@ static int rga_enable_clocks(struct rockchip_rga *rga)
 
 	return 0;
 
-err_disable_sclk:
-	clk_disable_unprepare(rga->sclk);
 err_disable_aclk:
 	clk_disable_unprepare(rga->aclk);
+err_disable_sclk:
+	clk_disable_unprepare(rga->sclk);
 
 	return ret;
 }
-- 
2.53.0



