Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94A1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CCCC433D6;
	Wed, 23 Nov 2022 09:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195748;
	bh=NssqwD5/Gv4Zq01FZfPoyFmZ9zR/cF/rab9d/sMdA+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3PCH9kXmo3/5sfhwLn05ohaXaLchaxC1WmzSQX9F3ypgGGoD2982llrZQaR67ck1
	 GKZzuOmsM9AlBEtrTpzIrCsfIv2lDigS0f+OrUXubw4JrSh/8XkP+W/ZnF4P8fU63N
	 SGVcYL6KIv5UOHtcrFP3CwBRBoqnAS03Ec+g62OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/181] ACPI: scan: Add LATT2021 to acpi_ignore_dep_ids[]
Date: Wed, 23 Nov 2022 09:49:44 +0100
Message-Id: <20221123084603.377195384@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fa153b7cddce795662d38f78a87612c166c0f692 ]

Some x86/ACPI laptops with MIPI cameras have a LATT2021 ACPI device
in the _DEP dependency list of the ACPI devices for the camera-sensors
(which have flags.honor_deps set).

The _DDN for the LATT2021 device is "Lattice FW Update Client Driver",
suggesting that this is used for firmware updates of something. There
is no Linux driver for this and if Linux gets support for updates it
will likely be in userspace through fwupd.

For now add the LATT2021 HID to acpi_ignore_dep_ids[] so that
acpi_dev_ready_for_enumeration() will return true once the other _DEP
dependencies are met.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 6e9cd41c5f9b..ae74720888db 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -793,6 +793,7 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
 static const char * const acpi_ignore_dep_ids[] = {
 	"PNP0D80", /* Windows-compatible System Power Management Controller */
 	"INT33BD", /* Intel Baytrail Mailbox Device */
+	"LATT2021", /* Lattice FW Update Client Driver */
 	NULL
 };
 
-- 
2.35.1



