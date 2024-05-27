Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C2F168C4;
	Mon, 27 May 2024 19:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837719; cv=none; b=KyNtasYOrTbkMTNxnjQML1Wq6RORwYNBnBVC0qvKAMK06vEq9sZH2qAywiLGmaCKQ0cjWkSnNXw3VyzxvFjJigXExaghBfY4JtFA96Fqv/Xj/8rtsdyHcTyz64fYLlGIdYXD9AZSSpJ+E5iKokNOMq22QePVcB/mg2GDtgXjtRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837719; c=relaxed/simple;
	bh=esnbydoelvBNbgOHYpurAVCp4IkcYc2qq5+CYY0GtF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXMyH4zNSX11TvYjHjAPxwKPnxts1YMeYBq69P7BSqyJ4KQOp/PHmc6iBFsWpY20xlyC/TOfDqyw5QACrU2Z+fJVzR1CrhG12qDX8loFH+9qnlhlyIVlQZNAL/ozhm2bJ0bXPbkv+V54nvSqvfbaMbuMwrFSUG5qG+NG3jnNVh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imJfgRQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imJfgRQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B08C2BBFC;
	Mon, 27 May 2024 19:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837719;
	bh=esnbydoelvBNbgOHYpurAVCp4IkcYc2qq5+CYY0GtF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imJfgRQ8nCLq7TasiNZN/t8YpgK7JQeFC7eZRJwkEk5oQqox4Ko+WQ6uolWwS8yFb
	 KMvkBC3l7cMLDvDuYm+4dhe9Jx2O9aRPaL/kjVZbGFmhFlBH/JEfwudOShkzKqC01i
	 4MktT3RabXsQsnIr8AbCKG9S+0zZRVLCMoA5Imag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 117/493] parisc: add missing export of __cmpxchg_u8()
Date: Mon, 27 May 2024 20:51:59 +0200
Message-ID: <20240527185634.334523057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 6f0c92e8149d8..dcf61cbd31470 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -22,6 +22,7 @@ EXPORT_SYMBOL(memset);
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
 EXPORT_SYMBOL(__xchg32);
+EXPORT_SYMBOL(__cmpxchg_u8);
 EXPORT_SYMBOL(__cmpxchg_u32);
 EXPORT_SYMBOL(__cmpxchg_u64);
 #ifdef CONFIG_SMP
-- 
2.43.0



