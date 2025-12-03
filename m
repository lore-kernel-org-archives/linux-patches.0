Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B19354AF8;
	Wed,  3 Dec 2025 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778633; cv=none; b=X3G+PPUOpwMyTl4K1BGKFvqnRkx73FeAMszJOq0O6k9bGO+M82/kx6hfjreZya8vJb4qTHDeHyFLIL2VYvEiYL1pIIyN7GiFQynEf65f2LQ1CvUA889Hso+6sXTovdl2kH6Wqc9va/c9Ym0PDp1a5zd4ydOBChhHaz7vluAIqb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778633; c=relaxed/simple;
	bh=1Jlprrfe3nPqrEen03BsDuNzgMNyc7BwYvHvskjAnuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V80A28vIGedkhH+FLdtqBZk6d3TUwd63bYT5SXP2SNfH8rSscK9yqf4ePaQJdDXh6DkeBU//cO088RA3s77pGZBuBrXlLza4LIRXBV9qDbGxo2b6T5HSwoHjUcGM47+ZCKv8g/O2zm1hlnkuPhlULBCn3HLnEp9igGKAy8Z4+wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGsq44J7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGsq44J7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F952C116B1;
	Wed,  3 Dec 2025 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778633;
	bh=1Jlprrfe3nPqrEen03BsDuNzgMNyc7BwYvHvskjAnuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGsq44J7dqrOZoObUHim2kU/uXFektuowxVZ2K13RoFLdYrI0uPhsXTI0EOrIvj2S
	 jpz1eivrU/8oZGjcNEISDZh0XhXZcIgtw++zt1OuIpOlyjBeAlIawpKluBiHSxxsrL
	 tApFKvdQAG3gnoyCS9wt4FMy1jRUYKDe6KlGgrcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/568] selftests: mptcp: join: mark delete re-add signal as skipped if not supported
Date: Wed,  3 Dec 2025 16:20:15 +0100
Message-ID: <20251203152441.146465877@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3393,7 +3393,7 @@ endpoint_tests()
 
 	# remove and re-add
 	if reset_with_events "delete re-add signal" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=0
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 3 3


