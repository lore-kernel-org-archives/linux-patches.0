Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CAD168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5+QI++a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BA8C433C7;
	Mon, 23 Oct 2023 11:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061755;
	bh=1Vdb/T+utPkL2YcOSQYuQJYNQLCJr6h/Xrad3UgiNvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5+QI++aV2t+YiUWQu3Yae2745HSv2a7hSbqXETh8SESHFkyLcCDw0krul0a6D25l
	 DBAqgATlvQUIccuDSHxb68DEknooyLP/EgLeiBJBaiu8S88HG73sTaAXnxdNXm29kh
	 GsH83dYwKwYexS5L3q0jI4fo1YuiWWudGmKqzGV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry <wrkedm@gmail.com>,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/202] ACPI: resource: Skip IRQ override on Asus Vivobook S5602ZA
Date: Mon, 23 Oct 2023 12:57:14 +0200
Message-ID: <20231023104830.244160032@linuxfoundation.org>
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

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit b5f9223a105d9b56954ad1ca3eace4eaf26c99ed ]

Like the Asus Vivobook K3402ZA/K3502ZA/S5402ZA Asus Vivobook S5602ZA
has an ACPI DSDT table the describes IRQ 1 as ActiveLow while the kernel
overrides it to Edge_High. This prevents the keyboard on this laptop
from working. To fix this add this laptop to the skip_override_table so
that the kernel does not override IRQ 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216579
Tested-by: Dzmitry <wrkedm@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 50ab81a333cdd..7438e57455d17 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -414,6 +414,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5402ZA"),
 		},
 	},
+	{
+		.ident = "Asus Vivobook S5602ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
+		},
+	},
 	{ }
 };
 
-- 
2.40.1



