Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071191F472E;
	Wed,  6 Nov 2024 13:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898259; cv=none; b=Li1hG4nxi0pK0Obc1VBFNqDf0BUmHGtTTnQcflYA6Mpv4Iw0unC9st+3tQ4vhUTVYQkYigHbkza1Mmt474eOukSmrYU+MUeF/0cHzlZxpas6+42jkP2ENCWcJwP/Sn+XctWrcSnE1oyF1z+DlfVbJSjoE0P5UJevNmrblag+K1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898259; c=relaxed/simple;
	bh=RHumeifFrFoOpKRHD9NBIvaMgvR9FrYjFgG+3GioQFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVxBX/fBN0/nLxegp8AhitAqlCp9hVetFnMUPhOHaxQPVkwooEClu9QkC6WAhKZZ3tQorbn2eIxBqRefNij7SmRM1HYLoubpGWwfKK8VHMhTxGMA1NMnic4WYD5JGsEXL4tAbWJe2t/SAbQOvL1P4+IjM5HbhjGn8w0kAJb3BqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaXtIwkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaXtIwkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B84C4CECD;
	Wed,  6 Nov 2024 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898257;
	bh=RHumeifFrFoOpKRHD9NBIvaMgvR9FrYjFgG+3GioQFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaXtIwkjukMIAP4Fvoi3aeg1RdrADRD0tgKeOVJwn4rSYqil61n7BnBGZrFq15jj1
	 eDckafnTY7JuXyTs3FKF4U+Jvgv5Csfh5X84Qlg8nLvcBecn8TipEieGRFhvke6da8
	 cUZ5+dl7q9YoGDhyHkjvsa99M+ja5TuQXpVYhNhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 150/462] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Wed,  6 Nov 2024 13:00:43 +0100
Message-ID: <20241106120335.217731712@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit a98cfe6ff15b62f94a44d565607a16771c847bc6 upstream.

Internal documentation suggest that the TUXEDO Polaris 15 Gen5 AMD might
have GMxXGxX as the board name instead of GMxXGxx.

Adding both to be on the safe side.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240910094008.1601230-1-wse@tuxedocomputers.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -456,6 +456,12 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* TongFang GMxXGxX/TUXEDO Polaris 15 Gen5 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
+		},
+	},
+	{
 		/* TongFang GMxXGxx sold as Eluktronics Inc. RP-15 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),


