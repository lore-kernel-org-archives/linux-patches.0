Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D1A2576E;
	Sat, 12 Sep 2026 07:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199952; cv=none; b=ed3XhXwMB4jqlBTWDiVJ5v4Bo8TPeBgCzgyq/B7gxiN6cUuPR5i7sUvuZlr4+WODl+u9jBgquYPKSCEeCeFuXYEq8mn8yH2hc76j9Ge/9Yyth3hS6rjWiwrF75VaSWi0jTaNvIKEUSx2Lwv0gfwXsxkaLA1TVcd3II3hLysyfFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199952; c=relaxed/simple;
	bh=oVzxpIt5QiTXylcqMmJfqQ04oqPQ2AfrIgBpRfzbJEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et7yLUy/PTw73QSOdL4y/XOOV3Andv16GzrRO54c68IucPHwfRlNFSbBmpbIiHGpFwcVVQkt/SDBE3QjEJmTfemoVD+aNTq14Um6RgqAvnZERGxkCQh/1eDEw44WmH8WA+C49E06HIiDp9CwgkYZ4rM9z/UuV2HYbhlNJh2P18Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouvl2S2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouvl2S2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58381F000FF;
	Sat, 12 Sep 2026 07:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199950;
	bh=4S90oSchML2aB+aflHg/gBSeYrxhrM9PvODXBoaXETo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouvl2S2vbxeyYPYifmTWPG8AAcScQ2ezvmTMXdl6ywKVnDYB/tW8ZDazSUjFdB3IN
	 TDy2FCvopeNZNDtXfh3dA1Tb2eNUrdfMKEiEEb2rHd/ZSZh4+gT8kgpqf3dygLa0Cb
	 Z+F4qpgiRpA+8crHT+P4PvokS5+necDHOcINvhyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Elder <elder@riscstar.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0683/1815] PCI/pwrctrl: tc9563: Power off only the external ports in tc9563_pwrctrl_disable_port()
Date: Sat, 12 Sep 2026 08:40:33 +0200
Message-ID: <20260912065704.922531586@linuxfoundation.org>
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

[ Upstream commit e41bbfc4c109f2db741eef5cd0ac55600930c449 ]

TC9563 supports powering off only the external facing ports like DSP1 and
DSP2. It is not recommended to power off USP and DSP3 as they have fixed
ports/endpoint connected.

Fix tc9563_pwrctrl_disable_port() to power off only DSP1 and DSP2.

Fixes: 4c9c7be47310 ("PCI: pwrctrl: Add power control driver for TC9563")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260725-tc9563-fix-v1-3-ec4286e31331@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c b/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
index a6d8518c50026..b0efe7560c914 100644
--- a/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
+++ b/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
@@ -240,12 +240,18 @@ static int tc9563_pwrctrl_disable_port(struct tc9563_pwrctrl *tc9563,
 	if (!cfg->disable_port)
 		return 0;
 
-	if (port == TC9563_DSP1) {
+	switch (port) {
+	case TC9563_DSP1:
 		seq = dsp1_pwroff_seq;
 		len = ARRAY_SIZE(dsp1_pwroff_seq);
-	} else {
+		break;
+	case TC9563_DSP2:
 		seq = dsp2_pwroff_seq;
 		len = ARRAY_SIZE(dsp2_pwroff_seq);
+		break;
+	default:
+		/* Only external downstream ports DSP1/DSP2 can be powered off */
+		return 0;
 	}
 
 	ret = tc9563_pwrctrl_i2c_bulk_write(tc9563->client, seq, len);
-- 
2.53.0



