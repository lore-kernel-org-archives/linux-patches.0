Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065130;
	b=X4HTMjFgyeSnYVnwgsTR9IG+Rw5IkUHx+iMq1QR5b2Ae0ur3TFfEZEdiRND/xZ3I2kOZ
	 1A73+4LfuwRfIf8AN3Pu2gr6OIglEVSZDyx7WUsi0YeiI9k9muMWzltEDBQCW4vnN+wNm
	 yD1Ug3GRSAQn7xzDdKflXWpYUX3vEe1u55yY5DEL/53EZPiYNUydWZ8hg4faovxViumQV
	 BAGx1UVhYy4iVt91k1N5da8chRwuk38K+Px3uGZ2Dh04IuSj86d3MyYVlFj1ttgsYeSNc
	 IDkq6aFDBnQ4UOx1eKa/+TveDseI+Bk2lJXFPxGv7Fv2GSBQKtBgbNXqrgImEXaAfmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0cnBhEru7K1whd5k4MpcfoZ7txWJUGw2v7w9XV8eOLU=;
	b=3WJUKv+ZvQOqj+wUF3U8vvwYEChuMjrypfc3R8o8ygQU56FlU82TeCe/qmAj81p2N/4v
	 nRT0OlO1LrtIohLx8dnO+tB6j2yuZLoHPDMKnWF8wWoEUXae/10jpg5pp6njGAEhqvPhh
	 A4XWCfE8fD9Pe2hL19zqxl24ok1hddGfT9NsejcneeYb4iVWeaCE625elkHEGqWZ+1DgH
	 6M3eTOFxxgrgVuXRjoMg7xJ7CjMIBEN0V/FvX6fcl/Fsif82Bix0RTRuFIRUBP4n3kwyZ
	 fF5Ej7trDy1wVv+FiFoMI8DBiRMAi+ZbWceqbjT0I5auFc9zsRs9VS77rSZ4WdtvrdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL5G6+W6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9EC606A32E;
	Sat,  7 Nov 2026 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jL5G6+W6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF01D1F008A3;
	Sat,  7 Nov 2026 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065130;
	bh=0cnBhEru7K1whd5k4MpcfoZ7txWJUGw2v7w9XV8eOLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jL5G6+W6r/U7ykYSSplCVyVYyHyaHpPka0QGR2RWvKo+SCTD75vEswTFaz3FtYoO8
	 +K+aTZVtu1N36UuK02k1aySd2WCJFgnUUyJbDvvn+XPkXwZVVLabsyIwO0hUIRXQAg
	 uISY2BlsuLUX8uG8vcIbX9r+Z1fyPAwCTRwk926I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	Wang Yan <wangyan01@kylinos.cn>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0951/1257] selftests/landlock: Fix snprintf truncation checks in test files
Date: Sat,  7 Nov 2026 08:54:07 -0500
Message-ID: <20261107135005.611286756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit 8e4c736cffdd6b133f6498e0d40ba60dc6819d43 ]

Commit b566f7a4f0e4 ("selftests/landlock: Fix snprintf truncation checks
in audit helpers") fixed the truncation detection in audit.h by changing
the comparison from ">" to ">=" to correctly handle the edge case where
snprintf returns a value equal to the buffer size.

However, the same pattern exists in ptrace_test.c, audit_test.c, and
net_test.c and was not fixed.  snprintf() returns the number of
characters that would have been written, excluding the terminating NUL
byte.  When the output is truncated, this return value equals or exceeds
the buffer size. The existing ">" check therefore fails to detect
truncation when the return value equals the buffer size.

Fix these remaining instances to use ">=" for truncation detection,
matching the fix in audit.h.

Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Reviewed-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260626070016.61049-1-wangyan01@kylinos.cn
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/audit_test.c  | 2 +-
 tools/testing/selftests/landlock/net_test.c    | 4 ++--
 tools/testing/selftests/landlock/ptrace_test.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/landlock/audit_test.c b/tools/testing/selftests/landlock/audit_test.c
index 72b5612375ddb..4bea8c880a4d3 100644
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -31,7 +31,7 @@ static int matches_log_signal(struct __test_metadata *const _metadata,
 
 	log_match_len =
 		snprintf(log_match, sizeof(log_match), log_template, opid);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 16afbfdf06bb2..50b637354b51d 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -2878,7 +2878,7 @@ static int matches_auditlog(const int audit_fd, const char *const blockers,
 		log_match_len = snprintf(log_match, sizeof(log_match),
 					 log_with_addrport_tmpl, blockers,
 					 dir_addr, addr, dir_port, port);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
@@ -3173,7 +3173,7 @@ static int matches_log_connect_bound(int audit_fd, const char *const blockers,
 
 	log_match_len = snprintf(log_match, sizeof(log_match), log_template,
 				 blockers, addr, lport, addr, dport);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
diff --git a/tools/testing/selftests/landlock/ptrace_test.c b/tools/testing/selftests/landlock/ptrace_test.c
index 2644445a9d020..e0e7f95e889b3 100644
--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -305,7 +305,7 @@ static int matches_log_ptrace(struct __test_metadata *const _metadata,
 
 	log_match_len =
 		snprintf(log_match, sizeof(log_match), log_template, opid);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
-- 
2.53.0



