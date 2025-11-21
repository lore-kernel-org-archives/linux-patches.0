Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FE43242B0;
	Fri, 21 Nov 2025 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733503; cv=none; b=S5OU0Ol+ybSjmBSiL3nlfYZHAAToP2yzt3FjTcQu0/zFOVKRp6/dQyUMleKXhpFVmHGLfzLnSXUV2YtAFc7P5/n+imyTTwC/EmhNsiNHlHuOLsoniRpTKhiBoBd83gJ/i6Oum6HvTv5epRDOIhZnBU8K6+ZyGCdxnz1teEE29H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733503; c=relaxed/simple;
	bh=Q2phM+guaWjZD+yqnKexcJbhBHu7dH5Boqhlw0tLC88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHJ+Dh3gOqIEzAzBTDs8/ixU3Zjiw39gYz929oITCAoJHEI+isGXbC8LqreejytJiwqmbMA/5z+JMl/GtTggTRunoOY+y8Dkl+Q/EC0yG8MVcS4Z4exSSp2LUAMdRrK2mIWZKEwZXg91vsGTJV442AA5wSNrfeXg3o6djuCCWyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8skqP+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8skqP+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF1FC4CEF1;
	Fri, 21 Nov 2025 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733503;
	bh=Q2phM+guaWjZD+yqnKexcJbhBHu7dH5Boqhlw0tLC88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8skqP+G4XJEpRkMlsJf3JZb6fJM+F4Rz2So4IkOsBf0NUC5+EHBb5n/cSm2JHBQ3
	 wS2LfBdR6Oqccg1u0QYMictE8H0feamZgokAiBzgz81bvjzoellog5N4HYMxKd7F6X
	 1PSnCr9AEWkCgxGGSyisB6MiGmP4VQT+oyoGgAU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 489/529] selftests: mptcp: connect: fix fallback note due to OoO
Date: Fri, 21 Nov 2025 14:13:08 +0100
Message-ID: <20251121130248.407630213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 63c643aa7b7287fdbb0167063785f89ece3f000f upstream.

The "fallback due to TCP OoO" was never printed because the stat_ooo_now
variable was checked twice: once in the parent if-statement, and one in
the child one. The second condition was then always true then, and the
'else' branch was never taken.

The idea is that when there are more ACK + MP_CAPABLE than expected, the
test either fails if there was no out of order packets, or a notice is
printed.

Fixes: 69ca3d29a755 ("mptcp: update selftest for fallback due to OoO")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251110-net-mptcp-sft-join-unstable-v1-1-a4332c714e10@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -516,7 +516,7 @@ do_transfer()
 			"${stat_synrx_now_l}" "${expect_synrx}" 1>&2
 		retc=1
 	fi
-	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ] && [ ${stat_ooo_now} -eq 0 ]; then
+	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ]; then
 		if [ ${stat_ooo_now} -eq 0 ]; then
 			printf "[ FAIL ] lower MPC ACK rx (%d) than expected (%d)\n" \
 				"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2


