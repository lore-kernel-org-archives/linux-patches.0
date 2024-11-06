Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052C01F4FD4;
	Wed,  6 Nov 2024 13:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898654; cv=none; b=g2H8RMM0o30Stq4Vr7H5M9OMUI+7QNbvMIKe5t5A+9ZC14I4mpfQjOv++0wZBptMt5GsD/7MVehTCJywStPrbwbgSOSKtcVw8UTaFb0GM8gdgMSnGBKzlgCeudi4rtFqOv3Q0aZ/OS6cyByXEdXRcUkg5D6QuR4un9phIi1k3f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898654; c=relaxed/simple;
	bh=8v3UEVbsAXkRsHJ5uu+TPxEcfo/PcY0p0WQYo4Nn4VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW5b5JOV3R/k4MVcCvduIZuUl3+0guHde0GpAHFI7lXPoVJ4iiPFkTHyXYcLanereA0vxFwYEPAppa54IwZOEBsdPTwHIC2WU/lnrMdtO2W6lC6dDHR9RpeFTK5w3eRY+RF5X8S5WbSsRQVx4wcSzomBmSpRuUF2+B9/0zw3NxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFHtKyIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFHtKyIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F744C4CECD;
	Wed,  6 Nov 2024 13:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898653;
	bh=8v3UEVbsAXkRsHJ5uu+TPxEcfo/PcY0p0WQYo4Nn4VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFHtKyIa/3aRfeUwLwpoStUYYYNay1gE8lG1EcszXH7NL/uy7pyrq18SIeeUjhW4L
	 dQq+ylDtZic5zETOo29Kby0MGWQ6DAx4XYLHiwOd71wTEw0/hCt9/Ekyk9em760t+L
	 n0vteA0Q30k1VyWD1pTUvkXwc5MstIOUey3CjW4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lamome Julien <julien.lamome@wanadoo.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 275/462] ACPI: resource: Add Asus Vivobook X1704VAP to irq1_level_low_skip_override[]
Date: Wed,  6 Nov 2024 13:02:48 +0100
Message-ID: <20241106120338.319224181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2f80ce0b78c340e332f04a5801dee5e4ac8cfaeb upstream.

Like other Asus Vivobook models the X1704VAP has its keybopard IRQ (1)
described as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh
which breaks the keyboard.

Add the X1704VAP to the irq1_level_low_skip_override[] quirk table to fix
this.

Reported-by: Lamome Julien <julien.lamome@wanadoo.fr>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1078696
Closes: https://lore.kernel.org/all/1226760b-4699-4529-bf57-6423938157a3@wanadoo.fr/
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240927141606.66826-3-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -443,6 +443,13 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* Asus Vivobook X1704VAP */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "X1704VAP"),
+		},
+	},
+	{
 		/* TongFang GMxXGxx/TUXEDO Polaris 15 Gen5 AMD */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),


