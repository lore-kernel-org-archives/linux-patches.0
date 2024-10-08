Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306471DE8BE;
	Tue,  8 Oct 2024 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393965; cv=none; b=YJZuGPw2/U6Ka2XDbBv1Wgh2wudayLDn70VCXK5tzsdFnpR4tBY/s2HdYlI/AHvSwd+SsRoHWQAMOt1rgjFRYgDE1VOnOieThPZI68Urz42AFOEr9nOd/WQ5LXrzSDqmFATVdIXySXyCsh0MojY2r1vE3WTHHJ9NiJt5k0Rr3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393965; c=relaxed/simple;
	bh=pZ6A1jFg54LEICjmxnTBEzqIciu5wpq/NYmpfNIeZZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIuJ+7KJkg2T/pV398iio1ADX0NkZuCYdXB96sjhNl7wQHfDyOAUGFEsOnOn5IxMl4OOIhwrRqF3dZQwomU+K6unEUw9AmK7/58Mjb4q0VL0lSuTonRs2vOXmfLrVvjUseKd9bMvcDByqB/DDwbhsaJJ6Pzr6KRpvvqoNZ8lBq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQ3zcbbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQ3zcbbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D5DC4CEC7;
	Tue,  8 Oct 2024 13:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393965;
	bh=pZ6A1jFg54LEICjmxnTBEzqIciu5wpq/NYmpfNIeZZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQ3zcbbSCcrARacfMoR/w/n3gF1WWTO6kKf9HPhlWc5m1jQm1mOGgZjqdTVRk89bi
	 SGg1MXmcUg7QhsSa5bdyVayHBZr/l40Pxu99B8GpuUpNvyuZ8+Q/9r5HDZXBvpvYSt
	 8gs8y7auEeeiYEup2W2JQqv/0SCIgH4plTFnzPB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 307/386] ACPI: resource: Add Asus ExpertBook B2502CVA to irq1_level_low_skip_override[]
Date: Tue,  8 Oct 2024 14:09:12 +0200
Message-ID: <20241008115641.465392524@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -510,6 +510,13 @@ static const struct dmi_system_id mainge
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


