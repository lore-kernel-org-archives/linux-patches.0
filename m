Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBC0130A47;
	Thu, 13 Jun 2024 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280762; cv=none; b=V9tSegiO1XFLa87MhP0x3mo+I5aXY2bFp/o5ZH8batbw3xTSQAb5jbtmlXcFNo3peI6XS/wkyIysOji+rraaLI+oYzxOyVbnA35lB+IGRgxby0DwGXsOoVBk2t7/2uLm9iqIllHenacKz/yY3L3BCbwaR0Lm4xSxicX8koSra5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280762; c=relaxed/simple;
	bh=BX/P87w5Ld2o/dO/zWheSVeqMnC+RIP8h3+uwYO3Bxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRon5f/1AN5Ng/JiAQJVImMK3Fx3vM68+QTLbNb3Vtud3rM8+5854IwhKuy3c/oNxpPCStB/dfqW4bkjuetEHWOa+a8Bs26SAPc/MZbGIbrlRiKnvlfSYDf2I83ub6rO67j6iAZ+7LhJt8Ux2AMg0jDOMPU+zAdN37s6f2A1mFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4TxnQ/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4TxnQ/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A54EC2BBFC;
	Thu, 13 Jun 2024 12:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280761;
	bh=BX/P87w5Ld2o/dO/zWheSVeqMnC+RIP8h3+uwYO3Bxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4TxnQ/YqJILChNf4Km6VkeM+Hsrkt0Ujxjrx7TMCEJfr/gN7AaEQ5/eHKV0V4gsX
	 E0lL+nGNw8sgDA3PlRVSXPK1tbeE8uyIBCQnc8vst9XKKWZRGM/ZaWMzMYwxq1Vw/S
	 bolywArh6K5ksPmhvvt83OOGrSUBq5ECv1rBHCLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/317] parisc: add missing export of __cmpxchg_u8()
Date: Thu, 13 Jun 2024 13:30:43 +0200
Message-ID: <20240613113248.514250217@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit c57e5dccb06decf3cb6c272ab138c033727149b5 ]

__cmpxchg_u8() had been added (initially) for the sake of
drivers/phy/ti/phy-tusb1210.c; the thing is, that drivers is
modular, so we need an export

Fixes: b344d6a83d01 "parisc: add support for cmpxchg on u8 pointers"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/parisc_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index e8a6a751dfd8e..07418f11a964f 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -21,6 +21,7 @@ EXPORT_SYMBOL(memset);
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
+EXPORT_SYMBOL(__cmpxchg_u8);
 EXPORT_SYMBOL(__cmpxchg_u32);
 EXPORT_SYMBOL(__cmpxchg_u64);
 #ifdef CONFIG_SMP
-- 
2.43.0



