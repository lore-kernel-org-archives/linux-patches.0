Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AB6381D6;
	Fri, 24 Nov 2023 18:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klexnqQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397FAC433C7;
	Fri, 24 Nov 2023 18:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851038;
	bh=xkFChtFnZEk4BQ7sQaQJBv/A9VsU8IL3+mYaaYkZ1/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klexnqQB2+HYYA1X/HhMqmxct806UiqfZqsk3LuuCOJZfKaxLhhnahRRU028aLZou
	 6f3uNFSyB0IKRvvPgXXpKKOHqPlpLQ7UQDeprR9VrA94VsQOzmnuCNf/9a1ZkA2JSi
	 J0ig23RFBaMFCHGJsT2im71jajOzOYkA4lZAH27Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.5 271/491] ACPI: resource: Do IRQ override on TongFang GMxXGxx
Date: Fri, 24 Nov 2023 17:48:27 +0000
Message-ID: <20231124172032.718204670@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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
@@ -496,6 +496,18 @@ static const struct dmi_system_id mainge
 		}
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
 		.ident = "MAINGEAR Vector Pro 2 17",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Micro Electronics Inc"),


