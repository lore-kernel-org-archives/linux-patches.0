Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0A61667C3;
	Mon, 27 May 2024 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836537; cv=none; b=ozWVApuQ9Lcx9kgkjumRV3j3Pll+Hm0G+Meu3DSFDfnr4ZlhzlgWdOKgV+tymrXx5c8xrKmj+pQRB/NLcb17K3ylhiOUCiCBOY+k3sfui4HxKRmUZsDMKgCmExY7mK96xoHEBRM3Xx7mlVPagswMOx4wTEr4HF2MDeYoNaEjpEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836537; c=relaxed/simple;
	bh=AVsQkldv8cdKfPvTVD7uAywKAd6qvR/pZf49LJBXZ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUAaMO3NYWTSZivoMCSyW93qALupuy+gzSvlL9DDFgJQJ3Zf3W7avoifTsPdkSiwMYKYMNJzMGT5I6g+9kLwsUqHi3LFWYqI2t17+Gkg3grMh6rVyC6Gy7ZQIINLRp17QTRZwormBpdDekQ28LXKEvxU/fCahUhokXW/pn4vLz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEYvAsok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEYvAsok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171E8C2BBFC;
	Mon, 27 May 2024 19:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836536;
	bh=AVsQkldv8cdKfPvTVD7uAywKAd6qvR/pZf49LJBXZ3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEYvAsokjfA4sDvAAfQ4r+QTAQuDmW4kBf12jR0dl7S+ZcjK1kMkZ61f0hJWO+WPs
	 bJ/WzlfGhFqESNXEXQ2BxWc1U+TGCnQax83Xrx1aiTq5BXQWm6RahCKptbc3v7EWVA
	 vuZAFTTZ8VSRUhUq/PTdEfcvn525T8xXYg4EZTKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 050/427] parisc: add missing export of __cmpxchg_u8()
Date: Mon, 27 May 2024 20:51:37 +0200
Message-ID: <20240527185606.383067198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



