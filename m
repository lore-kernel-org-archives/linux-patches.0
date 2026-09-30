Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ADD51A747;
	Wed, 30 Sep 2026 17:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789782; cv=none; b=cwLuu402b5vxd6EbZw87I75lLMiScK2xu7ylvUKS5Lc+cwaTF7wxTyJ6+GtVtgm3yJmqo39j7oiy7rsRd+VgiB99euY5WTbiT3eQx+vhSRxL9B+E7NAlGH5iDx/FqbTBv5X+t/ffCpo8UwP3ahMZ8tYwVH8weMbI6fsw4rHrTq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789782; c=relaxed/simple;
	bh=wcp3YY6asvV9e0EYxoL7nUuirrX1zYg03IL0Z6AK2wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cqZoWOie+qbCvGJd1iyL+VBKR6q0ctRuJfxZhXu/YpkKLO/yz9806q7qy99CQt9kc9ofDkzZ1kLNZGbhUJEynUFVJ8wg4hDbqIdzi+uEAPdcl0MbN0nHlgHyi5gg7abYK44bLBgkuuU1lVJ2XC9bjDjIfMlztsl1D59ScR3+hY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+HzIVU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+HzIVU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287191F000FF;
	Wed, 30 Sep 2026 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789780;
	bh=FSUp+u58V2adDynVwF7oPOPKrUIcdFi9IFxr06JeWz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+HzIVU4Gav9P7qRqkTk7LJ6EmElvjeaxGmordH0z4PdvfP1mv+bI7KWK2AheRozE
	 Hfyej+G8oVoXPwzqS/DlrzhxScQs84E4180lUcpZmjOf0p/LulKAZ4BdJ7VG6AS8L2
	 WAcoAF4oyFxdDJtSLNcxzSRvwV3T465Q+YMcuMhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 591/877] platform/x86/amd/pmc: Define enum for S2D/PMC msg_port and add helper function
Date: Wed, 30 Sep 2026 17:25:02 +0200
Message-ID: <20260930152427.403319904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 2851f4f8ed4e130d864c5478c6da933a4427ae52 ]

To distinguish between the PMC message port and the S2D (Spill to DRAM)
message port, replace the use of 0 and 1 with an enum.

To avoid printing the S2D or PMC port multiple times in debug print,
add new routine to retrieve the message port information, which can be
used to print the right msg_port getting used.

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Co-developed-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20241108070822.3912689-5-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 9cef693bce96 ("platform/x86/amd/pmc: Restore msg_port on amd_stb_s2d_init() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc/pmc.c |   22 +++++++++++++++++-----
 drivers/platform/x86/amd/pmc/pmc.h |    2 +-
 2 files changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -458,11 +458,23 @@ static void amd_pmc_dbgfs_register(struc
 			    &amd_pmc_idlemask_fops);
 }
 
+static char *amd_pmc_get_msg_port(struct amd_pmc_dev *dev)
+{
+	switch (dev->msg_port) {
+	case MSG_PORT_PMC:
+		return "PMC";
+	case MSG_PORT_S2D:
+		return "S2D";
+	default:
+		return "Invalid message port";
+	}
+}
+
 static void amd_pmc_dump_registers(struct amd_pmc_dev *dev)
 {
 	u32 value, message, argument, response;
 
-	if (dev->msg_port) {
+	if (dev->msg_port == MSG_PORT_S2D) {
 		message = AMD_S2D_REGISTER_MESSAGE;
 		argument = AMD_S2D_REGISTER_ARGUMENT;
 		response = AMD_S2D_REGISTER_RESPONSE;
@@ -473,13 +485,13 @@ static void amd_pmc_dump_registers(struc
 	}
 
 	value = amd_pmc_reg_read(dev, response);
-	dev_dbg(dev->dev, "AMD_%s_REGISTER_RESPONSE:%x\n", dev->msg_port ? "S2D" : "PMC", value);
+	dev_dbg(dev->dev, "AMD_%s_REGISTER_RESPONSE:%x\n", amd_pmc_get_msg_port(dev), value);
 
 	value = amd_pmc_reg_read(dev, argument);
-	dev_dbg(dev->dev, "AMD_%s_REGISTER_ARGUMENT:%x\n", dev->msg_port ? "S2D" : "PMC", value);
+	dev_dbg(dev->dev, "AMD_%s_REGISTER_ARGUMENT:%x\n", amd_pmc_get_msg_port(dev), value);
 
 	value = amd_pmc_reg_read(dev, message);
-	dev_dbg(dev->dev, "AMD_%s_REGISTER_MESSAGE:%x\n", dev->msg_port ? "S2D" : "PMC", value);
+	dev_dbg(dev->dev, "AMD_%s_REGISTER_MESSAGE:%x\n", amd_pmc_get_msg_port(dev), value);
 }
 
 int amd_pmc_send_cmd(struct amd_pmc_dev *dev, u32 arg, u32 *data, u8 msg, bool ret)
@@ -489,7 +501,7 @@ int amd_pmc_send_cmd(struct amd_pmc_dev
 
 	mutex_lock(&dev->lock);
 
-	if (dev->msg_port) {
+	if (dev->msg_port == MSG_PORT_S2D) {
 		message = AMD_S2D_REGISTER_MESSAGE;
 		argument = AMD_S2D_REGISTER_ARGUMENT;
 		response = AMD_S2D_REGISTER_RESPONSE;
--- a/drivers/platform/x86/amd/pmc/pmc.h
+++ b/drivers/platform/x86/amd/pmc/pmc.h
@@ -39,7 +39,6 @@ struct amd_pmc_dev {
 	void __iomem *smu_virt_addr;
 	void __iomem *stb_virt_addr;
 	void __iomem *fch_virt_addr;
-	bool msg_port;
 	u32 base_addr;
 	u32 cpu_id;
 	u32 active_ips;
@@ -51,6 +50,7 @@ struct amd_pmc_dev {
 	u8 major;
 	u8 minor;
 	u8 rev;
+	u8 msg_port;
 	struct device *dev;
 	struct pci_dev *rdev;
 	struct mutex lock; /* generic mutex lock */


