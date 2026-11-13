Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590789;
	b=nJqh59ikc4LPuzWqJwkcTUvvWwNgjMJM9YDrD78O7MyyLjxsBzpcaUvyVKYUzjX56KDZ
	 rn1n0UearNp11xSJU71ZaQCsDiFm9PFm0es7ldJyaVyimE+SXKS//SjnmiXl8qY9H8Jof
	 wmGwTL3YJ7qMbMbiAQSRscFIzmHiGWnQ2vgw0VVSrXT+1t7nQqE65g/NbeBxWPW6MtJmV
	 B9A3d+zTA0yZOiGurhjgmZEPB0mbnudKql9rKLDPdx0wbDD8E3QvZUrNoXUm9ycBWMYmp
	 m7rEKPnPXyN0M8o7XP1DymP3kDBiiRAow+W0pAKAYF1BNLLn/5LLib8z2JNHn+X5MNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/rxWE+83kWl1XpqwVFIkvrYpvhkFz0q0ZFqeKWLGMYE=;
	b=ONjL48bUJpn6r7JG/jQYSJjP3E7Ra8otBWPqkkUpzsJdf2q69HzCIVH7ibDwNwhfmy3G
	 5uvTDxUWEyjMlh6xTQdKpyuFr/WhCqikZ6n7QKFhT+HW75WOWEzJYOKiApIcEI/Iknc0D
	 z0w7kcEFKjQCqp8fbqmQZC4oNdGwbhpitTn5gG8RWQcwN3vnBmYHq2oYW8O1lhSBokc4L
	 IulD9mvxBHzTPelSmKVRISPe2wtWOoZvLUVWA46RXXWLnaAQFU3UwcXx3zDwJqMr6zr1L
	 wwb486yLazDA31Yxh0/tid2hisM/omA0Mx+6nenRRs/VY1ORPa1sdpftEteUUuG0Duw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AjsgQYP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C3E606E20F;
	Fri, 13 Nov 2026 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AjsgQYP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E2A1F000C4;
	Fri, 13 Nov 2026 17:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590788;
	bh=/rxWE+83kWl1XpqwVFIkvrYpvhkFz0q0ZFqeKWLGMYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjsgQYP+6OP4ezN/q4UptYN0U8uOlZv+9bKsplkcvBTUkV38HMkcQttJeuhbQZK/c
	 L2U6vIVmcQdxLeN65nb4QwJOZOlx6YPbaa5OcWMCvkn3TxLECvJxCep0shDEYPA+wA
	 t+Yfa+qmnhLaf3koYPQ2kVxMDhbmMn56Mif3da5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	Wang Yan <wangyan01@kylinos.cn>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 681/686] selftests/landlock: Fix snprintf truncation checks in test files
Date: Fri, 13 Nov 2026 10:53:34 -0500
Message-ID: <20261113153844.716428156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for the earlier TCP-specific audit helpers with their existing names and formatting. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/audit_test.c  | 2 +-
 tools/testing/selftests/landlock/net_test.c    | 4 ++--
 tools/testing/selftests/landlock/ptrace_test.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/landlock/audit_test.c b/tools/testing/selftests/landlock/audit_test.c
index dcf63b2f822e9..aa6df1b4d42e6 100644
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
index 8f3a780d354b7..822c23425d15a 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -2067,7 +2067,7 @@ static int matches_log_tcp(const int audit_fd, const char *const blockers,
 
 	log_match_len = snprintf(log_match, sizeof(log_match), log_template,
 				 blockers, dir_addr, addr, dir_port);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
@@ -2192,7 +2192,7 @@ static int matches_log_tcp_bound(int audit_fd, const char *const addr,
 
 	log_match_len = snprintf(log_match, sizeof(log_match), log_template,
 				 addr, lport, addr, dport);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
diff --git a/tools/testing/selftests/landlock/ptrace_test.c b/tools/testing/selftests/landlock/ptrace_test.c
index 4e356334ecb74..22133c5ae6c56 100644
--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -446,7 +446,7 @@ static int matches_log_ptrace(struct __test_metadata *const _metadata,
 
 	log_match_len =
 		snprintf(log_match, sizeof(log_match), log_template, opid);
-	if (log_match_len > sizeof(log_match))
+	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
 	return audit_match_record(audit_fd, AUDIT_LANDLOCK_ACCESS, log_match,
-- 
2.53.0



