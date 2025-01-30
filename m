Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140E1E9B00;
	Thu, 30 Jan 2025 14:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246723; cv=none; b=B/AyVwl8pbr6mqFHTJdhm1he7A8ZFW5qXFuC3YhVHh/fqKSonn2CjPTd0xvSI9MgrHucxz+2bj0h9sOPrW2OHJAP6Oo/icKri4CUZypY3o9gNZDJYnha7TubkSub3BoUdX4yIHXyQKx5GWGNAbDUKm5LbWPGBGhVaQR8cbCp/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246723; c=relaxed/simple;
	bh=esaLkNNwb4X2vx6345dLn//+lD7Yk/gZ4n36iid5fjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iijFqyKKdKA7aA+v0ZU3cEbdk9Fc24tWgC066CuS70V2xN1cQu6uaYrRfHNiSXjAszMuT0lnNGIM2lL6jFowoY1a652uT63CHkAxZRwFeNbQuapL3ALlmoBrJ6Mrx3MjLHklyWDrKIQ7ox7ZAP79UzVcC1BiVSNFPDMx8RSXMfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4szNzAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4szNzAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13807C4CEE2;
	Thu, 30 Jan 2025 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246723;
	bh=esaLkNNwb4X2vx6345dLn//+lD7Yk/gZ4n36iid5fjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4szNzAqd4Ng3eSSUVsjQmFIDHd1yJXa8G6bNIY3T64b13RtlPNJqpA8+hHgBx82v
	 /lq+7Xun5tV8u8iOjcBTSbj9ZszyZx2f1br9CyENHwX2oqWp+BfmObnO2P9Ycb3Ogl
	 pYTlm4WaNFnC/+yxh+6EQf81GMRwe7Vo+F9Suw8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 15/91] ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]
Date: Thu, 30 Jan 2025 15:00:34 +0100
Message-ID: <20250130140134.274257056@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 7ed4e4a659d99499dc6968c61970d41b64feeac0 upstream.

The TongFang GM5HG0A is a TongFang barebone design which is sold under
various brand names.

The ACPI IRQ override for the keyboard IRQ must be used on these AMD Zen
laptops in order for the IRQ to work.

At least on the SKIKK Vanaheim variant the DMI product- and board-name
strings have been replaced by the OEM with "Vanaheim" so checking that
board-name contains "GM5HG0A" as is usually done for TongFang barebones
quirks does not work.

The DMI OEM strings do contain "GM5HG0A". I have looked at the dmidecode
for a few other TongFang devices and the TongFang code-name string being
in the OEM strings seems to be something which is consistently true.

Add a quirk checking one of the DMI_OEM_STRING(s) is "GM5HG0A" in the hope
that this will work for other OEM versions of the "GM5HG0A" too.

Link: https://www.skikk.eu/en/laptops/vanaheim-15-rtx-4060
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219614
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241228164845.42381-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -514,6 +514,17 @@ static const struct dmi_system_id asus_l
 			DMI_MATCH(DMI_BOARD_NAME, "16T90SP"),
 		},
 	},
+	{
+		/*
+		 * TongFang GM5HG0A in case of the SKIKK Vanaheim relabel the
+		 * board-name is changed, so check OEM strings instead. Note
+		 * OEM string matches are always exact matches.
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=219614
+		 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_OEM_STRING, "GM5HG0A"),
+		},
+	},
 	{ }
 };
 


