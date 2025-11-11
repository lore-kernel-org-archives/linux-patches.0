Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392E33B6C4;
	Tue, 11 Nov 2025 01:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824552; cv=none; b=BJNJDogKId2mCG3s2cFBCoXcnlmivRGvCekBHXh+Ai7f0KSUSDeHnoMBjwAagsn3++bs93EtpD3ISauLKS3YHfSxW+XW2e8pOyGyxt1hvCZ8wUYJMiAq5MVIYvmOsms0U5Xrqd7RPUPBO6x6Zb6+1THXeq6d+F93klGTWpWkdGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824552; c=relaxed/simple;
	bh=ixDeqf2uYrkHLBMBBVxPspnDmVNwR9JDAAA7PkOaNi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKP2JhcNP5GMMUj5A+0KFS6sGSm5BZ9kNWk4pF+QBdZLRueVE8ALCIQr6oaPEIXwChdNjkVec3tTlOOkB4u3HVKwLkTOs9PM7gmmxJtQf/J8UyneH9oKWpjPsI501AOSbnNQnaf4k/v8Cu6svtpllBCibXIa1ONj/qc5c2Y9Z+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vooQiSWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vooQiSWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA00C4CEFB;
	Tue, 11 Nov 2025 01:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824551;
	bh=ixDeqf2uYrkHLBMBBVxPspnDmVNwR9JDAAA7PkOaNi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vooQiSWcRVdPMQAtl/1D7dCJPIwloPUKk4iF4AQPwAsCszfj3+/mZh+cjJ6YGk5ux
	 3wc9eQ+UBtKAbQO8VlFGZjoyJVB4+PSK+Ih1GEWFGl5/j6JSzhyyL67Yr8bOawvnT+
	 3LFl/2F0f+Y0Io38iYA0uQroou3CbP0ZIbEmqd3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 522/849] selftests: Replace sleep with slowwait
Date: Tue, 11 Nov 2025 09:41:32 +0900
Message-ID: <20251111004549.043155472@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 2f186dd5585c3afb415df80e52f71af16c9d3655 ]

Replace the sleep in kill_procs with slowwait.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-2-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index cf535c23a959a..dfd368371fb3c 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -189,7 +189,7 @@ show_hint()
 kill_procs()
 {
 	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
 }
 
 set_ping_group()
-- 
2.51.0



