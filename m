Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620890;
	b=ntl6FEOP9Etk3VY/cpVfpA1WEsm10t727f2D59lnzyH7Lzgvvz61XvsYNgDtcvBhvNnS
	 q63MWX/Jyz2AegZeWFAKn31+Awb7UzXt3dnWTDffExRTgnodknaCV5xLMKRindeHFDYHx
	 N/5RBHjY6YPis+ZvnZQwJuJ/DGIVKGssaGzmwjWJ47lY7fWPpGOdlpr7G0oy5OgFhRNgF
	 V90KF+EfkB6teIC/ceEY2RhIUDfH6Rev9wU+FkEEoF+ogxcqgUD0shpjNKwOfn8xmt0sk
	 GXuwKSNXXi/BeCfVHyARSzNQhZW5e578VwnMqyJBCtPrN9nbISGmTechGwULKpufsEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vry7+MQfufQ1cMdWy1zmXu0xvwu6uKKtfL0nmEY/jAc=;
	b=v4D8oOmDyjMeSB2Rkc2MkQc0Fir2HGnVcvY3MWEnZ5E0BJG9aesKFeEjWlymDHYXKZjx
	 tcnmQgcOEBLqcFzW0GOjX2VH1p2z5y5j0eTWseRjDb25j6mQETVO443IGL1xzakL1JYRs
	 BtofJKKl8yW6+/0WVi92AOSgBte6A9XR1kyD41+qsOX5aZkgRMtC1sugDAsX43DaItoJW
	 lMB8FntBDXD8w/qrK+VHZHhnt/q7nF3IDD+dKhZUuP/R69nRrLZU5g0Mf1WagUD2XPrTg
	 LokYUpLXc4c0dTYBOqoc7rel7xvJ10T7KiIFv5y4pqpLiCQmfRKdbnTdhofHyeJajcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hk7hYrqL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1C8606A31E;
	Wed, 25 Nov 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hk7hYrqL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB3F1F000C0;
	Wed, 25 Nov 2026 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620889;
	bh=Vry7+MQfufQ1cMdWy1zmXu0xvwu6uKKtfL0nmEY/jAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hk7hYrqL59OH3+kOm8AlKbLkV3xMpB7ArpPf3reqSSowPZOS87UGn6/IlpV/Rox6M
	 uR/+HDo7qdnDYhBd9yvKHf00EoUdogkpqtxN4u2DGlqxFM3pt8ZiE8q2EUxg7+UHNH
	 c8dn+/k+NXyR9/i8665/RyhNfvtIVKVVoe7nDiWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Dittrich <dittrich.m@gmx.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/990] ACPI: PM: Add quirk for Acer Swift 3 SF314-56G (MX250)
Date: Wed, 25 Nov 2026 15:23:05 +0100
Message-ID: <20261125143822.513736332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6d16740e1d70a..92cd9f963c6f5 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1125,6 +1125,19 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
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



