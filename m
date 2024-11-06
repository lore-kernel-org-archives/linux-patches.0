Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D881DF73C;
	Wed,  6 Nov 2024 12:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895718; cv=none; b=L0hOB4NJ89dtHI1iaBrpZtIwoNI4Xp92kfedqYL8qR85Vcur21jupuUrQk15YROVTW2biWeBE9z889SxeB4ZNWEalWf2sMK6NrfIyJGrCmLTwumG97rvKOf3sTHQRfgMN86gp0cK0Pyvv9NK8QJfMJ71Q3w2KbGoffbx7claViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895718; c=relaxed/simple;
	bh=1jxesrKA3MYMgEA0qCEl2m7gOvc5o2cB+au3TeQrHfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqzi9hERcBQ0Xr1i8Ulljg1VQU92T8fGaCk+1Xd+SbX9zcpiLEYGyHY3Yl/fkl+Qhig21c2+4UW8UPAQDJTZ39NYMAQI19+oX1SZMocvTo2R76L9o1pGPwpBKZRrNOCZVC/gPNOZcMjxk+g0LVIa4Vv5FhY53SwVD0gHnofyZkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKwzZYrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKwzZYrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6227C4CECD;
	Wed,  6 Nov 2024 12:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895718;
	bh=1jxesrKA3MYMgEA0qCEl2m7gOvc5o2cB+au3TeQrHfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKwzZYrrknrusKGnt8QPp5tWqpnjSw37xU4hs+ZK4iadRmsY/EwUnljRqGLPDOKGQ
	 0E5J2D7forVtoFOhucsdWH5NpmSJKqG/Xj2VHPS1Eto13925dDn/l6fYGGjQHbSZEk
	 lHzQoJcdwOyrqNO8vlUxphZmkPQTcui9O/twW9uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 312/350] dt-bindings: power: Add r8a774b1 SYSC power domain definitions
Date: Wed,  6 Nov 2024 13:04:00 +0100
Message-ID: <20241106120328.478044780@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



