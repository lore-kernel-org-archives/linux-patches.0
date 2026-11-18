Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026549;
	b=zuXe0h7YH6CYYX/ZcrutpQGODoEwh09G7uPYA3MGda7BXapNMbxQSfugayRXNLAPBi4M
	 MNpirroDUb9g3lnbFl2WwKVnNM+JyL61JDM75yhlmkQCysmMBgazAc7SAE4TTfUwtP9wv
	 qVpy+IguKXbLsR4H3UFq26RfI6GODP2+esTaGuqEzqu00btx6CNzIuRCJ7GJQeR+5IKXN
	 29yHsAK2dmVxr9yzCc55EsDzKq9boqSrSmfQC6oXnkfAyQmOqe9Y4ZsWyQQ0HHXbnC3rC
	 22fGt0mJTlW0zgGTZ9V08S7X3ZH6VcHNbQ/x+2URLf+C2DrAEMeTHapKMecUsBfxtPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7HpK+n46easr5FHfbHT1DaSxGZIAoneeYeUHpIgdal4=;
	b=UW+66U+YeWopj1lJ3tIwcpyQh6K8WNucDdr7bbzG/Vp0G0wG7CD19pa6EHs7qe8flbJf
	 MkQolDizprZxLhgQdSY0K68NyHpS/EpMKzPzBCzvqtBLDqgcLQwfnfwK8GWP56wBpLTSJ
	 TAEychuFUKsfVwpE3IU5hlXaBMaz135d04C21sduTw81FRDD3zV3M0L9GDZ+1S4A2i8NS
	 4QTBWDL1h1HyeNBsprJNA1vz79Nm1pAUeBa7AKD6RVkmrzWoe8txV9vlcAUldLhvfSovg
	 e0HJ9TZWgYYnxceUnNDSrn+4cPaHc6U6tbBAL/X5KNVpL7YZBFbhgdJcs6b8f7FORbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lglc/or/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F25606A31C;
	Wed, 18 Nov 2026 18:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lglc/or/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9912B1F000C4;
	Wed, 18 Nov 2026 18:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026549;
	bh=7HpK+n46easr5FHfbHT1DaSxGZIAoneeYeUHpIgdal4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lglc/or/VTMrkXv27rAKnFMtD/G8fYikO9zHxradQDmgg5UvrHQRaxlOLP5pO4hZc
	 ucApqhcSHBd7yakU4glL1iX3F4Vw0Fd52E28ox6ggHNsnGqFGXR6xDTDYQEiqGHKg7
	 9nlKWiwIVdy2aiAG1SHZmABKMJ1HZCtVk9ownEas=
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
Subject: [PATCH 6.18 1476/2151] resource, kunit: stop selecting GET_FREE_REGION
Date: Wed, 18 Nov 2026 15:53:31 +0100
Message-ID: <20261118150215.649090730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b8ef75b99eb2f..a44ab80a8cb75 100644
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
index b55f5c8e11f4c..ec2fe94a3e288 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2698,7 +2698,6 @@ config RESOURCE_KUNIT_TEST
 	tristate "KUnit test for resource API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
-	select GET_FREE_REGION
 	help
 	  This builds the resource API unit test.
 	  Tests the logic of API provided by resource.c and ioport.h.
-- 
2.53.0



