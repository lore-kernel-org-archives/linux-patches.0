Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA9F263C90;
	Tue,  8 Apr 2025 11:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111369; cv=none; b=AfUzW3BNNetmrEtxW18ecEIWzjXVXAAEmW61X9msPNkSbJWaicMnIohZYdPbkVoU30m4JqJK9c0kWiq8sZ5zRUsyINnmka/Tos56zX/aNpOHm2yuy8SQYEBZlBnNcaHPzQNhWDc4S2u0ZJOSyJcfFK2UxfPjvnwY2oFdLY3dSJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111369; c=relaxed/simple;
	bh=YN1dpTK2pJx/32ZtbmmuruEFA9vYu7JFX5QkgOHV/N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVg3f4BCzfQOotwbId4tYp8t93m9x3tChol7q/y4ZNd9T1kdDDjXq5eipbZ3GkkHgAMME1H1eWJc47P6sifYhVELWFnPYP2N+UPKoYmcfe4C3yvUDyJ7dzo4jDHg7bdynxSdrUvGPLQbpPJaUapRtU86qW5UuK4orf6MLqIwjoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kd2uqOdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kd2uqOdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820DCC4CEE7;
	Tue,  8 Apr 2025 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111368;
	bh=YN1dpTK2pJx/32ZtbmmuruEFA9vYu7JFX5QkgOHV/N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kd2uqOdP/JFNVMc2siT6gsypqH2RV8UfKeP0Q0ZNZ1/eE2076gsQESwmlKGP6SAh/
	 mfkRzhI/v8ffp7eKcBwXBUIbVJwCD+hhNpR7i8T4fOQ/xMv6ywqJT2Wrj8Q4A0GcP5
	 S4N1O5GN4+gkVJm5lBxnphDXTZGrxskDC+Ysil/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 407/731] libbpf: Add namespace for errstr making it libbpf_errstr
Date: Tue,  8 Apr 2025 12:45:04 +0200
Message-ID: <20250408104923.740728112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 307ef667e94530c2f2f77797bfe9ea85c22bec7d ]

When statically linking symbols can be replaced with those from other
statically linked libraries depending on the link order and the hoped
for "multiple definition" error may not appear. To avoid conflicts it
is good practice to namespace symbols, this change renames errstr to
libbpf_errstr. To avoid churn a #define is used to turn use of
errstr(err) to libbpf_errstr(err).

Fixes: 1633a83bf993 ("libbpf: Introduce errstr() for stringifying errno")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250320222439.1350187-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/str_error.c | 2 +-
 tools/lib/bpf/str_error.h | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/str_error.c b/tools/lib/bpf/str_error.c
index 8743049e32b7d..9a541762f54c0 100644
--- a/tools/lib/bpf/str_error.c
+++ b/tools/lib/bpf/str_error.c
@@ -36,7 +36,7 @@ char *libbpf_strerror_r(int err, char *dst, int len)
 	return dst;
 }
 
-const char *errstr(int err)
+const char *libbpf_errstr(int err)
 {
 	static __thread char buf[12];
 
diff --git a/tools/lib/bpf/str_error.h b/tools/lib/bpf/str_error.h
index 66ffebde0684a..53e7fbffc13ec 100644
--- a/tools/lib/bpf/str_error.h
+++ b/tools/lib/bpf/str_error.h
@@ -7,10 +7,13 @@
 char *libbpf_strerror_r(int err, char *dst, int len);
 
 /**
- * @brief **errstr()** returns string corresponding to numeric errno
+ * @brief **libbpf_errstr()** returns string corresponding to numeric errno
  * @param err negative numeric errno
  * @return pointer to string representation of the errno, that is invalidated
  * upon the next call.
  */
-const char *errstr(int err);
+const char *libbpf_errstr(int err);
+
+#define errstr(err) libbpf_errstr(err)
+
 #endif /* __LIBBPF_STR_ERROR_H */
-- 
2.39.5



