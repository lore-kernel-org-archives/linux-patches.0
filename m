Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C8415E87
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqflXx5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DDFC433C8;
	Mon, 23 Oct 2023 11:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060745;
	bh=XVF4Nlw1xsUFV3a/T1Lxk434Le7B+eH5RcHpzsLLjXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqflXx5txJtjOR6YATju3qvL8t2UYgTIbfVQND4jyXv3BDZaP2mCxYYjTXyrkkhJO
	 eqjI1hoi1Dty4TUu4de2ugkBAl4XxMa+fyLQSk9jCZWgSSamJyOi0f0O+VB6ujjERj
	 Bi0V9aVNhU9I2wsJz0EBVSzmO3ec/0N/e7WO5ZrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/123] ACPI: resource: Add Asus ExpertBook B2502 to Asus quirks
Date: Mon, 23 Oct 2023 12:57:17 +0200
Message-ID: <20231023104820.351761152@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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
index a34d625f6b875..b68cac8157109 100644
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



