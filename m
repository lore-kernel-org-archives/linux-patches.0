Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C231DE2AE;
	Tue,  8 Oct 2024 13:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392695; cv=none; b=Kw/mfYC1z3nDIWTSBHzT/pbjs/FKJ2HppE1XhIsnRRGUB9mKQ9S4+0DFmn1hBB5Lcpe+5lz3fyRCEVUNOfxVDs1zS/PNV6MpkC7WM5YzC56Ealsf1GTx6mM7UuSOiqdVzHKl56jBg1wM11gDLNANCsygf90p6FsZSvNH2idC3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392695; c=relaxed/simple;
	bh=HFA/C0L8jQe6tIIkFBoagGRLEkrBmKM7yUQuMMMNO9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LG8G14twFP7Vx7uV1eaVLjtAFQ/H1EVlfnVGiB5sq1vJ8Bn462JDSprkl3VLa5Bfn7MHO/yDCiKkT0rkU3O6zptvH55/M1woAb6xb8iBRO6bqKXyNIcmajJxePMurZFKFMz24GrmtM1u7faDcCMSGxeLm/OF1JBC5gxNtKQD8Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZgwk+8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZgwk+8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670E8C4CECC;
	Tue,  8 Oct 2024 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392694;
	bh=HFA/C0L8jQe6tIIkFBoagGRLEkrBmKM7yUQuMMMNO9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZgwk+8e+Oyr77810PmpR7H3PPhvzPdTJMWgtUDINq3R6qxDMHpe+ligC6y+5SGSX
	 ITNEV56rrWIkdRVULXdPQwXhxEb2UMXYM3gQtfWcd4t+sQLt29U9Ze8EMgJq7P8PpR
	 aS1OkS+NS6tcmAyxyM0mOp0u1sm90DjNBuFDmI2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 492/558] ACPI: resource: Remove duplicate Asus E1504GAB IRQ override
Date: Tue,  8 Oct 2024 14:08:42 +0200
Message-ID: <20241008115721.593800335@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

commit 65bdebf38e5fac7c56a9e05d3479a707e6dc783c upstream.

Commit d2aaf1996504 ("ACPI: resource: Add DMI quirks for ASUS Vivobook
E1504GA and E1504GAB") does exactly what the subject says, adding DMI
matches for both the E1504GA and E1504GAB.

But DMI_MATCH() does a substring match, so checking for E1504GA will also
match E1504GAB.

Drop the unnecessary E1504GAB entry since that is covered already by
the E1504GA entry.

Fixes: d2aaf1996504 ("ACPI: resource: Add DMI quirks for ASUS Vivobook E1504GA and E1504GAB")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240927141606.66826-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -511,20 +511,13 @@ static const struct dmi_system_id irq1_l
 		},
 	},
 	{
-		/* Asus Vivobook E1504GA */
+		/* Asus Vivobook E1504GA* */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_BOARD_NAME, "E1504GA"),
 		},
 	},
 	{
-		/* Asus Vivobook E1504GAB */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "E1504GAB"),
-		},
-	},
-	{
 		/* Asus Vivobook Pro N6506MV */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


