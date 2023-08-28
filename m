Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CD211C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DC3C433C7;
	Mon, 28 Aug 2023 10:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218110;
	bh=qN5xTVdTYfTan9vc4i7C+M7EecBAKWmnopQrQdoR9uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4efKySDDdIZ7ntrwgmXxhew0S9D+rvrEv5480nEvoCoiQFSJxVEKpsXj+M+X3mWD
	 ucWtzenKP4Z2oqvOl3CtqzPev7r2mefQwLcNDPXLgHIBrsxJiXogpnr8mlMLZX8SU4
	 LFzIAm3DYC6RdsN7B36g40FV0M71VU2ofXppM960=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.4 098/129] ACPI: resource: Fix IRQ override quirk for PCSpecialist Elimina Pro 16 M
Date: Mon, 28 Aug 2023 12:12:57 +0200
Message-ID: <20230828101200.603469172@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 453b014e2c294abf762d3bce12e91ce4b34055e6 upstream.

It turns out that some PCSpecialist Elimina Pro 16 M models
have "GM6BGEQ" as DMI product-name instead of "Elimina Pro 16 M",
causing the existing DMI quirk to not work on these models.

The DMI board-name is always "GM6BGEQ", so match on that instead.

Fixes: 56fec0051a69 ("ACPI: resource: Add IRQ override quirk for PCSpecialist Elimina Pro 16 M")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217394#c36
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index a4d9f149b48d..32cfa3f4efd3 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -501,9 +501,13 @@ static const struct dmi_system_id maingear_laptop[] = {
 static const struct dmi_system_id pcspecialist_laptop[] = {
 	{
 		.ident = "PCSpecialist Elimina Pro 16 M",
+		/*
+		 * Some models have product-name "Elimina Pro 16 M",
+		 * others "GM6BGEQ". Match on board-name to match both.
+		 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "PCSpecialist"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Elimina Pro 16 M"),
+			DMI_MATCH(DMI_BOARD_NAME, "GM6BGEQ"),
 		},
 	},
 	{ }
-- 
2.42.0



