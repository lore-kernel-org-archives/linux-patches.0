Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B979E33344D;
	Mon, 29 Dec 2025 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025899; cv=none; b=QVnDAz+bqH5F4O+BE/T7mOSwL2mFCvi8nd7pUCLj75obuJgz3GhH0kLiy+4XLJVMphkivlPAgLNLQ+YfB0vheYCVu/9+n9D4zJKmtsk+feklCWxEmNa7ucy+ISDVMXoDFu/dpKrol+ufTYvEUCxAzImgnrKqIbkA0Je9R6EZsoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025899; c=relaxed/simple;
	bh=vp5iESNVit46XwVPQ9P4+bItIiJSmkRRNF86MEcccrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBZ4yEiUegATJe6opToQQLHhBTkIBjKw/wrDEjXbHC83n5kueqm3TFhIL4r+A03uhw6DbnEaNARygPpVVhC/dQl5Jo1neyIgjJ87TTcUtnsRS9F+OGNaJPA/yHAht48THBdY/ZH9MdIXLcU+j8RAqIwznXGLDVmIrmEndQMyHQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udgEFi6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udgEFi6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017B0C4CEF7;
	Mon, 29 Dec 2025 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025899;
	bh=vp5iESNVit46XwVPQ9P4+bItIiJSmkRRNF86MEcccrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udgEFi6OmLdAoXRN5jZ8Yu2tQDhZ4lUJ3WARPviLtmIWxBYP2O8WhsLT6AakgekCi
	 vznU75t6DbMwOwzrUz/Lm7JB9aDHEvSR0NIqug5vX+Hl1P9sPfM8eA5lr2jEmde86U
	 IkcxKVVwc9YU7cmWqqH1LgTYfWwOzF4GHGuxP7Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 375/430] svcrdma: return 0 on success from svc_rdma_copy_inline_range
Date: Mon, 29 Dec 2025 17:12:57 +0100
Message-ID: <20251229160738.121487962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 94972027ab55b200e031059fd6c7a649f8248020 upstream.

The function comment specifies 0 on success and -EINVAL on invalid
parameters. Make the tail return 0 after a successful copy loop.

Fixes: d7cc73972661 ("svcrdma: support multiple Read chunks per RPC")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -863,7 +863,7 @@ static int svc_rdma_copy_inline_range(st
 		offset += page_len;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 /**


