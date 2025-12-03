Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0819734AAE3;
	Wed,  3 Dec 2025 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778358; cv=none; b=XvsvZ5RQG3/cA32iEeiuJuKLC6Y+BTj/s62108VHXjx/0na2X9wmgLYBkGKYWcOgdqJ6v3wQ29Zkwqe6xmwUSJdIE31RW0i+FkD81iud4blARMswso+NhNdli3ksaMKTluGb+etAPf0oXIh4vG+xgTfw8nk7g5IJzVPs9lxkel4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778358; c=relaxed/simple;
	bh=X544rEJL8NDQlWnRJhHeAHi0UJTOBXNVYCs2Tp1qY/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tzvgx+y1W2uCg8yOA/FiqnoojcOyAh/WOtOI05yFb5ui0MlY3tD/qHyXGQ4SOoSqWRI+kHUmSHMhhnJMX+A24oZQQoUeGpsdF6B7hHaf6Sp8Pq2zLj4OIdm+dsOA/33B8veZaqMjV4+rLCqDa+CR0vPGtakEv40Aip3h6lcdCxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7yO5GE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7yO5GE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6DEC4CEF5;
	Wed,  3 Dec 2025 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778357;
	bh=X544rEJL8NDQlWnRJhHeAHi0UJTOBXNVYCs2Tp1qY/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7yO5GE1NOrch2WC4nPCMIO0V+oXxrkIoWY0tIxY13A+CN+qYAoLCbtZh0rYjhyaE
	 /xuo1+O77AKWi+mkKrGA9vRmGl42M6/K+i6QArlvSvYUcG+wReGgiTSRfNV/JbjN3A
	 66yCRe1e5oPwvRahsS84kI0j8j9U+125n6qgdLCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/392] selftests: mptcp: connect: fix fallback note due to OoO
Date: Wed,  3 Dec 2025 16:27:52 +0100
Message-ID: <20251203152426.011140401@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 63c643aa7b7287fdbb0167063785f89ece3f000f ]

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
[ Different operators used ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -535,7 +535,7 @@ do_transfer()
 			"${stat_synrx_now_l}" "${expect_synrx}" 1>&2
 		retc=1
 	fi
-	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} -a ${stat_ooo_now} -eq 0 ]; then
+	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ]; then
 		if [ ${stat_ooo_now} -eq 0 ]; then
 			printf "[ FAIL ] lower MPC ACK rx (%d) than expected (%d)\n" \
 				"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2


