Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E7E1779B1;
	Tue,  8 Oct 2024 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390854; cv=none; b=ikovWI2X4QAqym39IzgJTRx/E4xVD+aaNmtZnsNipSCkEy7enBNIhrFj8sb0bqViESzDfZ49XLqS43gHhRk1Wrxx/VF/03NT1SYkcSwpE4bPlaBDKKEWkVXTE96HvT4kindt8kEuuWu1z6BJZuiK98nSCuIp9IArLQNcu/7bCwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390854; c=relaxed/simple;
	bh=mTlk/bvVXCwyNnIIlhCH8wgC50d8ZVVm3cokhe7pKAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHKOoUDlE1kti2cMMzZYhX2eMDlI7qp7szcYS+w6elw64vjLa6egicUnx44f7UBs8SuYSieAk+GOVVhZooO7WTElcdCiAaHZEJKHT2oJtU0VdJdVV2hC87wZ+2/0/Xziy+WAKvWFqqVOzWvXS1Y/p/dTfiJ9RSebYMVSK5jjACA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZXmC16k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZXmC16k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549DAC4CEC7;
	Tue,  8 Oct 2024 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390853;
	bh=mTlk/bvVXCwyNnIIlhCH8wgC50d8ZVVm3cokhe7pKAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZXmC16kaW5TVcpO3fodAuyXUqL2chEyzLnceYLjAmNP+5PeNN8XXU0FaNdVOKonC
	 aZUDbrI9rEhOQ++51PenpWCT1ijKeyeG8oONUAUmdC3aVtKNjEIgpxukmlOQWeLizO
	 vbqEO6BTgX6/iOuuObSk7gk9vobTo/FU9NyeBigA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 413/482] ACPI: resource: Remove duplicate Asus E1504GAB IRQ override
Date: Tue,  8 Oct 2024 14:07:56 +0200
Message-ID: <20241008115704.657330411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 65bdebf38e5fac7c56a9e05d3479a707e6dc783c upstream.

Commit d2aaf1996504 ("ACPI: resource: Add DMI quirks for ASUS Vivobook
E1504GA and E1504GAB") does exactly what the subject says, adding DMI
matches for both the E1504GA and E1504GAB.

But DMI_MATCH() does a substring match, so checking for E1504GA will also
match E1504GAB.

Drop the unnecessary E1504GAB entry since that is covered already by
the E1504GA entry.

Fixes: d2aaf1996504 ("ACPI: resource: Add DMI quirks for ASUS Vivobook E1504GA and E1504GAB")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240927141606.66826-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 8a4726e2eb69..1ff251fd1901 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -511,19 +511,12 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 		},
 	},
 	{
-		/* Asus Vivobook E1504GA */
+		/* Asus Vivobook E1504GA* */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_BOARD_NAME, "E1504GA"),
 		},
 	},
-	{
-		/* Asus Vivobook E1504GAB */
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "E1504GAB"),
-		},
-	},
 	{
 		/* Asus Vivobook Pro N6506MV */
 		.matches = {
-- 
2.46.2



