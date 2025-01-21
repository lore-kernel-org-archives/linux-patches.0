Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FA61F5439;
	Tue, 21 Jan 2025 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482855; cv=none; b=PZjrgTeu4Nzw57RQgPTJMo/CliIXC+FNvJjo0HTKlXaGulOKQwrcQngf9gH11x8+9Q6+CEwH4NlVSE+6UVhGJKYmvyhGPBncLv5ZHlV3Y8Bu+yyrmHHe1pk3QtKguF9Rn5Avp4nZtiawAKFq611wzLmpp86r6BbHLDO7AJxqGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482855; c=relaxed/simple;
	bh=aOkyX8HyZLN4PyfEQHVZqDnpBgSu8zCQd+MraqZK0rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWkLdJITBMqA/jW4haTqBo/uS1Dtb9uIsvwurKr65poRNGw5jTMODRRPHVeRsZN1hK8FATGNNf0suVp6c97GT9ybfAUTq+MkB2D3kaqk4MS7nPsswAgpbA+40TgDSMSTujAI7ungmpLbe4OubMwd6aYIN+aCXLhdrACBAETW8cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axJRf+fR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axJRf+fR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A632C4CEDF;
	Tue, 21 Jan 2025 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482854;
	bh=aOkyX8HyZLN4PyfEQHVZqDnpBgSu8zCQd+MraqZK0rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axJRf+fRo/iQHzUWxSWyoAL3xruSSOOVu0+fbFoRaYK7vZ0whL5kRXe8BJv9RFQeU
	 N2o3Fh8bcggGkVPJQOx+Z9Cb9XfU4mFwk1Wgcrkcc9ZHuon2jAL1DrpPf8LrsAKbsQ
	 /KwoCBAQSn29CQ+mvGK0WYRrA4qNc7ejYdR+xcBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 031/127] ACPI: resource: Add TongFang GM5HG0A to irq1_edge_low_force_override[]
Date: Tue, 21 Jan 2025 18:51:43 +0100
Message-ID: <20250121174530.882685111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -618,6 +618,17 @@ static const struct dmi_system_id lg_lap
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
 


