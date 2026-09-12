Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D427735C6B2;
	Sat, 12 Sep 2026 09:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206281; cv=none; b=mTs15tMvDi+hJ+lQKvZqsbj9wAIfM/ju729XHjXfEJXPS62X5W2yzaNRhD5JdhUOIBsFB3Rgy4XdFOnjIiIihVJq9YBsl4451w/J+ObW7N0Yc2fDSe4SCpGWdd/JrHJqBZozrSy2wcjBsfjx0ajDGhhwi0qIQp/jcwCyS2hTK78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206281; c=relaxed/simple;
	bh=0qcR00oaurWYri0EI8VS2z5KIZPbn9E5KXNhNmggdRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B20nnjb830kijayc7rQ4ex6ZDML9Wk1Jfm1BvK2QfB1MLIaRtRV6Ub1A9cVm/jC0j5/kaUs90PYaCFl6/P5tQ2zBfcURPu2HgX1nXB+unog+MJMUJc6QRysGj6DTRoQ0eGZFh/ShfD5CRG5P8WiKeqbdQ0a/IPvPMYRqtTBYBog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V59L+zPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V59L+zPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2B71F000FF;
	Sat, 12 Sep 2026 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206278;
	bh=wFRJyHdcwaBvx6WFLsrlm2cuXrLaiqJE1cZmjJGVQ/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V59L+zPsxtuqeWhywV+oYFFGN/ofmJBZYo4OTl9/GJbYE4S9SeMAo0GiWLTPdAIAR
	 Qj96qkaWVA8IOvcUExKPTBMzhhKXde24+nFpT4GkKouVI6un2aYfvZ8LfUoAetmKQ3
	 STe0pBnu3gppkwyTeRoL3j5fgOAAzRx2oKy+GQK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0173/1518] selftests/bpf: Systematically add SO_REUSEADDR in start_server_addr
Date: Sat, 12 Sep 2026 08:39:02 +0200
Message-ID: <20260912065627.408729519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cdf7b66414442..e7ae891669e50 100644
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



