Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B1E248BAF;
	Wed, 15 Jan 2025 10:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937668; cv=none; b=fkHxubvF5crqmP1qY9prpXIor4wW4UeWxG2+DHmlUqWzs0L1eCZl4YIEQN1VDlmHEVeQo3MDUWIv7RrwUDLkEVnBLTHW3zAK+4F5IxyHjQfn1iXzgHQspz3EVTZpyYMgGW+fQnyjvx8hUbmS0B2/cmBdwNBhWQ3t3S7PRBV23lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937668; c=relaxed/simple;
	bh=NwhaqSIwEfbJEHXHshMtTc6+iCKyKDeaimXgt6xJzLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0N8qr17b/fquiJ2jHR1qiK4PHx6Pn8/p87a76U3udhV/IANl+W4LaYU5Qu3Vm7GuuGRmeC0KeL3BYztz8ELmVZyeO7ex9QFVuDPoOeDyHQIpvfTcPhuusFFPFB6d9yS6q8YHrQtcAOPpE4FO+1aeX4qtx1GK/91zHgPAPynrrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIlQBMHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIlQBMHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B49C4CEE1;
	Wed, 15 Jan 2025 10:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937668;
	bh=NwhaqSIwEfbJEHXHshMtTc6+iCKyKDeaimXgt6xJzLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIlQBMHb/cmdHntRWnmocV4KpltgS2kPU+j1YhPEd1Rb57wjTXgCnTPqtwEUL0MG1
	 tA5zr00i4M95wZtu6sr6Lake+oCORV1osh1zDyZJfLoHXZgkacnVQPk54qcjFIwGj+
	 LKrcGPH5IBMHivg0/JP6C0k+4J9792G4Z9D4rlmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 46/92] ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]
Date: Wed, 15 Jan 2025 11:37:04 +0100
Message-ID: <20250115103549.377507910@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -615,6 +615,17 @@ static const struct dmi_system_id lg_lap
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
 


