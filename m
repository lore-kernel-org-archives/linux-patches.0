Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B658A309F1E;
	Mon, 27 Oct 2025 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593347; cv=none; b=ZSGojZiDCrq6NDB1VUSLuILBgrIDfvLRxLnp01T1PZwvf4JJBiS0BdruzoCrZbSRx0jtWUwq8/X86IrwiFvQYp46ruoZSdd2U4qfbObiEF7V1idK9piitw1HFCN4LB2KTgPrrVboKtgzyPuc/HjUJr1PY3v30Oioeyk1eykQdV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593347; c=relaxed/simple;
	bh=wNfdrxtMw1t1Bgkrnogl/kvbz5Upo5w/nxi6NCN5ZFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkeIuixBMdfgZ7VhdQOBnLlvCJDAxyEzdsCHrrhpjfphpU7BVyIBvMjBIOP+H9nrWSXqkETMF1FgC0ss6CT7ULE4ulho1WoNEhRTo6Q/cpG/NKfv4ZrSS7f5p1IRoEti0Oila+47Km/9MU9JfdUYw4ewbmZcUl7rqxAt7ROWGf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKRr2hed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKRr2hed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3767CC4CEF1;
	Mon, 27 Oct 2025 19:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593347;
	bh=wNfdrxtMw1t1Bgkrnogl/kvbz5Upo5w/nxi6NCN5ZFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKRr2hedLPwBQ0APJy+Q6fa1hI+2GBrHEo57wn8zZ4SYUa6/Wa0R4FlYe7Vi3IzqB
	 ZjeLdLuNQt0odCxqfii55LjD5HV4LIkxO3y7Of9EcnVYjPgvEa3AQ+FJk5UlmtqMbh
	 4ltLDgS3YiBqtKCMCEde6Uf9wI4kYVYlq1V6XeQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 104/184] selftests: mptcp: join: mark delete re-add signal as skipped if not supported
Date: Mon, 27 Oct 2025 19:36:26 +0100
Message-ID: <20251027183517.716888762@linuxfoundation.org>
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

commit c3496c052ac36ea98ec4f8e95ae6285a425a2457 upstream.

The call to 'continue_if' was missing: it properly marks a subtest as
'skipped' if the attached condition is not valid.

Without that, the test is wrongly marked as passed on older kernels.

Fixes: b5e2fb832f48 ("selftests: mptcp: add explicit test case for remove/readd")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251020-net-mptcp-c-flag-late-add-addr-v1-4-8207030cb0e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3852,7 +3852,7 @@ endpoint_tests()
 
 	# remove and re-add
 	if reset_with_events "delete re-add signal" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=0
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 3 3


