Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF041AC44C;
	Mon, 14 Oct 2024 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916390; cv=none; b=iib0QwQv9GGsgFhwe+kvQIc1fy4sowOco4QTnvZDfi4DYPgXQvkiZjpcQSUWtaKheDWVeAk1F89VMfL6PBdqxwvmVeHbBHK+pSxLrHiLe7PeTRK/PKJyOnNI3IChtUnYR8Z/XL9iNLW1tF2gDpCOERZozQqHBOVimrXNCrkHZa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916390; c=relaxed/simple;
	bh=XZuamApvgDuucRy9jJ4Xj/FSGvNduRd8II9JtYjZzYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FysOl4mpZr5MCMOZTKLbdVr2xIvtvIsGy3pZOrkDSzWMyCPTsm7I02VnpwmGLUzycV6aV3QtCHpQI+DfTDmm8vziuUfd67PBzeVcr66bp9ZZ1KJF9txJmgsAo/u8cGUWW7pjyM9ZPmhyESY6q11ULQuY7kqfnuUwcl+7NhAiTPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWL9ZmbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWL9ZmbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70950C4CEC7;
	Mon, 14 Oct 2024 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916389;
	bh=XZuamApvgDuucRy9jJ4Xj/FSGvNduRd8II9JtYjZzYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWL9ZmbSIKQbB1f3iv7Sro0b2mX77M/TnSmuMpx1pANJd0rR/UPXdPg3ou0x54z81
	 FPQayFLUC12jCe08/cTSFthykYoaidqm586OnTUXft7iZzoXKEGUGi+ugf+SiB9LhQ
	 FuBEEHDwJXyUjqUylnfFBjzTaguwTUWuQF82uZfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 170/214] ACPI: resource: Make Asus ExpertBook B2502 matches cover more models
Date: Mon, 14 Oct 2024 16:20:33 +0200
Message-ID: <20241014141051.614100174@linuxfoundation.org>
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

commit 435f2d87579e2408ab6502248f2270fc3c9e636e upstream.

Like the various 14" Asus ExpertBook B2 B2402* models there are also
4 variants of the 15" Asus ExpertBook B2 B2502* models:

B2502CBA: 12th gen Intel CPU, non flip
B2502FBA: 12th gen Intel CPU, flip
B2502CVA: 13th gen Intel CPU, non flip
B2502FVA: 13th gen Intel CPU, flip

Currently there already are DMI quirks for the B2502CBA, B2502FBA and
B2502CVA models. Asus website shows that there also is a B2502FVA.

Rather then adding a 4th quirk fold the 3 existing quirks into a single
quirk covering B2502* to also cover the last model while at the same time
reducing the number of quirks.

Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241005212819.354681-3-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -490,24 +490,10 @@ static const struct dmi_system_id irq1_l
 		},
 	},
 	{
-		/* Asus ExpertBook B2502 */
+		/* Asus ExpertBook B2502 (B2502CBA / B2502FBA / B2502CVA / B2502FVA) */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "B2502CBA"),
-		},
-	},
-	{
-		/* Asus ExpertBook B2502FBA */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "B2502FBA"),
-		},
-	},
-	{
-		/* Asus ExpertBook B2502CVA */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "B2502CVA"),
+			DMI_MATCH(DMI_BOARD_NAME, "B2502"),
 		},
 	},
 	{


