Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F63B3D382;
	Thu, 30 Nov 2023 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MeK4ApuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2829C433C7;
	Thu, 30 Nov 2023 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361994;
	bh=yRWu6OW5PiFN9PXiJAUupRjIm12QHvtB8pV5AAcdrrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MeK4ApuVQx8EReQyPGmT7u98/pdrmbpMCuZvu6p2MBf5zC2TlERrV7/QdI3IMhG8n
	 JIE2GoHVFAQWYnGewPiXZBMFAIY3nuCrZcZMLgdVmSKntP/FXvw2/sfA0gSRyTsuk5
	 HkyGCVKB+lY4bqZyJwythF7vT9792G/noChHpom0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 44/69] ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CVA
Date: Thu, 30 Nov 2023 16:22:41 +0000
Message-ID: <20231130162134.522717940@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -440,6 +440,13 @@ static const struct dmi_system_id lenovo
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
 		.ident = "LENOVO IdeaPad Flex 5 16ALC7",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),


