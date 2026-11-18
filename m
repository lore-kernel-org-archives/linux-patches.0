Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039851;
	b=pkw6w2O5C9MncbeoTbRVNsr2GK090xQPfSQbQJiTYFCpRb2Y+NUvZVJ8OHWfCC1uZ1re
	 en1R6dvXtqBQT81uDBmucbBh/pFXppAPV1Wg2n74JDD83ZcJOnQV3prT242P9Wbbw+tW3
	 lOPPRJlK9Waoalq8P2cNiWhfjiie4joS9NJEzzIkLZROe0llmTIK2GiD5DjZVbp8OD4fs
	 iV5GqbY7aRT6S5Q6ouk/S2MfGgP340tey3nmUIFtYbbf9ge7yeSe5BipaoKi3XSG4N1OE
	 jsUDtN+lVa0fUhs2Q3D+RUfYvL5CAl73niXhxkdw1WKTKqHlvmEQtI6jV+Z4lle4dfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lx+rlwNSxzWi/Z9I+9mXRXQgWcjZ2lDsb94yXPFdCUI=;
	b=XzmiBnnx0eXQki+/49VF9CTVgBjKvUsd7Pz7AMdy11sE1XhxRqc5ELeP8Y3RkoxsOgml
	 BRHY+0FOEtn+c9rFoWTobclvLaZ5Y0lDWp1+BYNwuKs+/UL4cP7YdGRCxPeErdaMA7LA3
	 vjuSUrNjIhSeYacbb8j2ZBAS5Epn80y1ePK/csTWIl4JjEfjvrj42af3y2yfGR5Y7Sxst
	 E/wxhoh6dCNpTSMNoN+t4kPPqmGhZhyNjn/+RlVQsZArwbymRgPk7pHvyrjXVXUxfxTc7
	 Lx4APMBsbCPcq22lz6nRmhpNhLYFEgOvEbWwLwzl6KmhGIdTw6EKmbBF6uIgnY5x+KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaJzZEtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CDC606A320;
	Wed, 18 Nov 2026 22:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gaJzZEtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52781F000C5;
	Wed, 18 Nov 2026 22:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039851;
	bh=Lx+rlwNSxzWi/Z9I+9mXRXQgWcjZ2lDsb94yXPFdCUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaJzZEtMCkPzsDLlV+yt9Chg9H0+QirWggJlsCH3SzuMq+vPFSpbb9QtVASirpp5D
	 CKK9lukYurUGO8pF8/5Z3uhAQOiaIA9bNmWeeEQzRHeCtTWp4Y7bv+al+9i+eoEHWe
	 YphMEEKTVRItstGu4qqb+Z1aFXncjs74KjdSGtNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2248/3318] ata: sata_dwc_460ex: Dont enable interrupt if libATA core registration fails
Date: Wed, 18 Nov 2026 15:47:50 +0100
Message-ID: <20261118150429.277833924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 66db8dd8ec267..73c1c499c258b 100644
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



