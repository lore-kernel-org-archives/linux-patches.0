Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23FC18E350;
	Mon, 28 Oct 2024 06:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097407; cv=none; b=Ux+93au53HVEnE7UOikGblnkJ0dbdL5WoWofEjlj6y5Ezz54L4dKp8oDH/Gkz7iFkcyYQW6b9GI/Av7gBGs4xpHHftLRVPyNhq5rYV21M3ObASQz4hBIyRu4cf6gMJEaSjUlMw7eL+as8NSZtJunCMOtyCDbT5vLX3sXc1R+VKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097407; c=relaxed/simple;
	bh=WqC2R+goD53iVlJH9hPTPOPvNIFxN1gXuNX1HScLTH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MY/BmVDEQ8VW6qFPO8oCuXhkAWq06AgS1LwCximbfIzZWMDKEJTaz1Jm7IoOlVJ7DRCtliKAt4BCPK9m7A3ia5IycV/LZaAtN78TZGaYKAtPt384sx4Bzfjfot+wCbDEEwsjIlxU3r8gKxF4+cGWvcQiWT1pzpKMF44BIHaZVJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNSpWz1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNSpWz1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14B1C4CEC3;
	Mon, 28 Oct 2024 06:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097407;
	bh=WqC2R+goD53iVlJH9hPTPOPvNIFxN1gXuNX1HScLTH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNSpWz1RRtQ+wbikDjtHE4mFm4YqyXEJmz202DbhOZLg00OwccXGdKf21RTaYvE5P
	 bTFc4obcKEWqMK6qeRA8xA5D0kobuqA6ogN7lrlDxSl//MucguLNRt1Qi4RBc8g47O
	 +cEyRzOfpuz0kEtEosX6iqC1m478X9+8qOIKK/O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Holten <dirk.holten@gmx.de>,
	Christian Heusel <christian@heusel.eu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 118/137] ACPI: resource: Add LG 16T90SP to irq1_level_low_skip_override[]
Date: Mon, 28 Oct 2024 07:25:55 +0100
Message-ID: <20241028062302.010426349@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -502,6 +502,13 @@ static const struct dmi_system_id tongfa
 			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
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
 


