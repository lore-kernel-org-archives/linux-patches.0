Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAEA1DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2X35KA1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8283AC433C8;
	Wed,  4 Oct 2023 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444210;
	bh=x1get3cokCt1FnkEf27Wbc5ot7WeNJJlOl9awTEl5wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2X35KA1QW3jCgZQKLBnl4d3h468EsiR5Ji0Uuwj+Z4VVv03LawSEsttuOfSuizlfy
	 eT6HyCbwlmpW2tC9YuKuePmAI7SgfxTDRWykDbbC8MCCBR6Zj5nv6E6suzuf4JWPT8
	 IQptPR0Lf0/69ZlfpAo9KxOfTPbPu3N6T/dJK1TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 169/321] parisc: iosapic.c: Fix sparse warnings
Date: Wed,  4 Oct 2023 19:55:14 +0200
Message-ID: <20231004175237.087334376@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 927c6c8aa27c284a799b8c18784e37d3373af908 ]

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/iosapic.c         | 4 ++--
 drivers/parisc/iosapic_private.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index bcc1dae007803..890c3c0f3d140 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -202,9 +202,9 @@ static inline void iosapic_write(void __iomem *iosapic, unsigned int reg, u32 va
 
 static DEFINE_SPINLOCK(iosapic_lock);
 
-static inline void iosapic_eoi(void __iomem *addr, unsigned int data)
+static inline void iosapic_eoi(__le32 __iomem *addr, __le32 data)
 {
-	__raw_writel(data, addr);
+	__raw_writel((__force u32)data, addr);
 }
 
 /*
diff --git a/drivers/parisc/iosapic_private.h b/drivers/parisc/iosapic_private.h
index 73ecc657ad954..bd8ff40162b4b 100644
--- a/drivers/parisc/iosapic_private.h
+++ b/drivers/parisc/iosapic_private.h
@@ -118,8 +118,8 @@ struct iosapic_irt {
 struct vector_info {
 	struct iosapic_info *iosapic;	/* I/O SAPIC this vector is on */
 	struct irt_entry *irte;		/* IRT entry */
-	u32 __iomem *eoi_addr;		/* precalculate EOI reg address */
-	u32	eoi_data;		/* IA64: ?       PA: swapped txn_data */
+	__le32 __iomem *eoi_addr;	/* precalculate EOI reg address */
+	__le32	eoi_data;		/* IA64: ?       PA: swapped txn_data */
 	int	txn_irq;		/* virtual IRQ number for processor */
 	ulong	txn_addr;		/* IA64: id_eid  PA: partial HPA */
 	u32	txn_data;		/* CPU interrupt bit */
-- 
2.40.1



