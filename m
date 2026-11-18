Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020054;
	b=VghB21+uNhzu2xJp1XlnDqRKS4jTlpMNp9JFQBGChx+hRND3nwH3cNR/sorWqHWRmQGq
	 ImXOtAnVsM9dHtVpIEwJpsV3fB5SXAa8tyXMj1CPVUdM9pkJOb7lIBdR6FIJnoAmnppja
	 FHDgP1HJ58GaWXBFXJbaoE+h1b8jBAoqdWgXXawsX3FwbIe5N0MVs35uQf+4319wuK2tv
	 r9j3ZcVjzqXbqjkZv6GgDbLc5zHfIp94UQfS7bR8EINwI0zxquqt01QVVt5Fw8NysKQ/V
	 pPBclSKALQwJtNnUShekhZFQ+WdPaxYI80mcj3IFN+r6tgYFaRrGbaCoT8u/FkTP8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eo+gba0QEXzmn9iEXAaSmkBdyH9tkrah55PfoMo9g88=;
	b=UojqChphJH0FmJAUFIHJpMznvM4ncJNJNcKlatjv8MmJVtkzUGLIScnk0EfP/le2v6ol
	 VpfVX6Wz/gbCzrD+p3i5Q/ayLsMBKlNuqBccg03yejdzc3loHqJQVqnzfL9e6ediqOV0H
	 ZRIl2L+gYN8sv7MaF4jQxSUkyGyUKBF0QStIrTn0NHB1IG6mjDu++oq/HIt6yH22YsDOL
	 gNx5edffYVRZknljEbu9fJfjRkdEMzkMA0lKQu1I6EGoQllwrN89SjI2Y2EinX4C7sPWA
	 nQEqtf1wZQUar3fQgywFHu/C7sVtBzZ0UrPhY+cn6HPuuZUrHYCxiw/hwOI+Z6lTcWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=voi6p2vg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6FD606A334;
	Wed, 18 Nov 2026 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=voi6p2vg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1E51F000C6;
	Wed, 18 Nov 2026 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020054;
	bh=Eo+gba0QEXzmn9iEXAaSmkBdyH9tkrah55PfoMo9g88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=voi6p2vgOl8wBkmXVnk08PdMNGXwhZvBcf1G2au0pfRb1X0uzM/n5l1MkPqKNQGCB
	 UCLqsIMtFAPpDZfJ2rVv+3ov0yf4Mi2Rc6VUAb8nwOch60eZ0IP4XNFd0sldupQ7GU
	 DWFjmqUn7g/CYo8tXCHxHnExlncLOpfACFC42EAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bradley Morgan <brads@mainlining.org>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1815/2651] resource, kunit: stop selecting GET_FREE_REGION
Date: Wed, 18 Nov 2026 15:50:55 +0100
Message-ID: <20261118150352.554323578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 7c3f4d699f34535285d0ceb184927d71543d0064 ]

RESOURCE_KUNIT_TEST selects GET_FREE_REGION even when no other option
needs it. Remove the selection to follow the dependency rule in
Documentation/dev-tools/kunit/style.rst.

Skip resource_test_region_intersects() when GET_FREE_REGION is disabled.
GET_FREE_REGION has no prompt, so configurations without a production
consumer cannot enable it. Most configurations will therefore skip this
case; this is intentional. The union and intersection tests remain
available.

Since kunit_skip() does not return, the compiler drops the reference to
the unavailable alloc_free_mem_region(), as in the CONFIG_OF_ADDRESS
check in drivers/of/of_test.c.

Link: https://lore.kernel.org/20260926002651.87267-1-kmehltretter@gmail.com
Fixes: 99185c10d5d9 ("resource, kunit: add test case for region_intersects()")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Tested-by: Bradley Morgan <brads@mainlining.org> # Power10
Assisted-by: LLM
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <david@davidgow.net>
Cc: Rae Moar <raemoar63@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/resource_kunit.c | 3 +++
 lib/Kconfig.debug       | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/resource_kunit.c b/kernel/resource_kunit.c
index 42785796f1dbc..9eeb2b1a85c01 100644
--- a/kernel/resource_kunit.c
+++ b/kernel/resource_kunit.c
@@ -225,6 +225,9 @@ static void resource_test_region_intersects(struct kunit *test)
 	struct resource *parent;
 	resource_size_t start;
 
+	if (!IS_ENABLED(CONFIG_GET_FREE_REGION))
+		kunit_skip(test, "CONFIG_GET_FREE_REGION is disabled");
+
 	/* Find an iomem_resource hole to hold test resources */
 	parent = alloc_free_mem_region(&iomem_resource, RES_TEST_TOTAL_SIZE, SZ_1M,
 				       "test resources");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6b24a2c89b84d..1dc11129f3c2c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2776,7 +2776,6 @@ config RESOURCE_KUNIT_TEST
 	tristate "KUnit test for resource API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select GET_FREE_REGION
 	help
 	  This builds the resource API unit test.
 	  Tests the logic of API provided by resource.c and ioport.h.
-- 
2.53.0



