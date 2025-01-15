Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE5E248BD1;
	Wed, 15 Jan 2025 10:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938714; cv=none; b=dVIkAkWEtSWJRpkDsKZI4n/L+AG7hIygKbRyT6G8PVNuIlzt4pS22Ypgm2jj/lnZ8Gz/zBeW+eELylmq9I9qqv+7OIrx6iyRS3/NsGcMgnttHGi0LEIy+P9jCQcDDJ+3SigAnwPNIfiPXq8G+stDyRlLn+uJBNwz9aB52O+mMe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938714; c=relaxed/simple;
	bh=TnNWTqW/cGyK2ln5xxBYRoIumIiz1nsyWryfLW6rYr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2cqi1kx7ih5AVp6c7Nzac/QLyAlebt/fngbMXh/gHIZGF+TbXgl/K2WoOBppIUoRs9pdM9Mp/dXamDEM9HUL86u8mp+1W8IK4jsX07Lu64DPO9Nn243cpmexZ+a3w3VhdnLZSX5+luAKxm3NkYbrZgjfDgFfmFTXJL6IP4xNpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WIjefYB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WIjefYB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C91FC4CEDF;
	Wed, 15 Jan 2025 10:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938713;
	bh=TnNWTqW/cGyK2ln5xxBYRoIumIiz1nsyWryfLW6rYr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIjefYB5X0KAdjpgl0FFXynRZPqR9MMvNzRLY7j80vZkkKo17N8FMjTUxyZaVzU69
	 4UcBLjSDHdb8zQNKfjBb18NyoYHfP6CfGmIZ3p+OFrHvaCxPsNu7wxBzj3aN+WgRqD
	 qgZoG9//Zor5vn/DT1JFsSPbPLDay/B+gaseBcc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 072/129] ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]
Date: Wed, 15 Jan 2025 11:37:27 +0100
Message-ID: <20250115103557.249277532@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -633,6 +633,17 @@ static const struct dmi_system_id lg_lap
 			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
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
 


