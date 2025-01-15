Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938C1248BC1;
	Wed, 15 Jan 2025 10:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938223; cv=none; b=i9+XTfCMgENnc7/TmfiU+BSJvm47QIG0YI7g81TvncSJ0Zys+l7uc8T1/RvQCoFDUmNclbuoUJPBV8zbN+XqC+1b1mJ7CSkmuYYqb/INoMBZXHeNEsG6EShCgdCKTeUwDhFUMMnApkOa6vLmREp7oyyuqN5NNpw7CIRJgWaTWQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938223; c=relaxed/simple;
	bh=W7FJ7JQT468TZ2B7eTmlsl10j1EY6NmEbLdkn7dRbkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oka9NbPb4AdXxaWF7EwFrO1blDK48Lr7ex3LO1HnjTxqwH1AYjFehpDGNDnGhJpqZJRWW3AChLmTgVrjSeekTId1ljbEgNDg3qP3C3+Pztx7uKu0xSNtHEE5Gbgsa4NxpoPFuc7EXE1Er6Inl1TdwgAjobRc/6fw8NlHyFa//BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr7GYU/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr7GYU/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA48C4CEDF;
	Wed, 15 Jan 2025 10:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938223;
	bh=W7FJ7JQT468TZ2B7eTmlsl10j1EY6NmEbLdkn7dRbkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr7GYU/TvQBOjIU/E8IxH9OH447hLYX3v8sCF+7Rg6E9Ca1x1Y1CTFqhrsVgqSuQn
	 9S0XH4LH7s384ckL+ktRQ2cIHUxrg2P/xAwwRpSIFPNcv+m/pRD7rkzivKacMGbphx
	 HeYcv1KwYlRA+rju13usFuLaqkb0Khb7Z2g4COpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 119/189] ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]
Date: Wed, 15 Jan 2025 11:36:55 +0100
Message-ID: <20250115103611.208479006@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -646,6 +646,17 @@ static const struct dmi_system_id irq1_e
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
 


