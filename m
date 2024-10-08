Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9B61DE4CD;
	Tue,  8 Oct 2024 13:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392705; cv=none; b=ka0fmRj75x52LAXPh960YTRUFp8KrLS3jeOx5atWTZVnUom2CP+FERB1pjGcFi+0NNPwLAsT9vCtt1ax01+WUGoxnONtwpnF7qZgMqBzPLq+phJGg9wr/s1UalY2znE8fZddhe6+CRvas/c8p3yonNXigGm17vxsXBapBjbWQsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392705; c=relaxed/simple;
	bh=0oL4L2HbTxYxqk5ptZHWeBmzkDwKG4IFrnQIzqqtOPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZbDDWrdMq6g59p/3yvNV4c/9fdDNkBbRv8pT8jqEQYRTHtUTWGGJ5b1dq8gnxFjd84uS3Ida+zE2VNb1sham1YtNuJx0hJGCigGvELlQBLpx6VnuoA4rKQMlW4Ko4RxWbUDNfHqlpR30Mdr0xHnhgb2gWscMS8RAQ4J7euqM2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYQJQvtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYQJQvtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8894FC4CEC7;
	Tue,  8 Oct 2024 13:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392705;
	bh=0oL4L2HbTxYxqk5ptZHWeBmzkDwKG4IFrnQIzqqtOPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IYQJQvtYwcXexNkYFhsfYcTFsSSznrxPB2wL082x7XE6vy8jUDfFPbuopMmZspe3s
	 lnk1z6YbGJuNmFoffFsi7+5Yy0xo6EP8KK9N+sZnYFQ0DR42lc0Ntjr2drOjkfm5yj
	 wktTTldVsknzuA5mRW53dgW1GYC+SH1Y7pRrsp8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 495/558] ACPI: resource: Add Asus ExpertBook B2502CVA to irq1_level_low_skip_override[]
Date: Tue,  8 Oct 2024 14:08:45 +0200
Message-ID: <20241008115721.709681296@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 056301e7c7c886f96d799edd36f3406cc30e1822 upstream.

Like other Asus ExpertBook models the B2502CVA has its keybopard IRQ (1)
described as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh
which breaks the keyboard.

Add the B2502CVA to the irq1_level_low_skip_override[] quirk table to fix
this.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217760
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240927141606.66826-4-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -511,6 +511,13 @@ static const struct dmi_system_id irq1_l
 		},
 	},
 	{
+		/* Asus ExpertBook B2502CVA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2502CVA"),
+		},
+	},
+	{
 		/* Asus Vivobook Go E1404GA* */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


