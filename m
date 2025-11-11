Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14305266B6C;
	Tue, 11 Nov 2025 01:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823895; cv=none; b=j5irBs86HUrhCTT8/WbDkT4kAkfH+zClnfhgmyjNWjr5luMb/7qJqNm03Jk5D5BOFXVc4HTRGQnBFWt6HVfRoUhOV0/YYWgPGP3z+uFBgdO+s8h+joiqL2vSeU+wyU8Jt2mRMAOOnWiPn3PKyaXM2ozKKG/LBg5NnfYYJBqJN28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823895; c=relaxed/simple;
	bh=LCY+TaoMFbbORKHDGij6n08hEg8jAJSdkx39aeRdpA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6qL1vSV5J91ZcBdlx4iG/+a3CEsnDNKSoB6HmT61TejQuOfJwCoELP21MpmCNsQVkM1MAnjeTZe60osvB2V/1Ol6Nq8t5wL7gzDl8tIezPDDWE/jN3rLtAV/POTIYcs07+etyOtwls0HZ2JGV7ZGtb1upnulDbCA+ATv4bNSvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jY193sFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jY193sFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49678C4CEF5;
	Tue, 11 Nov 2025 01:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823894;
	bh=LCY+TaoMFbbORKHDGij6n08hEg8jAJSdkx39aeRdpA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jY193sFYdYHl2z+AfalDgQIsrwe7Kt+n9IjN8+Ve7b2MKEWyVGVjyl6hZGq1IelZZ
	 iICqrQwNLvRJNpbug/6skhzNCAJ3zpjDCgxchXsmLKqrS2Q3AQekZe/iG7wWlVXKx5
	 Qyj+ZeDY3OQF1Cy4RJYL9PiLbc7QsVO3cLKXRMxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/565] selftests: Replace sleep with slowwait
Date: Tue, 11 Nov 2025 09:43:21 +0900
Message-ID: <20251111004534.637419512@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a7edf43245c2a..bb2b789541ff4 100755
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



