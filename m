Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617624;
	b=sZ+FG9jfp2vp0uAAhzyTSNXKS4j3Eu6Pd/Def+63i2z4tv+eOtwSvdg0WfScTqcpCOKn
	 Q+JO9Uh4rAAZ4ccL91dVdLnqJt8bZe1eGymqL7r7/F2HT/QvVpfue8VSCfTPljw8VJiyR
	 +NzoLLmqglpJ5DRGikCcx/fGwRAQeaqpKhzohnewykoMoTb3Sa484kQYWsCjkDlvZWzvo
	 pxr+tECpHeQAzOrXSUtmaBVxTnOzqgRQGcl4dNmPA2s2FZm/Lm4cN8cpSWCpbkMcoUjP3
	 K0a3FzgLkOH9Y+epIc/op6tB3V/k38XjPtRsNI/QXs8UTiixOoUbTC0w7zb1Gtc7vwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=of3lVUyTTSqv/5swhFYHu1rijRbrqpIwdXPLkIye6N0=;
	b=pSAZBv2balSONQOCbnZVS9EOVubFZ9l8YrBl4job5Gba+GejeBT1V3eDuEr2Mab33jHt
	 wbXpxu43v95hCKELtMZ3QIclGJlvYaHxe0X4xLC6n4Oh6c9roXWKjOA6H27vPDqHP0utL
	 MIcWp3vL85DcdCgYVCFHcVMn3zywnPP3py3VXpmGV+pgGvP9U/nNY977mMJFVlLyoiBOa
	 MHJGt66bgN2TTHPWQiWf5qc0BJHd51k32DOLIeRy9rF7ijtWQs7Rgr7mlvMhlweBFzPg3
	 pQf4zOr5rYOg8gX/Rr1DzFYdqvRLSExW+R3423/bYSy9F/jXzPAG6nQQ3yJo9ebtDdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFZHS4QR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EFA606A321;
	Wed, 25 Nov 2026 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFZHS4QR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58121F000C6;
	Wed, 25 Nov 2026 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617624;
	bh=of3lVUyTTSqv/5swhFYHu1rijRbrqpIwdXPLkIye6N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFZHS4QRoSr6AaOSrSi60dw26n6x71uH4OB6dP+OF/B4kqg+zRttfSv8D6net/smi
	 vQHKffmP6tEKR/xtRPDxeFUZ+z1WR1ivYhFZyhGakzx8ggayKQOoOxbNMM5bajhp2J
	 +HWN6N2kYGi5CanwY/gZfq486QZ5xqigRakzJpw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Dittrich <dittrich.m@gmx.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0007/1005] ACPI: PM: Add quirk for Acer Swift 3 SF314-56G (MX250)
Date: Wed, 25 Nov 2026 15:22:25 +0100
Message-ID: <20261125143821.910580533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 23a4e207a01eb..c6955d1ad29db 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1120,6 +1120,19 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
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



