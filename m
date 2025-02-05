Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120DC1519A9;
	Wed,  5 Feb 2025 15:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768684; cv=none; b=ER1Xf2HBK5LJXzpqqdSHLfHXe0D6aH2Ha3vd1QoNcwQaJv8hoQ0F+t0jlEB9n26N0lAm2J5MQAJn0apsQPxrG+rWfJEq5c74ykb9ze60n/nfjWiziDrxg8v7eXAatlvuOnW1OavlQxIX4SXnezen8cjEdy3AJ4YM9WcZLdneX5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768684; c=relaxed/simple;
	bh=vvSk0YxVy6B7VK9ceN30CsSfKYaD4QnPwNNRs3DsvP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVSadIPM+8SJHShzO/IsWtMUwtBdc5VdWgbWaNVYHR62CL1OIB0tF5q+RP/wtmmVO5Pckrl0Xuwx/jG0Q8CPB3h116TceT6ibUJ089FEMC2/nm1OVbgUe6UYO2S+M3OyIjn9SbMwBKbor/tDoTMq754vbkiW/+/S+CC3urwsA80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzlAUUQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzlAUUQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73031C4CED1;
	Wed,  5 Feb 2025 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768683;
	bh=vvSk0YxVy6B7VK9ceN30CsSfKYaD4QnPwNNRs3DsvP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzlAUUQ2G56WTg2KX7Wxp0uyiPREzHlui8IOoIf7uAkw/yqtf588ebyUos3uL6SJ5
	 m9Ut6M8uZ2zm8DI/HH9nsxampXe2Dt80wKhusOMvESL6qp+jLB7l3D1b2q8hWxF7/m
	 ajQESWkK78Z24JVyPE3ON4L2FZqIzeF2rqc4fSqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 621/623] LoongArch: Change 8 to 14 for LOONGARCH_MAX_{BRP,WRP}
Date: Wed,  5 Feb 2025 14:46:03 +0100
Message-ID: <20250205134519.968230627@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit f502ea618bf16d615d7dc6138c8988d3118fe750 upstream.

The maximum number of load/store watchpoints and fetch instruction
watchpoints is 14 each according to LoongArch Reference Manual, so
change 8 to 14 for the related code.

Link: https://loongson.github.io/LoongArch-Documentation/LoongArch-Vol1-EN.html#control-and-status-registers-related-to-watchpoints
Cc: stable@vger.kernel.org
Fixes: edffa33c7bb5 ("LoongArch: Add hardware breakpoints/watchpoints support")
Reviewed-by: WANG Xuerui <git@xen0n.name>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/hw_breakpoint.h |    4 -
 arch/loongarch/include/asm/loongarch.h     |   60 +++++++++++++++++++++++++++++
 arch/loongarch/kernel/hw_breakpoint.c      |   16 ++++++-
 3 files changed, 76 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/hw_breakpoint.h
