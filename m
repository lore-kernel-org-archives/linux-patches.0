Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCA92E84A;
	Fri, 24 Nov 2023 19:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIoJU9j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A31AC433C7;
	Fri, 24 Nov 2023 19:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852747;
	bh=pyql9RvRpjKLP2bl11wc352upFzG7JxGOXWzxjzRbn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIoJU9j2kDqmUYeDyMVvD8slLXz8vpDoh6ybC/vuXwOZOdSqptQBwMcWtXsKsX7Ve
	 uapp7qrvAkOg+zp0/c5XEua/YJAx380BTokkhdABaRZ2wBZ8eM3Nc7b+twmn2LfEGX
	 BXlNZ7QsbN2aDjfUmr6bj+p+IUne8E64VlK2qmmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 106/193] ACPI: resource: Do IRQ override on TongFang GMxXGxx
Date: Fri, 24 Nov 2023 17:53:53 +0000
Message-ID: <20231124171951.482659474@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 0da9eccde3270b832c059ad618bf66e510c75d33 upstream.

The TongFang GMxXGxx/TUXEDO Stellaris/Pollaris Gen5 needs IRQ overriding
for the keyboard to work.

Adding an entry for this laptop to the override_table makes the internal
keyboard functional.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -443,6 +443,18 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* TongFang GMxXGxx/TUXEDO Polaris 15 Gen5 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),
+		},
+	},
+	{
+		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GM6XGxX"),
+		},
+	},
+	{
 		.ident = "Asus ExpertBook B2502",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


