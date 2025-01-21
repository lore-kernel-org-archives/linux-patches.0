Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5721F540C;
	Tue, 21 Jan 2025 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482860; cv=none; b=MtomA5m0eHrU5tvWCnQrL8kt9Gkodm9cqOG9YfHogG9Kcw+eLDyKWUYbSV1fHLTcLejwY5sJ3NLmtHra9pv2k06kLMS6ecBowQDivUZn6ikiSGsjORXuoSqPpv3dwrwV2nTPhuLWpsEcovGpwY+ZWIc5hhamCtBiM339MUH1ht4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482860; c=relaxed/simple;
	bh=s8UwKUtOzwoEnpMBsAsHza1DH/EeL1cD/6MDBTZrFDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5i9f2DkgNqJoSOupx0+5D/J07EADUipj8Q2wkwLAfWJj9Lknlr384ruEetZOcIAY7Y4z/y5RF49xUp7fG/GnQE/nDarlK8dO7geibSaRR1tEd/TzA/E60g1HwMGhnJHIunmogRW6DJuLW4akFazKafk1DmW7Ilw9Xqyw/oOyo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWj5FQi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWj5FQi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447A6C4CEDF;
	Tue, 21 Jan 2025 18:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482860;
	bh=s8UwKUtOzwoEnpMBsAsHza1DH/EeL1cD/6MDBTZrFDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWj5FQi8f7Sz0INMTTZvLbkas+95wXzhDi0ZDh5GatfW74+sGwDOpAyHznYveysKT
	 pm03UzbMORV4NUOAkLmQlkQCvrOgkOe5M9pOLKfEAckJ6FBDSh8CX5TEJUc3VL8luI
	 UpiGG4xvsA3keETyT/2tqXmNUS7VQjj6xvdsERvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 032/127] ACPI: resource: Add Asus Vivobook X1504VAP to irq1_level_low_skip_override[]
Date: Tue, 21 Jan 2025 18:51:44 +0100
Message-ID: <20250121174530.923963123@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 66d337fede44dcbab4107d37684af8fcab3d648e upstream.

Like the Vivobook X1704VAP the X1504VAP has its keyboard IRQ (1) described
as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh which
breaks the keyboard.

Add the X1504VAP to the irq1_level_low_skip_override[] quirk table to fix
this.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219224
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241220181352.25974-1-hdegoede@redhat.com
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
+		/* Asus Vivobook X1504VAP */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "X1504VAP"),
+		},
+	},
+	{
 		/* Asus Vivobook X1704VAP */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


