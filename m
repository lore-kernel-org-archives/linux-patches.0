Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246EA330337;
	Fri,  9 Jan 2026 12:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960655; cv=none; b=BH8umQlOl7H4Nt5fjDXo2JsxEIhDZM7lZ12zJBdL87EmQ6Fm8HeV0N9/4xj3ln//QdOEIhEJOOAkb+ZVvy6YVeKEgMvBa+1fkXyFvruFphWSqG+z298Jf/j6T7UNDNLqsiWRq1L8tntN38YzN5Andb3kQ/zIINo+TzvkKHkuTuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960655; c=relaxed/simple;
	bh=1VFTLyubVdtlg26RMaTHOVzKLA3fFQMj8doiOS7R03s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f59Xq17T0RoxJrA/LH429KR67L6767i3ErOLfHR/dr8F/tze59yz2SshXAg2QW89BzuecuoCqVXICqtaBfTtTKLxBHqF+kCwZ65kpjVUo0OvrhsfdA1VM3GlwOCdSCOSt5sY3HngV6FiGOaV9CKhkXvWcRLBUDijz4li7KAigX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNiacJlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNiacJlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D9BC4CEF1;
	Fri,  9 Jan 2026 12:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960654;
	bh=1VFTLyubVdtlg26RMaTHOVzKLA3fFQMj8doiOS7R03s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNiacJlfYWOZ4NLTejwdGoG6nnGsyn4TbaqY+q00eM8I5ILX3iFimJ+duSfTraNDq
	 X6kAZKh1O3ayfh9o8xbtbJC9X9in/cE/1ZJ0mB/4ThPlXszHAr/GjGp66PfLo0CwuN
	 cql5kZ0+YATabebh3jaXbYKZTFzcLQsWHvyIQqwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 478/737] svcrdma: return 0 on success from svc_rdma_copy_inline_range
Date: Fri,  9 Jan 2026 12:40:17 +0100
Message-ID: <20260109112151.967435091@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -834,7 +834,7 @@ static int svc_rdma_copy_inline_range(st
 		offset += page_len;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 /**


