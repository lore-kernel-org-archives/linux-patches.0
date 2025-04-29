Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6999A243364;
	Tue, 29 Apr 2025 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949178; cv=none; b=Bt72OKzu4kENTsHaMgaFLllKm5EV7O9YuA55ISwA56+aRIv9IRyxBRF1XMXjfJ9TeyAgB9zLMz5D8ymb3zYi71JS1hbrL5Mv7Iw8wb6DMJBEvEZ4G/6gxpsvDMN58vb+JUNfg5WkOMFNMV8p6PRa53MvJoG47SuHkBjcBIa+jAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949178; c=relaxed/simple;
	bh=AaWqhBXvqDU/uI0eXKWcXLkwTGNyefedDPHgF2uIMUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL7e+6b8o3cN6j0zWkNiLfhb6tz0s7Ffey/UMCRNAWOuTtEIpxI/iizgXQjDkeZou1sILF7c/juzEJNCcYO+1ozX1RlWfD08zjxgiFFaBDPn5YKVZcRhzCutohPb+VTWJLg5gZ2zvZzckbBXdl80o3BmxdwzLCIC66/tCTlBP1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d68IVPvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d68IVPvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9628BC4CEE9;
	Tue, 29 Apr 2025 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949177;
	bh=AaWqhBXvqDU/uI0eXKWcXLkwTGNyefedDPHgF2uIMUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d68IVPvD11DQl+xoAtvUaBPOGS99/6Z0XXYRrlLF0tUbK7F+BTrw5Yfw90Czi5KFP
	 pVtKpUvExY///tDO4T0KejvGF6DyQA8dy1AUSgXyiNklkV8xiuNuLkZz+iJVmmVfXn
	 OS7S8lGkiP7PhOaU+LZabH5p+lxGoJ1TlBJiDBh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Hanxiao <chenhx.fnst@fujitsu.com>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.15 235/373] ipvs: properly dereference pe in ip_vs_add_service
Date: Tue, 29 Apr 2025 18:41:52 +0200
Message-ID: <20250429161132.807632502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chen Hanxiao <chenhx.fnst@fujitsu.com>

commit cbd070a4ae62f119058973f6d2c984e325bce6e7 upstream.

Use pe directly to resolve sparse warning:

  net/netfilter/ipvs/ip_vs_ctl.c:1471:27: warning: dereference of noderef expression

Fixes: 39b972231536 ("ipvs: handle connections started by real-servers")
Signed-off-by: Chen Hanxiao <chenhx.fnst@fujitsu.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1384,20 +1384,20 @@ ip_vs_add_service(struct netns_ipvs *ipv
 		sched = NULL;
 	}
 
-	/* Bind the ct retriever */
-	RCU_INIT_POINTER(svc->pe, pe);
-	pe = NULL;
-
 	/* Update the virtual service counters */
 	if (svc->port == FTPPORT)
 		atomic_inc(&ipvs->ftpsvc_counter);
 	else if (svc->port == 0)
 		atomic_inc(&ipvs->nullsvc_counter);
-	if (svc->pe && svc->pe->conn_out)
+	if (pe && pe->conn_out)
 		atomic_inc(&ipvs->conn_out_counter);
 
 	ip_vs_start_estimator(ipvs, &svc->stats);
 
+	/* Bind the ct retriever */
+	RCU_INIT_POINTER(svc->pe, pe);
+	pe = NULL;
+
 	/* Count only IPv4 services for old get/setsockopt interface */
 	if (svc->af == AF_INET)
 		ipvs->num_services++;


