Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015152;
	b=L+Jxkf3ZyK6WswrIC9UtLKqYuOiMNQJDvb8tCG8TAJ5yUn87nOngKFgyupbMA/0loPsm
	 J2B8IA4V/ei51mpVpaFPMzSPvVYIQnZKslKLpJ3555uDEuhwdZC6C2UvSldBVy4X9qRLU
	 a6gmlknjWtwS/r5xI8TbbPD8eXQ9H0C/7K6k7P7POiOtA4A6zbYeZ6vgfXlUg+teslLjL
	 vZbV3h960bXPr9P3bSeHRraAyVzt346i4ah0rqGK/IF7uCRoF9gxCGAu2W4NXb9BXnzmX
	 sZQTuDP4OkPVXUoauwmVkyFXmNslXs2ySoVb0d0lLbKRqER8lE6nyfmMyDNwcUwqIEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dmPi6UfHzoPlCxCwOzGiDlRyzB9YLYgj3FZ0vEu3UIM=;
	b=jSE5BNpQlPLgMsOY8td/+3GviAp2tvGlRm0bb0Ca4cxmiCO5LTjtxJvcYBr5PvFma2vE
	 TVNhprEr+kooZ87kFK6X7z3sOo2iM3zwpAvKTnYpXllW1GdIYCZbh0kPTHcrKHogwLdYb
	 n/lqrTbzcQxLUtZ6j3uJ8X8WT2M27LSpmqROBnIQmnwbZxOtmAWAnMRvhF4N6yY/Zrj/7
	 YdWEZIR0edy0YsZLTZpzoQXiQQR2FoKD0JtTLy2iPv5r3J5C/BFzDW7C33zGGfm62bC2Q
	 HnknXm7wX5itVGt+ogju2XhzVat66yxtBs9R7NDyEKrFtFryh2q88jwWX2VfqKX81kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjUNSDra;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11578606A320;
	Wed, 18 Nov 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KjUNSDra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D731F000CD;
	Wed, 18 Nov 2026 15:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015151;
	bh=dmPi6UfHzoPlCxCwOzGiDlRyzB9YLYgj3FZ0vEu3UIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjUNSDradIrWg/b0MU8f0Arr2Skyk2cS+1oqj8CdVfhbjTpwyGqVyjqgF/wJ+Ua1H
	 JkfAvMGr9AggOu9Q00lJYQ8HI7qKtE7mWJuyzKOqIYM6BYb0/ctAkjljzOSEG0xb1V
	 wyYBX+6cfGl4Q3R++OKf1YBEkShFrAC0MCP11NvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0069/2651] selftests/bpf: Allocate a larger timeout for connection
Date: Wed, 18 Nov 2026 15:21:49 +0100
Message-ID: <20261118150250.421343721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

[ Upstream commit 669e4fa766000ae4137bb02eb22ce75ba78ad32d ]

Some tests, like tc_tunnel or tc_edt, sporadically fail in CI with the
following logs:

  (network_helpers.c:309: errno: Operation now in progress) \
    Failed to connect to server
  send_and_test_data:FAIL:connect to server unexpected error: -115

This is due to SO_RCVTIMEO and SO_SNDTIMEO being set on the client
socket (see settimeo() in client_socket()), allowing connect() to return
an error and to set errno to EINPROGRESS instead of ETIMEDOUT.
Increasing the timeout value for those tests is likely not a good
solution (and it has already been done by commit 2790db208b44
("selftests/bpf: Improve tc_tunnel test reliability")): some tests
expect some data transfer to fail, and so the timeout value would
increase overall test execution duration again (not only the connection,
but any socket operation).

Another solution is to allocate a timeout budget specific to the
connection: we can apply a larger timeout only for connections, and once
the connection is established, set back the timeout configured through
opts->timeout_ms; this would allow connection to succeed under heavy CI
load, while keeping timeout reasonable for the rest of the test traffic.

Create a dedicated connect helper that sets a large timeout for the
connect step, tries to connect, and if successful, finally sets the
timeout value to the one configured by the test.

Fixes: 99126abec5e5 ("bpf: selftests: A few improvements to network_helpers.c")
Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260818-tc_tunnel_flaky-v7-1-aec161e74ef2@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 46 ++++++++++++++-----
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index cdf2d7d3ab321..d27dc79475de6 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -49,6 +49,8 @@
 			errno = __save;					\
 })
 
+#define CONNECT_MIN_TIMEOUT_MS	5000
+
 struct ipv4_packet pkt_v4 = {
 	.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
 	.iph.ihl = 5,
@@ -291,6 +293,37 @@ int client_socket(int family, int type,
 	return -1;
 }
 
+static int connect_with_timeout(int fd, const struct sockaddr_storage *addr,
+				socklen_t addrlen, int timeout_ms)
+{
+	int connect_timeout_ms = MAX(timeout_ms, CONNECT_MIN_TIMEOUT_MS);
+
+	/*
+	 * Override timeout configuration with a larger value for the
+	 * connection
+	 */
+	if (settimeo(fd, connect_timeout_ms)) {
+		log_err("Failed to set connect timeout");
+		return -1;
+	}
+
+	if (connect(fd, (const struct sockaddr *)addr, addrlen)) {
+		log_err("Failed to connect");
+		return -1;
+	}
+
+	/*
+	 * If the timeout configured by the test is different from the
+	 * connect timeout, restore it
+	 */
+	if (timeout_ms != connect_timeout_ms && settimeo(fd, timeout_ms)) {
+		log_err("Failed to set timeout for connected socket");
+		return -1;
+	}
+
+	return 0;
+}
+
 int connect_to_addr(int type, const struct sockaddr_storage *addr, socklen_t addrlen,
 		    const struct network_helper_opts *opts)
 {
@@ -305,8 +338,7 @@ int connect_to_addr(int type, const struct sockaddr_storage *addr, socklen_t add
 		return -1;
 	}
 
-	if (connect(fd, (const struct sockaddr *)addr, addrlen)) {
-		log_err("Failed to connect to server");
+	if (connect_with_timeout(fd, addr, addrlen, opts->timeout_ms)) {
 		save_errno_close(fd);
 		return -1;
 	}
@@ -376,20 +408,12 @@ int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
 	struct sockaddr_storage addr;
 	socklen_t len = sizeof(addr);
 
-	if (settimeo(client_fd, timeout_ms))
-		return -1;
-
 	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
 		log_err("Failed to get server addr");
 		return -1;
 	}
 
-	if (connect(client_fd, (const struct sockaddr *)&addr, len)) {
-		log_err("Failed to connect to server");
-		return -1;
-	}
-
-	return 0;
+	return connect_with_timeout(client_fd, &addr, len, timeout_ms);
 }
 
 int make_sockaddr(int family, const char *addr_str, __u16 port,
-- 
2.53.0



