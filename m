Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280AB239573;
	Tue, 26 Aug 2025 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207515; cv=none; b=ed0hD7/cIN5Q2oEZey3oWTzauKoElZcfKrg+UqcSOXs1Eqv/fKhKkAnjnUjYuETQd5Wa/dkXjd0Mk99WtkUyxjinWYrgouMe1a9nuV8D87QM4wlj1J+pGkvwLo91U/yzBiXzZMni6LdlsFUDtPTrK3aDtkllUGDQMrbSZQpk5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207515; c=relaxed/simple;
	bh=ii2wuVG4FHxO5R/lJ/3dya0/u59AoVgOTIpNyURFgVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnhITkr7XgAIkPLUUj+54m4CNk32cxxzYtFyZkTaT5loXgEeRFDQ8M70BKAIxlPlf+FqQuAWAeFcguJ/f75Y0sSAgnd3ubr2Cht2FvNq4nsQQr6kTVG9dIWhngsbC9oMZKfKtU7JP+6ipW8flXzU2p8OXR4A1uwIqkqmqVmDapA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSOtZVnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSOtZVnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CF7C4CEF1;
	Tue, 26 Aug 2025 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207515;
	bh=ii2wuVG4FHxO5R/lJ/3dya0/u59AoVgOTIpNyURFgVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSOtZVnNp/hJNj+yPI3oLHcK+UML/SSZkrvZ5ab4JlUM4sO1+VyIf9ls2TNTdo6Ti
	 1KOz6szv25kfs9cVthmmzvDRhn5JE+Aa9+eIhrgdUvphvTG699hbKdbMaFULFoDbmW
	 wMHwywMCN4rlVoa4+HTOQdf/GTIvADl69KoJY6lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 210/457] selftests: mptcp: sockopt: fix C23 extension warning
Date: Tue, 26 Aug 2025 13:08:14 +0200
Message-ID: <20250826110942.554333367@linuxfoundation.org>
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

commit 3259889fd3c0cc165b7e9ee375c789875dd32326 upstream.

GCC was complaining about the new label:

  mptcp_inq.c:79:2: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
     79 |         int err = getaddrinfo(node, service, hints, res);
        |         ^

  mptcp_sockopt.c:166:2: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
    166 |         int err = getaddrinfo(node, service, hints, res);
        |         ^

Simply declare 'err' before the label to avoid this warning.

Fixes: dd367e81b79a ("selftests: mptcp: sockopt: use IPPROTO_MPTCP for getaddrinfo")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-8-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_inq.c     |    5 +++--
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_inq.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_inq.c
@@ -75,9 +75,10 @@ static void xgetaddrinfo(const char *nod
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
 
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.c
@@ -162,9 +162,10 @@ static void xgetaddrinfo(const char *nod
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
 


