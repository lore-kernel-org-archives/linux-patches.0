Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9CE1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D0AC433B5;
	Wed, 23 Nov 2022 09:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196441;
	bh=/NiMo/wrEOascdcvbbrGjZmpvDphjSdGKHk1PUjRYWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjXdsljHzsjWgczfCbWpPqqVjE9mfEcNQ1Qs9tpeUGm1vC1cYvHAILH/cQ8V6tQYy
	 HejofxSHRkOYZRtqJcLEJItQLldNdEy6jgWz8rPqOX5jpzGLRfSOo9lNVjgc0kY58h
	 ayD+vv6IFRJYSaxRuZQ0/B33+DiYfZrMJY/FMunY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 031/314] ACPI: scan: Add LATT2021 to acpi_ignore_dep_ids[]
Date: Wed, 23 Nov 2022 09:47:56 +0100
Message-Id: <20221123084626.938327228@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index 42cec8120f18..adfeb5770efd 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -796,6 +796,7 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
 static const char * const acpi_ignore_dep_ids[] = {
 	"PNP0D80", /* Windows-compatible System Power Management Controller */
 	"INT33BD", /* Intel Baytrail Mailbox Device */
+	"LATT2021", /* Lattice FW Update Client Driver */
 	NULL
 };
 
-- 
2.35.1



