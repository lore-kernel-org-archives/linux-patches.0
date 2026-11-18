Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016489;
	b=Jkju4iWc1hOx7fo4X8LLvq9VmhZv9x8Fr4lERGMGk4Y+YCQzom4AEN2qw5LUde9/jUVQ
	 sg3yoCx0l+H/ccXNEg6TPv84MCd5mrlAcWOBmCeotvWAGNuHNQUCnqK0KmncuPs0IRmVH
	 wqM2hFn4/3lpOvolwU5t//tCau7ie1fjQ2Pjn0D+4GKvAtY6BTnU+atgme/xLmc160A8A
	 m+ClaOx8/oZzEfNnRnrm0ms5HVYtu4v7HjSEsmuwQ4qpMz0Q031lNwF6bIADS/uZs5+uN
	 UMP6pCr0IuIUNMrxNNKpSZHvABuCX8JzH4zCngGcrh+DqgNFptFR7psCY3iVdUw+CUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CKN3dAvzffPkWiE/mvglSSAeLGB64KuvA7yrfnVMeoY=;
	b=noz4NMP3HhAR8MnQwTg4ldkZ1cxib8t49o7PGOrfYvZ1g2zFVzwugDlLpAJcGmz3uNfA
	 L/IU3OKG7oFZQd5+IPl21Dnjmq8qVInvHYNJF5JpjXvF1mdYsBvNNGtCead/oKvtFbotC
	 qnM/1FkZi3/CBQ6nGk+Ot1lKP2gKdBtO+fWZUyTOfp0jne8OiDiqNAXqHIT1EDgfKPFdX
	 ok2X4jT4W6wo7rWPDJu3FNKKdFrnh7vsLmdHpYIQcEfniA1TjOKzRGRKpTc9Gzrt2bsN3
	 kaVqjRkM6Wk6AwHyMn45bUQlGmIMHmX9FOztQjlp3CZv2/Yisjd7gBLbUKdyjX1P+6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvdHeCTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029AE606A31C;
	Wed, 18 Nov 2026 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mvdHeCTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BDD1F000C4;
	Wed, 18 Nov 2026 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016488;
	bh=CKN3dAvzffPkWiE/mvglSSAeLGB64KuvA7yrfnVMeoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvdHeCTHfCuforQW7FFvpA7pE+QwDqukJC5zZI6rTddR4s2/01z/Zj5VUfazXgmZA
	 M6iuz9GYOdk8WwbqBfDJFNRB4vxHawM9Gg7VYuLesf6uEnE+gVYrp7JfKkgQB1HS+n
	 XXO+C1OEatxLUX5XN0jkf6eQ+MPk5Tjz+2HpcZnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0546/2651] ata: sata_dwc_460ex: Dont enable interrupt if libATA core registration fails
Date: Wed, 18 Nov 2026 15:29:46 +0100
Message-ID: <20261118150307.403701278@linuxfoundation.org>
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
index 8e3fc713891af..aa816a1a4c541 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1185,11 +1185,14 @@ static int sata_dwc_probe(struct platform_device *ofdev)
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



