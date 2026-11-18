Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055141;
	b=2yVnN9H0Vpvy2vWgk+kPry+Tp7Okj7Icd6AcXNJ/5aYiUZP6qRVwXoCzOo09L31Tk7HR
	 9OyaIN5y3gzXn5wGnKBTS+x3d6pAJNYffs4k7XFh+xZVqDLFZvxsqHPNjMKo3/XttKchI
	 nGklSHeRVXZGvffFRU0tldhJN9bYbtYD6kPshuug7iE2EzlX6kMwxHpDrPZFqHPVM3RnP
	 unCZsdl6Iei20MX/q/Kn/AwWOFkZgePOalXa7JHiYUPtPSm2Bqba7gvXP4IPyGginVSbc
	 DymCpNCeihrR7cf1GaIZC+JD/Ga9OiYhcAjLlENmSgUGhqrbF8BwBKCW+zaX0aQMAsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ptGSZBBMiYvFO61gKepU3VYo46QH7czaNO5i6thL720=;
	b=esX8rqke93l0O05hbKhDKSZ+PMQ6zGsxG7+nPVixxXwdrm5w4lNc8tgKMFPmlvC+kC6J
	 XwpUA8s28fZCKRqWIH2/SlhHfEJk24wn9zEXLtO+XDTHJEXyKLDM3ruORSZfFk/djS/tL
	 ULY/gfQZBrHyYGZugY7MHiAtQNjH+BMdW/y8Ui0YZ2VHcyFZxwFEut+IeaXKG7ieVfbX8
	 6q88MreXltq6IBGX1ORE01jderudCsy2tEbTK/20UBvuOLwquWshrobDgwA2rcQTMl7kR
	 eVUOcuHrZCrrOXYAey3JV2bqK0kGxQgzdM+mRcindkFW9L1OXGZn5hhnxcx2QEb+f1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irccnF+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2688606A31C;
	Thu, 19 Nov 2026 02:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=irccnF+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524451F000C5;
	Thu, 19 Nov 2026 02:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055140;
	bh=ptGSZBBMiYvFO61gKepU3VYo46QH7czaNO5i6thL720=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irccnF+Wp+CWCANmuBNErGHATG97OlarHCfOeDXFos77GDzNXseEmqI6bWJ3MzGXL
	 9loMdhm3jsqMcE8wL06HOpsewBx6YS3vHk/rV9K7H1yhomAqzMYR8qUlYils0H+tlK
	 K6mLYpdzLo0xiMqdHEnc7ecDRfLB1x+qR2rapG/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1525/2214] ata: sata_dwc_460ex: Dont enable interrupt if libATA core registration fails
Date: Wed, 18 Nov 2026 15:53:21 +0100
Message-ID: <20261118150113.193051811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 41a37a3dddb9e..e830a4158d0ec 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1275,11 +1275,14 @@ static int sata_dwc_probe(struct platform_device *ofdev)
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



