Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727E82AF07;
	Mon, 28 Oct 2024 06:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098509; cv=none; b=DYzAT4hSKpZm7/mtZ1MYKIieQaKtOXMIFwL85quOlUQcAoBlGA9VCPAPLvJQK95J9FZo3eFW3YRFZaatX4YjnpLam9foNnNgKj4E1wlbPhe+rowfKqCKpfCsXPGClrlZ67jQm/4wDthQ4rsUjYary6vXzfnb+0zSBYHFP0LPAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098509; c=relaxed/simple;
	bh=CKtnxhp3CRTzFGx6wLJY3LT1YGd/M2nxh8zi5efYBDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZNBVyLN7Bch+qPAn1r02js8USxizCzNwWuc9M7fxONp3Tm6lUqs2HP+LR0xeary/jKtA4d7qrGFB6BIpLoOA3Qp+amCj26LIGb8XYTSQIC3fXTjEQfukuMJHsM6Cbrs0ibYSqrQQzALZ349KlJX7hYOPPiFakbksGp4Qj5cQug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNlOWR7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNlOWR7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B879C4CEC3;
	Mon, 28 Oct 2024 06:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098509;
	bh=CKtnxhp3CRTzFGx6wLJY3LT1YGd/M2nxh8zi5efYBDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNlOWR7F55exoS2msz34fetlLPSgyMidC+B7eSvRn/GasdcT/1j1W975wYU//BP8A
	 Gzik2WN42xXUwNqIZJlnHhVUPfn9d5Anp+OQCVFyC7f3WzoEpUCj5Vwr5B2LCInRTJ
	 b+8Iq0kpJgD4ygrM1SxeTuShSWIt9QGrXDa5PKak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Holten <dirk.holten@gmx.de>,
	Christian Heusel <christian@heusel.eu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 211/261] ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]
Date: Mon, 28 Oct 2024 07:25:53 +0100
Message-ID: <20241028062317.369854710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: Christian Heusel <christian@heusel.eu>

commit 53f1a907d36fb3aa02a4d34073bcec25823a6c74 upstream.

The LG Gram Pro 16 2-in-1 (2024) the 16T90SP has its keybopard IRQ (1)
described as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh
which breaks the keyboard.

Add the 16T90SP to the irq1_level_low_skip_override[] quirk table to fix
this.

Reported-by: Dirk Holten <dirk.holten@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219382
Cc: All applicable <stable@vger.kernel.org>
Suggested-by: Dirk Holten <dirk.holten@gmx.de>
Signed-off-by: Christian Heusel <christian@heusel.eu>
Link: https://patch.msgid.link/20241017-lg-gram-pro-keyboard-v2-1-7c8fbf6ff718@heusel.eu
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -538,6 +538,13 @@ static const struct dmi_system_id irq1_l
 			DMI_MATCH(DMI_BOARD_NAME, "17U70P"),
 		},
 	},
+	{
+		/* LG Electronics 16T90SP */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LG Electronics"),
+			DMI_MATCH(DMI_BOARD_NAME, "16T90SP"),
+		},
+	},
 	{ }
 };
 


