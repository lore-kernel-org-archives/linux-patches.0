Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8413976023;
	Mon, 15 Apr 2024 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191154; cv=none; b=iwhTAlsrM82jyfx/CsaCiD4h3nRajppTQb2xzN21ppqeF4iFYD2CEyNtPJKQXg5RrEgDiAb+vJDyylvMtUgtSkyYQq4yOMxgq4OBUFi024V4YoX3jlbqX8H+6mO8Rp+84rY1awA4AIgIsxzfD1f5NPIH0jHRUPLoK2xnjAd6QOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191154; c=relaxed/simple;
	bh=Vy+t/Q7YGB+UuQOGBIH+Pdioc4BAVhiBJmiURe4fsCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZWvgC9DlKYXSXfS+amMnROvG3cxhrchYa4hh9SCuAceQCTiGSLEPDYrpKz2kCaQJPppvqb8lkN7lh6otgzSLUywyRXZagzmxj18s2u/CWe4eIerBW7zESHO4faJ9uOuEIMeH4qPONObC+RCHKkWVwV0fjSej1wu/8FyXBiAwow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uAwyQFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uAwyQFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41F3C2BD10;
	Mon, 15 Apr 2024 14:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191154;
	bh=Vy+t/Q7YGB+UuQOGBIH+Pdioc4BAVhiBJmiURe4fsCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uAwyQFaQxNZsfe7jsAb0XBI0375v7a5uKA2IX10Vjasym0/8Ci4/6AsYLfq45Get
	 j7uPYkLI9Q3DVkcxsRahjhnDHQZLoq/1OYcHSSLShJ+LbquPWS4DJRz5nb5zxNwpTT
	 dtksCqM/yB5Sk/uBuhlgzTeB7RBa37TJJmC2H/gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 048/172] lib: checksum: hide unused expected_csum_ipv6_magic[]
Date: Mon, 15 Apr 2024 16:19:07 +0200
Message-ID: <20240415142001.876740925@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e9d47b7b31563a6524b9f64ea70ed0289cc4d9c4 ]

When CONFIG_NET is disabled, an extra warning shows up for this
unused variable:

lib/checksum_kunit.c:218:18: error: 'expected_csum_ipv6_magic' defined but not used [-Werror=unused-const-variable=]

Replace the #ifdef with an IS_ENABLED() check that makes the compiler's
dead-code-elimination take care of the link failure.

Fixes: f24a70106dc1 ("lib: checksum: Fix build with CONFIG_NET=n")
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/checksum_kunit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/checksum_kunit.c b/lib/checksum_kunit.c
index bf70850035c76..404dba36bae38 100644
--- a/lib/checksum_kunit.c
+++ b/lib/checksum_kunit.c
@@ -594,13 +594,15 @@ static void test_ip_fast_csum(struct kunit *test)
 
 static void test_csum_ipv6_magic(struct kunit *test)
 {
-#if defined(CONFIG_NET)
 	const struct in6_addr *saddr;
 	const struct in6_addr *daddr;
 	unsigned int len;
 	unsigned char proto;
 	__wsum csum;
 
+	if (!IS_ENABLED(CONFIG_NET))
+		return;
+
 	const int daddr_offset = sizeof(struct in6_addr);
 	const int len_offset = sizeof(struct in6_addr) + sizeof(struct in6_addr);
 	const int proto_offset = sizeof(struct in6_addr) + sizeof(struct in6_addr) +
@@ -618,7 +620,6 @@ static void test_csum_ipv6_magic(struct kunit *test)
 		CHECK_EQ(to_sum16(expected_csum_ipv6_magic[i]),
 			 csum_ipv6_magic(saddr, daddr, len, proto, csum));
 	}
-#endif /* !CONFIG_NET */
 }
 
 static struct kunit_case __refdata checksum_test_cases[] = {
-- 
2.43.0



