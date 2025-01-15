Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CDD248BA1;
	Wed, 15 Jan 2025 10:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937671; cv=none; b=E4G7fBTbN7XC52znMeeqBRH9qo7NIAa/7xCReWPGJR9GzubD2FxVY3zvozWvTrkA/zHosZt4hz2lgwk1nvpWro5VVs36cSQaVW45gtCE9pYE8Ooq8arbhoDty3ZzWtD/PAzyxNYFA0WPaAl5KrmWg5pTU1xqI0biV/lNRFS0hO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937671; c=relaxed/simple;
	bh=tPR4EXpXmgVOmYo3kqT9KgOT1eaFyPFVRsMDm1OWaH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WihTJMGV2Co6NqT/hDjV47tQfzywcwbFHpOJdeMUbbVQoLqfNjE3GxIrhbXrC1N4PPCougJo+e3p1OHKR3wWILAnWmKxaHfIMfwSBGHC+fWSQADFf6g27U+tN9/XpLRF5Z0qaNIgS6QUDDGSY7ufDLyTglp2m+4Q7FBy4kTzch0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3IScjhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3IScjhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AF5C4CEE1;
	Wed, 15 Jan 2025 10:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937671;
	bh=tPR4EXpXmgVOmYo3kqT9KgOT1eaFyPFVRsMDm1OWaH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3IScjhXvp7gaPSN6GoNr6NHNHZNSWDNhvo+RXbD4/0B0Q12gMrwrALH1iiDSuJTI
	 Zc/N2sJJlSVojZ7lYU6ByPs9vRcKNOTfwAaa1y/0ZNlZBqOaUOSeOPl558LK6O2l5E
	 r+q2I/zU7sDReaYHRINpQ3e00HQy+KRI9EHyBJck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 47/92] ACPI: resource: Add Asus Vivobook X1504VAP to irq1_level_low_skip_override[]
Date: Wed, 15 Jan 2025 11:37:05 +0100
Message-ID: <20250115103549.417272313@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -440,6 +440,13 @@ static const struct dmi_system_id asus_l
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


