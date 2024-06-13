Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A835A1448C1;
	Thu, 13 Jun 2024 12:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282972; cv=none; b=bvtfUfyhysl+Ik0pEsnvdFrJOshnaxNj8DvOIA42VxaXhhnYBihMP4xuMBpPY0E3a/hlHd7nBCWuEXeYyBf5Sm2qdGJ9zX1mZ/1L8BfBFBZo/eBpj7dH/6VuGXpM5kXLceV0xsqmOywGRcCklT/uBzLvkilBefY77G5mXCFx7U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282972; c=relaxed/simple;
	bh=NPK+TOgca1BHlBlURYQIDIbsJ6fSVsoAf/tQth6ZO14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZ1t69A9TBKAQ4gQRVOhU9OEzwfLDQNtKKNZjQGXsChut67wYNi+Y55lQBPRUIPffZtT1Lgx8IqksfS/ocssEwP39MFyIhJwagYPNMKgqLn2XdVfeFxYTIp6+m67ATS+qo9dhUx4tfgUdIzRB7BAqXV7dwz8XPtA+scacMpQSbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihO5TCy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihO5TCy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5C0C2BBFC;
	Thu, 13 Jun 2024 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282972;
	bh=NPK+TOgca1BHlBlURYQIDIbsJ6fSVsoAf/tQth6ZO14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihO5TCy4lPjZ4HAYi2NkPBi5UO5wDoTFZ1tVRZdE/V17clvANi9AaOJhUWbyFBF/v
	 KlslCDATy3oP+9rzIU+rXNEFJBkY2jYFCdu69njDjq1SGNlnLP05NaSRRD/zsMv8ib
	 SH7oq8l9JxDHq7wxrZunY1gMb1kvIBuZqZUgjqPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 24/85] ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx
Date: Thu, 13 Jun 2024 13:35:22 +0200
Message-ID: <20240613113215.074462167@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit c81bf14f9db68311c2e75428eea070d97d603975 upstream.

Listed devices need the override for the keyboard to work.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -576,6 +576,18 @@ static const struct dmi_system_id lg_lap
 			DMI_MATCH(DMI_BOARD_NAME, "X577"),
 		},
 	},
+	{
+		/* TongFang GXxHRXx/TUXEDO InfinityBook Pro Gen9 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
+	{
+		/* TongFang GMxHGxx/TUXEDO Stellaris Slim Gen1 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		},
+	},
 	{ }
 };
 


