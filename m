Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B7E60261;
	Tue, 23 Jan 2024 00:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970895; cv=none; b=P/uMcShl0chI7Th8MSgK/2W/P3UyC6UE/Idsx1JGFfrp/igzh0QXWRzcO0yymyQwvGVO7+SlrnJchAq0sgaWYCSchonE2AZ5FZGi8H+Idc2b8iZgOvIUf7oRiYPnDU5UOPNyms/gHiDXw+w1Pw2+WuElQj1Ew8ceicfXHHETBUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970895; c=relaxed/simple;
	bh=hABojjeCaazRy+1jm6aN7wYwscOuZ0btt5iPNjoZr0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMtPGSHUWm1GSrTTlALj40EDYjPbRExxY/wkujLDXPVELwnGKjS+/T00YPIC3Xkfuvq0e2PGZEixy7Llcm8wkv4VFxr0t2oIPK+yJgMIsUxBU/ekoT9rR3qDrwg+ff+rAS63Va31YHmvEYvyDe2/igqVEnQJxZRCwJyUzSZEQ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPrYG0zD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPrYG0zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9D3C43390;
	Tue, 23 Jan 2024 00:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970895;
	bh=hABojjeCaazRy+1jm6aN7wYwscOuZ0btt5iPNjoZr0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPrYG0zD5FXUR/AfWujPvPbD8RYA8hXLGYuf2C1wZtwc1STxpJb8oGbkhMeycbTEv
	 C116/Fm4UtmDsaKTUPc+AN7l5IXtvdpfrG4svXdOCygr3tSlFxje6m5OV5RjSuAKVE
	 1l1le3gtQRe+96LGTNfou8cR88uq7ekRAcDY5BxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Acuna <ldacuna@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 040/286] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Mon, 22 Jan 2024 15:55:46 -0800
Message-ID: <20240122235733.557161759@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit df0cced74159c79e36ce7971f0bf250673296d93 upstream.

The TongFang GMxXGxx, which needs IRQ overriding for the keyboard to work,
is also sold as the Eluktronics RP-15 which does not use the standard
TongFang GMxXGxx DMI board_name.

Add an entry for this laptop to the irq1_edge_low_force_override[] DMI
table to make the internal keyboard functional.

Reported-by: Luis Acuna <ldacuna@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -456,6 +456,13 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* TongFang GMxXGxx sold as Eluktronics Inc. RP-15 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
+		},
+	},
+	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GM6XGxX"),


