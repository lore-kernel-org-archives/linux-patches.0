Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AEA1B21BB;
	Tue, 15 Oct 2024 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998314; cv=none; b=nNXVOdDWb+FZq6aLeD8gzTpNEGQ/opav7xKkMTMHX0Lp6vQrp5NG3jmPb39tsjAG0ErC8eYcQNS3J/9XubMrN/wfai0U0dnkjgB+qwaNKAfKohrpZq8SsRcpRVBBcmhwM4J1phEYgsHWgYyodqEB24Li4keFAH3sNmVdp0Fuvpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998314; c=relaxed/simple;
	bh=6efLnOEsna/a/j/yFD12JT8rjYhIGVTq2kUcz8HSjTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ePixkVxRiyw0EQ2GRs9JQH+UFREy0tTLzK1+0RFcpdWrrPsqQKsmxZ/HO9WrU/1xc6rMhZDdXVRyIdNl4KFnYgniq0XKf+eLMvtvs4xsY+6JpOB1CtOoTOBGJP3pdNFzaSRl3dUM3gsIj1j6lFh8ZYVAhy6VkfrFgLa6ARtJ3jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiI4huPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiI4huPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ACDC4CEC6;
	Tue, 15 Oct 2024 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998313;
	bh=6efLnOEsna/a/j/yFD12JT8rjYhIGVTq2kUcz8HSjTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiI4huPEdobSeaOpQSDeAmNXxDiF2W3H/O3KC/g2jQ1hAle7DrgdZJ7hKB9qENP2h
	 DH6p/WnHrF0aGaAFjklyPDFDODKRPSbcR5iTBlHzG/xF5WpGWYiHchw7A9tLnrXlWn
	 qOa3LKyyl6+zoPy88u67sTw1Lh7sAgN51SlW9bzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 411/518] ACPI: resource: Add Asus ExpertBook B2502CVA to irq1_level_low_skip_override[]
Date: Tue, 15 Oct 2024 14:45:15 +0200
Message-ID: <20241015123932.846063531@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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
@@ -495,6 +495,13 @@ static const struct dmi_system_id asus_l
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
 		/* TongFang GMxHGxx/TUXEDO Stellaris Slim Gen1 AMD */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),


