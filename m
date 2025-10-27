Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC6F31DDBC;
	Mon, 27 Oct 2025 19:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592661; cv=none; b=LkUY5OQZSkXgnSmQ8qgeZKq53GWvqZ9ns1mvYAEXrVRqrx+nmCkDzgan44QkuIVBxu+oziuflIbqxoI0W2w4MC6H2m6VPR7uljvAva9rzQgDHqNGJO5Z7eZIxxONFK2Bma2yMZhbuACOQQYn+h40gRYW986ewUqewWBXQOi6EJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592661; c=relaxed/simple;
	bh=soSpHTcRDAJaxTxiCf2a6n7UU0ZjMG2CGhtVqhop03k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJvbs9fFVjIoZHKmsOmMe2WwUSzoOpAR83xUDfI7zLVCFMfi/KIS5dpxJRUaK/QDiHBOtz2JhTTdYEN+I6RitA5me1FQm+7P3lKqapWopCdClzZnK+JXDHFG/0JaFvZfKu+hjPUOwOZ+iPw7lcJJt+ps8ALQpvKlmndcEGp4u+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUNWb1nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUNWb1nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB220C4CEFD;
	Mon, 27 Oct 2025 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592661;
	bh=soSpHTcRDAJaxTxiCf2a6n7UU0ZjMG2CGhtVqhop03k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUNWb1nxZL8pIYOIjYfHcjkdegKVAycb2QOOiM0klhMB9jcwz6H1EXG5CSaH9rLBr
	 VL8wcrexV8ouh0MwwaYLSGP+Q8jIyjKDfKw/ZhLze4rslUosg0AkDJ7YvanwnzNVQu
	 LRfRzNs/dIUkWzrFPeRVwGO+3jk7bt6nZc/f8cWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 48/84] selftests: mptcp: join: mark implicit tests as skipped if not supported
Date: Mon, 27 Oct 2025 19:36:37 +0100
Message-ID: <20251027183440.098020815@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 973f80d715bd2504b4db6e049f292e694145cd79 upstream.

The call to 'continue_if' was missing: it properly marks a subtest as
'skipped' if the attached condition is not valid.

Without that, the test is wrongly marked as passed on older kernels.

Fixes: 36c4127ae8dd ("selftests: mptcp: join: skip implicit tests if not supported")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251020-net-mptcp-c-flag-late-add-addr-v1-3-8207030cb0e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3737,7 +3737,7 @@ endpoint_tests()
 	# subflow_rebuild_header is needed to support the implicit flag
 	# userspace pm type prevents add_addr
 	if reset "implicit EP" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
@@ -3762,7 +3762,7 @@ endpoint_tests()
 	fi
 
 	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		start_events
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 0 3


