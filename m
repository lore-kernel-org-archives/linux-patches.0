Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678CF222590;
	Mon, 22 Sep 2025 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570158; cv=none; b=fyHbEf0WBVDl5/6RahF4pSjXb0rsKRFVrZbFyFZiodLwuqBoKkrFtdE0//22uBoJfEvIO2QQ7ZB7Ja+j15mGg0QvcLW14ZvDeNw1ZBUT43Uu+PU74oVtqchl0SKgyoPrZW++mMSLvTHhKNh4D1PYxRk4IZcnZ2r9ojPFChGsneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570158; c=relaxed/simple;
	bh=PHQxS5H3hgqCD+iVVt2z6F7CozTq9F8rrbtn+Ae6gc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU7dxOmCXX4v6Ucm+o/+wCNYk02MRTur1+sYR/ZoqpohHHYVnpqRQWqY2UeAX+0teasr1+1/CdaXzI6G4h20Od+xVxzuVavdlmozYvVfofTub51abPTDuSFCvCnXF8s2akzOYCqgFHUpQH6bl9ueRNmqlxPkqj7rTGGZ9TROiPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LgXVYNDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LgXVYNDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F62C4CEF0;
	Mon, 22 Sep 2025 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570158;
	bh=PHQxS5H3hgqCD+iVVt2z6F7CozTq9F8rrbtn+Ae6gc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgXVYNDcuef553fw8ZlqroLSr/P3E7EmNVjVpSIlvmMm5mud8cLHlbF3ljTUtMu0y
	 bSLBc3zP/JGZ1W0tHjLxN0x0DxjXsOEI+NCFeHn/Ta8UtzMEzfGhVIHbR9ObPJdZe+
	 kF46t8+kiHdOYmgtdY4JUNFjgXBDbtP6EwhY9Ezw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 028/149] selftests: mptcp: sockopt: fix error messages
Date: Mon, 22 Sep 2025 21:28:48 +0200
Message-ID: <20250922192413.578446234@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit b86418beade11d45540a2d20c4ec1128849b6c27 ]

This patch fixes several issues in the error reporting of the MPTCP sockopt
selftest:

1. Fix diff not printed: The error messages for counter mismatches had
   the actual difference ('diff') as argument, but it was missing in the
   format string. Displaying it makes the debugging easier.

2. Fix variable usage: The error check for 'mptcpi_bytes_acked' incorrectly
   used 'ret2' (sent bytes) for both the expected value and the difference
   calculation. It now correctly uses 'ret' (received bytes), which is the
   expected value for bytes_acked.

3. Fix off-by-one in diff: The calculation for the 'mptcpi_rcv_delta' diff
   was 's.mptcpi_rcv_delta - ret', which is off-by-one. It has been
   corrected to 's.mptcpi_rcv_delta - (ret + 1)' to match the expected
   value in the condition above it.

Fixes: 5dcff89e1455 ("selftests: mptcp: explicitly tests aggregate counters")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-5-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_sockopt.c  | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
index e934dd26a59d9..112c07c4c37a3 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
@@ -667,22 +667,26 @@ static void process_one_client(int fd, int pipefd)
 
 	do_getsockopts(&s, fd, ret, ret2);
 	if (s.mptcpi_rcv_delta != (uint64_t)ret + 1)
-		xerror("mptcpi_rcv_delta %" PRIu64 ", expect %" PRIu64, s.mptcpi_rcv_delta, ret + 1, s.mptcpi_rcv_delta - ret);
+		xerror("mptcpi_rcv_delta %" PRIu64 ", expect %" PRIu64 ", diff %" PRId64,
+		       s.mptcpi_rcv_delta, ret + 1, s.mptcpi_rcv_delta - (ret + 1));
 
 	/* be nice when running on top of older kernel */
 	if (s.pkt_stats_avail) {
 		if (s.last_sample.mptcpi_bytes_sent != ret2)
-			xerror("mptcpi_bytes_sent %" PRIu64 ", expect %" PRIu64,
+			xerror("mptcpi_bytes_sent %" PRIu64 ", expect %" PRIu64
+			       ", diff %" PRId64,
 			       s.last_sample.mptcpi_bytes_sent, ret2,
 			       s.last_sample.mptcpi_bytes_sent - ret2);
 		if (s.last_sample.mptcpi_bytes_received != ret)
-			xerror("mptcpi_bytes_received %" PRIu64 ", expect %" PRIu64,
+			xerror("mptcpi_bytes_received %" PRIu64 ", expect %" PRIu64
+			       ", diff %" PRId64,
 			       s.last_sample.mptcpi_bytes_received, ret,
 			       s.last_sample.mptcpi_bytes_received - ret);
 		if (s.last_sample.mptcpi_bytes_acked != ret)
-			xerror("mptcpi_bytes_acked %" PRIu64 ", expect %" PRIu64,
-			       s.last_sample.mptcpi_bytes_acked, ret2,
-			       s.last_sample.mptcpi_bytes_acked - ret2);
+			xerror("mptcpi_bytes_acked %" PRIu64 ", expect %" PRIu64
+			       ", diff %" PRId64,
+			       s.last_sample.mptcpi_bytes_acked, ret,
+			       s.last_sample.mptcpi_bytes_acked - ret);
 	}
 
 	close(fd);
-- 
2.51.0



