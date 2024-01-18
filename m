Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934BB22F1B;
	Thu, 18 Jan 2024 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575043; cv=none; b=TamGUoR9KNr/hhGSEmgOm+kzSxj6PSGqXFdFpVor2XLaFDO0Gr8UPic5bf4PC41MZ+hy5nDK5apdkW1exqQeiFN80cuPyKLEececSP6sjH3CfAFTB8jbEtW3jPAFS53SLnUUSpjfApJZB/Vkw3NM997agZISH71fkjRNj5/AUzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575043; c=relaxed/simple;
	bh=xyB15rj1o70Nzqhi4TLaEC51iRZTrg72HNsy/gVa6KY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=nwnSh9Nu+WYuCPoGSISKUoYPXQIiMKiMxSs0YAic+hWhcTNAk6vRmedMZkfXuOqfcPd7qLs8d7ucVlGDou7Zg4xk6Q/jfD+xT6uBa+ikC0QZJyOqKOJx2y/iWHFszj6M7zUSin0KRLHjgQ2OYvbx0z13FNWIkMd0K8dItZzEots=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWD3ZFsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWD3ZFsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C40C433F1;
	Thu, 18 Jan 2024 10:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575043;
	bh=xyB15rj1o70Nzqhi4TLaEC51iRZTrg72HNsy/gVa6KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWD3ZFsr8/N9K53wdWpcaH3wgHBa+TWcLSMO+m6IUciklp8ZZDVtqmXWkg2VSxvoc
	 eTFUJV/56XOUA4bNxmGUKgS3J4BK+/fWaM4GelPnY0sVZ6zPO0MUF0yH2WMJs0jViV
	 gzED/Yt+WdJZvA50qMpzLNfASIxCsMQJ3HOjiYcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Acuna <ldacuna@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.7 09/28] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Thu, 18 Jan 2024 11:48:59 +0100
Message-ID: <20240118104301.551179383@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -511,6 +511,13 @@ static const struct dmi_system_id irq1_e
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


