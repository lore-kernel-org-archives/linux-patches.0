Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5858A168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpduFwgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A02C433C9;
	Mon, 23 Oct 2023 11:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061758;
	bh=uQxq4hvJtB35nS6hZtvxgtxil5ISgN74d8tAAbFnmqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpduFwgpCvrO8EP2Zmy91fkbXJg+F93vdCINyQRwgg0/SJ3caJuKvK2A9PxUKCznB
	 kQ72VqE4KSYVN8I5StnfPdr9xiQRJ/WUCvRTsD9RqDzI1yAwA6RI5UonJkbCl+0qqB
	 nBki7vd3MEKBWrv0w86JMC8MnrQGZK3Q9InPDuRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/202] ACPI: resource: Add Asus ExpertBook B2502 to Asus quirks
Date: Mon, 23 Oct 2023 12:57:15 +0200
Message-ID: <20231023104830.272772335@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7203481fd12b1257938519efb2460ea02b9236ee ]

The Asus ExpertBook B2502 has the same keyboard issue as Asus Vivobook
K3402ZA/K3502ZA. The kernel overrides IRQ 1 to Edge_High when it
should be Active_Low.

This patch adds the ExpertBook B2502 model to the existing
quirk list of Asus laptops with this issue.

Fixes: b5f9223a105d ("ACPI: resource: Skip IRQ override on Asus Vivobook S5602ZA")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2142574
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 7438e57455d17..f76147272b333 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -421,6 +421,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
 		},
 	},
+	{
+		.ident = "Asus ExpertBook B2502",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2502CBA"),
+		},
+	},
 	{ }
 };
 
-- 
2.40.1



