Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4082112E6C;
	Sat,  3 Feb 2024 04:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933708; cv=none; b=u29pk4gQMMPCJ5az6Pc+IuqvuMYDd+/czjQDZFOpLSm3f8x150X2YL7W0I7KWP50g6jrD7kaqTcY3jJyh+LZvFXGCMosVyyutsKBGgPXlXIY64on8Xasgb7XVYrLc5bHRJi2Cgkm3nOiMlp6eT3K1IK58/tZPLVZs172h0BkA6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933708; c=relaxed/simple;
	bh=fjlRJ2mvjpHaX3h3BDMAyno85YPb8+HMjWiqx3MInkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koxkmvtR8oxx22oVpw4F84II1nUfjd/oOt6sE9TFSSiGSPOj+syy3MbwtT7essgeOAMPLCuNOBlW2alNB19HVdguv4ROnqp+yAPpE0a4bLbRxL700vnAnqlBcnIHG5opxlDQ/1+b8tohI8qM+QHRofQImAucffM5QdeoI+mfLf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4JZTMhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4JZTMhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4F5C43399;
	Sat,  3 Feb 2024 04:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933707;
	bh=fjlRJ2mvjpHaX3h3BDMAyno85YPb8+HMjWiqx3MInkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4JZTMhB/gSgxk50tubJ2xNokg+HUnweayxdcPoSR9wgupk12ujvO9JTYvvybqRd0
	 oQqBHDc7+CVCkGwolydbu2NcPOJXJqKHOHlz9v7hB2iL7Tc4z4zCt/A0k/ZZ9C32NX
	 D8wEOv9ilZRrUNpK43sUgDQz3xLm4oald4eO6DQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 309/322] selftests: net: dont access /dev/stdout in pmtu.sh
Date: Fri,  2 Feb 2024 20:06:46 -0800
Message-ID: <20240203035409.016899515@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



