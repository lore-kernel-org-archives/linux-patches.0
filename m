Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6B3362123;
	Wed,  3 Dec 2025 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780209; cv=none; b=PqkHqOqbZR4E6T1EOyRete7BYNmqG1mhVu9pOMcm+p/sDWIXXXPEC2E4RhD2nMR3OzpV6Gj87KLCi9yxx3VV+sJrdlvsNSu4/+8IME8fdoh8wEoQGqUEkWDsl+WVZDfhULmzpNZwCsp/bxu1TzBqjzf9IEPsfsyilxuuXiCgOa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780209; c=relaxed/simple;
	bh=BJOPCHC8VWyVMsMgBY99bZuIWvmad6NBcgsIwgt0UK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5wAzTKKAm0dHBSC9S43juIvXsENYd0DmdMqiDJaR10s3eFQgI6+9TBsfTxwqtDIv7xG9Q/9n32B+Gy5S/ufuDoSaiF/G0nRpV8m3KUSEBfBq/Wb3hrXjIv+kAnjCV9gRlUb+BK4yCaKSMeTzu8r+z1SOUAAsE2ZTuUcsQ7l1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuW7uOXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuW7uOXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF48CC116C6;
	Wed,  3 Dec 2025 16:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780209;
	bh=BJOPCHC8VWyVMsMgBY99bZuIWvmad6NBcgsIwgt0UK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuW7uOXXUnK9C/cvwRBIn2N93MKhdrO1dn0WbwQKlLrwB3vraKehJqIWZpZCqKWGo
	 HBxmN3LQyZqfk+4olakkTc304dOBGFomGn6MNJTfBxSxlJ0QzY1vjNwTHe+bTQ7/7J
	 VU5w/3ylGtYzvaAgfOZEx6pZyLLKG1Mcrig5dCEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 487/568] selftests: mptcp: connect: fix fallback note due to OoO
Date: Wed,  3 Dec 2025 16:28:09 +0100
Message-ID: <20251203152458.542605477@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -523,7 +523,7 @@ do_transfer()
 			"${stat_synrx_now_l}" "${expect_synrx}" 1>&2
 		retc=1
 	fi
-	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} -a ${stat_ooo_now} -eq 0 ]; then
+	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ]; then
 		if [ ${stat_ooo_now} -eq 0 ]; then
 			printf "[ FAIL ] lower MPC ACK rx (%d) than expected (%d)\n" \
 				"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2