+++ b/arch/loongarch/include/asm/hw_breakpoint.h
@@ -38,8 +38,8 @@ struct arch_hw_breakpoint {
  * Limits.
  * Changing these will require modifications to the register accessors.
  */
-#define LOONGARCH_MAX_BRP		8
-#define LOONGARCH_MAX_WRP		8
+#define LOONGARCH_MAX_BRP		14
+#define LOONGARCH_MAX_WRP		14
 
 /* Virtual debug register bases. */
 #define CSR_CFG_ADDR	0
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -959,6 +959,36 @@
 #define LOONGARCH_CSR_DB7CTRL		0x34a	/* data breakpoint 7 control */
 #define LOONGARCH_CSR_DB7ASID		0x34b	/* data breakpoint 7 asid */
 
+#define LOONGARCH_CSR_DB8ADDR		0x350	/* data breakpoint 8 address */
+#define LOONGARCH_CSR_DB8MASK		0x351	/* data breakpoint 8 mask */
+#define LOONGARCH_CSR_DB8CTRL		0x352	/* data breakpoint 8 control */
+#define LOONGARCH_CSR_DB8ASID		0x353	/* data breakpoint 8 asid */
+
+#define LOONGARCH_CSR_DB9ADDR		0x358	/* data breakpoint 9 address */
+#define LOONGARCH_CSR_DB9MASK		0x359	/* data breakpoint 9 mask */
+#define LOONGARCH_CSR_DB9CTRL		0x35a	/* data breakpoint 9 control */
+#define LOONGARCH_CSR_DB9ASID		0x35b	/* data breakpoint 9 asid */
+
+#define LOONGARCH_CSR_DB10ADDR		0x360	/* data breakpoint 10 address */
+#define LOONGARCH_CSR_DB10MASK		0x361	/* data breakpoint 10 mask */
+#define LOONGARCH_CSR_DB10CTRL		0x362	/* data breakpoint 10 control */
+#define LOONGARCH_CSR_DB10ASID		0x363	/* data breakpoint 10 asid */
+
+#define LOONGARCH_CSR_DB11ADDR		0x368	/* data breakpoint 11 address */
+#define LOONGARCH_CSR_DB11MASK		0x369	/* data breakpoint 11 mask */
+#define LOONGARCH_CSR_DB11CTRL		0x36a	/* data breakpoint 11 control */
+#define LOONGARCH_CSR_DB11ASID		0x36b	/* data breakpoint 11 asid */
+
+#define LOONGARCH_CSR_DB12ADDR		0x370	/* data breakpoint 12 address */
+#define LOONGARCH_CSR_DB12MASK		0x371	/* data breakpoint 12 mask */
+#define LOONGARCH_CSR_DB12CTRL		0x372	/* data breakpoint 12 control */
+#define LOONGARCH_CSR_DB12ASID		0x373	/* data breakpoint 12 asid */
+
+#define LOONGARCH_CSR_DB13ADDR		0x378	/* data breakpoint 13 address */
+#define LOONGARCH_CSR_DB13MASK		0x379	/* data breakpoint 13 mask */
+#define LOONGARCH_CSR_DB13CTRL		0x37a	/* data breakpoint 13 control */
+#define LOONGARCH_CSR_DB13ASID		0x37b	/* data breakpoint 13 asid */
+
 #define LOONGARCH_CSR_FWPC		0x380	/* instruction breakpoint config */
 #define LOONGARCH_CSR_FWPS		0x381	/* instruction breakpoint status */
 
@@ -1002,6 +1032,36 @@
 #define LOONGARCH_CSR_IB7CTRL		0x3ca	/* inst breakpoint 7 control */
 #define LOONGARCH_CSR_IB7ASID		0x3cb	/* inst breakpoint 7 asid */
 
+#define LOONGARCH_CSR_IB8ADDR		0x3d0	/* inst breakpoint 8 address */
+#define LOONGARCH_CSR_IB8MASK		0x3d1	/* inst breakpoint 8 mask */
+#define LOONGARCH_CSR_IB8CTRL		0x3d2	/* inst breakpoint 8 control */
+#define LOONGARCH_CSR_IB8ASID		0x3d3	/* inst breakpoint 8 asid */
+
+#define LOONGARCH_CSR_IB9ADDR		0x3d8	/* inst breakpoint 9 address */
+#define LOONGARCH_CSR_IB9MASK		0x3d9	/* inst breakpoint 9 mask */
+#define LOONGARCH_CSR_IB9CTRL		0x3da	/* inst breakpoint 9 control */
+#define LOONGARCH_CSR_IB9ASID		0x3db	/* inst breakpoint 9 asid */
+
+#define LOONGARCH_CSR_IB10ADDR		0x3e0	/* inst breakpoint 10 address */
+#define LOONGARCH_CSR_IB10MASK		0x3e1	/* inst breakpoint 10 mask */
+#define LOONGARCH_CSR_IB10CTRL		0x3e2	/* inst breakpoint 10 control */
+#define LOONGARCH_CSR_IB10ASID		0x3e3	/* inst breakpoint 10 asid */
+
+#define LOONGARCH_CSR_IB11ADDR		0x3e8	/* inst breakpoint 11 address */
+#define LOONGARCH_CSR_IB11MASK		0x3e9	/* inst breakpoint 11 mask */
+#define LOONGARCH_CSR_IB11CTRL		0x3ea	/* inst breakpoint 11 control */
+#define LOONGARCH_CSR_IB11ASID		0x3eb	/* inst breakpoint 11 asid */
+
+#define LOONGARCH_CSR_IB12ADDR		0x3f0	/* inst breakpoint 12 address */
+#define LOONGARCH_CSR_IB12MASK		0x3f1	/* inst breakpoint 12 mask */
+#define LOONGARCH_CSR_IB12CTRL		0x3f2	/* inst breakpoint 12 control */
+#define LOONGARCH_CSR_IB12ASID		0x3f3	/* inst breakpoint 12 asid */
+
+#define LOONGARCH_CSR_IB13ADDR		0x3f8	/* inst breakpoint 13 address */
+#define LOONGARCH_CSR_IB13MASK		0x3f9	/* inst breakpoint 13 mask */
+#define LOONGARCH_CSR_IB13CTRL		0x3fa	/* inst breakpoint 13 control */
+#define LOONGARCH_CSR_IB13ASID		0x3fb	/* inst breakpoint 13 asid */
+
 #define LOONGARCH_CSR_DEBUG		0x500	/* debug config */
 #define LOONGARCH_CSR_DERA		0x501	/* debug era */
 #define LOONGARCH_CSR_DESAVE		0x502	/* debug save */
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -51,7 +51,13 @@ int hw_breakpoint_slots(int type)
 	READ_WB_REG_CASE(OFF, 4, REG, T, VAL);		\
 	READ_WB_REG_CASE(OFF, 5, REG, T, VAL);		\
 	READ_WB_REG_CASE(OFF, 6, REG, T, VAL);		\
-	READ_WB_REG_CASE(OFF, 7, REG, T, VAL);
+	READ_WB_REG_CASE(OFF, 7, REG, T, VAL);		\
+	READ_WB_REG_CASE(OFF, 8, REG, T, VAL);		\
+	READ_WB_REG_CASE(OFF, 9, REG, T, VAL);		\
+	READ_WB_REG_CASE(OFF, 10, REG, T, VAL);		\
+	READ_WB_REG_CASE(OFF, 11, REG, T, VAL);		\
+	READ_WB_REG_CASE(OFF, 12, REG, T, VAL);		\
+	READ_WB_REG_CASE(OFF, 13, REG, T, VAL);
 
 #define GEN_WRITE_WB_REG_CASES(OFF, REG, T, VAL)	\
 	WRITE_WB_REG_CASE(OFF, 0, REG, T, VAL);		\
@@ -61,7 +67,13 @@ int hw_breakpoint_slots(int type)
 	WRITE_WB_REG_CASE(OFF, 4, REG, T, VAL);		\
 	WRITE_WB_REG_CASE(OFF, 5, REG, T, VAL);		\
 	WRITE_WB_REG_CASE(OFF, 6, REG, T, VAL);		\
-	WRITE_WB_REG_CASE(OFF, 7, REG, T, VAL);
+	WRITE_WB_REG_CASE(OFF, 7, REG, T, VAL);		\
+	WRITE_WB_REG_CASE(OFF, 8, REG, T, VAL);		\
+	WRITE_WB_REG_CASE(OFF, 9, REG, T, VAL);		\
+	WRITE_WB_REG_CASE(OFF, 10, REG, T, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 11, REG, T, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 12, REG, T, VAL);	\
+	WRITE_WB_REG_CASE(OFF, 13, REG, T, VAL);
 
 static u64 read_wb_reg(int reg, int n, int t)
 {


