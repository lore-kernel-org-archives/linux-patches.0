Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215916;
	b=IOEAQe2xVHfVfrDjDX3HTkzK7sV4ELrQi6NH5FCK48SqyrCVJ0PewupppDi/UGleGzhc
	 s+O+hN1c9q4pihlNK8iH7omB173wvjrLeYzMkZDvokQzrNRVSCmkU2ejKmwmgKCRQq4yb
	 rW42JRZdFyvk6+z6iMOMp2N7BWITy1tYB2oAGMZCkZMYWlnwD/hBTQNVKLPBRZR0FtqL3
	 5dwa0X6VeN/B3q4SDFDuFwaf3STkYh2uSbxZy1J7DpAYhzCkSXRQskG5YPuy7E43NGEl/
	 XdKSmHqXGLyAS2v05uNcZgZjNCyu010inC0NLmskTAojkrc2l2/8xIrGA22us4b3l4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zND+P4XtiOlixZihv9rBaeiykwTxI2ve97Bq4QThNc8=;
	b=honBDp2C1XtpCPPcJxjFuMs0z2vpRThHcrHy6o5EDrsGqqmvs/J56AIqeyPdtZ0rzc4+
	 MchLx95V93zBiBOvw0CozZfsf1Y8HCGJO+w53i4tJq797KfmcHQ0w4cP3ELvxBWjWphq6
	 KcPN7rKlULGdaIG8iFocF030u/MUJtNJMn/e5V/3YtnCAYGXQsUOvR8SPq9qptL8ArFEJ
	 cILIvSGb0KKZl7aQu4nLRpbQ2hps+vFnmGximcK34Cd4mz4YfKP3LdX5oAgoKLOGhp+CZ
	 lncbMR0xzuK79jTrCv7hN6/sQ6xCemk/ihKnn4KZc2IoJDJOy9MWXLOCPh3X9yJdeJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNS8v8pj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5EE606A31E;
	Wed, 28 Oct 2026 19:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eNS8v8pj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8371F01825;
	Wed, 28 Oct 2026 19:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215916;
	bh=zND+P4XtiOlixZihv9rBaeiykwTxI2ve97Bq4QThNc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNS8v8pjKF1wwCLAyTi1cHT7Mtg7O/W/nwP51WYfQlJPN4m0fzVrhYQeVpu8eIuDO
	 8RflBm8t5a2fJ0CWNZEFf2spn6nNtHT/n7HwRvTPH/x5EM+nL3fwkdHempJSc30HXT
	 yGQ5VNMg+iadCEHVgKPJ2cz4b/7Am8wZquvVKM1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francis De Brabandere <francisdb@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1378/1887] platform/x86/amd/pmc: Propagate SMU errors and validate S2D address
Date: Wed, 28 Oct 2026 17:57:54 +0100
Message-ID: <20261028170530.806118689@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 0225c1d637687b03726f00ac65b6def843d2c464 ]

amd_stb_s2d_init() discards the return value of several S2D SMU commands.
When the SMU refuses a command (e.g. "SMU cmd failed. err: 0xff") the
failure is only noticed indirectly - if at all - and reported as -EIO,
masking the real error.

More seriously, the S2D_PHYS_ADDR_LOW/HIGH return values are ignored, so
on failure phys_addr_low/hi are left uninitialised and the assembled
address is passed straight to devm_ioremap().  When the SMU leaves them at
zero this maps physical address 0 and trips the ioremap-on-RAM warning:

  amd_pmc AMDI000B:00: SMU cmd failed. err: 0xff
  ioremap on RAM at 0x0000000000000000 - 0x0000000000ffffff
  WARNING: CPU: 13 PID: 4592 at arch/x86/mm/ioremap.c:...

Check the return value of each SMU command and propagate it, and reject a
zero physical address before calling devm_ioremap().

Reported-by: Francis De Brabandere <francisdb@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221759
Tested-by: Francis De Brabandere <francisdb@gmail.com>
Fixes: 3d7d407dfb05 ("platform/x86: amd-pmc: Add support for AMD Spill to DRAM STB feature")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260721181756.143084-4-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 8eaeb1e8f9753..8eb5ddeca0d46 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -872,21 +872,31 @@ static int amd_pmc_s2d_init(struct amd_pmc_dev *dev)
 	u32 phys_addr_low, phys_addr_hi;
 	u64 stb_phys_addr;
 	u32 size = 0;
+	int ret;
 
 	/* Spill to DRAM feature uses separate SMU message port */
 	dev->msg_port = 1;
 
-	amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, STB_SPILL_TO_DRAM, 1);
-	if (size != S2D_TELEMETRY_BYTES_MAX)
-		return -EIO;
+	ret = amd_pmc_send_cmd(dev, S2D_TELEMETRY_SIZE, &size, STB_SPILL_TO_DRAM, 1);
+	if (ret)
+		goto out;
+	if (size != S2D_TELEMETRY_BYTES_MAX) {
+		ret = -EIO;
+		goto out;
+	}
 
 	/* Get STB DRAM address */
-	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low, STB_SPILL_TO_DRAM, 1);
-	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi, STB_SPILL_TO_DRAM, 1);
+	ret = amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low, STB_SPILL_TO_DRAM, 1);
+	if (ret)
+		goto out;
+	ret = amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi, STB_SPILL_TO_DRAM, 1);
+	if (ret)
+		goto out;
 
 	if (!phys_addr_hi && !phys_addr_low) {
 		dev_err(dev->dev, "STB is not enabled on the system; disable enable_stb or contact system vendor\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	stb_phys_addr = ((u64)phys_addr_hi << 32 | phys_addr_low);
@@ -899,6 +909,10 @@ static int amd_pmc_s2d_init(struct amd_pmc_dev *dev)
 		return -ENOMEM;
 
 	return 0;
+
+out:
+	dev->msg_port = 0;
+	return ret;
 }
 
 #ifdef CONFIG_SUSPEND
-- 
2.53.0



