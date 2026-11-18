Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023648;
	b=vD4oy1rJTqKH/qvBpHyhswC3RYds+vQSCrglvAwf3cWKx+p+2HjuI9cyGxkdUJLcwLnE
	 oCULtQHhXaHMsC7yfmHkcciVWRHJ6aTGmX2A+cjkiFV5yeV9hgweiU67CYe8R/2sKzT+N
	 Z1rKn55IvhH1q9uZGPzodlNVTLA2auScgnysrwpDY5TQiiZ35jM2b9ZuPs1B26Ui2OHr8
	 nK8UCtIgEaSaok4s4PAOW8Hd5LSjaDv9MEt2on0xSC35P3LANcvdvwL8bnoo3ww5uo/iX
	 diM5EjqDpI5YbZ6WG3sRAGU8tGRgzEKsAAlrvNK+bkJvfiKeH0VVt2UyDbcS4KKHazA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pejF1eZgjdzWnpAovbqNEq/AOWYN59QdlIg89N9HENA=;
	b=EV5cUNUIoYIYkPhzBxXvkfkEKeTzveqJ4ke75qbOzEULKILPtlsx8wFrRGkmBR5VdAxh
	 DUq5x1GFYBO82VlyKPIZHo+bRPpqI/xZPN/eKRjQtyjB1EoEybhdaWg85Q4WISRZrmwiG
	 ojgeHa7z9wXELIfcN7EAP9kgP+vlV8PTDdCYJopgWKlaARwbEyWActRrk7wD8Zi6axhJB
	 NWkT4FUIE27UxtTEwsEAAN2u13NWITIowKcy84+7Hfa9/rOyL6pyWQB8tTEIEHwVm1d1Z
	 L9xHCRF3GRxdBqQdPZ080bMhig8jT9ssTBH8fVveyZ7bnGRbqeTTWgDGbo9XAx/zlbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VXDRuICS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E96606A325;
	Wed, 18 Nov 2026 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VXDRuICS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB6E1F000C5;
	Wed, 18 Nov 2026 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023648;
	bh=pejF1eZgjdzWnpAovbqNEq/AOWYN59QdlIg89N9HENA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXDRuICSZP7s990WLrGXOZmi1oRuClwWAQBXthhAZpwlKVCXGqXEMebwt6akbAEyF
	 jFVRKHGEQ5opOMcbmoKjlKjzNnjsRwPWkWYa56VOvg2dptvzz+nriHN5uW+vVZClJi
	 6v5pCYkT+nxq7XBP4ufkiT7HOWclrBMwtuimNNJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0445/2151] firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
Date: Wed, 18 Nov 2026 15:36:20 +0100
Message-ID: <20261118150138.245190187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



