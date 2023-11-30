Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B650754FAF;
	Thu, 30 Nov 2023 16:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlXzxcHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D515AC433C7;
	Thu, 30 Nov 2023 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361545;
	bh=YATGxVbVP/1ud/xjQviJFtgArN09l7loZPy0aSPJIRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlXzxcHPpB0/FQDbLcO8TF8Yuz/xgUYVwXTyIjwndK936qieX11VaydlzZg9gEbuZ
	 PqDT8X/0U2JhwGIPVbUN8xYKwI2y1XqDVO0W3YzgKE9l41obSOne8Ly0nbF6FWoKsJ
	 TQmbf+fwH+cggaPqQVb5dG1T9XdAptLVJ8Bhykww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 065/112] ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CVA
Date: Thu, 30 Nov 2023 16:21:52 +0000
Message-ID: <20231130162142.384687175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit bd911485294a6f0596e4592ed442438015cffc8a upstream.

Like various other ASUS ExpertBook-s, the ASUS ExpertBook B1402CVA
has an ACPI DSDT table that describes IRQ 1 as ActiveLow while
the kernel overrides it to EdgeHigh.

This prevents the keyboard from working. To fix this issue, add this laptop
to the skip_override_table so that the kernel does not override IRQ 1.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218114
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -447,6 +447,13 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* Asus ExpertBook B1402CVA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B1402CVA"),
+		},
+	},
+	{
 		.ident = "Asus ExpertBook B1502CBA",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


