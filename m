Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF31356742;
	Sat, 12 Sep 2026 12:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214825; cv=none; b=sUgrZImoI8ynCmTUdK6nNdRHPPPIjwBrmKT0nMbnX+y2KENRkoK8FzLmIrwQ7JqI0aRdfaph9EWTDRb38n5+jlhqDiZF5oeXYcMne0GRJ1/5nHaZ80gSb1Lm9RO+GlVChaOhzuOpASmBXES7VkkMUH6rMtBKdMp9pzKDPeYaFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214825; c=relaxed/simple;
	bh=kTzhEqJmwNoxVCEy+uYnPmolVREO5TreuEbrzxAEN8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEmfIIWqJa3QDNnqQcmuL7/0T2vwiMURwUJsfk/na1bj7f2P9zozbYPOGWBNmV6taJZeuVfS+Kse1LNzzTr4KXNfPYB51/iWh4kZ6P1+L9KhdfS05iI+BI+h2YCUh6LVHpFQl9StsQM15+9oeFbXTFQwGSpC8Im3eIxr7xenakk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JagUZ8WH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JagUZ8WH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47901F000FF;
	Sat, 12 Sep 2026 12:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214823;
	bh=xDFfmQTj/Lz5S1WVNnE/GfoKX0WvxULi4ySemh2TO9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JagUZ8WHaVZcfsHnZRU3w9ub+et+NSUzSVJoKUO5yC1jCY6r5t5NRd6P/hCXd9ibn
	 Ln7xUsXredP13m7zRyxahIgSRu+Br2sHbDux5SDCX9aPd7+lxEwV+Zc5ZSVBKWMkgf
	 cBgUUXii6DX6FNcQ21gXf4EY4UU1etg1fr+l6sHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0378/1376] selftests/bpf: Systematically add SO_REUSEADDR in start_server_addr
Date: Sat, 12 Sep 2026 08:46:44 +0200
Message-ID: <20260912065615.974162467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

[ Upstream commit 38e36514fcb01ff1cce84cd77a93906f233a4cb8 ]

Some tests have to stop/start a server multiple time with the same
listening address. Doing so without SO_REUSADDR leads to failures due to
the socket still being in TIME_WAIT right after the first instance
stop/before the second instance start. Instead of letting each test
manually set SO_REUSEADDR on their servers, it can be done automatically
by start_server_addr for all tests (and without any major downside).

Enforce SO_REUSEADDR in start_server_addr for all tests.

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251105-start-server-soreuseaddr-v1-1-1bbd9c1f8d65@bootlin.com
Stable-dep-of: b4b8b334f6b5 ("selftests/bpf: Mask socket type flags in mptcpify prog")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index af0ee70a53f9f..e5f8cab87dd9a 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -97,7 +97,7 @@ int settimeo(int fd, int timeout_ms)
 int start_server_addr(int type, const struct sockaddr_storage *addr, socklen_t addrlen,
 		      const struct network_helper_opts *opts)
 {
-	int fd;
+	int on = 1, fd;
 
 	if (!opts)
 		opts = &default_opts;
@@ -111,6 +111,12 @@ int start_server_addr(int type, const struct sockaddr_storage *addr, socklen_t a
 	if (settimeo(fd, opts->timeout_ms))
 		goto error_close;
 
+	if (type == SOCK_STREAM &&
+	    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) {
+		log_err("Failed to enable SO_REUSEADDR");
+		goto error_close;
+	}
+
 	if (opts->post_socket_cb &&
 	    opts->post_socket_cb(fd, opts->cb_opts)) {
 		log_err("Failed to call post_socket_cb");
-- 
2.53.0



