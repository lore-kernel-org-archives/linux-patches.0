Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E721A260583;
	Tue, 12 Aug 2025 19:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025402; cv=none; b=GtHjTjdL90VU6n2tmDz25SShr6VlO4R/G0Hsm61+WlL0HgfO9nDvVqM582mDYwCDqFkrdOI/qF0+xCc/sml/aVoFnAwLVqv+WE+zqD+MHZFrBI4q3u654MgUUWWEr5mdC6y1EMyCWxnXQA+/9Z6iz90wQo4XbvM9D3gI8LU19ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025402; c=relaxed/simple;
	bh=elY/aWZ4PwScci9zQjpLEdgbTEmlVK3qFml4+bXaHLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHO15gtBoUNNI4fBAG3iaKMzSx0xqoWRv6kfgrZlnF9GnKUTsyRpImbTz71DcHiSci13dMQMGIFCqWcQNPJCltsgiAYYsN6W6nqDe4QC4faDbsdikC9LUZRSVO0hDuWNL5GN1c7/X9hWTzVcqvZ9d3g2BH9I0HunhIp5YFk6q+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApdkbGHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApdkbGHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C122C4CEF0;
	Tue, 12 Aug 2025 19:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025401;
	bh=elY/aWZ4PwScci9zQjpLEdgbTEmlVK3qFml4+bXaHLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApdkbGHHq6kyQ1yNKLYjbop9C1UJBWJhOkNOUYktTLqazZExmpono6xkYwgX654bY
	 alOnPukFo4d8aa2Cdr74FXVzk6LgbUvi9HMXq+0GhEPEGBCYRUjJQ742b99X6MWnz7
	 yOO340kkmHeYGgoIRn3Yu+4SzQQwItu59jWvaVKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 030/480] ASoC: amd: acp: Fix pointer assignments for snd_soc_acpi_mach structures
Date: Tue, 12 Aug 2025 19:43:58 +0200
Message-ID: <20250812174358.595745093@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 0779c0ad2a7cc0ae1865860c9bc8732613cc56b1 ]

This patch modifies the assignment of machine structure pointers in the
acp_pci_probe function. Previously, the machine pointers were assigned
using the address-of operator (&), which caused incompatibility issues
in type assignments.

Additionally, the declarations of the machine arrays in amd.h have been
updated to reflect that they are indeed arrays (`[]`). The code is
further cleaned up by declaring the codec structures in
amd-acpi-mach.c as static, reflecting their intended usage.

error: symbol 'amp_rt1019' was not declared. Should it be static?
error: symbol 'amp_max' was not declared. Should it be static?
error: symbol 'snd_soc_acpi_amd_acp_machines' was not declared. Should it be static?
error: symbol 'snd_soc_acpi_amd_rmb_acp_machines' was not declared. Should it be static?
error: symbol 'snd_soc_acpi_amd_acp63_acp_machines' was not declared. Should it be static?
error: symbol 'snd_soc_acpi_amd_acp70_acp_machines' was not declared. Should it be static?

Fixes: 9c2c0ef64009 ("ASoC: amd: acp: Fix snd_soc_acpi_mach id's duplicate symbol error")

Link: https://github.com/thesofproject/linux/issues/5438
Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20250609121251.639080-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-pci.c       | 8 ++++----
 sound/soc/amd/acp/amd-acpi-mach.c | 4 ++--
 sound/soc/amd/acp/amd.h           | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/amd/acp/acp-pci.c b/sound/soc/amd/acp/acp-pci.c
index 0b2aa33cc426..2591b1a1c5e0 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -137,26 +137,26 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 		chip->name = "acp_asoc_renoir";
 		chip->rsrc = &rn_rsrc;
 		chip->acp_hw_ops_init = acp31_hw_ops_init;
-		chip->machines = &snd_soc_acpi_amd_acp_machines;
+		chip->machines = snd_soc_acpi_amd_acp_machines;
 		break;
 	case 0x6f:
 		chip->name = "acp_asoc_rembrandt";
 		chip->rsrc = &rmb_rsrc;
 		chip->acp_hw_ops_init = acp6x_hw_ops_init;
-		chip->machines = &snd_soc_acpi_amd_rmb_acp_machines;
+		chip->machines = snd_soc_acpi_amd_rmb_acp_machines;
 		break;
 	case 0x63:
 		chip->name = "acp_asoc_acp63";
 		chip->rsrc = &acp63_rsrc;
 		chip->acp_hw_ops_init = acp63_hw_ops_init;
-		chip->machines = &snd_soc_acpi_amd_acp63_acp_machines;
+		chip->machines = snd_soc_acpi_amd_acp63_acp_machines;
 		break;
 	case 0x70:
 	case 0x71:
 		chip->name = "acp_asoc_acp70";
 		chip->rsrc = &acp70_rsrc;
 		chip->acp_hw_ops_init = acp70_hw_ops_init;
-		chip->machines = &snd_soc_acpi_amd_acp70_acp_machines;
+		chip->machines = snd_soc_acpi_amd_acp70_acp_machines;
 		break;
 	default:
 		dev_err(dev, "Unsupported device revision:0x%x\n", pci->revision);
diff --git a/sound/soc/amd/acp/amd-acpi-mach.c b/sound/soc/amd/acp/amd-acpi-mach.c
index d95047d2ee94..27da2a862f1c 100644
--- a/sound/soc/amd/acp/amd-acpi-mach.c
+++ b/sound/soc/amd/acp/amd-acpi-mach.c
@@ -8,12 +8,12 @@
 
 #include <sound/soc-acpi.h>
 
-struct snd_soc_acpi_codecs amp_rt1019 = {
+static struct snd_soc_acpi_codecs amp_rt1019 = {
 	.num_codecs = 1,
 	.codecs = {"10EC1019"}
 };
 
-struct snd_soc_acpi_codecs amp_max = {
+static struct snd_soc_acpi_codecs amp_max = {
 	.num_codecs = 1,
 	.codecs = {"MX98360A"}
 };
diff --git a/sound/soc/amd/acp/amd.h b/sound/soc/amd/acp/amd.h
index 863e74fcee43..cb8d97122f95 100644
--- a/sound/soc/amd/acp/amd.h
+++ b/sound/soc/amd/acp/amd.h
@@ -243,10 +243,10 @@ extern struct acp_resource rmb_rsrc;
 extern struct acp_resource acp63_rsrc;
 extern struct acp_resource acp70_rsrc;
 
-extern struct snd_soc_acpi_mach snd_soc_acpi_amd_acp_machines;
-extern struct snd_soc_acpi_mach snd_soc_acpi_amd_rmb_acp_machines;
-extern struct snd_soc_acpi_mach snd_soc_acpi_amd_acp63_acp_machines;
-extern struct snd_soc_acpi_mach snd_soc_acpi_amd_acp70_acp_machines;
+extern struct snd_soc_acpi_mach snd_soc_acpi_amd_acp_machines[];
+extern struct snd_soc_acpi_mach snd_soc_acpi_amd_rmb_acp_machines[];
+extern struct snd_soc_acpi_mach snd_soc_acpi_amd_acp63_acp_machines[];
+extern struct snd_soc_acpi_mach snd_soc_acpi_amd_acp70_acp_machines[];
 
 extern const struct snd_soc_dai_ops asoc_acp_cpu_dai_ops;
 extern const struct snd_soc_dai_ops acp_dmic_dai_ops;
-- 
2.39.5



