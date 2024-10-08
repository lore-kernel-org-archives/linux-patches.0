Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EB51DFD1;
	Tue,  8 Oct 2024 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392702; cv=none; b=eUMVDAVsBsFt54yN36u16HIbuPLESWnUDR83S0I0m6gnDFD/h0r+F4CT6QSyHUnPiAue9npW0f78MSFiEa1Q1MbaJnlwaAODPyloggi/yOEhbEROIu2csRulqIg9d2EvM+QKj1fl/YWyyGPHwraOYiN7pDtMGJXrnrtk0O1RvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392702; c=relaxed/simple;
	bh=LTPvT39e4JSW7kvYKP1gqwshuKqeNnBOcN+IQl6Fj+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fdr9X/0NsscBReNcwLbjZZusCuz7EfoOmQfJlEG6lNAQEqregvOe1IJQ7Qos/IhDTRLlMjS9Xt12cByWSiapk7gk1Ob+37m2Fp0AaKE7ixxGBYH9IDuK62BlDkiIN/jNjJcew8F+3BJ3Hay0CshfuBSglFwKIxXaDvUcO19qGxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18bQ2UCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18bQ2UCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C17FC4CEC7;
	Tue,  8 Oct 2024 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392701;
	bh=LTPvT39e4JSW7kvYKP1gqwshuKqeNnBOcN+IQl6Fj+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18bQ2UCr2czp8+XkUw3cyr7HJJ3ojTzKIr4keIdmr2cKQI4ehPyyAI8nmhDCmReOx
	 +FYVUe3ielMmhqzGTqcxIvDR6QdcLngOFNHKOY2hD+eiwb7xWYWAHZF3e/rB24kvR2
	 rZwNqv1AotOabQ3uEEDmPRwJ9Ra/yIMXTvCc4QUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lamome Julien <julien.lamome@wanadoo.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 494/558] ACPI: resource: Add Asus Vivobook X1704VAP to irq1_level_low_skip_override[]
Date: Tue,  8 Oct 2024 14:08:44 +0200
Message-ID: <20241008115721.670763468@linuxfoundation.org>
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
@@ -441,6 +441,13 @@ static const struct dmi_system_id irq1_l
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
 		/* Asus ExpertBook B1402CBA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


