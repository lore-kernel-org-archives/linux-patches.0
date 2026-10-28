Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212229;
	b=0SOv3xo4KfqXr7O5gaoWUZ0uOft7nK92f70sZN4uj2nGrDkdzC4PU+qs6mPlChMBgbF2
	 qg2+hczb88AShI9HG+YRs9tHm+dqgyFOa6AuIYRmJtgioePb4WK8fwU2mO+JwdJEA5i3L
	 qhwJLupLubiMGfboubm0GwTzULZBfGnEgmjplHvPrHUMTJQmo4glo6cLbWollQXwewrj4
	 usuOqSGOLfSJD75B/Jd0mL8E/4tD8ERkU6Jof0WNiOjzv8+l0tLFgS2AGlpGnzK2TZiEH
	 f2ylIAuAodXviqlMh+r5bA6yGjG/yYAaMNMzloNMw7jju/IqCMAEwTlNLtHMh1Klf0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6NUfJu0E7rBN2USqyqC7a1418A1hOrImQ4XbNtg/kA4=;
	b=3sbfHiaWDk5khcNIb3ULxNoLZA6Th5cqyLGiMWXj1tnGAyV7XfeLlZ0hOrm0pVP231BT
	 0cqYSV7YFVNXluXbPZuPc5CYZMDDZHq4zD5NH4EgVz3yppYLHwJmjjNMvVo8e+4yKpCcb
	 yPCKn+7I/Avpe0yicR+gk2x7D50duRRezwQpeCl/gZHpWhdl6HWdRmvqRDHHjgglu9Mc5
	 VR/W2QyAxOFGqPtF7rPpi+rLJAv1mqzd3PuuPMhdhBpHdEnDG4EPXhoLAKKhXhQBugpnt
	 yKjEpwwTrPuhXYd1CLQtrz9C8wvxHn3Mu+uFTrPBHMmhTGvnQekia4vx0jqRHA3Xb+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVjD29H8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9CA606A31A;
	Wed, 28 Oct 2026 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVjD29H8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC031F01825;
	Wed, 28 Oct 2026 18:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212229;
	bh=6NUfJu0E7rBN2USqyqC7a1418A1hOrImQ4XbNtg/kA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVjD29H8wdxcY/mDHnKyuHgAgApMw2WVAiIyl2MEE/7HR54klGOzYU/j5Ey3h3YgI
	 W1xpl3w13nQVq8ELhxcal+f431KwaB848OBCzxwcSh6kvy9ILAiOCMsn6qtl1k1SkB
	 BxtSvX9+GjBlVWkwt/j47MePHxbu+VAcWMBr3PmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0083/1887] i2c: mxs: fix DMA channel leak on probe error
Date: Wed, 28 Oct 2026 17:36:19 +0100
Message-ID: <20261028170501.124019426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 777979e627115734052b323d2721cdb500e81dcf ]

mxs_i2c_probe() requests an exclusive DMA channel before resetting the
controller and registering the I2C adapter. If either later operation
fails, probe returns without releasing the channel because the remove
callback is not invoked after a failed probe.

Use devm_dma_request_chan() so the device core releases the channel on
probe failure and driver detach. Remove the manual release from the
remove callback because the channel is now device-managed.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 62885f59a261 ("MXS: Implement DMA support into mxs-i2c")
Assisted-by: unnamed:claude-opus-4.8 typestate
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: <stable@vger.kernel.org> # v3.7+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260815151720.3757460-1-ruoyuw560@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index e0f3b3545cfe4..d792bcc11a895 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -832,7 +832,7 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	}
 
 	/* Setup the DMA */
-	i2c->dmach = dma_request_chan(dev, "rx-tx");
+	i2c->dmach = devm_dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
 		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
 				     "Failed to request dma\n");
@@ -870,9 +870,6 @@ static int mxs_i2c_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&i2c->adapter);
 
-	if (i2c->dmach)
-		dma_release_channel(i2c->dmach);
-
 	writel(MXS_I2C_CTRL0_SFTRST, i2c->regs + MXS_I2C_CTRL0_SET);
 
 	return 0;
-- 
2.53.0



