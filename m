Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623943;
	b=zmaf70JXcqDaF8DsGbOMEY0ZCKybDIToEN+vymqLErgMeFr+YzSUV/kfgdtGJlDqiX8n
	 +5xBpl+pOwFZQCJtBb/20/xqeFBcGozfIGhuc0g98HaKGR3asbaqFX/kCbJs9CuTxq6Mi
	 CUbfT5ApIHz8rgqqKnba5nuz6hl420yoDflCKmccPBphpuyX4z46uqkotJzk9vxRgr0CK
	 tNiMLtcRr0EZpno9ctVOvm/2QWgq6CNSdAzRlF8g2ZL80o/GP4ONdatW2avHa6na8cJ2Z
	 8FBZJtENXeg066/coTDhfcHrsbe+KWxvjBC2WlPheIP4QXqI34ViO1sLLKGym4DuHuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3UBo6ut+MvDoJnxT4m04m+vMdWXQY0g7xueD+UmLKF0=;
	b=Cuzw+q97reVt/0+Zvq6y4RM8QHOP/VLxCtaI+8U1Q5qnDmYrFux7wVuzLqutWd/IGjIA
	 m/UtPdPNgGD7Pn2lZl8cL41kTybEI5PgI5ztE4X8ZnJY5unj4M77Qj+Zldx8BWXmdutwL
	 76sKVouDjuat+bRBdiXVvMEIVMA4KHyovKcXah/LB9Z12aEYwGWA/pLJl21/QGgBzlQFe
	 7lPqxj2JaZrzCjMc4lEHDDcq5mx36ZrT7BqczCuliEu7bKTW+NNhTmpyOamwNAaxqEMRN
	 lDo1FaadtKLBU+vuwCkcq3hoPW7PCC9pilzs7AqaqbLnmYw9IMcRUX/4B7AR+XMql6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/C2N9b7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2982606A321;
	Wed, 25 Nov 2026 16:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/C2N9b7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E6D1F000CA;
	Wed, 25 Nov 2026 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623943;
	bh=3UBo6ut+MvDoJnxT4m04m+vMdWXQY0g7xueD+UmLKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/C2N9b7lGI7E8JwuYwQHn2tF1e+DRf+bjrxpTRUOnyzKpKydJI4MrlfMKtNlaNT/
	 1ZDq5ojIJRlqvSzt+gVBYjDhGBhvmLeOj2Qw+SyLidtZQ69l4bZ9fiSrWJrBTPvrpa
	 PQ92jMsbvycchCW2gHAKTFR6ziI+OeYwhJejQAEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Dittrich <dittrich.m@gmx.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/816] ACPI: PM: Add quirk for Acer Swift 3 SF314-56G (MX250)
Date: Wed, 25 Nov 2026 15:25:59 +0100
Message-ID: <20261125143849.477212297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Dittrich <dittrich.m@gmx.net>

[ Upstream commit a0039113053d4d3f629ea1b9cd74130ca597f14a ]

The Acer Swift 3 SF314-56G (with NVIDIA GeForce MX250) suffers from
the same ACPI power resource regression as the Thunderobot ZERO.
The power resource controlling the dGPU is incorrectly turned off
during initialization, causing the GPU to fall off the bus (D3cold).

This commit adds a DMI quirk to keep the power resource on for this
model, similar to the existing Thunderobot quirk.

Tested on Acer Swift 3 SF314-56G with NVIDIA MX250.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221087
Signed-off-by: Matthias Dittrich <dittrich.m@gmx.net>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 9f9f580e393c7..754c3936db099 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1047,6 +1047,19 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ZERO"),
 		}
 
+	},
+	{
+		/*
+		 * Acer Swift 3 SF314-56G with NVIDIA MX250 suffers from the
+		 * same ACPI power resource regression as the Thunderobot ZERO.
+		 * The power resource controlling the dGPU is incorrectly turned off
+		 * during initialization, causing the GPU to fall off the bus (D3cold).
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Swift SF314-56G"),
+		}
+
 	},
 	{}
 };
-- 
2.53.0



