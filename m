Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE3112A17F;
	Tue, 23 Jan 2024 00:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968785; cv=none; b=bbxwk1Nw8ir3RLfsQRWYy4jDBgqqJy193Ir96XlTy+GFuOGEwjODrEAxN9dCE+0NRCN6tMFrlvSq8Wft4RkZDw90Cr0vuOqlF1FV6t+x7SQWCkAi0CzgOuwBoDGRpwA02K3PgmZ3QFvbYOmsgIS0OIw7qjWQcBVI08WlFIYxsj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968785; c=relaxed/simple;
	bh=KuuMHEG79UcNNLToiC9dqtUFC1/fLnKaIMP4c6v7YuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAWKzElx30QB0pCmHskZ9DdYVuDewAu3An5x89tURqXBVYDxxfqRMsNSAGjBjCnv8NXflwKiuR5NqmrSe4C5/KRsXGR16+Npxwq2PTOzWpuNT3LOkrE8+H9/n7s1AtyJn4Ba0onAA6A8NFhPhxEtgpQlTGW15OlePG7pZE1ML10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsi2Vgz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsi2Vgz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0227BC433C7;
	Tue, 23 Jan 2024 00:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968785;
	bh=KuuMHEG79UcNNLToiC9dqtUFC1/fLnKaIMP4c6v7YuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsi2Vgz/uGiw6edZnMxqrmyefSH9zGEnh8GOQPMlNYDp5Nsdztp46rFQ0mZJBPzFJ
	 XlgPtykW0JBfp7xlKYfORra/iHaqGHkokJVzk5DRcUh+s8JaueGVg1g/28iy3PxKfX
	 xOpuuSbBRnvSHqgvWsZwGIzEQX6fBH53v6Sjfez8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Acuna <ldacuna@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 032/194] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Mon, 22 Jan 2024 15:56:02 -0800
Message-ID: <20240122235720.589913688@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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


