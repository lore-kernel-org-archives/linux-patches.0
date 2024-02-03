Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3792C691;
	Sat,  3 Feb 2024 04:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933982; cv=none; b=lc8NAWPO5mcfrKqh9OZNR0+5Oyu8nXKK6+qn4VXFPSVj1vyzX0z0UtM6dY4BZOPl1ptF6XJnrAizInT9EFbbocZYdiuncAxxNFBErcD9NJyvm6kEZ+pb+iPIdk1mbhtnEpjw9gCfbVbzOyqfFCtRvCtGJQGkMhQUFtg65gh+Xz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933982; c=relaxed/simple;
	bh=3wbj6rtg3TvaLzvlr+6qHwjhpdPMliNDsXC92nQtSNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdwuKyD2q4Vt9veO6MHTMhWB4a0egsavJs/KAgsDMlRQ/pGwtTrr8EL5qa7FQDJToYrPcN7mELImEkYH4lYLw+nXVed7RMCD6Z3/ViMzeKB8nDW3iRRBu+vzLoJP9xcuidS4rXcuuoePsRTZcpskdOaxqq+5KF3Saw6JKxyGTJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEYe59kH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEYe59kH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856B4C43394;
	Sat,  3 Feb 2024 04:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933982;
	bh=3wbj6rtg3TvaLzvlr+6qHwjhpdPMliNDsXC92nQtSNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEYe59kH6jIsDlUwVbOSl+CflSBiL1Xw70naXxLmMxSkd21J6H4W/bHJc9aZOEjtD
	 S2zGHgAlMzcwJOqXdkR2UnjzGMBlTzK2i/OKoHhbGx8e9JLbmVrdFITtAHjEd5DKsI
	 dtSBFkHLLBtQ+vw/fAbQjKUUthj5LbKg87KcePWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 340/353] selftests: net: dont access /dev/stdout in pmtu.sh
Date: Fri,  2 Feb 2024 20:07:38 -0800
Message-ID: <20240203035414.530292262@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit bc0970d5ac1d1317e212bdf55533935ecb6ae95c ]

When running the pmtu.sh via the kselftest infra, accessing
/dev/stdout gives unexpected results:
  # dd: failed to open '/dev/stdout': Device or resource busy
  # TEST: IPv4, bridged vxlan4: PMTU exceptions                         [FAIL]

Let dd use directly the standard output to fix the above:
  # TEST: IPv4, bridged vxlan4: PMTU exceptions - nexthop objects       [ OK ]

Fixes: 136a1b434bbb ("selftests: net: test vxlan pmtu exceptions with tcp")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/23d7592c5d77d75cff9b34f15c227f92e911c2ae.1706635101.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 1f1e9a49f59a..4a5f031be232 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1348,7 +1348,7 @@ test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() {
 
 		sleep 1
 
-		dd if=/dev/zero of=/dev/stdout status=none bs=1M count=1 | ${target} socat -T 3 -u STDIN $TCPDST,connect-timeout=3
+		dd if=/dev/zero status=none bs=1M count=1 | ${target} socat -T 3 -u STDIN $TCPDST,connect-timeout=3
 
 		size=$(du -sb $tmpoutfile)
 		size=${size%%/tmp/*}
-- 
2.43.0



