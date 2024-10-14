Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F711AAE02;
	Mon, 14 Oct 2024 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916386; cv=none; b=tnSZaV3sY5LjwAC5VdazQhLJ+rpc+gUWOzUSoObQv7Er1bEdBxBLVCkAWtLUGhrXSWcHAjnV0AGkKYp8HeeTp4/sLn5Cn9x4jjGH/Hl8s7xb+8u4O+74tEaFiax+2cO3LCFHDhyEl3lwGEtbE4fs4aTswcTd2t22XXH4EyWtvnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916386; c=relaxed/simple;
	bh=snMuU3y33INBcR6e8NeXBM2vID+lOQq4bipJii6tSkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0YhNvxE5Y9BDdjdJiG+jiZMnYPbrRtLrPU16vTiz4zCiO4ckRO7EVNYxMKp+cZNTG4Rl476AYFkAiVaLVz/61msdaMyB3hu9s0oC/4IDgg+ihsnLEzawMggRdpnCO44vt8Bsd2CXrT4U+kYWi9O2LSDzdUILDfq28Shc8X/u4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IH2Onvw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IH2Onvw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FF2C4CEC3;
	Mon, 14 Oct 2024 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916386;
	bh=snMuU3y33INBcR6e8NeXBM2vID+lOQq4bipJii6tSkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IH2Onvw/0jVuG+QOzi4jyPcDsyuYomopsVeWz+5fLZb9JkYsA4ODxClA2Abr5Lpna
	 JJXsSu5YzylfMne0UKDCZDHwbN8LzEU4xe0zD4/jMoQEJ916Ny3X9zadOoPzL5Vn1B
	 zr+1EuPSJSgE+otLPJmjPZbRfmQVRGrBt+uMZL4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Blum <stefan.blum@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 169/214] ACPI: resource: Make Asus ExpertBook B2402 matches cover more models
Date: Mon, 14 Oct 2024 16:20:32 +0200
Message-ID: <20241014141051.575245197@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 564a278573783cd8859829767851744087e676d8 upstream.

The Asus ExpertBook B2402CBA / B2402FBA are the non flip / flip versions
of the 14" Asus ExpertBook B2 with 12th gen Intel processors.

It has been reported that the B2402FVA which is the 14" Asus ExpertBook
B2 flip with 13th gen Intel processors needs to skip the IRQ override too.

And looking at Asus website there also is a B2402CVA which is the non flip
model with 13th gen Intel processors.

Summarizing the following 4 models of the Asus ExpertBook B2 are known:

B2402CBA: 12th gen Intel CPU, non flip
B2402FBA: 12th gen Intel CPU, flip
B2402CVA: 13th gen Intel CPU, non flip
B2402FVA: 13th gen Intel CPU, flip

Fold the 2 existing quirks for the B2402CBA and B2402FBA into a single
quirk covering B2402* to also cover the 2 other models while at the same
time reducing the number of quirks.

Reported-by: Stefan Blum <stefan.blum@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/a983e6d5-c7ab-4758-be9b-7dcfc1b44ed3@gmail.com/
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241005212819.354681-2-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -483,17 +483,10 @@ static const struct dmi_system_id irq1_l
                 },
         },
 	{
-		/* Asus ExpertBook B2402CBA */
+		/* Asus ExpertBook B2402 (B2402CBA / B2402FBA / B2402CVA / B2402FVA) */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "B2402CBA"),
-		},
-	},
-	{
-		/* Asus ExpertBook B2402FBA */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "B2402FBA"),
+			DMI_MATCH(DMI_BOARD_NAME, "B2402"),
 		},
 	},
 	{


