Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885201FA26E;
	Wed,  6 Nov 2024 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896699; cv=none; b=U0B8XDcbSKuAinNaoP54/qRtzO2fXroNVWbHXbVCNFlCER0Lc3RztDknb7A/ZNX5vuzkB0KmEzyQ2aLkjAJkm2YOSAcoYXjuAlJUkDRpc+5y5ysMVUr+pxOwbi9dQozxY5nCztQHlLA2HvE5f3VyedtMxNpgMP9L0iLhMkzc4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896699; c=relaxed/simple;
	bh=p5XbARGB8oa1Gdq+kMOMknkzATbAcXtojPEFFvDZ1Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTjP4W4U0eFRsM50pBjkVLdZqAYpL0ZFDGfSI/rAfrbBBp1SSaO42boXuORhWJkhlNWcNY4RY+e4RHIFMfhHK1lFnK3/RTxp8aBBTe1KY1/ybob97mF9w8hqgwdz+bEjeHSDQv6K6hxb2QDjdHX5/IB/UwAiyaPyvD5uSzu3WQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyXXulcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyXXulcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF47C4AF09;
	Wed,  6 Nov 2024 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896699;
	bh=p5XbARGB8oa1Gdq+kMOMknkzATbAcXtojPEFFvDZ1Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyXXulcwGVmgRoNKZN5kbo2xAW1nhGPl5/7qI3fT0aS46thHaecHt2tDcwNWW2/52
	 gwid1gnnA0LqkeykaNja/F2bCkkU/owfXwWbBTb/NZeBktCVKclkPTpY32SAyGOScv
	 2hUbb3HVbbFXrFBIOksW/fNVN6FZCV3CtuI/mgHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Holten <dirk.holten@gmx.de>,
	Christian Heusel <christian@heusel.eu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 044/110] ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]
Date: Wed,  6 Nov 2024 13:04:10 +0100
Message-ID: <20241106120304.419795938@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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
 


