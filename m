Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B6C2E7F03;
	Mon, 29 Dec 2025 16:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025430; cv=none; b=JH4ncrc2Ev/HZ2sVWRW3EUrgUUHZY0m99NnQMwAe6sF/vaDy+7dB1FeR6G/F7WpILnmml1j2H14fNgEQvQj+qFW1hPpOaHH5WxPqLSUyokKMlpVSUS+r144XPLEQtNWfjwnSpxWV9VoqJclXQxdBHStRiXKmabsB4X/P4fAaJQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025430; c=relaxed/simple;
	bh=Z3EIqoRjeaF0XS4+3UREx/1Nm5+nMmGDZwB9pQdnL5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QTf5p3r1sIJBub6Qv2FGEs+4eN5AvMf/yz9WorAOQ5biESGhzkwkuEUMip1EoC76TSeIY0XwMUC2qyzhzDWd71PZtYz7WDGYEvF0BmA5Zv12LPn04359nCf66+JTmVSLvYjU3rC2g4/y2Ki+dodLVkIV7rR3obRxldNZVLKnlzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqyrwQKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqyrwQKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B522C4CEF7;
	Mon, 29 Dec 2025 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025429;
	bh=Z3EIqoRjeaF0XS4+3UREx/1Nm5+nMmGDZwB9pQdnL5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqyrwQKNBuI1zp2QLZhrLGrYSVJT0vvH3mNZNqmtaA4M6QT4A3fBfUDDGNCG2+y//
	 xb1Txt16wDz+fnS4fxVlKyaVS+e2+dFIwmzUfvr36q7OBLLAMJF2PdoCx5Og8HFcZm
	 w6xuWCTEJ1SI2aaYuMhFMmSx2LZz3fGjqWDg7a2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 211/430] platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks
Date: Mon, 29 Dec 2025 17:10:13 +0100
Message-ID: <20251229160732.118013211@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9c07a7faf18f..560cc063198e 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -177,6 +177,18 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
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



