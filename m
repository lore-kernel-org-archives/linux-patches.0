Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82E2FBFA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5BEC4339B;
	Mon, 15 May 2023 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171236;
	bh=v0LR2KYR8PyyF39lOMybbrGeHTn4QIJZBer4850tj4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1iOhxvMnValwFOPjrUJBfTjFaRSTXQyynCDsmEXUiohsM/JEheQPeshscqjcUq/V
	 q27HBK6tsSc2pB44/wpX8G30m9+zs7JqTv0jM2zrgYNCaAx2M/UzWpKteaRTxzoHrn
	 OAb6vXGOTdTdaK/VeeKCPyvXPhK+u5hMBOo2p+CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.2 145/242] platform/x86: thinkpad_acpi: Fix platform profiles on T490
Date: Mon, 15 May 2023 18:27:51 +0200
Message-Id: <20230515161726.249615394@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

commit 0c0cd3e25a5b64b541dd83ba6e032475a9d77432 upstream.

I had incorrectly thought that PSC profiles were not usable on Intel
platforms so had blocked them in the driver initialistion. This broke
platform profiles on the T490.

After discussion with the FW team PSC does work on Intel platforms and
should be allowed.

Note - it's possible this may impact other platforms where it is advertised
but special driver support that only Windows has is needed. But if it does
then they will need fixing via quirks. Please report any issues to me so I
can get them addressed - but I haven't found any problems in testing...yet

Fixes: bce6243f767f ("platform/x86: thinkpad_acpi: do not use PSC mode on Intel platforms")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2177962
Cc: stable@vger.kernel.org
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230505132523.214338-1-mpearson-lenovo@squebb.ca
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10593,11 +10593,6 @@ static int tpacpi_dytc_profile_init(stru
 				dytc_mmc_get_available = true;
 		}
 	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) { /* PSC MODE */
-		/* Support for this only works on AMD platforms */
-		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD) {
-			dbg_printk(TPACPI_DBG_INIT, "PSC not support on Intel platforms\n");
-			return -ENODEV;
-		}
 		pr_debug("PSC is supported\n");
 	} else {
 		dbg_printk(TPACPI_DBG_INIT, "No DYTC support available\n");


