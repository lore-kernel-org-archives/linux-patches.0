Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67EB17555;
	Sat, 30 May 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165139; cv=none; b=CJt9smwNjU/bJFLuY5Dqk4yb+ON3LoeNQHg/O9CZGTThykJVm/tmIuqjaRZLaoe5nOJ33bbLnjOp5cP8JcMc8r86Ujm6PhBYgupcU6/0zeLTC51hJ3deTaayweoUVNVOSwz86AsfIOM69efxQN9qrDls+TZk9UldhxHDsqKc6YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165139; c=relaxed/simple;
	bh=cJp1qrr0DhGgI5nS0U6Tc19MbVUknvYhMP4H38zx86Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZvjnKdSHGLr52/8SI7VU2IlFxlBpd1pf/m7PccIqtYcfniIK36EktETXjBmjlGjhMOafJEztxOK5Et7n/7nozNaUL4qxctHywnbis2IjvwXE+WRRpuTnmwoFIihT4iJwgIsTlmHz2EgOCY8m5NQNDJDp5MumgAOI+22dRIO0RkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCOZK65M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCOZK65M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F141F00893;
	Sat, 30 May 2026 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165138;
	bh=NWeSbLQ9U7sPV0p6VwwQhPPU90jjq8O2DspDGx6I6fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCOZK65MhFhpujYGWVWUHWcegCnhtOVL5qq916G3qjZRuoUj9ZfNtftddiQzxiP+j
	 UqWyeGidwZTlqwwzr5APK5bPu5iiNzOdjwAyYkEz1P7gG6rqFrp3LY6gs7Tigm4z1p
	 ycJc0KyMTD+BOZu0v+sxUNwitWPjAa4W6R2mK6OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 761/776] net: dsa: mt7530: rename mt753x_bpdu_port_fw enum to mt753x_to_cpu_fw
Date: Sat, 30 May 2026 18:07:55 +0200
Message-ID: <20260530160259.404123920@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 7603a0c7d2210a253265394b50567c64fbb977e4 ]

The mt753x_bpdu_port_fw enum is globally used for manipulating the process
of deciding the forwardable ports, specifically concerning the CPU port(s).
Therefore, rename it and the values in it to mt753x_to_cpu_fw.

