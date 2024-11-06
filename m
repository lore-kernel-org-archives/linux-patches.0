Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188AA1DED5D;
	Wed,  6 Nov 2024 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898950; cv=none; b=kgwnVKDZ8Fq26iydZhVKlhn91uBYWxjUJF3ZsLzfr1NZxo6iqUzHVV0A+iWSjyGZtG/BkWaDmicjPIQwlvAhdaeDQHZEJkDS0qs8zbiHQ/7UJfeRDwbacJTRoQnh2vTOflh7N63W1ghQ/rmBNOetdOMy6aLsn0aN03zflPFGKYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898950; c=relaxed/simple;
	bh=D6630sXzUkvt3Nmqoxbubn+cz82O6OJOH+WXrH/osHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APL5kUl7M9ot68KH+vbhRh8gGVxAg75/YhmiszpOZ7NXomCsCebpVoWZ+UYBoimTXsl6rdS4xsybEMW2Qs++jTUNK0Khc9DjF3oeIbvBckaWegTdcqHodafMRWfHok+tlFwtJSd79x1RoEz5rONt/A4JOtaAdLOScCw6sMiaPCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgemqfDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgemqfDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E24C4CECD;
	Wed,  6 Nov 2024 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898950;
	bh=D6630sXzUkvt3Nmqoxbubn+cz82O6OJOH+WXrH/osHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgemqfDnlEPtcSjgvGr7cf5xr3XrT0ppH9RO7FrnMUkELoPUcNuknsYRXI/z8sj6v
	 aO7WKdb4OZ8Jen5ilMXeNf8/fUKXRGaC0wEI34VaePmPppLiPamat5vicR1Xa97sKg
	 MJ4dOVM9bQYPVnOGXjqlhTjfQEXNFLMQk+uykpYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 410/462] dt-bindings: power: Add r8a774b1 SYSC power domain definitions
Date: Wed,  6 Nov 2024 13:05:03 +0100
Message-ID: <20241106120341.648301044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Biju Das <biju.das@bp.renesas.com>

[ Upstream commit be67c41781cb4c06a4acb0b92db0cbb728e955e2 ]

This patch adds power domain indices for the RZ/G2N (a.k.a r8a774b1)
SoC.

Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Link: https://lore.kernel.org/r/1567666326-27373-1-git-send-email-biju.das@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: 8a7d12d674ac ("net: usb: usbnet: fix name regression")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/power/r8a774b1-sysc.h | 26 +++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 include/dt-bindings/power/r8a774b1-sysc.h

diff --git a/include/dt-bindings/power/r8a774b1-sysc.h b/include/dt-bindings/power/r8a774b1-sysc.h
new file mode 100644
index 0000000000000..373736402f048
--- /dev/null
+++ b/include/dt-bindings/power/r8a774b1-sysc.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2019 Renesas Electronics Corp.
+ */
+#ifndef __DT_BINDINGS_POWER_R8A774B1_SYSC_H__
+#define __DT_BINDINGS_POWER_R8A774B1_SYSC_H__
+
+/*
+ * These power domain indices match the numbers of the interrupt bits
+ * representing the power areas in the various Interrupt Registers
+ * (e.g. SYSCISR, Interrupt Status Register)
+ */
+
+#define R8A774B1_PD_CA57_CPU0		 0
+#define R8A774B1_PD_CA57_CPU1		 1
+#define R8A774B1_PD_A3VP		 9
+#define R8A774B1_PD_CA57_SCU		12
+#define R8A774B1_PD_A3VC		14
+#define R8A774B1_PD_3DG_A		17
+#define R8A774B1_PD_3DG_B		18
+#define R8A774B1_PD_A2VC1		26
+
+/* Always-on power area */
+#define R8A774B1_PD_ALWAYS_ON		32
+
+#endif /* __DT_BINDINGS_POWER_R8A774B1_SYSC_H__ */
-- 
2.43.0



