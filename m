Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDAB415F25;
	Tue, 21 Jul 2026 19:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661012; cv=none; b=F3OeEpz165NY677YvVkKSQMTFFAh8Bbevni6xm/dod3pQjk9UX5EWPaZYKIuVPV/VS7TjafwXGsLklKNFOi5QKPHJVeMh+uuH7F122uTZSQuBgYocnF2Rd4ik9wpxSlk/k9RiZznjJzLWU3P6RfTfL99A0gMlIW0/AmP8p8Dlr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661012; c=relaxed/simple;
	bh=jCq8lfjrAn5SI00x4kMCyBjMH0aDQnBiYFdjDpJUwjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itxHsjRssz+tIXdAtmMBaeFrClDKGFOQLwHTEqLhhXw6BHBHBiGqKo9w6ijttVeoL3Bhlqzp6JGeXlwG577UJfTZ9IZWEE852wwYHKPLJ4pM3RNAokkm5HKEGnjcLnpttoZgu9rft+Taes6x/7IONg4yPaLR5JFkzHg7ZL0UQ34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qF+mH8Qc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF+mH8Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006451F000E9;
	Tue, 21 Jul 2026 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661010;
	bh=McyapHS5POn09wEAPsQ/9jn8pBBtA18TdizuJi8XlRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qF+mH8Qcm4dOBSFtJ8vuGhA+hHJ1MNvArOnMix2mHnaDLEr+TokEsq9MPzYp+/RnI
	 unePuYLUqGYl7CoZqJW8kbn9WgPTz2qkNDtr30aUVanpnmOQlod56lSRbHvLhW4dSp
	 TecUD0nUi2n2mqzMaSV9Rgdl0HyzW58eUIR1+2lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1155/2077] tpm_crb: Check ACPI_COMPANION() against NULL during probe
Date: Tue, 21 Jul 2026 17:13:48 +0200
Message-ID: <20260721152620.064306676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit ddd33806b8911fa2ef849e8bbbab1e3fcb26adc0 ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
tpm_crb driver.

Fixes: 48fe2cddc85c ("tpm_crb: Convert ACPI driver to a platform one")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/2848144.mvXUDI8C0e@rafael.j.wysocki
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_crb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 7d1377e8e616a1..ceb4100ba400f4 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -786,8 +786,8 @@ static int crb_map_pluton(struct device *dev, struct crb_priv *priv,
 static int crb_acpi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct acpi_device *device = ACPI_COMPANION(dev);
 	struct acpi_table_tpm2 *buf;
+	struct acpi_device *device;
 	struct crb_priv *priv;
 	struct tpm_chip *chip;
 	struct tpm2_crb_smc *crb_smc;
@@ -797,6 +797,10 @@ static int crb_acpi_probe(struct platform_device *pdev)
 	u32 sm;
 	int rc;
 
+	device = ACPI_COMPANION(dev);
+	if (!device)
+		return -ENODEV;
+
 	status = acpi_get_table(ACPI_SIG_TPM2, 1,
 				(struct acpi_table_header **) &buf);
 	if (ACPI_FAILURE(status) || buf->header.length < sizeof(*buf)) {
-- 
2.53.0



