Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5E61A58C
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBUqS4Mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943B0C433C7;
	Mon, 16 Oct 2023 09:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447063;
	bh=A7EIEdOqe8ky4IIBp5rKzi6JkBO5uI2JmBMDAUHFKZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBUqS4Mva3x56uIK0u3rMtpdW8kmlYcbj/4El+tdlo9bqtaAM7TvAT84JrLbm2L4k
	 i4ji7D/ZEs4782terQL7OFdBvErMoWv+kiZZBH+ymuNNWP+LzNhTsy1jiCGb3W1WT6
	 IewLG0k00q0whrPIKHZbXA1pgg+/KMoC0Rg6saWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 094/131] ACPI: EC: Add quirk for the HP Pavilion Gaming 15-dk1xxx
Date: Mon, 16 Oct 2023 10:41:17 +0200
Message-ID: <20231016084002.401940240@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit cd4aece493f99f95d41edcce32927d70a5dde923 upstream.

Added GPE quirk entry for the HP Pavilion Gaming 15-dk1xxx.
There is a quirk entry for 2 15-c..... laptops, this is
for a new version which has 15-dk1xxx as identifier.

This fixes the LID switch and rfkill and brightness hotkeys
not working.

Closes: https://github.com/systemd/systemd/issues/28942
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1888,6 +1888,17 @@ static const struct dmi_system_id ec_dmi
 	},
 	{
 		/*
+		 * HP Pavilion Gaming Laptop 15-dk1xxx
+		 * https://github.com/systemd/systemd/issues/28942
+		 */
+		.callback = ec_honor_dsdt_gpe,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Gaming Laptop 15-dk1xxx"),
+		},
+	},
+	{
+		/*
 		 * Samsung hardware
 		 * https://bugzilla.kernel.org/show_bug.cgi?id=44161
 		 */


