Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05431D8DEA;
	Tue, 15 Oct 2024 12:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993874; cv=none; b=CgbskxGGuF+VRJcUDjbQMp5i+2TfA0JfJh8nLSl/dC/WGqrzI5rTrbwqC5TautopKYG2g3z1OU/uR52VvVpiz5H9zQxjWfpBWCI8fpYjAgB+b3Knk5HuyIg9W9cHAlnK06zMs7A4F39cxpuYzth33+T6xFcLPFg+9Ra4Ia0Mnko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993874; c=relaxed/simple;
	bh=qalimmjQjFH5e3M+Yz+gMNVgx3tWLmliaa3u8YlWl/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6KeoFpU97NKfHiOpI7qKIX/JfKWbyiI7OFL9ZrOq3FlWfKKBSBZSPtvWPjH1CPwVBBuxYDlYVF4m9TNgPqDMHiZVEn0opp7DApoNxAUuOeDpoSTRKB6m9fbzVGoCYyfooYTENz89C7J2A2fGYQE3BH0YnqdLDa+pehpj6IzvCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0O3a4ttU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0O3a4ttU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1825DC4CEC6;
	Tue, 15 Oct 2024 12:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993874;
	bh=qalimmjQjFH5e3M+Yz+gMNVgx3tWLmliaa3u8YlWl/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0O3a4ttU62qcd4qDFhWM+kL1E9WmDyqGLsl2plLgzB/FVI8JZkpig192aB5JdVcJJ
	 TFL8R/55T7g8AxaV+wZ1AKwtWqQRBvEKNujWEOkU54io0lvZQjbX8SZ22xsb4doud7
	 cx958CCK0gtQ428XHhH35yItbiVZir2jxFOuVF0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 540/691] ACPI: resource: Add Asus ExpertBook B2502CVA to irq1_level_low_skip_override[]
Date: Tue, 15 Oct 2024 13:28:08 +0200
Message-ID: <20241015112501.772477299@linuxfoundation.org>
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
@@ -517,6 +517,13 @@ static const struct dmi_system_id mainge
 		}
 	},
 	{
+		/* Asus ExpertBook B2502CVA */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2502CVA"),
+		},
+	},
+	{
 		/* TongFang GMxXGxx/TUXEDO Polaris 15 Gen5 AMD */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxx"),


