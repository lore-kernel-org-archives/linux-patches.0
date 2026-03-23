Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D93BA235;
	Mon, 23 Mar 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282410; cv=none; b=pfaiJ7VYxy8BfZNRpmDNGMDwGRrRVaPSPk9ZPnwKOPfJC1UWF4Qzz/eKUwQrlxLYQJr6yNLJuXSdLbp/MogWmvh6WoyDvYkcHjPfsWxdZpk/ZMwvW2cb1QIhjuhsE+ks716cylYh8e7XB8Frl5ScXSV0L2Aj+0Q7svzx1cD8afE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282410; c=relaxed/simple;
	bh=xG3PlNjxWvZwyzCU01g6Jol4pIrYqNE0wFZ5ZZHQg2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIlbRG4hEzZd7ngiaYSildF5UEZ0gowyOySmgnCmSrLt0PISqBh6osT8Uxj8oiGy+FJ+SvJGS36o+JZPBqdGgVZVAgHfsjRUfLHwx03/NkTliI0qlVdOYmXM6qTVv4oqu52eYwj8FP7sp83lGzbtZ58uE4udsaFCacHppR4QAu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUBwtkMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUBwtkMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9233C2BCB0;
	Mon, 23 Mar 2026 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282410;
	bh=xG3PlNjxWvZwyzCU01g6Jol4pIrYqNE0wFZ5ZZHQg2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUBwtkMpzT8zCbjUbbuUvlAhkrpZujMFDPtXHKRqtPaIvmqEw1Lmt8sZtDbphVXyv
	 Brvo3UEtQeoPfwsK0rurhqIttHoU/GilWtJnsl6Zvb0W5sUczVzTmJqKQ/G1dQfkfI
	 eWIycvgScpy1l6rYt/WzVMo9GHXt3hoeXwRdtLO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Mazek <pmazek@outlook.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/481] ACPI: PM: Save NVS memory on Lenovo G70-35
Date: Mon, 23 Mar 2026 14:42:09 +0100
Message-ID: <20260323134528.832853658@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Piotr Mazek <pmazek@outlook.com>

[ Upstream commit 023cd6d90f8aa2ef7b72d84be84a18e61ecebd64 ]

[821d6f0359b0614792ab8e2fb93b503e25a65079] prevented machines
produced later than 2012 from saving NVS region to accelerate S3.

Despite being made after 2012, Lenovo G70-35 still needs NVS memory
saving during S3. A quirk is introduced for this platform.

Signed-off-by: Piotr Mazek <pmazek@outlook.com>
[ rjw: Subject adjustment ]
Link: https://patch.msgid.link/GV2PPF3CD5B63CC2442EE3F76F8443EAD90D499A@GV2PPF3CD5B63CC.EURP251.PROD.OUTLOOK.COM
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sleep.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 6026e20f022a2..cc490fbcfe273 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -372,6 +372,14 @@ static const struct dmi_system_id acpisleep_dmi_table[] __initconst = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "80E1"),
 		},
 	},
+	{
+	.callback = init_nvs_save_s3,
+	.ident = "Lenovo G70-35",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "80Q5"),
+		},
+	},
 	/*
 	 * ThinkPad X1 Tablet(2016) cannot do suspend-to-idle using
 	 * the Low Power S0 Idle firmware interface (see
-- 
2.51.0



