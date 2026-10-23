Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774599;
	b=AWVGXhxG5bRfygS98JQ9pxNKLmk4EhsZgq3IZVPk53HS8UKwYJaStq+VN7WQFtMqEqt7
	 cxBknU/Pfj2FTjMSjnTN8x3j/e/weiwUp8UlZ3UJkhL1OQaQSa0+2TvPRWWQQLvCjyGSm
	 dFWGTLrDbkMoibNM8gmEYOHsBEjYmnspcjNQErZ1j/t36evCPbAY9eSbm7jpnaP4kHkuf
	 SSwa5xjFlr37FRWdlNl4LZwr46rrSs4C4nnKG9QPz1YkkKNPtpFh+F4XfmlC7spMlIayC
	 8DMZcp36ct8iZuR1XpxQ6FBmQz5Fe+thbxU1WmMZ1I8s8NVfJLeoRMYhB7uKj7eWFFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kK4NHdhFP0SMnkIOpLM6PHQXivWDmXt4RkHPOEGlBD4=;
	b=lq1hRmjNTEmkn4+8ENVtv7M6uBBShMi/KuFvyvx91D/AlMglBSffycoPztUE1XKfqeQB
	 laEE2j/f1R1qCnYIewfll5XPNuBu5UCiUr4OIYWNmA7ft+H8kqWFd6YeOdCIC7yzzd0FQ
	 LHR4I2qrOqhJpB+BYs+1z6W0WQYBx8HnoGS/1/g6/QaFYq8GcZ/X88FsKh3hbZnTHnPYA
	 1aDNhOTtK3qiQf4MzCgQB1fbvDPyxrXGlHPdLN1rSLMtfV7Ir+uHxKDyrqOClSyvft3Dq
	 oAaV15pJM4upt25jK8NlNut+P/2r5hMAhmhNI4VcwCLd+BebfEPdeRcfzxsQGkS7Yyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A88/hSjh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DFB606A31B;
	Fri, 23 Oct 2026 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A88/hSjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32E21F01828;
	Fri, 23 Oct 2026 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774599;
	bh=kK4NHdhFP0SMnkIOpLM6PHQXivWDmXt4RkHPOEGlBD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A88/hSjhRAblO9MbcX0uCCbA30tShkmGsOz+KgJO3u05PL4d3aEKJSxDud515iqqO
	 N2AYKjC5jOgZJ+D2aEdbf0b78viFjkpd561VnKgLGXDI7Y8XOAeN/pbgSI3nmnwrMA
	 1yIIg0EuMui5mcasc3n13891tjZn94mqpjZ887bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Alexander Gruhlke <gruhlke@mailbox.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 096/242] PCI: Dont treat ~0 as ready in pci_dev_wait() with RRS SV
Date: Fri, 23 Oct 2026 18:38:58 +0200
Message-ID: <20261023163716.049624372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gruhlke <gruhlke@mailbox.org>

[ Upstream commit e8df1d194c39b7a5159d570798941851f70a8668 ]

With RRS Software Visibility, pci_dev_wait() considers a device ready as
soon as reading the Vendor ID doesn't return the RRS value.  Devices aren't
required to respond with RRS while they aren't ready, so the read may
return ~0 and pci_dev_wait() stops waiting too early.  This was seen with
Intel [8086:0a54] and Samsung [144d:a80c] NVMe SSDs.

Also wait while the Vendor ID reads ~0.  A VF's Vendor ID always reads ~0,
so check its Command register instead, as is done without RRS SV.

Fixes: d591f6804e7e ("PCI: Wait for device readiness with Configuration RRS")
Link: https://lore.kernel.org/r/20250611101442.387378-1-hui.wang@canonical.com
Suggested-by: Lukas Wunner <lukas@wunner.de>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Alexander Gruhlke <gruhlke@mailbox.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20261011190145.23621-3-gruhlke@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 80d2338b2a0a8..c8be53376ff3b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1213,9 +1213,11 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 	 * initialize.
 	 *
 	 * If the device is below a Root Port with Configuration RRS
-	 * Software Visibility enabled, reading the Vendor ID returns a
+	 * Software Visibility enabled, reading the Vendor ID may return a
 	 * special data value if the device responded with RRS.  Read the
-	 * Vendor ID until we get non-RRS status.
+	 * Vendor ID until we get non-RRS status and something other than
+	 * ~0.  The Vendor ID of VFs reads ~0, so check their Command
+	 * register instead.
 	 *
 	 * If there's no Root Port or Configuration RRS Software Visibility
 	 * is not enabled, the device may still respond with RRS, but
@@ -1235,8 +1237,13 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 
 		if (root && root->config_rrs_sv) {
 			pci_read_config_dword(dev, PCI_VENDOR_ID, &id);
-			if (!pci_bus_rrs_vendor_id(id))
-				break;
+			if (!pci_bus_rrs_vendor_id(id)) {
+				if (PCI_POSSIBLE_ERROR(id) && dev->is_virtfn)
+					pci_read_config_dword(dev, PCI_COMMAND,
+							      &id);
+				if (!PCI_POSSIBLE_ERROR(id))
+					break;
+			}
 		} else {
 			pci_read_config_dword(dev, PCI_COMMAND, &id);
 			if (!PCI_POSSIBLE_ERROR(id))
-- 
2.53.0



