Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AC728DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1468Hkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4172DC433C8;
	Mon, 16 Oct 2023 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467978;
	bh=IXk/O+wbAFJBewtHKG28dgf7dSsl0fJmnfzOfGGnRao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1468Hkk16mtbK5Wp0gvkvBvwvyrVCZUPVBJMGfGT9/uNTRebBI0wAMQ2yE9tBVRl
	 HY/0ZEYj4ew7032YqpLxfGysTQLCCp0NsV5gS/YLsDz20x2WLdh0RSFH91JSY4A0GV
	 qmFbM2W4W4D1j7R9WlhCY6B+gEG/ZJJjOHdDeR/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.5 128/191] ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA
Date: Mon, 16 Oct 2023 10:41:53 +0200
Message-ID: <20231016084018.381188645@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c1ed72171ed580fbf159e703b77685aa4b0d0df5 upstream.

Like various other ASUS ExpertBook-s, the ASUS ExpertBook B1402CBA
has an ACPI DSDT table that describes IRQ 1 as ActiveLow while
the kernel overrides it to EdgeHigh.

This prevents the keyboard from working. To fix this issue, add this laptop
to the skip_override_table so that the kernel does not override IRQ 1.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217901
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -440,6 +440,13 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		.ident = "Asus ExpertBook B1402CBA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B1402CBA"),
+		},
+	},
+	{
 		.ident = "Asus ExpertBook B1502CBA",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


