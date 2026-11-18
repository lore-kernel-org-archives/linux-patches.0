Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029715;
	b=XLpz4VhXJQ4MfwKgxmtRjcHAzgVrtaB3WVgp0oiFVxKq0T8vEg44fYG2cXFJCLWP0l18
	 bvLPuSRv75HF4glq+9EWg728diQfX3pq8Zlv+wdleOdzhJ00qAChhoDBdjNcxVcihSETH
	 IeADzemoqvBMe659wXpOxEKRAN/KscVAI8Z+sghfHFWMiD4TO3cAorrBTHTzqP3yhiBne
	 Vae3jE7Agb6/mephx7GUPTwFDsauu0OxT5rWCls69Erg0W61p8NTnbpvrLG1H51YPRUtP
	 Q05x4BFOTqmwZrWryHR1voEOJWmAPkdjy1fWZms+ZPHuc4X8iJdXtFKBWZX9M59gSFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cw+ZMIyKq83EvVQSgO+CUvPOc7iD09oqjjp1iF6Zm9o=;
	b=RyJFWgfVFBKimVQUsSIQ/GoWBvFthZK10HwY/dd4BVtCTiayaPYx7FMka07lPaP6Fw1K
	 sMD2wAiMI/k7Ds6cMkqFxuULoN0c1H/VDRGrhHFcXDe/tXKE+07YNuvz/kej3nUITwbhS
	 sHGNPpjPabUP0LidoS6wWenbvgfFc/+IInEe4cCJmSI1HDuZJtZdfeCLemNenb4mEt3j+
	 PtPcGlVLEB84tAE8Dtdi/hHe5hAttfLGFii88dJkrgyPT1I84jo37SD3hR/4X4M1xsYbJ
	 ezYXpqQubj1gN0+kV1FEkajsohSqSSaJJFKxVLNfXqfQnhNAOXE3YsuuUofzBoH1IFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URx1swv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A775606A32F;
	Wed, 18 Nov 2026 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URx1swv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622E71F000C4;
	Wed, 18 Nov 2026 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029714;
	bh=Cw+ZMIyKq83EvVQSgO+CUvPOc7iD09oqjjp1iF6Zm9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URx1swv5QpMGiYugx3Stcd+zjUyLwq9Dz48GJIhCCx1fDHT6Uuy1+mtxoWH/Ux88Z
	 h62ytwz9notVQrUPnHzRcf+QVP+aUGAdLK8r3O+Ix5irqh2w+k+UxiVtovgCQIlzGD
	 3XYsNun8h7l3XqSOXp32WTscaayeIi8XDjaDeHDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0448/1756] ata: sata_dwc_460ex: Dont enable interrupt if libATA core registration fails
Date: Wed, 18 Nov 2026 15:42:55 +0100
Message-ID: <20261118150026.637700072@linuxfoundation.org>
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

From: Nikolay Borisov <nik.borisov@suse.com>

[ Upstream commit e137035fcd66cb454c479bb989968561bbc60341 ]

Recent 4bbc16a353a9 commit changed the timing when interrupts are
enabled. However it didn't account for the libATA registration step. So
it's possible that interrupts are enabled when the device is not
registered with libATA core.

Resolve the issue by failing the entire registration process in case of
failure to register with libATA.

Fixes: 4bbc16a353a9 ("ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered")
Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/20260917150707.1643330-1-nik.borisov@suse.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 23753c4ae1b56..b3fbb9f54a9c4 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1184,11 +1184,14 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	 * error_handler() to execute a dummy Softreset EH session
 	 */
 	err = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
-	if (err)
+	if (err) {
 		dev_err(dev, "failed to activate host");
+		goto error_out;
+	}
 
 	/* Enable SATA Interrupts */
 	sata_dwc_enable_interrupts(hsdev);
+
 	return 0;
 
 error_out:
-- 
2.53.0



