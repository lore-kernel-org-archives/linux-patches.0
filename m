Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029601;
	b=ogBO8KHBYD7ZrY/WLT1fT05IwbXgHyFj6Hp+gFYA/BCtxTx0fdDnF2D2EfC5a7nFaUMA
	 smv0zN9vPEkNhI56dfqv+c5OEwSpTm8DZJh38zH2EL641nX7TGvZMx7wcUEUNcP+8XCjh
	 WhfjjalBq5r8WFmKdL7HDbU9Tqm8zlOExF6DqsvHTwAY40aLbOLvwVa/gHXnx4vlWlKVG
	 o5/v1qGOBofyy9tSjBauy4Qo/dkWKSVs5iEZGwgGYxlp9K3nbWp3p7y5yF0Go4RtU50MJ
	 Zoo6d+q7rmS658h0ib2Z7l0q6MB73dwX3fJTe/vKmyj2vYeVo0WDSoFgs+67v3Jxj+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qVvk3y6wKbOLASXJEWn9TeGcl5+BtKDe5WCu12q331I=;
	b=ZEfXgefh84noHFm+r6tJytkY6reOp5nDV1EeTIdY3ZSyquF0TlHukkVmTtk12RcG98Fm
	 vlh+Ub2zl+x+KT6VocDB6hafW0njaXBgNYjxcHwCTnV+VHqgmRwSHN7TWtjJpr4ZTzp5y
	 cKKqMrTY8vXm2ED7jC9ls3aDXqa9V845JI3zpIBAbNYqFdneXT+7Tyt8piUfcLGk0hn0g
	 7u7QSCGxn6cnXPf/cTMgZLR3qZnUpT+WGwOEmQr19U5/12O1yo4XaQqhP+r0M8/HbSzwX
	 JEdWPsXSQoGJ5NxMLIftvAkV6cs0qro1uRIj4HpTiEyvq4b9qx5bVAN7jAIRJTtohsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOEpTy63;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF22606A330;
	Wed, 18 Nov 2026 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOEpTy63
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34691F000C4;
	Wed, 18 Nov 2026 19:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029601;
	bh=qVvk3y6wKbOLASXJEWn9TeGcl5+BtKDe5WCu12q331I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOEpTy63TuMMK1o33S1Av244sG3691Fg/gJc9oT8+8jgrLKvDknDFolQKmoUAFzAM
	 WHIuVYkpriJn1E0yycIBOauXjWNLhvExWHY6zv6v6pHvDXdNimqyTIx6LT47NH4dcW
	 vgS5uLImQAdeMaVlck06yRTj58VmUSIDnf/Lv94E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0407/1756] firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
Date: Wed, 18 Nov 2026 15:42:14 +0100
Message-ID: <20261118150024.965621713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit e3631d0242842940f9e902afaea98202e56277e8 ]

If kasprintf() fails while setting up mailbox channels, already
requested channels from earlier iterations were never freed. Route
the failure through the existing cleanup path.

Fixes: ffbf23d50353 ("firmware: imx: Add DSP IPC protocol interface")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-dsp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/imx-dsp.c b/drivers/firmware/imx/imx-dsp.c
index 01c8ef14eaec3..41d1d6153923b 100644
--- a/drivers/firmware/imx/imx-dsp.c
+++ b/drivers/firmware/imx/imx-dsp.c
@@ -99,8 +99,10 @@ static int imx_dsp_setup_channels(struct imx_dsp_ipc *dsp_ipc)
 		else
 			chan_name = kasprintf(GFP_KERNEL, "rxdb%d", i - 2);
 
-		if (!chan_name)
-			return -ENOMEM;
+		if (!chan_name) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		dsp_chan = &dsp_ipc->chans[i];
 		dsp_chan->name = chan_name;
-- 
2.53.0



