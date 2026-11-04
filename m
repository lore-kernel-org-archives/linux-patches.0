Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829572;
	b=ysH0tirqLO0nGsP9Ue8HXZpr8xJ7UldGOdy1s8IRgQLJ15PR0Q3uoqN5LoW0+62pNfWc
	 pwqs5iYG3nDh+VYrP7lgEcg/Xpkuph+N7+uZakleB5RwNW2g9Az/Ws9Woe0gmfuxbyyIa
	 DzRelsaB8GI99Stdyd2x35sY3TI92emGZwfjW54sK/EetZTybpYm0/XEAwyK/+aSBBu7/
	 tz2ZFERedkMmDxVrBZRtApS5W/OrdSRV/GoQqGdvb6ArPwUuLy7qPssD9PAjDCL0g/vsS
	 8MXtSe0SUY+fZDw982qy+cK5XOrYMfSlFqHuVs3ziMMKRFlO+azxp/HIOcMAfloeXaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=334Ndnd0IvbcOlgCJE9DbKFac7shZ8q+ShjS3zKUrdw=;
	b=lWHCdK4IV/b6/Ol+9zry23zewrMEImKiC3ve/kFl4U6/GRa0u005UgnuxVmDwBjGae3p
	 rq2sFAA9ujp8lD5MfC8kG3fdQhF3IPQ82SWe3FgNik/A+h0VJSfyyM+UBlYuoikCpFRzr
	 TNGf1yRp36d+SIKNTtO3Uiou4VIGeP0dFM2C5CU56iOy2KfA9Hkd3vtn0GatTY30VBdFt
	 CWNwSRHxFf9dGxUHxtS+DSIuAgzfstzqgwGG7yLdYwGsJKvIneDkNui8ObnKytuPIUkgf
	 A7FKHnK/59aLSgwMcijwjmQjz6B+GH4Vc5lq4HdiDdZAodjuoWAdhf8DkAebW5eNgMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qE6iCV5V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A69606A33E;
	Wed,  4 Nov 2026 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qE6iCV5V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E401F00A18;
	Wed,  4 Nov 2026 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829572;
	bh=334Ndnd0IvbcOlgCJE9DbKFac7shZ8q+ShjS3zKUrdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qE6iCV5VNxqhrO6Jt7NZtk77fcwqhG62bJzXlXtn1EZeSrFhNdv1UcS+g9ghOizqc
	 J5YBCz2ZdhlO3eYIpru8sb83sGGWcfsTGjs6egtszhzakA2yi0TOMv5s0t1U/sbCKI
	 QH19xBNnqSM9jahNjLiydI4PsYq107mTAk41ZGUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yap Weei Choong <ywc8891@gmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0209/1005] platform/x86/amd/pmc: Add T14 Gen2 AMD (20XL) to s2idle quirk list
Date: Wed,  4 Nov 2026 15:59:02 -0500
Message-ID: <20261104211049.660760780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yap Weei Choong <ywc8891@gmail.com>

[ Upstream commit e25fb2258bddbcf70df69d1358be3e1274bdc5f2 ]

The ThinkPad T14 Gen 2 AMD was sold under two machine types, 20XK and
20XL, but only 20XK has been in the s2idle quirk list since the quirk
was introduced in commit 455cd867b85b ("platform/x86: thinkpad_acpi:
Add a s2idle resume quirk for a number of laptops").

On 20XL machines the firmware SMI handler therefore still runs on the
NVMe D3->D0 transition when exiting suspend-to-idle. With IOMMU
translation enabled (the default), this intermittently stalls resume
for ~10.25 seconds: seven devices across three root ports (nvme, both
xhci_hcd functions, xhci-pci-renesas, snd_hda_intel x2, snd_rn_pci_acp3x)
block in pci_pm_resume_noirq and are released simultaneously, consistent
with all cores being held in SMM.

Add the missing 20XL machine type, mirroring the existing 20XK entry.
This is the same class of omission fixed by commit 9a469c6dfab3
("platform/x86: thinkpad_acpi: Add missing T14s Gen1 type to s2idle
quirk list").

Verified on a ThinkPad T14 Gen 2a (type 20XLS41C00, BIOS R1MET62W 1.32,
kernel 6.12.95): with this entry the quirk message appears at probe and
a 14-hour suspend resumes in ~1s with no noirq stalls, where previously
even short suspends could hit the ~10s delay. A further two-day soak
(short naps and two ~14-hour suspends) showed every resume clean.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221755
Signed-off-by: Yap Weei Choong <ywc8891@gmail.com>
Tested-by: Yap Weei Choong <ywc8891@gmail.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260717060744.1252065-2-ywc8891@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 74ddf1d8289a9..09a30f3337596 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -71,6 +71,14 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "20XK"),
 		}
 	},
+	{
+		.ident = "T14 Gen2 AMD",
+		.driver_data = &quirk_s2idle_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20XL"),
+		}
+	},
 	{
 		.ident = "T14 Gen1 AMD",
 		.driver_data = &quirk_s2idle_spurious_8042,
-- 
2.53.0



