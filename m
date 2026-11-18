Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047264;
	b=HLKvvosSPz01+1hEEFECrDXORcK2l4FVbsyumHbKxwvYQeCeKrPXtot21eUjO0j7HKb8
	 828DjE1KG7lLLcjUT2NAgMYgJQohhCTnZGbz3e1mqfviW35mio6x1Zdk5E5x4Ub7wJhDz
	 vCOI/BIqJop3gmn3jrInk3M/WKqRqRtSV91bfdfQKXrWL5Wv1zZ8im+0OHpoo3TdpIoxW
	 /BFYtR3bnVe3r8YMDxTHfCFi6QzOFsujBONRPMvtCn7A6UOEIN4edWHS7TfZbFcand796
	 WoFdB9ZGR5zBUtv2IrV+Ym4UA5Elopz8gpvd42PpIWr7MCKe28TvZGLAwtI5wJmbdXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8g5c42nljkVWe3zZQJXci+93LxADBdQYInmPegWbk8Y=;
	b=Ltx/Zms4zBjDjzbE4Uko3nJWh5F2PJSarMGNiuh6EHmCqYT4E5iFaF9kKXV5+m5dhTTl
	 et0W3zi8UNB5Tq4Mpl1W/Mkr03JugBS//NXDzturTuqTKtp3m3Svst7Z16F4K197d6Tzd
	 00xKJycdE//thelFN7RetxyJGI2n/vWE3FV2558PrH623VpnSlMEqMw8CAams9UIUaIWP
	 E5t5XbVP+jBh2FddbW/X/IgUCEDGha4DSG6G62/nb//AvrWLrGhvdwGSU1Ffd6GrRxwTs
	 tWoeF5v17iSNXrasd4wrbu0GvzKarOX01g9euR0drprexuSOKwnbJeTjYZ5Wkiogs0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S+bOe0cK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B59606A320;
	Thu, 19 Nov 2026 00:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S+bOe0cK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD93A1F000C4;
	Thu, 19 Nov 2026 00:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047264;
	bh=8g5c42nljkVWe3zZQJXci+93LxADBdQYInmPegWbk8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+bOe0cK3Eax20knN95WuFO4gtgFYaFw3rAXtMnEdRnDa9hFaBKRmFN3s1VDrHf1A
	 vFCH6EJqOqfjm0kiBm4oLI40nh1V84QqdfsDwxOC0H3chuekzq1fECJsLOl9gb2MRU
	 xr4zK5JN8oGdmFHcDby3O5/xnmng/Z2i3c3srYnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1577/2857] crypto: omap-sham - fix crypto engine cleanup
Date: Wed, 18 Nov 2026 15:43:31 +0100
Message-ID: <20261118150258.160540374@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit be51ea091c6563158531e8c74e040552fdb1e28c ]

omap_sham_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ sashal: adjusted cleanup context to match the existing inline unregister loops and tasklet_kill() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index cbeda59c6b191..79c52f0b87ac6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2207,6 +2207,7 @@ static int omap_sham_remove(struct platform_device *pdev)
 					&dd->pdata->algs_info[i].algs_list[j]);
 			dd->pdata->algs_info[i].registered--;
 		}
+	crypto_engine_exit(dd->engine);
 	tasklet_kill(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



