Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BFE13A259;
	Tue, 27 Feb 2024 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043055; cv=none; b=TCOOHKedKVp10JGqdOkBDOvtlMsi1T0tB2YUfArmjlAWNVWM+bt619I7T8RYVVe5b9jgfpESJoc/Z4ZquTjYmkrmBN6/XmpsBW5Bt86V665BwIbKaeNV0+SuC5SM13Q3wcREQidClURjVmY+MUyoUCnqxtblE8ELiY3q8v4oLic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043055; c=relaxed/simple;
	bh=XtVjOlDNPyxhYVZlLUSxglBIxWrqqj4hYIJ39nLc9Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMXxeOG7FnPVwIxFXjuMLuepv8k3QDDqt40MYC+5Z6DgpKE1Q0EYFhUjOU2k8w9AwlruZRZ7Jy5V2l73lF2zghLtYX8z6yb496Roulhwejoy4d/IHA07EwVnF254ypdHVKOiP1GF5sWOR1cnfoCSyeGIdVwCtQe+7IlCXTy3ZCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vqzd8SxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vqzd8SxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BC5C433F1;
	Tue, 27 Feb 2024 14:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043055;
	bh=XtVjOlDNPyxhYVZlLUSxglBIxWrqqj4hYIJ39nLc9Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqzd8SxEQ500RSQe8hvj96PJ3rLPEOchG44yDunQBXmU4nuPvLvPgwJx/F/W0/QQJ
	 UC64qKaSqQMJR7UsHJ8w9oRs5F3Fg8IMUdS5yDLb/9vBJ3ovE3zWePyWHgd+p/Rutv
	 l7tQUw0abxOYbWT6zddLr1RVmHjucty46AoWs8Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kellen Renshaw <kellen.renshaw@canonical.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/245] ACPI: resource: Add ASUS model S5402ZA to quirks
Date: Tue, 27 Feb 2024 14:26:17 +0100
Message-ID: <20240227131621.338020774@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kellen Renshaw <kellen.renshaw@canonical.com>

[ Upstream commit 6e5cbe7c4b41824e500acbb42411da692d1435f1 ]

The Asus Vivobook S5402ZA has the same keyboard issue as Asus Vivobook
K3402ZA/K3502ZA. The kernel overrides IRQ 1 to Edge_High when it
should be Active_Low.

This patch adds the S5402ZA model to the quirk list.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216158
Tested-by: Kellen Renshaw <kellen.renshaw@canonical.com>
Signed-off-by: Kellen Renshaw <kellen.renshaw@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 91628fb41ef85..4d1db2def7ae4 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -421,6 +421,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "K3502ZA"),
 		},
 	},
+	{
+		.ident = "Asus Vivobook S5402ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "S5402ZA"),
+		},
+	},
 	{ }
 };
 
-- 
2.43.0



