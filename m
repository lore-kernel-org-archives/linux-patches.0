Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016267;
	b=Cf65xwG3gJtl1+Xnc7UwRMxLB0zUhvzOzDoqtKXHeJiFdEKOTZKmVr+dhMOIWvMzhYJa
	 mRv0pRdgffXTexVahhiD46IqFGX+6fG02IkOXGGn0Y2Ze5yrBqBoBEO+Nzj5MaRFM1ytB
	 VdsblG7mxb8Jg7hmDAZv39kRT4WcJPEeOlB3Eb0tuzN4MidU8a5LqavvCpXilQgLeT2Xi
	 2SACAwZI4qnUvahkKS+PXhd7iv4OWk2V1z2FlkNthfg56ja+Ekxl0lOBV9X62gvYj1I12
	 ZVp+9CQybx/j3KNlr0e1m7lKrvinn/SmJt2+REzoK68dtu987V01Ks6DMWhmDPr6Iiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FLGYdZnG0M7MBFnWj9/A5vfsifQrCUbVg0AgheQ/cdk=;
	b=k5UEX4Dbs9EB4WFS7+5KP/EY+cBFEuZIGDwni3qy2/10eElN6oPOH8D1VsPC9oqf4UNJ
	 x9tP8EkSuOsF7F6PCNEW5UnoOZ5Lo3OkW43ygZwxKoJCzAcO17mSq+jeTtQp+YV4ED/Xx
	 Ona70X8nyO5/S82nDAN3JhnpfHH+T6W9ZY7/LCfKljHOmyuEb2DstsgnBJKmQkrdep5/p
	 dzDhRFsSLqTds3/E046Ig/6Erb8MRagIYa2mqL85D1I3QdvKpyyJNytAQS282dYt5mOZF
	 ouf0BTJmxo2aqFr1keR1C4oGhaROOTG9ZkU4jaihDBX6OhSl41z5ghfg6cgj4yv8LqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kk5hPhx7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52C760A3810;
	Wed, 18 Nov 2026 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kk5hPhx7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C283C1F000C6;
	Wed, 18 Nov 2026 15:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016267;
	bh=FLGYdZnG0M7MBFnWj9/A5vfsifQrCUbVg0AgheQ/cdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kk5hPhx7CRsjCASiwdRu3lXWTWnZ/M50uXuuVPM2wo17ueWuJatxDFC+VHS7j9vVc
	 ljwBkfkPxZTt4CriVe0t3GHcXYDRE1gUxNP4j9Q2/cZuC7YKIGCoQbDy6DSaFzHgZ3
	 IbxaZlobFu58UbR4lWswkC8K0JzFIgiNJjEK1aqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0466/2651] firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
Date: Wed, 18 Nov 2026 15:28:26 +0100
Message-ID: <20261118150304.573717378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ed79e823157af..7e3f45ddf0c18 100644
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



