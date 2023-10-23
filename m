Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB39F17758
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta8IYnMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D6BC433C9;
	Mon, 23 Oct 2023 11:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061761;
	bh=WOzQ2xahpP7TITBBvqILXCh5PuJwAPjUrb4n1L82Tg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta8IYnMN+yIhYACZPTjXRQNYYVgcGcb2LARaSmYYxeLERGxaIrytMZhrQ9YCL+afG
	 TndRHqnuXRTn7N2cvscKAZ01Vw+oSwr0jdSICF9XFoovRVc7T03GcfqnRHijTCByom
	 LQV+rSm2rpMFL008tv/V5LBROBJv6MGJDlc45cHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zelenat <zelenat@gmail.com>,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/202] ACPI: resource: Skip IRQ override on Asus Expertbook B2402CBA
Date: Mon, 23 Oct 2023 12:57:16 +0200
Message-ID: <20231023104830.301993699@linuxfoundation.org>
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

[ Upstream commit 77c7248882385397cd7dffe9e1437f59f32ce2de ]

Like the Asus Expertbook B2502CBA and various Asus Vivobook laptops,
the Asus Expertbook B2402CBA has an ACPI DSDT table that describes IRQ 1
as ActiveLow while the kernel overrides it to Edge_High. This prevents the
keyboard from working. To fix this issue, add this laptop to the
skip_override_table so that the kernel does not override IRQ 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216864
Tested-by: zelenat <zelenat@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index f76147272b333..57e8ba44df741 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -421,6 +421,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
 		},
 	},
+	{
+		.ident = "Asus ExpertBook B2402CBA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2402CBA"),
+		},
+	},
 	{
 		.ident = "Asus ExpertBook B2502",
 		.matches = {
-- 
2.40.1



