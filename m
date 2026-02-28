Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE8D340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301137; cv=none; b=csYZkxRV5K0MQdn3s/VQlIKDtwRvo5NTyXO4wkSuTeDbM6beArNXhfwfUevv1UyPRVXlkb6BfBUXRQsg64t4ojliJ7BIAUOQlmJi/3/+GU6JJKm8U/UT6VU6Yeat8HxlpBSL0Eh8sH8yuJ9/wejfOdKQGPefau8FmwuUNxrtNbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301137; c=relaxed/simple;
	bh=mz3RJ5rgCVHrReDGadpyTqNtR9r3w3PV1eS+GmPEafk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8pM/QgfLTppTM5vmiwS+PfITnnBfHMRiYmbwlerS2irJnJ1jVBzAO3nPm6E+3Zc7gjvZz1AfkAI/S6on0VXxQfXxnSa9cih32/EWv2HCOOxlgZ9WE4sE95uKRNDpe+ibqsHI6hAXur8xYRy4RNWw5s4kUMlZYcY113n9fxOpSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMDFR+1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMDFR+1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9058FC19425;
	Sat, 28 Feb 2026 17:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301137;
	bh=mz3RJ5rgCVHrReDGadpyTqNtR9r3w3PV1eS+GmPEafk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMDFR+1kwg/BJ/uadOE3FdHWI2LUk0ckGuxcpWBAVABGhLOhkKUxL2z8kE7yhy2n0
	 iIUrM2VdDa/2F9MMrkYbhvNgHKH5r2I3i0+eAi2Z/pWjLfF0EqxXkjHI3gItJLSjEg
	 /KK3PfNcQL6iFgXcJ4/8nxuq4CRhugdEJ04hGPKs6qbE2sJD1U6Mf/Qlr5hVDKdJvA
	 G3+rf4VjMY1xYESjWBT4dp/XNd/6lR5LOeK/yTSm9Ep9ZYOtU94GLaHOdlpBFUxMs8
	 M+iQCHxU2Bg7jJ6U4Pj2WVbvQEUC3nOVTRAem1T0s+Udw4Wo4TMLTgp2cxxIKi5YFT
	 cSiG1cKvbBPvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Carl Lee <carl.lee@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 297/752] nfc: nxp-nci: remove interrupt trigger type
Date: Sat, 28 Feb 2026 12:40:08 -0500
Message-ID: <20260228174750.1542406-297-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Carl Lee <carl.lee@amd.com>

[ Upstream commit 57be33f85e369ce9f69f61eaa34734e0d3bd47a7 ]

For NXP NCI devices (e.g. PN7150), the interrupt is level-triggered and
active high, not edge-triggered.

Using IRQF_TRIGGER_RISING in the driver can cause interrupts to fail
to trigger correctly.

Remove IRQF_TRIGGER_RISING and rely on the IRQ trigger type configured
via Device Tree.

Signed-off-by: Carl Lee <carl.lee@amd.com>
Link: https://patch.msgid.link/20260205-fc-nxp-nci-remove-interrupt-trigger-type-v2-1-79d2ed4a7e42@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 049662ffdf972..6a5ce8ff91f0b 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -305,7 +305,7 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
 
 	r = request_threaded_irq(client->irq, NULL,
 				 nxp_nci_i2c_irq_thread_fn,
-				 IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				 IRQF_ONESHOT,
 				 NXP_NCI_I2C_DRIVER_NAME, phy);
 	if (r < 0)
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-- 
2.51.0

