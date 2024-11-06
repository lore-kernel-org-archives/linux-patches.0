Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECF54765;
	Wed,  6 Nov 2024 13:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898977; cv=none; b=emNyVdxy8kTLOc1qybcBIzIp/6LexnJyzJ2qm5KucKfi33VAkjKKRAI5ODemmIcFZj0EVz7HcWfo/E9sa5dvRZ/3H/TpQ+mv4lStf8xMbQhTtLFtktOXGx7rmNCrs84wOJmv2zNK7kLhorChWXgNe2lnWuoFMhaYZh5ulCeiHC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898977; c=relaxed/simple;
	bh=SAB3BMMm2pqvkH4i3LHyj21eE9Gk+l5SF3K2j14YYxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8K6ghP33Ce2DYf5sVDm+oFRi/k9XKInkXi0/PEjDo+QRtftYRKFWtV+4I+eQx7AkcB10a1bdllx35JLVDxtrM6waHCOg2rvnHkIugau9FpC71H6Lb+6hPaDsUlk00q6V/yX7a3yZU73tu5y60z52HWopijjMJqnjcsP1FCnaFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6RrWny5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6RrWny5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFB4C4CED3;
	Wed,  6 Nov 2024 13:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898976;
	bh=SAB3BMMm2pqvkH4i3LHyj21eE9Gk+l5SF3K2j14YYxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6RrWny5zSaPmZIetBKiqUan1R+5YPRlPAuDBqp4uUjq0/grkKnG79eytECFcEQBb
	 beIq976rHCQm2ha1uS+myh8zDMxilhAImxLJ3OfTb5oQFMcd05B5u6Q1qFQGLgzaAj
	 xibL4rcswmQkzVOpxKd30QLYRIY0Dycur5lV6C7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Holten <dirk.holten@gmx.de>,
	Christian Heusel <christian@heusel.eu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 418/462] ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]
Date: Wed,  6 Nov 2024 13:05:11 +0100
Message-ID: <20241106120341.840122720@linuxfoundation.org>
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
@@ -507,6 +507,13 @@ static const struct dmi_system_id asus_l
 			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
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
 


