Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373E33559CC;
	Tue,  6 Jan 2026 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720595; cv=none; b=a4u9v1Y+DY3EsTvCOOLnBHUPkOBNHbu1y+30ZUUUPnnnVZC9o4w9lpOtJvsf81FWcepnIiEixQEsYTe7i0Gu7dN1k0ScKt6HBuGEwTexGGZbO2j1jBgW8mJ6vlwK/s72LqXpbFLJ82srRAxJfgt/OhiDDzphIOtgFy7cvYwubmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720595; c=relaxed/simple;
	bh=L9um6RXs1IhJd5ZyH8IY30DRnnCxGSzQcIB+9e/nsZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+y1GZlK9N0I+NVvhIzwkmoUdDCNugL4z63nStjc+eEpSd1sBeGMlpQJWbEL4LdEiYiMGnDScuZ8n7STiEt45MM/eEyfkv60MYyBgO8qP5blPll2aBGOchJLOWkU+pIB1wg0T2Dwj7emX6C/XZPR99VXrsXufxMsklNKxnKWmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1IWHS86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1IWHS86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B757C16AAE;
	Tue,  6 Jan 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720594;
	bh=L9um6RXs1IhJd5ZyH8IY30DRnnCxGSzQcIB+9e/nsZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1IWHS86R4H3OVfl3MajZhvPV+30wVD5AmLw/oeGh3QaNtvT7TxteGPvkeSqM43TW
	 3Bik6n6xZtmLo95v3iLQgjRdYWmNoTMhWiam2rsD6HloHybZ81Sbuwvr2aHIzR5qHa
	 XmevG5ZKrV9wn+xrv0qVAxlHwO5DiNSN176mmlEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 242/567] svcrdma: return 0 on success from svc_rdma_copy_inline_range
Date: Tue,  6 Jan 2026 18:00:24 +0100
Message-ID: <20260106170500.268796595@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -860,7 +860,7 @@ static int svc_rdma_copy_inline_range(st
 		offset += page_len;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 /**


