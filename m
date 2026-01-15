Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016453B8D5F;
	Thu, 15 Jan 2026 17:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498130; cv=none; b=PCG4C3/RiwzBmvXW3h3WuqVOSjcN2z8PyefeeInEVQdkd+YMcGmmJWAkyoHZgN2kEO8lBEKC3xFaspCXLTOnGWkRXJ0RPU1vwWwqGjwxdwZWEI3e6y3hlg02z08ODi17igj7BAhbxbfyQ5/Ngw24DWQj4pwz+RWHCUFnoxfIxo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498130; c=relaxed/simple;
	bh=JgyNhkKWxA5kHCR51+NoH1zJSlGVWO7AvFwf1nDLxJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uapFr833oiVDIwUoK5uxeAGlE0p9OdRvsisaUyBvupzY5A5ebM30IrbEP7/SDTiDkVIXES1QUkw+CTt8wipvPBhBkm/TPOUhRzvYQR/NwmjRM6O0UiAdCI9diB8jltR0q3DITVaKlYveaa9297aOPzYGJUSd6TJiReAuIEhYqQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg5QKmhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg5QKmhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F630C116D0;
	Thu, 15 Jan 2026 17:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498129;
	bh=JgyNhkKWxA5kHCR51+NoH1zJSlGVWO7AvFwf1nDLxJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg5QKmhkjO+TEsj9MCCEOZEhctjisYM7oMbxi3lu3O79JLQ1/gt+fsnx+tyVlKsZ1
	 HpetUlHqiwF4FCyf3GfZUoyoIxqzMr5AlhRMiqilW61gbx+SNCy4GsGAEApHTEBvhU
	 PGlo2KmXFjF2jx80+iaYh1AazAkUjHKonRpXr+U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 324/554] svcrdma: return 0 on success from svc_rdma_copy_inline_range
Date: Thu, 15 Jan 2026 17:46:30 +0100
Message-ID: <20260115164257.956101085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -808,7 +808,7 @@ static int svc_rdma_copy_inline_range(st
 		offset += page_len;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 /**


