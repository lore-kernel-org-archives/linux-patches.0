Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062456;
	b=y7h24JuZ8ibpbqMgu5NMGCytbzCTSr6ksR5GPclx+2eFPcdeTgkXfgbltfbl+ra3Erbu
	 wp7edKuoIg7crH2UC5kLgaPdh4tTooWuCPSZN8XpbN0NXfimk87F4oyV5UwvP4Uj2Ki9H
	 bU8BQu/bRbDxq48FicZxwcQvKn5ue7joH+3yu7UMZhuTf6GADP0U2I1vpYxEQ8f5c5kK4
	 CLGG+trA2mqvg2PjVY+Q54fk1Lv87rNvyejXfqJ4T5om1ezSZCI6dvU7pz9knNx1cttL9
	 XY/wmP+gcfoIJy+TWCr73rXpbfjv0vwGcHEZoEv5WSN+OD25SdKqc3e0rCr8HatqpKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qtCYqT7xXO5jN2InAQH6ThjZCZUpOM6qCmC4miaK2I4=;
	b=4omXz10ZF1cvd0XROJspePkl8Uc/rsONggIRVckSKzF0bL3HDgt5rtRl3mG/hUi1/J+U
	 Xs7SRinEYee8oj9taFGIXvwXLOYaJGDjutAyFoITQb8ufo8nNwHaFYy6s6hfMWkVBVfEE
	 FZn/Bgw5yDVJpfRlQkIsAKYxDGe/9eZ+D97UTyYBJsnB2pq5RAi8Ih7vZNroFFWZbjlqV
	 qV4BWpyNDjsjuFvf9mjgxJI7jjB3RJAv0jAwWg18Jwldsfz3Z6Pu8u/W3LMQ3NlYZLoTN
	 2CVh36OqfTOHFOgYo+OF3h4Kx77mcUyROR2C6sOOfS+e+U2KW2dL4Rd9PEyZpNV63TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlJ9ao7n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70705606A644;
	Sat,  7 Nov 2026 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KlJ9ao7n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194921F008A5;
	Sat,  7 Nov 2026 14:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062456;
	bh=qtCYqT7xXO5jN2InAQH6ThjZCZUpOM6qCmC4miaK2I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlJ9ao7npeRhQWLNicTYPFNczDr05eewvnUlmJ15GKaoUg/auHjWI4x9M/HXaCUZ5
	 CCWXK99uXhIYP+olIi8/WUZv3oN5g3O8CrWDvwgpnGIoe4BP6Q0S4k3KpbIy3hIsvY
	 fEsq/z+iG/yshfNrOPEQLs9CDlJYPaKCtKy9qAIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1325/1536] dax: Return errors from dax_core_init()
Date: Sat,  7 Nov 2026 08:55:41 -0500
Message-ID: <20261107135035.029446226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 4da700e2cadf84a6e858391d5be51d64dcba080f ]

dax_core_init() returns success when either the character device
number allocation or DAX bus registration fails, even though the
error paths have already released the initialized resources.

For modular DAX, this allows the module to remain loaded despite
failed initialization, leaving subsequent users and module removal
to access resources that have already been released.

Return the error code from the failed operation so that module
loading fails rather than reporting successful initialization
after the resources have been released.

Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261012151857.22534-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 6eb7ecd233840..718da8ab8a002 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -602,7 +602,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.53.0



