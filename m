Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045569;
	b=z28Vk4sdlrudMfkSKB9BmEpZuEOce1eQPGEAKmOaz8HPswiDq0kXF2Sey3dM4Kbi7VEH
	 dqhnRd7eSDsZlhfEIEb15Au8H7g2VgWMLq7wsA8062dEemIsfEhDavba/5Z7CQVVWCcPY
	 PLPI9JKtnvfbqiJyttLE4IM+6CZqocLysH+oaZ1pKsdSMWmbzVLzf6h3e4a/EDyHq6Nvr
	 7whE/qARH98ZX3poZyzFl3RIiczrcCeZeJhHpEKHP+B3V/jfqmUqWYyZa0UzQFC+oYh/n
	 SrQ9mxa5BBZBpqkqBfe60qntEVRcUcotIHKhWoeMrWtdpk5uf5zoT4OUxMbhMvNJGFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cNHKJhErnEaxt7ynELMsPIo1kmUaKa6uQJmUjInbV70=;
	b=RaOMwsmSe+PA8k553YlkX//AYTRAo1+YsX+Th304KVhLLWslOLSccjBJMcb5le3rWi6j
	 kz4KzYWkUAO+sLoKq5BZXP82UkoOJ+jLBunxym9CWFqxmAVBVCYI6t2Oc9rozLRjzD8zs
	 KUhFghdT5v9LzZxubqiUGlzZc41upF57iTQoOKk9yMNFyuzIPuNxPKM+xrIw0I7H0LDiQ
	 ImH/DkNwau03AX2tGHWNe++QzLNY0pCByWE/7RA7LORJe9imJ1iRSunEzZB0PflZajHWo
	 acpjyxMoMexr5dgwULeMqYfLLKjuepVymG2Fg/KqmAplK9n8LfEYBQdGikSrEpavscA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQGzy0WL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AE4606A33F;
	Wed, 18 Nov 2026 23:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQGzy0WL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074E81F000C4;
	Wed, 18 Nov 2026 23:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045569;
	bh=cNHKJhErnEaxt7ynELMsPIo1kmUaKa6uQJmUjInbV70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQGzy0WLktd7xZb7TiiUG0KgENDfur//ZrKg0YQg2U5DpiVDk7aL1n5ZKh9qz/Wih
	 EcKotAvEL8JEs2GymD2/ANigvMdWdwO5MGrMlvB05VO+z5WhInq5PO60WgKqgmUTQM
	 eBMjIezYG6RvRnUDAKnIOlRbDOd6WmAqfznuiQjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0970/2857] dax: Return errors from dax_core_init()
Date: Wed, 18 Nov 2026 15:33:24 +0100
Message-ID: <20261118150236.535493088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d34788813da74..4188307c0f64a 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -585,7 +585,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.53.0



