Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590993;
	b=CZ9daRpTyGGccQQqU9JlS+Qz8PjISdGhbvY1+ri92Mpa1KzexfMv/ZK2iPHZfjmulQwN
	 baLEgXA1wh+SQWyvIa4qx/0GWtXfkSYXvOdfuuywjtBhpiw9ZqlthGl7v1iUpQWQl+h8y
	 o/HxeUc9F8xEsZO3Gr/WBMm8OxLp6Kx1YhlKDOxvlqvKdf0gnAa1w9vObAGG2IKnMjNIH
	 NrG38puYnfvqLRxe7tHgcQypZasKaGPtYRjs5Y8CkPvCsPYiK8hFa0EOXh3MWvxq/tae+
	 W6O/C8xvmNnQlDb6jDhTjt2zR+J7jUyEP8Kmh4yKyUbQgsyduEK8s5XfMSS6hIXfgWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HeZ5fXyKLQjXdgdxYkjHPsJOIUKVvscNDYpbQv4ucx4=;
	b=sV1a3tazQH++Y1GaIHSOTZ4O+yfUh7kLOWJ0QxaoxWDV31Tx8HQG9uG67VgKtG4aH8pn
	 3QDThmLknHB8icK42wKv4fasG6K2M+fb8sX6GAJ1mNCFXOeHxRQMcdG0NXd407vzFCGFI
	 EQuT3BzJvwp130w5+iuu0rxS79v2/Xp/Ja4l6BY923dKry2kXGikwJAwU84oX1QXgbSkx
	 DagyDn4G2jLLYCMZFSzKACrgqeIUnoUt9iG/AtXau0j2ffIkilll3T6zofrVjfa4bn36m
	 lfALOdbwVCGvp8j97cZ+80CowTPgsD/Wsq6TmL2prx8wa5QPOgD/FJdxl/P3I8nYr/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ltt4LNN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E98960703F9;
	Fri, 13 Nov 2026 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ltt4LNN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6AE1F000C4;
	Fri, 13 Nov 2026 17:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590993;
	bh=HeZ5fXyKLQjXdgdxYkjHPsJOIUKVvscNDYpbQv4ucx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ltt4LNN0IY82anQfEizhggVrPca13YOJlTN/UUfRB0EaboPJxt82pK4b38UcuFhTk
	 WeRQNtCPpR6Q/CfJ7cBFcKWQ4cQDZUb0BPRrdZofjqKF/ImDK/bnMzhJvBkJ/S4cRr
	 m/0YcmW4CtVX2h1+WybcrTVhBYUbUkVoWm8KIKCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Noam D. Eliyahu" <noam.d.eliyahu@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/670] tg3: Invert restart quirk logic to restrict SNP power-down bypass
Date: Fri, 13 Nov 2026 10:45:31 -0500
Message-ID: <20261113153817.735614945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Noam D. Eliyahu <noam.d.eliyahu@gmail.com>

[ Upstream commit d7314b51341c037973ce022f12c6009fd07b021e ]

Commit 9fc3bc764334 ("tg3: power down device only on SYSTEM_POWER_OFF")
bypassed `tg3_power_down()` on system restarts to prevent reboot hangs and
NMIs on servers where NICs were initialized via SNP (such as Dell PowerEdge
R650 and R750).

However, skipping the power-down flow globally causes the ACPI _PTS method
to trigger fatal PCIe AER events and hangs on other models. Commit
e0efe83ed325 ("tg3: Disable tg3 PCIe AER on system reboot") attempted to
mitigate this by adding an AER-disable DMI quirk table. Maintaining a
growing list of models for a secondary symptom misses the root cause,
leaving systems like the PowerEdge T440 (sharing the BCM5720 NIC) exposed.

Fix this by inverting the quirk logic:
1. Restrict SNP power-down avoidance strictly to
   `tg3_restart_snp_quirk_table` for the specific systems requiring it
   (Dell PowerEdge R650 and R750).
2. Restore standard power-down behavior for all other systems, eliminating
   the separate AER-disable quirk table.

For systems affected by the original SNP restart issue, their shutdown flow
remains completely untouched.

Link: https://lore.kernel.org/netdev/20251221175050.14089-1-noam.d.eliyahu@gmail.com/T/#u
Fixes: 9fc3bc764334 ("tg3: power down device only on SYSTEM_POWER_OFF")
Fixes: e0efe83ed325 ("tg3: Disable tg3 PCIe AER on system reboot")
Cc: stable@vger.kernel.org
Signed-off-by: Noam D. Eliyahu <noam.d.eliyahu@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20261026220955.473247-1-noam.d.eliyahu@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 42 ++++++++---------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 7f143e388d420..190e7f622e7f8 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18170,41 +18170,17 @@ static int tg3_resume(struct device *device)
 
 static SIMPLE_DEV_PM_OPS(tg3_pm_ops, tg3_suspend, tg3_resume);
 
-/* Systems where ACPI _PTS (Prepare To Sleep) S5 will result in a fatal
- * PCIe AER event on the tg3 device if the tg3 device is not, or cannot
- * be, powered down.
+/* Systems where powering down a tg3 device on restarts triggers
+ * NMIs and fatal hangs during reboot if the network adapters were
+ * initialized under SNP.
  */
-static const struct dmi_system_id tg3_restart_aer_quirk_table[] = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R440"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R540"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R640"),
-		},
-	},
+static const struct dmi_system_id tg3_restart_snp_quirk_table[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R650"),
 		},
 	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge R740"),
-		},
-	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
@@ -18228,14 +18204,18 @@ static void tg3_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		dev_close(dev);
 
-	if (system_state == SYSTEM_POWER_OFF)
+	if (!dmi_first_match(tg3_restart_snp_quirk_table) ||
+	    system_state == SYSTEM_POWER_OFF) {
 		tg3_power_down(tp);
-	else if (system_state == SYSTEM_RESTART &&
-		 dmi_first_match(tg3_restart_aer_quirk_table) &&
+	} else if (system_state == SYSTEM_RESTART &&
 		 pdev->current_state != PCI_D3cold &&
 		 pdev->current_state != PCI_UNKNOWN) {
 		/* Disable PCIe AER on the tg3 to avoid a fatal
 		 * error during this system restart.
+		 * Needed since on restarts for systems in
+		 * tg3_restart_snp_quirk_table skipping on powering down the
+		 * tg3 device causes a fatal AER error during ACPI _PTS
+		 * (Prepare To Sleep).
 		 */
 		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL,
 					   PCI_EXP_DEVCTL_CERE |
-- 
2.53.0