Change FOLLOW_MFC to SYSTEM_DEFAULT to be on par with the switch documents.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3ac85bcfd404 ("net: dsa: mt7530: preserve VLAN tags on trapped link-local frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 44 ++++++++++-------------
 drivers/net/dsa/mt7530.h | 76 ++++++++++++++++++++--------------------
 2 files changed, 56 insertions(+), 64 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f0b2510bff15b..fbee11e8f6e0c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1187,42 +1187,34 @@ mt753x_trap_frames(struct mt7530_priv *priv)
 	 * VLAN-untagged.
 	 */
 	mt7530_rmw(priv, MT753X_BPC,
-		   MT753X_PAE_BPDU_FR | MT753X_PAE_EG_TAG_MASK |
-			   MT753X_PAE_PORT_FW_MASK | MT753X_BPDU_EG_TAG_MASK |
-			   MT753X_BPDU_PORT_FW_MASK,
-		   MT753X_PAE_BPDU_FR |
-			   MT753X_PAE_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
-			   MT753X_PAE_PORT_FW(MT753X_BPDU_CPU_ONLY) |
-			   MT753X_BPDU_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
-			   MT753X_BPDU_CPU_ONLY);
+		   PAE_BPDU_FR | PAE_EG_TAG_MASK | PAE_PORT_FW_MASK |
+			   BPDU_EG_TAG_MASK | BPDU_PORT_FW_MASK,
+		   PAE_BPDU_FR | PAE_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   PAE_PORT_FW(TO_CPU_FW_CPU_ONLY) |
+			   BPDU_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   TO_CPU_FW_CPU_ONLY);
 
 	/* Trap frames with :01 and :02 MAC DAs to the CPU port(s) and egress
 	 * them VLAN-untagged.
 	 */
 	mt7530_rmw(priv, MT753X_RGAC1,
-		   MT753X_R02_BPDU_FR | MT753X_R02_EG_TAG_MASK |
-			   MT753X_R02_PORT_FW_MASK | MT753X_R01_BPDU_FR |
-			   MT753X_R01_EG_TAG_MASK | MT753X_R01_PORT_FW_MASK,
-		   MT753X_R02_BPDU_FR |
-			   MT753X_R02_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
-			   MT753X_R02_PORT_FW(MT753X_BPDU_CPU_ONLY) |
-			   MT753X_R01_BPDU_FR |
-			   MT753X_R01_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
-			   MT753X_BPDU_CPU_ONLY);
+		   R02_BPDU_FR | R02_EG_TAG_MASK | R02_PORT_FW_MASK |
+			   R01_BPDU_FR | R01_EG_TAG_MASK | R01_PORT_FW_MASK,
+		   R02_BPDU_FR | R02_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   R02_PORT_FW(TO_CPU_FW_CPU_ONLY) | R01_BPDU_FR |
+			   R01_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   TO_CPU_FW_CPU_ONLY);
 
 	/* Trap frames with :03 and :0E MAC DAs to the CPU port(s) and egress
 	 * them VLAN-untagged.
 	 */
 	mt7530_rmw(priv, MT753X_RGAC2,
-		   MT753X_R0E_BPDU_FR | MT753X_R0E_EG_TAG_MASK |
-			   MT753X_R0E_PORT_FW_MASK | MT753X_R03_BPDU_FR |
-			   MT753X_R03_EG_TAG_MASK | MT753X_R03_PORT_FW_MASK,
-		   MT753X_R0E_BPDU_FR |
-			   MT753X_R0E_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
-			   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY) |
-			   MT753X_R03_BPDU_FR |
-			   MT753X_R03_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
-			   MT753X_BPDU_CPU_ONLY);
+		   R0E_BPDU_FR | R0E_EG_TAG_MASK | R0E_PORT_FW_MASK |
+			   R03_BPDU_FR | R03_EG_TAG_MASK | R03_PORT_FW_MASK,
+		   R0E_BPDU_FR | R0E_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   R0E_PORT_FW(TO_CPU_FW_CPU_ONLY) | R03_BPDU_FR |
+			   R03_EG_TAG(MT7530_VLAN_EG_UNTAGGED) |
+			   TO_CPU_FW_CPU_ONLY);
 }
 
 static int
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 4a013680ce643..9e76a2b6403b5 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -67,47 +67,47 @@ enum mt753x_id {
 #define MT753X_MIRROR_MASK(id)		(((id) == ID_MT7531) ? \
 					 MT7531_MIRROR_MASK : MIRROR_MASK)
 
-/* Registers for BPDU and PAE frame control*/
+/* Register for BPDU and PAE frame control */
 #define MT753X_BPC			0x24
-#define  MT753X_PAE_BPDU_FR		BIT(25)
-#define  MT753X_PAE_EG_TAG_MASK		GENMASK(24, 22)
-#define  MT753X_PAE_EG_TAG(x)		FIELD_PREP(MT753X_PAE_EG_TAG_MASK, x)
-#define  MT753X_PAE_PORT_FW_MASK	GENMASK(18, 16)
-#define  MT753X_PAE_PORT_FW(x)		FIELD_PREP(MT753X_PAE_PORT_FW_MASK, x)
-#define  MT753X_BPDU_EG_TAG_MASK	GENMASK(8, 6)
-#define  MT753X_BPDU_EG_TAG(x)		FIELD_PREP(MT753X_BPDU_EG_TAG_MASK, x)
-#define  MT753X_BPDU_PORT_FW_MASK	GENMASK(2, 0)
-
-/* Register for :01 and :02 MAC DA frame control */
+#define  PAE_BPDU_FR			BIT(25)
+#define  PAE_EG_TAG_MASK		GENMASK(24, 22)
+#define  PAE_EG_TAG(x)			FIELD_PREP(PAE_EG_TAG_MASK, x)
+#define  PAE_PORT_FW_MASK		GENMASK(18, 16)
+#define  PAE_PORT_FW(x)			FIELD_PREP(PAE_PORT_FW_MASK, x)
+#define  BPDU_EG_TAG_MASK		GENMASK(8, 6)
+#define  BPDU_EG_TAG(x)			FIELD_PREP(BPDU_EG_TAG_MASK, x)
+#define  BPDU_PORT_FW_MASK		GENMASK(2, 0)
+
+/* Register for 01-80-C2-00-00-[01,02] MAC DA frame control */
 #define MT753X_RGAC1			0x28
