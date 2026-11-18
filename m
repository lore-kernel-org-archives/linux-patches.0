Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031555;
	b=v17HGqPw/Rj4U7hDWFqrCkdd7of1ICF1nJizUcHRHqoUHbOggoyMFxNqEEZGLBn1z9CT
	 v3v3bhcv62ZJrALZJpoawjK1XY8625aYqq18GmXhOiIkd18WbJ7eemRsYRXN5ct/5gLT2
	 cYnvi+gyXaoNzVh7gg5M82MjN5VLncXdVqXHOqAzocu/hPeuah5DeHAiBZaTTLlFTh2ln
	 hlMtYDLQNZbWeQFyhhG3SklmGNuTQ718QUmJCRHybRLJEn0nyssaCpLnQGTo4GIyAvOhe
	 EPxZBG2iCk89JGcymyWc+KxFgeiP73m7HIOKdDdDhnCCY0f8R4tgakw1g7P8+QpPFUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nYzBNR4CpDpUn+mbc1P+O+qLf2gDmQ6vu8ohp2DPJqM=;
	b=t1aucdijgFXd1tmncMd/v7awkicqDPKAfhJcNaOT4//KkkeI3g04DZWaJB5BqpUcJMqu
	 fQHybGjAt4Kwv18cpYKBBLOgBc7v1aMGccd4ScfEZ8YdaocE9FHsVVr9oEJNCTgkR6vUJ
	 NZdSnEOEfDWYwAyPCfs3/VM4LMpO03KEq9r5dNc8ZFeyseQf6V+xA15hmMBYU691F+AXJ
	 LGQ33eGa7l4Te2Fait62DOgdjkBuf7KIC8FP6OcJc4zphfRTMULMxhELO9G8i5i2JerMe
	 FDfoxEOUqCzTzz19wM4dZSQqvxfXvx8PlzA6eAFSjypBQPGliquI9t6BASaatwaPB7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGYuYx1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1878606A320;
	Wed, 18 Nov 2026 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGYuYx1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D92F1F000C4;
	Wed, 18 Nov 2026 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031554;
	bh=nYzBNR4CpDpUn+mbc1P+O+qLf2gDmQ6vu8ohp2DPJqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGYuYx1WCn/D11L/zyz6UNi8QXauRYrTbFjyB1xglsWSwfQtRoKYUTXJ5w5O4xKEH
	 8QaDVNccgK2bLZc5oh034cMt1tGwVb9JPRqfQjVkP1lHOKYlypzVc4rsoqBD9USIn2
	 a1psqC8j91nn/5xC3SG918tSnaQ9QXeeHq7SZ4xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1097/1756] platform/x86/amd/pmc: Use managed APIs for mutex
Date: Wed, 18 Nov 2026 15:53:44 +0100
Message-ID: <20261118150053.882223056@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 6ad1b2dc0f2a76b23a31fc7a52ed4ec06e4344a3 ]

Adopt managed devm_* APIs for handling mutex creation and deletion,
facilitating automatic resource cleanup.

Co-developed-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20250305142615.410178-4-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: c9ba86f54117 ("platform/x86/amd/pmc: clear devm-managed pointers on remove to prevent stale reuse")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 821a2f4dc554a..a442d37ad828c 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -917,7 +917,9 @@ static int amd_pmc_probe(struct platform_device *pdev)
 		goto err_pci_dev_put;
 	}
 
-	mutex_init(&dev->lock);
+	err = devm_mutex_init(dev->dev, &dev->lock);
+	if (err)
+		return err;
 
 	/* Get num of IP blocks within the SoC */
 	amd_pmc_get_ip_info(dev);
@@ -960,7 +962,6 @@ static void amd_pmc_remove(struct platform_device *pdev)
 	pci_dev_put(dev->rdev);
 	if (IS_ENABLED(CONFIG_AMD_MP2_STB))
 		amd_mp2_stb_deinit(dev);
-	mutex_destroy(&dev->lock);
 }
 
 static const struct acpi_device_id amd_pmc_acpi_ids[] = {
-- 
2.53.0



