Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EADC2931FB;
	Sat, 12 Sep 2026 08:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200165; cv=none; b=Z+7ZegYANeY/pEau5V23P0dGAvCL5F3DEE7SiASxJDTlbvOK0ZkWM+96tYy0XgYnICn7RMeAh1g0tOKPSr7/2eYX9dK31UqCWsruHDaLkImL10nCrIrw/OKdRej1odpOUirM0Basv2TnGi3Rkdgqq/UuS94kH1GwEZDDUSwjIsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200165; c=relaxed/simple;
	bh=REIAg8uXWytaGr+lgOp0x2fAEoQtCpp7n5CdCcl4Uq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km1j9SNS96+/a4hckuXq0/mHCR9zsFVuZsJeeG57Rd7zZGStEb5Ij2iCIRLlTUibpA1ATKHyN9oyTANr8a9BHeuJWEVbl7k9WXHQGDxCcJWenrQf2VPsFI2rg5nIZBiWAS318M6VV9pZhaRGL/Y389jSIW5DmiIg5j/e38UKGKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHyPcLvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHyPcLvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F1E1F000FF;
	Sat, 12 Sep 2026 08:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200164;
	bh=fE7BSuAXj+7YNyzlCzZDAGtqzgA0DchRJ3etrJq0BYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHyPcLvd/QWLUQ7OA4JOYz0CFspEzqCIrr6A2iok+DT6EYG4ThFo0uNUQV2eyUoZM
	 PesLMKprRYvlSbWYWbouqYj57gmpCE6qPaGelgof/XKavAySy5RCVclnkOvlCK5JkR
	 7xm3t7wNWoIwjF/L6wWFNhdjei38kwyIn1eDpqic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Elder <elder@riscstar.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0682/1815] PCI/pwrctrl: tc9563: Fix parsing the integrated Ethernet MAC Endpoint node
Date: Sat, 12 Sep 2026 08:40:32 +0200
Message-ID: <20260912065704.898610421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 6e5e6c2194b2acbded5b12ed80590d215b786d29 ]

DSP3 has an integrated Ethernet MAC Endpoint which has its own set of
config registers for configuring settings such as ASPM. The Endpoint device
has two physical functions and those two functions share the same settings.

Parse the Endpoint node under DSP3 instead of parsing both functions.  The
existing parsing logic also has one OOB issue as parsing both functions
will result in accessing past the tc9563_pwrctrl->cfg array.

Fixes: 4c9c7be47310 ("PCI: pwrctrl: Add power control driver for TC9563")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260725-tc9563-fix-v1-2-ec4286e31331@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c b/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
index 1555e8a9b3ca1..a6d8518c50026 100644
--- a/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
+++ b/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
@@ -595,12 +595,18 @@ static int tc9563_pwrctrl_probe(struct platform_device *pdev)
 		ret = tc9563_pwrctrl_parse_device_dt(tc9563, child, port);
 		if (ret)
 			break;
-		/* Embedded ethernet device are under DSP3 */
+
+		/*
+		 * The integrated Ethernet MAC Endpoint under DSP3 is a single
+		 * device whose functions share the same config registers.
+		 */
 		if (port == TC9563_DSP3) {
-			for_each_child_of_node_scoped(child, child1) {
-				port++;
+			struct device_node *eth __free(device_node) =
+					of_get_next_available_child(child, NULL);
+
+			if (eth) {
 				ret = tc9563_pwrctrl_parse_device_dt(tc9563,
-								child1, port);
+								eth, TC9563_ETHERNET);
 				if (ret)
 					break;
 			}
-- 
2.53.0



