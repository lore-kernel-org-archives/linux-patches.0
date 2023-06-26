Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BA6C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4FDC433C8;
	Mon, 26 Jun 2023 18:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804894;
	bh=l10l9PI1AupypbNd6CoKWuXRTlCF9QNESmH42w8cKyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXQc1seUoc3QUWXcDNip5DKN0fZCHPenyMyOY5jXD0WLMqNCIP3xeRoIfwrgi0mOe
	 gcF03wpeaO1NslguBuCi7iNn1Pku2P/Wnaq4rBQY7jbLHh78YoSh/xfmw4grNEYq1J
	 x2z6UtPX8CoXhz2haMf4YqlKoPzDSqJntxDjTTFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Steven Price <steven.price@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 78/96] arm64: Add missing Set/Way CMO encodings
Date: Mon, 26 Jun 2023 20:12:33 +0200
Message-ID: <20230626180750.255767565@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 8d0f019e4c4f2ee2de81efd9bf1c27e9fb3c0460 ]

Add the missing Set/Way CMOs that apply to tagged memory.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20230515204601.1270428-2-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index f79f3720e4cbe..543eb08fa8e5f 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -109,8 +109,14 @@
 #define SB_BARRIER_INSN			__SYS_BARRIER_INSN(0, 7, 31)
 
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
+#define SYS_DC_IGSW			sys_insn(1, 0, 7, 6, 4)
+#define SYS_DC_IGDSW			sys_insn(1, 0, 7, 6, 6)
 #define SYS_DC_CSW			sys_insn(1, 0, 7, 10, 2)
+#define SYS_DC_CGSW			sys_insn(1, 0, 7, 10, 4)
+#define SYS_DC_CGDSW			sys_insn(1, 0, 7, 10, 6)
 #define SYS_DC_CISW			sys_insn(1, 0, 7, 14, 2)
+#define SYS_DC_CIGSW			sys_insn(1, 0, 7, 14, 4)
+#define SYS_DC_CIGDSW			sys_insn(1, 0, 7, 14, 6)
 
 /*
  * System registers, organised loosely by encoding but grouped together
-- 
2.39.2



