Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CE732D0FF;
	Mon, 27 Oct 2025 19:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593341; cv=none; b=NEJHft5Viq7VoHeifMoopstYXJ4TUyQcheONC9LAUfkl5hX0cDsutaXPGcjVA8AP4LVlRNnHRrpXj0/RoN6TaXFjVyDmIX6ocCOezsVkHgkEm9kDDjVXMy5yps0GgAoHlpfjx2YqHjUZHPCpLKtvtN1ZvZrUrSpNY3V+2XrPzPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593341; c=relaxed/simple;
	bh=7QNzhxLHd25scwFRKljwxas3mu732uBepE8F9mo7GfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7MK/XbP73Gi9fp50krfrHMv7O+FMEIdIC9kSgCqdZJw5XGLk71r8Jcccr8QwAZ0ETS4mhT9pNetQeHn0ngfv7O+Ky3z50TkVUs9rru1oTX95yNWfT+A87q86nI0CgNZxLgydfJ+h9I5MASAD+C7d+0N4ieuOVKJSecnalm6ko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvsTumwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvsTumwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFC2C4CEF1;
	Mon, 27 Oct 2025 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593341;
	bh=7QNzhxLHd25scwFRKljwxas3mu732uBepE8F9mo7GfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvsTumwWCwf1nwPnwx1MQjdF28pgvQKSBuZEroTr3kLXAIBM/CWc93bYWyEiy6spg
	 kv3NghWM690OufvJ4R7jS69pYq4uds0kVUw18Rvhsqw0LWAPbPYeSvIUwnFwzyzfXg
	 CqEqIiz7rZbIA6UFk/AtQPfZ08Oi1pyCjvtcqFEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 102/184] selftests: mptcp: join: mark flush re-add as skipped if not supported
Date: Mon, 27 Oct 2025 19:36:24 +0100
Message-ID: <20251027183517.659966902@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit d68460bc31f9c8c6fc81fbb56ec952bec18409f1 upstream.

The call to 'continue_if' was missing: it properly marks a subtest as
'skipped' if the attached condition is not valid.

Without that, the test is wrongly marked as passed on older kernels.

Fixes: e06959e9eebd ("selftests: mptcp: join: test for flush/re-add endpoints")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251020-net-mptcp-c-flag-late-add-addr-v1-2-8207030cb0e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3927,7 +3927,7 @@ endpoint_tests()
 
 	# flush and re-add
 	if reset_with_tcp_filter "flush re-add" ns2 10.0.3.2 REJECT OUTPUT &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 1 2
 		# broadcast IP: no packet for this address will be received on ns1


