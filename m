Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619379;
	b=DBdLKMumrn6x6Jj3fiIYpTv8+YdHGUVE3AY7QPLEpz36UK07xgwNgmsjeT7MlO+ne0sB
	 uCDEE5LbcmQ/Rao5iVxOVO+JkgYCgX+Uz1N+nu72sFWH9thNLvv1bEDhup4V3cNiN8eil
	 bF4PaVMrw2LbjURoPwbB1XSlVCgTjRZTNVVNyS7wAgRv1HbGF7e6dx+BgeLkYWwBcTV8O
	 SLtYfZsbmOSDPZeSmZfkSROiRMclSPswHJBwVbJC2pIRnLAA6rts5cnluGOsTTgttNGCi
	 7vBzttKwnL4PD3m/L4+z76PSKXbXC6HZgDLY99r/KIlXfV6+VNODz8a1FWNd/RS+O/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5H97xj4+3oMbkVnDCimJDqHo4Bzcm3YhN9t/wM7cYaA=;
	b=MOW5iKlnNNptFdiEficqXWB2bH44+oqckcpE7WLyQqj7C9tiqNYUQr1e2HW2RFnLfzI0
	 9a2ED1C4s3pgNxcnZ7WOjSJC8uKEus1z9Y/N8uYWNMEr6NnPvFJaDOuzWaP1YhehwsWGq
	 qbqvj3to4XuLG7z6tp1pHzmhxKlwTR9pH0vJC6XvxLRkWzdxq+81InOfw89q+J32iMm4X
	 3Almaf1njQOHB8y3yaJVpXikN4ighSv5dzb3H+3yIvUvq2iZABQysg3NY0xTTIhRsU9d7
	 5cOyEQ4KykLA8akRxrhya3Q9mEBQKFPvHshrqqoFUmTb3bwhwjwYOjHPrpc7YjWlVpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juqiBabf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E24F606A31E;
	Wed, 25 Nov 2026 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juqiBabf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5487E1F000C6;
	Wed, 25 Nov 2026 15:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619378;
	bh=5H97xj4+3oMbkVnDCimJDqHo4Bzcm3YhN9t/wM7cYaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juqiBabfVgp0If/j27fdLumz8PHmyKWQyDsAYKoYYPk+cGkFE4Ez58rcj/yktQ1Rp
	 8QEWJHihKUbmSqoXBERJtSCzcGUZmH9jmNP9LOqKg3G9yt2A3ep7LXNu6XsnrC8X/X
	 oDII3GcuBn0siz4rz3H8OyZMAjmYcLnN/xtkr+cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0577/1005] mmc: sdhci-brcmstb: dont log an error for missing BOOT registers
Date: Wed, 25 Nov 2026 15:31:55 +0100
Message-ID: <20261125143835.264526752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit cf4a8d8b82db7f8e88e6ef4f3020a72860a9c440 upstream.

The BOOT register range is optional: the probe function ignores a
failure to map it and the suspend/resume code checks for NULL. It is
mapped with devm_platform_get_and_ioremap_resource(), though, which
calls dev_err_probe() when the resource does not exist. Every
non-removable host without a third reg entry therefore logs an error
at probe time and then works normally.

The binding only describes the "host" and "cfg" ranges, so this is the
case for the in-tree users. On the Raspberry Pi 5 family (BCM2712),
where the SDIO host of the Wi-Fi module is non-removable, each boot
prints:

  sdhci-brcmstb 1001100000.mmc: error -EINVAL: invalid resource (null)

Look the resource up with platform_get_resource() first and map it only
when it is present. Hosts that do have the range are mapped by the same
two calls as before.

Fixes: b7e614802e3f ("mmc: sdhci-brcmstb: save and restore registers during PM")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Gregor Herburger <gregor.herburger@linutronix.de>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Kamal Dasu <kamal.dasu@broadcom.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-brcmstb.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -491,6 +491,7 @@ static int sdhci_brcmstb_probe(struct pl
 	struct sdhci_brcmstb_priv *priv;
 	u32 actual_clock_mhz;
 	struct sdhci_host *host;
+	struct resource *boot_res;
 	struct clk *clk;
 	struct clk *base_clk = NULL;
 	int res;
@@ -534,9 +535,13 @@ static int sdhci_brcmstb_probe(struct pl
 
 	/* map non-standard BOOT registers if present */
 	if (host->mmc->caps & MMC_CAP_NONREMOVABLE) {
-		priv->boot_regs = devm_platform_get_and_ioremap_resource(pdev, 2, NULL);
-		if (IS_ERR(priv->boot_regs))
-			priv->boot_regs = NULL;
+		boot_res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+		if (boot_res) {
+			priv->boot_regs = devm_ioremap_resource(&pdev->dev,
+								boot_res);
+			if (IS_ERR(priv->boot_regs))
+				priv->boot_regs = NULL;
+		}
 	}
 
 	/*


