Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023264;
	b=MNVtQTzTU+ABMljyae7L7rLUBDaQ4jVsQ/yfZUN+z+HFITjg8ToLopWcDqHhePi9hMDo
	 AsUQ074rjAPaj+oduPpWiYWpHo+JgT+sreCMnXziiVHDGCfiaTTfbZU0e77RqaDaCmpXO
	 a3w1dF7f78GC28SSPscZnmiMLYiTCP5SKTDjP1mTFbxtR6PCC8DdZnYxOA0lzNlJ+fJ0I
	 2KyxPdexSIzntnyuhwdWmjuy+IPkudS8D9nh+ljFn4AI2cKFrYlLwrNCgEK1i2kEuroYk
	 q9Xv9D4Th7o3kopHie0hLF4WBZt58xyc3khRqUgpR8QWeftxj7tEgEFLJbzFHxnB3wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b/l+fMZ5ei2qCRNQdp64vYdYPmxQ5PiTuzbWueD6Dso=;
	b=Kev+Nx70kPOI9kH9X40iPqsZ2T3aPwMrmn+6u5/EbsQ5lAirG3sbGy535duIATvspZhH
	 o7Z6urbrzhwof2II4FVFocvGC4SFmoIAMdvLJbecPRHYx8sJPI133k6OKKuVeYdtqxhub
	 YVxuC3gp4/8oJIXFHKV5rp18BQwEtOLStW0WefrrupBeIso9Hk3Lf7JEiiWcXu+JmLUpD
	 DP2o3pP2tumu01gNH8vLlLIjlYkfvQf86qvyrAl2zmQycmYam/zxRSfESN5c4Pf2LJL07
	 lslPFmMKLq4OSo7Ju7mxFtGMDS8eoirhaTa4X5UmzevmeHVZ8Sy9nboLmnglwNFUSYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnH3ov0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A9F606A320;
	Wed, 18 Nov 2026 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnH3ov0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE36D1F000C4;
	Wed, 18 Nov 2026 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023264;
	bh=b/l+fMZ5ei2qCRNQdp64vYdYPmxQ5PiTuzbWueD6Dso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnH3ov0PN3bbEMSmK/jgtXSfbwx/hF0ELoiUBlkegsSND61FAIeqKnaEzS4ESNoTp
	 Fluz1DMexCPFvuSASl7ELXPR3z36Igq/b4IA6+m5KE/BYPZl7lxxCIXmQFyLVorgZk
	 8MJZ87I4EZ6SNcgoYecDkJ6IFWjhkpNvFPUKCUvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Gallagher <cdine@cdine.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0308/2151] ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310
Date: Wed, 18 Nov 2026 15:34:03 +0100
Message-ID: <20261118150133.135652912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Gallagher <cdine@cdine.org>

[ Upstream commit f16c512a07b954aa3b0b3c580e7abb5dd4f5e703 ]

This patch adds a quirk mapping for the "Blade Stealth 13 (Early 2020) -
RZ09-0310" laptop, which exhibits the same issue as the following two
related products already accounted for in this file.

 - Razer Blade Stealth 13 Late 2019
 - Blade Pro 17 (Early 2020) - RZ09-0329

Summary of the issue this fixes:
The firmware's _LID method still returns "closed" after resume when the
lid was opened during S3, causing systemd-logind to suspend the system
again within several seconds (15-40) after waking.

Signed-off-by: Ian Gallagher <cdine@cdine.org>

Link: https://patch.msgid.link/90ab9b58-da8b-4ffc-bd4b-adf7590545a9@app.fastmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index b507b88df6c37..44a1f26d6c969 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -143,6 +143,18 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Stealth 13 early 2020, when the lid is opened
+		 * while suspended the open notification is lost and _LID keeps
+		 * returning closed after resume, causing spurious re-suspends.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Stealth 13 (Early 2020) - RZ09-0310"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0



