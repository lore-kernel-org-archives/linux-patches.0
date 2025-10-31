Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A5A34D387;
	Fri, 31 Oct 2025 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919341; cv=none; b=kapvhPpaV9lOgtjnteNdvquwHDBw1knsZ9YgBS/DvdYUOui+8p0/KBjj4pv+HXjjIFr9kP+3C13DHN07HS8CvFRo9BdyApmpGHwHvnEis692ixSGuxA+6I+TGLGN2rSNw4J6oorLvhkOmm9wrlkkWr0h6RHBxQ2CndBzOOhjRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919341; c=relaxed/simple;
	bh=ROEBsDoJQg14cTJWlt3tUeWqYxRiAaBW6UEiuc1ys6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XafLwZ+djPOs3fs0UczRJ0OM9BxNy5lzai9ADhmw/FTBVzLNVYOe729pqCPoF9LaDJvNMosztTNKs29NaPGNnh+Z3MnwxYxtWtyQ5kFRhQUYGCa6aRGACH0E/B2eKtMlNQMtKTMucZ6hd6DwAkWHbE6x6Les73Ptr0KUyvNtHeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I85KcN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I85KcN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4D8C4CEE7;
	Fri, 31 Oct 2025 14:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919339;
	bh=ROEBsDoJQg14cTJWlt3tUeWqYxRiAaBW6UEiuc1ys6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1I85KcN0pWT+GfGDMLETdOJkp5+AH49ARIA8bTCJ1xS2+V8N0UJ6VNmtil7a/5l14
	 WkaR5XBHMjTb2syQeBV7kLqiEU8hK3ezt86oQ+abE/5z89d8+cnkj45AXYY7+952hf
	 oaWMIaJRxbIIIwnMCjbjy4YJ1Lbty48OOJ5GOTjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/32] selftests: mptcp: join: mark delete re-add signal as skipped if not supported
Date: Fri, 31 Oct 2025 15:01:12 +0100
Message-ID: <20251031140042.872883775@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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
@@ -3837,7 +3837,7 @@ endpoint_tests()
 
 	# remove and re-add
 	if reset_with_events "delete re-add signal" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=0
 		pm_nl_set_limits $ns1 0 3
 		pm_nl_set_limits $ns2 3 3


