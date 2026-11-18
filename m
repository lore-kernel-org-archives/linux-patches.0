Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048342;
	b=NuHTTBYRCY15IB68f+fyZkrJwC6c46JVQRHhUv7x3WIj4D6o9GvD5tInMYiGFAmJvYek
	 yybzFyWXll4VZThVAuwPNTHqpdKch9ToDNlz1mfmqx7lG12d52niY8q0HymAo815TPNNO
	 pGysMRcS0BRtMbPiGgOzOy3KmAapsXXB6JHgcXjlZj3AhR5cJzQlRfQAP7PcIjqE0Ihlq
	 6T6rBLh8pXbjq81CZAHS718ufugI6v0auxA3elNbHJDwQR6VHk0SyktMnPMfZeG1yDN2F
	 35M9reUZGuZB7XvoMKuDz/qzk2FPjFMDwjsBlTFuCbBdiUi1z98AkbGnr4n9ARVez6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FkrwZGog1PxmsTwZqmMwhhazY18lYWDJEcH539jOQxM=;
	b=D5c0PMnztnj8IpcR8RFQWkmadhDm6wPZx1+5QMi9iKsQu3UvIDq9c7wSVDtGlvSHA9wK
	 Ppil3KPQ3nm5Xr58aSi0OZWfrqm8uCi7SaCsAjRFRQ2Oajk7ux6Cbj88PN9ANtRjfCg5R
	 s1eUTx+yOQ5SE+Gw/eftaY+zDsADtpKGhoQ/NNTO3OnwuirkSx/RoVQQUGO8pD9YcsGtA
	 1+gq7NjchylK9p4XOZmmdz2wC6WIMnQY1X75Nv4SbBFfnq/7RHYDlZp/RGc1S8lnWKoQd
	 uQofX/SE1rXn9EEKVklUB1aa3QC6bm70H052oW82araGhCpZJ77FuIz4Z3+U6Mn9UFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yb6JbKc3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD25606A320;
	Thu, 19 Nov 2026 00:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yb6JbKc3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5D61F000C4;
	Thu, 19 Nov 2026 00:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048342;
	bh=FkrwZGog1PxmsTwZqmMwhhazY18lYWDJEcH539jOQxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yb6JbKc3jioLS6mjEsE93c16/0cD4B0pBwBEXNnwFiZjnrH2rxvuqAb4W0802WVWg
	 k7jPfG5dbfSGd+R4Bztm9mcWQ+q2jK5iTl0dIs+c7EiclIiOPGLYrEsvT5g66edJj2
	 2csXzTJWPwleR7y0dpLV2k8DlTEn2F1vYAlP87Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1961/2857] ata: sata_dwc_460ex: Dont enable interrupt if libATA core registration fails
Date: Wed, 18 Nov 2026 15:49:55 +0100
Message-ID: <20261118150312.012567136@linuxfoundation.org>
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
index d3b8bbeef363e..342e08c8fb221 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1198,11 +1198,14 @@ static int sata_dwc_probe(struct platform_device *ofdev)
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



