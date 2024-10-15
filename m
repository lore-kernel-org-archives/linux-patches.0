Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CBA1CFEA9;
	Tue, 15 Oct 2024 12:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993871; cv=none; b=Q9hBUZ2twFvZqZd5DlxRUG/uoVGOaIVWfqX6Si12vwbIYVe0+6uJoEts3rFoAe4CB+PBceXHb558NDvrRXPB4zs+Yup51RIBHPNurZoryAju336uNv8CxUuLBpV+dNCla63L8fhE++tm9Mfm8eE05oW7unPOXEVHw1cRwqRrcuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993871; c=relaxed/simple;
	bh=57bMxCsQiWNVyZOSdUjZAA2aI3iUr0rE4wwktpdFpDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGavQX/3rvtm9Y/5O7Gmv3UdTeBL58sclri2KD2EMjTOOkM2sHaZbmCDxidk++7353dmizTOhdF2yHyMe5xFevivFhAt5S+lkTDafPAfoxW1PaXA73PCunt1EpvN0gX0v+grXrejz8kdfpi13tBborxn9rCFth4i/Oax2eyTwco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JutEZ5IL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JutEZ5IL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B8CC4CEC6;
	Tue, 15 Oct 2024 12:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993871;
	bh=57bMxCsQiWNVyZOSdUjZAA2aI3iUr0rE4wwktpdFpDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JutEZ5ILRaVWIZSErLCdUWqqjYFv1m3WpbkDuzB1gbCs2Spcad/ePVvl7agTiqsHF
	 RJtBP7sw0qFTHg7QbSvGHmJnbDeEdrtdYqdvhCKBW4xwE9uWyUdUbDfHV1CMRmtXap
	 z+Kz494Fok8BTVwv6pfkR4WIxDKrv7Q4E3JxU2ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lamome Julien <julien.lamome@wanadoo.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 539/691] ACPI: resource: Add Asus Vivobook X1704VAP to irq1_level_low_skip_override[]
Date: Tue, 15 Oct 2024 13:28:07 +0200
Message-ID: <20241015112501.733456925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
 		.ident = "Asus ExpertBook B2402CBA",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