-#define  MT753X_R02_BPDU_FR		BIT(25)
-#define  MT753X_R02_EG_TAG_MASK		GENMASK(24, 22)
-#define  MT753X_R02_EG_TAG(x)		FIELD_PREP(MT753X_R02_EG_TAG_MASK, x)
-#define  MT753X_R02_PORT_FW_MASK	GENMASK(18, 16)
-#define  MT753X_R02_PORT_FW(x)		FIELD_PREP(MT753X_R02_PORT_FW_MASK, x)
-#define  MT753X_R01_BPDU_FR		BIT(9)
-#define  MT753X_R01_EG_TAG_MASK		GENMASK(8, 6)
-#define  MT753X_R01_EG_TAG(x)		FIELD_PREP(MT753X_R01_EG_TAG_MASK, x)
-#define  MT753X_R01_PORT_FW_MASK	GENMASK(2, 0)
-
-/* Register for :03 and :0E MAC DA frame control */
+#define  R02_BPDU_FR			BIT(25)
+#define  R02_EG_TAG_MASK		GENMASK(24, 22)
+#define  R02_EG_TAG(x)			FIELD_PREP(R02_EG_TAG_MASK, x)
+#define  R02_PORT_FW_MASK		GENMASK(18, 16)
+#define  R02_PORT_FW(x)			FIELD_PREP(R02_PORT_FW_MASK, x)
+#define  R01_BPDU_FR			BIT(9)
+#define  R01_EG_TAG_MASK		GENMASK(8, 6)
+#define  R01_EG_TAG(x)			FIELD_PREP(R01_EG_TAG_MASK, x)
+#define  R01_PORT_FW_MASK		GENMASK(2, 0)
+
+/* Register for 01-80-C2-00-00-[03,0E] MAC DA frame control */
 #define MT753X_RGAC2			0x2c
-#define  MT753X_R0E_BPDU_FR		BIT(25)
-#define  MT753X_R0E_EG_TAG_MASK		GENMASK(24, 22)
-#define  MT753X_R0E_EG_TAG(x)		FIELD_PREP(MT753X_R0E_EG_TAG_MASK, x)
-#define  MT753X_R0E_PORT_FW_MASK	GENMASK(18, 16)
-#define  MT753X_R0E_PORT_FW(x)		FIELD_PREP(MT753X_R0E_PORT_FW_MASK, x)
-#define  MT753X_R03_BPDU_FR		BIT(9)
-#define  MT753X_R03_EG_TAG_MASK		GENMASK(8, 6)
-#define  MT753X_R03_EG_TAG(x)		FIELD_PREP(MT753X_R03_EG_TAG_MASK, x)
-#define  MT753X_R03_PORT_FW_MASK	GENMASK(2, 0)
-
-enum mt753x_bpdu_port_fw {
-	MT753X_BPDU_FOLLOW_MFC,
-	MT753X_BPDU_CPU_EXCLUDE = 4,
-	MT753X_BPDU_CPU_INCLUDE = 5,
-	MT753X_BPDU_CPU_ONLY = 6,
-	MT753X_BPDU_DROP = 7,
+#define  R0E_BPDU_FR			BIT(25)
+#define  R0E_EG_TAG_MASK		GENMASK(24, 22)
+#define  R0E_EG_TAG(x)			FIELD_PREP(R0E_EG_TAG_MASK, x)
+#define  R0E_PORT_FW_MASK		GENMASK(18, 16)
+#define  R0E_PORT_FW(x)			FIELD_PREP(R0E_PORT_FW_MASK, x)
+#define  R03_BPDU_FR			BIT(9)
+#define  R03_EG_TAG_MASK		GENMASK(8, 6)
+#define  R03_EG_TAG(x)			FIELD_PREP(R03_EG_TAG_MASK, x)
+#define  R03_PORT_FW_MASK		GENMASK(2, 0)
+
+enum mt753x_to_cpu_fw {
+	TO_CPU_FW_SYSTEM_DEFAULT,
+	TO_CPU_FW_CPU_EXCLUDE = 4,
+	TO_CPU_FW_CPU_INCLUDE = 5,
+	TO_CPU_FW_CPU_ONLY = 6,
+	TO_CPU_FW_DROP = 7,
 };
 
 /* Registers for address table access */
-- 
2.53.0



