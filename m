Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355B615E87
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnW8+O70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38AFC433C8;
	Mon, 23 Oct 2023 11:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060739;
	bh=asjBv9fSXQQUYLt/ZfsaV29ZGYfj12TmzMzfy+yz8i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnW8+O70LjdAliBRnACzsGfHQrdct8gFukmqmU+aKFxXocJm8+QMsK3scFdQZQSbZ
	 bsLozaorpsWEOvg4xQK0FzZ1y9hCsr0F3bFoZprw4vYpB/9/xbOwcU+Gt1Sc+LfwOc
	 XPCKWa5aS7E6OmaLAj0snG/oOi05KbGdW+k/Gs5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kellen Renshaw <kellen.renshaw@canonical.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/123] ACPI: resource: Add ASUS model S5402ZA to quirks
Date: Mon, 23 Oct 2023 12:57:15 +0200
Message-ID: <20231023104820.281237794@linuxfoundation.org>
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
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 27b364e23c60b..61a7f9a05f645 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -407,6 +407,13 @@ static const struct dmi_system_id asus_laptop[] = {
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
2.40.1



