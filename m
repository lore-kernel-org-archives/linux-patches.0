Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8AC23F417;
	Fri, 31 Oct 2025 14:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919459; cv=none; b=piGvbe089ZajYINM8fpFLhPHGxMdZuZuR1xMMoyEGnFImn8baxVUPZ4UleH1hL1MlT8sJ8ZY48KDQiqWuQZFMfn6Rg1qj66Mvuw4VUcLabn6pCfRLoKdrn7lbDXhngTYbGbAiEYwJ0OGEyxVVtQwRNSeK189ZJKXQ2cx9nHRroY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919459; c=relaxed/simple;
	bh=mrrmN6F0HRYCD9L/tuTogT32eUOo/5hAtSWGK6KfBMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxr1rdMyzsvdqaen6eH+EaCWVoeK+EHaogNxbZUZk8QxNO2S9SWT9he9R884BzUJYgRN0zwDiKUcQCgaDedFF74Fz6Ael7YbbarqSgOycBuYMiah2WSddLHf2BfMhtPFRxiYYy6JGhsfTh7H/1O4Qb4shFpUD57Air6TbcqF/Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVv4H2vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVv4H2vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B849C4CEE7;
	Fri, 31 Oct 2025 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919459;
	bh=mrrmN6F0HRYCD9L/tuTogT32eUOo/5hAtSWGK6KfBMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVv4H2vNkTy/HBp5+lTq6SSW3dHaXAJKlAPuj5ja7gcEv/N1VNmDDRM3kmxRKffXv
	 Bb3r14s3SkSMX1O64Iq0VLkIuBFQS7pdp3V7RQBpTwLQM11IYVjTqWV3DqxMKe1TrR
	 lJmRNx6+lVE5ysBKC8He1uxvyStroL/GmdN3y/Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 26/40] selftests: mptcp: join: mark delete re-add signal as skipped if not supported
Date: Fri, 31 Oct 2025 15:01:19 +0100
Message-ID: <20251031140044.650295575@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit c3496c052ac36ea98ec4f8e95ae6285a425a2457 ]

The call to 'continue_if' was missing: it properly marks a subtest as
'skipped' if the attached condition is not valid.

Without that, the test is wrongly marked as passed on older kernels.

Fixes: b5e2fb832f48 ("selftests: mptcp: add explicit test case for remove/readd")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251020-net-mptcp-c-flag-late-add-addr-v1-4-8207030cb0e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3823,7 +3823,7 @@ endpoint_tests()
 
 	# remove and re-add
 	if reset_with_events "delete re-add signal" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=0
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 3 3


