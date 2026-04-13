Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDDA24DCF6;
	Mon, 13 Apr 2026 16:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096457; cv=none; b=dC1wmO5/YGuVsURIUfo26s+gRlqY/ZB7igIEXHY7y3J0mvccTSrGgC0qmBD9G9EqBI6LIu+zKKIsPONjJUdTJSEXX6fOu93flL4KyhqXAo/gSuMjfIQ6BIBieBxEz3+7NASuyUNNPOc6wBugjSrGyQdy8GsWEGxhcHmGRkT10d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096457; c=relaxed/simple;
	bh=N2yf5YF4QISnOLAAH88fIJTUux5kcNB8eZiJTEHoh4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZpB/p5aqA0XK9dl+RQNZu70LcV5tszwwwM3a54Kqn/i9nhZqEJjDx/G0InuCj5E5ShjTmRvnmothjHle4wvtPLyi6XR7WJq92fbU8+n3IvhEpvG5EvcXPBCjVzH5CL0y0Q6nZnDEopZTEdI05ROujDFN68578fmAhKGH2TNwf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLhtG/p7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLhtG/p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F8FC2BCB0;
	Mon, 13 Apr 2026 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096457;
	bh=N2yf5YF4QISnOLAAH88fIJTUux5kcNB8eZiJTEHoh4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLhtG/p7QPMmJWuc9FsgqY6iZOocLQYNCv8UJ/P/Pty8HbvO1uBDhXQna4cBPR81y
	 SJDIBR0BymAHiRu/XZ3nqsVErAtz8ar88SrBLKuokRRFSOYDW73aEsTqnaPew10u1W
	 ERdembC0nNIPWmGFcJOo1QCkSoQJl9i8m4f+kg48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Pighin <anthony.pighin@nokia.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 19/83] i2c: imx: zero-initialize dma_slave_config for eDMA
Date: Mon, 13 Apr 2026 17:59:47 +0200
Message-ID: <20260413155731.742435084@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Pighin <anthony.pighin@nokia.com>

commit 39ed7d89b973329cc5c764b65ba6302b17b1907e upstream.

commit 66d88e16f204 ("dmaengine: fsl-edma: read/write multiple registers
in cyclic transactions") causes fsl_edma_fill_tcd() to read
dst_port_window_size and src_port_window_size when building transfer
control descriptors.

Initialize the structure so unset fields are explicitly zero.

Fixes: 66d88e16f204 ("dmaengine: fsl-edma: read/write multiple registers in cyclic transactions")
Signed-off-by: Anthony Pighin <anthony.pighin@nokia.com>
Cc: <stable@vger.kernel.org> # v6.14+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260331182632.888110-1-anthony.pighin@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -401,7 +401,7 @@ static void i2c_imx_reset_regs(struct im
 static int i2c_imx_dma_request(struct imx_i2c_struct *i2c_imx, dma_addr_t phy_addr)
 {
 	struct imx_i2c_dma *dma;
-	struct dma_slave_config dma_sconfig;
+	struct dma_slave_config dma_sconfig = {};
 	struct device *dev = i2c_imx->adapter.dev.parent;
 	int ret;
 


