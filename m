Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F60E227599;
	Tue, 26 Aug 2025 11:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207512; cv=none; b=mV+fjapmv9Bcydokb74/VnVS78Oz2HugRY0t8j7gJwRgeyPttR5z0Vkkb1qbfoqVnOPTh8YfSyyz0lGvC9X3wRvZGRX7ysbYaGLWUWrjY92csGYx7xQPWodzE45zqqrFtnqS4B6iKcC0OeG2cuhZfr1ApbBQvd9zjX4hRXTbpDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207512; c=relaxed/simple;
	bh=OrDNSlsJzz+VaCk4m0vRjuOmd8sNw0H4xuqUxhJ1J24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9uXlAQ4/lUGt4tdJtIj5fAiXygQCw9r2YI8faUNCDSfF1wgc8J6kqv6x3XtPnt8fN2LPJGbaby26oPdNx6AdJyfYthHNYkonvVY76Qj4Vy+6QS5eOvJW4rHnyzVRklDiXMHhx5zsZUPq4THs997Th8PI5riJgorYznzW7vGoDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYCFeOKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYCFeOKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14480C4CEF1;
	Tue, 26 Aug 2025 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207512;
	bh=OrDNSlsJzz+VaCk4m0vRjuOmd8sNw0H4xuqUxhJ1J24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYCFeOKFP7oNiPrDmY5hNBWuCAqdw4gHC+MVozLGjMtvzao7+AKDMbTOa5sK/1aQt
	 32OqciIJVXxKnehcisrkD/kkExM8a3rUHAOrBTdI8QF1Jwc13L2CAci1B7IYLgiY+j
	 13NCMTl57d5MWqeN1RU8jNvUmhVeaiu1+h85Wmo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 209/457] selftests: mptcp: connect: fix C23 extension warning
Date: Tue, 26 Aug 2025 13:08:13 +0200
Message-ID: <20250826110942.531017019@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 2eefbed30d46d5e68593baf6b52923e00e7678af upstream.

GCC was complaining about the new label:

  mptcp_connect.c:187:2: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
    187 |         int err = getaddrinfo(node, service, hints, res);
        |         ^

Simply declare 'err' before the label to avoid this warning.

Fixes: a862771d1aa4 ("selftests: mptcp: use IPPROTO_MPTCP for getaddrinfo")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-7-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index ac1349c4b9e5..4f07ac9fa207 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -183,9 +183,10 @@ static void xgetaddrinfo(const char *node, const char *service,
 			 struct addrinfo *hints,
 			 struct addrinfo **res)
 {
-again:
-	int err = getaddrinfo(node, service, hints, res);
+	int err;
 
+again:
+	err = getaddrinfo(node, service, hints, res);
 	if (err) {
 		const char *errstr;
 
-- 
2.50.1



