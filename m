Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1B3350D57;
	Tue,  6 Jan 2026 17:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720142; cv=none; b=j3zMf6FjAsYiIRzzqlQ3grQ95xavnGDv7O4nJmT5/Io2WaeftVNtLqpsNaCcPo9m8N1UN0kxf3y2hsj2ZQF7pWC2uL95fOpR7PJNoe9M6RbZiTyDV0//8e7DRIy8j1GJsyZ4inqzus9CQJEPsw3o0tt9U/hiB+22Qn1MseEDuTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720142; c=relaxed/simple;
	bh=m8nkw/+i77Gnhc23NH8blNbGtBdE/+6esbp2MDW4Fsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HYvI1PXEu0w6n7MMx9wpfm/pe73ou0GSjPmtYQ69J7Wgj7/ihMIGkWW6wSF+65r+DBvoW4+hK473Hck+xhs0hew359UCl3vRzJqX0l8UXRYdrth1QAb0nUsfs7FQ7N2GYgu7arwq/wi3LOsVEyA05SAhVrSr+rMl4mkTymVNYsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LW8185RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW8185RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C5FC116C6;
	Tue,  6 Jan 2026 17:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720142;
	bh=m8nkw/+i77Gnhc23NH8blNbGtBdE/+6esbp2MDW4Fsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW8185RTnaAbCzzgZGirngT3m/UR7+I+lZR3LC4FcfGiTw9x/0d/uyNPYeC+ZpiJ1
	 P4L1VPUJfi8l0N5M06pshZQYuc+4usUtCPn63SHXnBemoJZ+WMZJ+uxz3uSwJKV2x+
	 f8W/lSqgakEf0/Yu0A9KseLkEcC0FsYvpGWOn3pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/567] platform/x86/intel/hid: Add Dell Pro Rugged 10/12 tablet to VGBS DMI quirks
Date: Tue,  6 Jan 2026 17:58:49 +0100
Message-ID: <20260106170456.764005230@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index 59392f1a0d8a..04056fbd9219 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -168,6 +168,18 @@ static const struct dmi_system_id dmi_vgbs_allow_list[] = {
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



