Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFA93C1FEF;
	Thu, 15 Jan 2026 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497993; cv=none; b=no3g3sa5fO8WtH9tJzq5D1hMZxUNTCdP+iwI3Eip6n33pWxkxSsrPVnLYONQWpsKvPy6oS47o/95EJusNtSBhFSwk3I1aDCiOyUAor6pTVmPjltKlcr/KUBu972N+nf6noEN2hftzzyLsZxV0vdNn/5EJfmqNX1WUtI82Dwj70E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497993; c=relaxed/simple;
	bh=ZQ3s3p0XnX02lbU6yN5NSSAmoJut7eBZAOLGPVhr8b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXQ+4qKBYm8xFy9Lf/TZrS7+GWiI3Dfrbjr7KvF48mgcBIl/HxDAnspr82qzUqrTmBnDRy5allG4C2Yjn22XoQcIEOAYqSdV7yyNmGKcbqZTiEtkw7T/Wl2S9WStMooeyhWk8htQE+ymspAfFvazKREScui5AjEQNKgg9YsetuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIlzbYRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIlzbYRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D821C19422;
	Thu, 15 Jan 2026 17:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497992;
	bh=ZQ3s3p0XnX02lbU6yN5NSSAmoJut7eBZAOLGPVhr8b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIlzbYRivxxIHNvHIonTnBnV+lND9uf5oaIOnGUWAjSmDJefSFdHnMoBsaVffCCpV
	 tjNLV2IrgTUxCbYYrxHyh6qdA7870K5SIKPHrk5VKu3QdwoeFM0zXYsMRNrx8DNnEn
	 7rdhI0laOk3YqP+nyEDRULIQFMNQzyl0tPMMxsow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/554] platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks
Date: Thu, 15 Jan 2026 17:45:40 +0100
Message-ID: <20260115164256.146932431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit b169e1733cadb614e87f69d7a5ae1b186c50d313 ]

Dell Pro Rugged 10/12 tablets has a reliable VGBS method.
If VGBS is not called on boot, the on-screen keyboard won't appear if the
device is booted without a keyboard.

Call VGBS on boot on thess devices to get the initial state of
SW_TABLET_MODE in a reliable way.

Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20251127070407.656463-1-acelan.kao@canonical.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/hid.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index f59a3cc9767b..4d488e985dc5 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -144,6 +144,18 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Elite Dragonfly G2 Notebook PC"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 10 Tablet RA00260"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell Pro Rugged 12 Tablet RA02260"),
+		},
+	},
 	{ }
 };
 
-- 
2.51.0



