Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DF323C6;
	Tue, 23 Jan 2024 05:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705986721; cv=none; b=udRJKiVpW7lNwHdQ/YrxcYWs9YFNgf8VLYV7wsswFxjJumTXX4N1DElawlZUYF6jkFWZvp+NxUC3nia2mZ8Pj+CzRDZkqTQpjgxqpGyiXaWaiwYd6r84pRw5s2YhRA7b4NeyyAW24FahWcc2IqZcpYbDpx72UyatBxtwDS5KU2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705986721; c=relaxed/simple;
	bh=c8iOlCeaEk0mMOc3eox/UyW+/s+RyondPxM+SYVNgYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dPZVOf+Nfy/xEY1h6Vxu4EakU6oOD9EOajLM97OdrqjFHTowV6KmnEL7LpZf/LJQ6qxpO50ExXx8qXPAFHhrnzl54VxCedmtSr0rO/8vexrdwaVAnfRnNI2pCwHyZlbxbEwjGfJ9j3dMJmwO1vehcqLa9usvA/H0K78chAXDeIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CK7i3sh0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CK7i3sh0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Q0Ch9qtRDsWgaVCBGepAuuXz/gYgKTWF5H3y3EF92GI=; b=CK7i3sh0X/d+FbrRuelyjzmkUF
	g4WhAEw/bVzzPrcg/Kk8fFNuWWZP3Xc1AGgKnajfVMGG5uZnI0+kJMx/kkITYM/aZBF3/f3/qphdC
	06uwix2eTLt15I5YGocvVF3eQAEFnKM1EPMldi2U31ysRpqT/MKMtxg6JlO8LpalvWDXnDpgSD8yp
	NwML+KzgFl8jrNXzGxLI/mAmYgqGhVgGGHpuEdi6iJMsPKrylxk/LEkFDp6L/4sjsv2z+VB4+y9Fs
	ejN3sjYZhYRNe4sR3EAYKnmbm60QYPWuTGc3ZyBmkeAQkgPR9LkHLrNX9VwYlC5iw3jf70Jj6c/LQ
	TCh5d8BQ==;
Received: from [50.53.50.0] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rS94j-00F7Dd-0D;
	Tue, 23 Jan 2024 05:11:53 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jon Maloy <jmaloy@redhat.com>,
	Ying Xue <ying.xue@windriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH resend] tipc: node: remove Excess struct member kernel-doc warnings
Date: Mon, 22 Jan 2024 21:11:52 -0800
Message-ID: <20240123051152.23684-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove 2 kernel-doc descriptions to squelch warnings:

node.c:150: warning: Excess struct member 'inputq' description in 'tipc_node'
node.c:150: warning: Excess struct member 'namedq' description in 'tipc_node'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Simon Horman <horms@kernel.org>
---
Resend after merge window has closed.

 net/tipc/node.c |    2 --
 1 file changed, 2 deletions(-)

diff -- a/net/tipc/node.c b/net/tipc/node.c
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -86,8 +86,6 @@ struct tipc_bclink_entry {
  * @lock: rwlock governing access to structure
  * @net: the applicable net namespace
  * @hash: links to adjacent nodes in unsorted hash chain
- * @inputq: pointer to input queue containing messages for msg event
- * @namedq: pointer to name table input queue with name table messages
  * @active_links: bearer ids of active links, used as index into links[] array
  * @links: array containing references to all links to node
  * @bc_entry: broadcast link entry
