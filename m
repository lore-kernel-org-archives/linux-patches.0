Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FC71514C5;
	Tue, 18 Jun 2024 12:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715088; cv=none; b=rkZFjoWQogrEK1U+PtDKRSMIjLU2yzkWcmfBWJ+tQiRfAiJrpwC2XBUhsN5Zfugm6gaoq2I/xY4tMqAQklyqR7UylL14+o0ZnIMdxpDsoY1TKN11QSNIWk+jBs7Y9WhSI7GDyLEwBoZ0U09RpjQ53rPv3J+tZAUmWR4Ws+liaRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715088; c=relaxed/simple;
	bh=9SOBWy4WcyRkoK85gKFU1K54MzydTx8MmPWrw1JCcSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9LoNumdYGO1Va0AIK4qmb00kWIEMP40AtgiTdz+b/SHijmXNuaspurL0gi+kMYqfXkY0Treaqoc/ZJH1a9Fz0Debary5OLOY74j8qP7hlZOt9nvDsQE+fFkARMcNGD3Usp4tRTiD9grDtlIy0fqqv4xuJqW+Rhpt55gQVc0Xo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+W5bAaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+W5bAaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C14C3277B;
	Tue, 18 Jun 2024 12:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715088;
	bh=9SOBWy4WcyRkoK85gKFU1K54MzydTx8MmPWrw1JCcSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+W5bAaEmDNXmGSMs0heL7bJfMRAQaKCbRWPklW0Q6apCO1nUzyrtLMLrSI24BJ52
	 AoR/H4Liq1Tik7c+p+05YxKV1sLQFIeh8aOIboNCeCYxWXCFpgf83d+u0FZFqNpXcq
	 b2+K2RFzhfCO0z7LSTV22D++0erJTV3ce31I0lW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miroslav Benes <mbenes@suse.cz>,
	Christoph Hellwig <hch@lst.de>,
	Jessica Yu <jeyu@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/770] module: unexport find_module and module_mutex
Date: Tue, 18 Jun 2024 14:30:44 +0200
Message-ID: <20240618123414.649576904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 089049f6c9956c5cf1fc89fe10229c76e99f4bef ]

find_module is not used by modular code any more, and random driver code
has no business calling it to start with.

Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 72a5dcdccf7b1..c0e51ffe26f0a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -88,7 +88,6 @@
  * 3) module_addr_min/module_addr_max.
  * (delete and add uses RCU list operations). */
 DEFINE_MUTEX(module_mutex);
-EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
@@ -645,7 +644,6 @@ struct module *find_module(const char *name)
 	module_assert_mutex();
 	return find_module_all(name, strlen(name), false);
 }
-EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 
-- 
2.43.0



