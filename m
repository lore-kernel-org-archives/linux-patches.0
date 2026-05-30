Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C29639478D;
	Sat, 30 May 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166432; cv=none; b=eApVQtDUgYqdZFAHZ8uc5VII8dBrkt5MnrAIfFJsgCdizInrhO2K255BltK5ee/9YOStGUWoFeyhiePIilHH2+OCrKNZfNC5OpO1iW2TLvb2WtcS+FdrNQd43LRGk07i2noMUIe7UXEobGWkP3l3JIDg3uRaE3tvtsLwtbZt25Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166432; c=relaxed/simple;
	bh=sGVYiqaUwNpoamOhicdoEGieCtkWe6WoWhtzuIhUvac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEKgJ1/PRp5/j12l+MA1HiNIW6102b0nHDsg45UtT9i9cVEpV+DIjhaNyPK/wuDsaUs59n6rSau5NN0VrsCgyPC9BVANy3fkFd/ZbYcCXM3Oq/t/m38axZ3vJO+Mq3ndI4K9AjYItQ9gx2EU6U/C5bJZHAZK7gPTgOvRAkx8SbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ts0EA2On; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ts0EA2On"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853761F00893;
	Sat, 30 May 2026 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166431;
	bh=1OzvCWyZ3Vf9o3YqieAsFx3qfUTVWv0dg6X9Djoy90Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ts0EA2On9qXUVfyc1B4Cj7hWWEAB0gL7Hmp6LfJoIJRWaVwfvx5sh9Fx2bYiUTSlZ
	 +zP/9dpliLprNMlI/+LVyiQNGBkETnJT18WXY5gfzAELpDVzB7grdhsncpbTXBWm/c
	 ln+fkqeTg7YHEve+UWXuD1uWvz2jRGUDcAdAjCII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 372/589] dmaengine: mxs-dma: Fix missing return value from of_dma_controller_register()
Date: Sat, 30 May 2026 18:04:13 +0200
Message-ID: <20260530160234.597069917@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit ab2bf6d4c0a0152907b18d25c1b118ea5ea779df ]

Propagate the return value of of_dma_controller_register() in probe()
instead of ignoring it.

Fixes: a580b8c5429a6 ("dmaengine: mxs-dma: add dma support for i.MX23/28")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260225-mxsdma-module-v3-2-8f798b13baa6@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mxs-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index dc147cc2436e9..5d34440b9e127 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -827,6 +827,7 @@ static int mxs_dma_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(mxs_dma->dma_device.dev,
 			"failed to register controller\n");
+		return ret;
 	}
 
 	dev_info(mxs_dma->dma_device.dev, "initialized\n");
-- 
2.53.0



