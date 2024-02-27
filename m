Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6187E13B293;
	Tue, 27 Feb 2024 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041099; cv=none; b=rVIV1HcWMgoypFHY5W3KUuRKBUL/aFxsdvhoVcPjJ27Xi0vnRhcXvtQwWKS9echg+7SBrqDheQgF72hhK3cD1o5sWlKaOFjMnvCOSUIAt3MqOTO6G3cD2Pva0BPHlv3jwq4lzJf3TsTBSJjkVqngn1YFvLW7sPZKMVItA/TOcsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041099; c=relaxed/simple;
	bh=dbfcXWoa9UhulJ0c/FG3C67WmfGloDGs45yCbDl0iHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+bdHX7044vRP2YjXQJodmaYGVVUrdegRRWdDZRAfaFReILLm1ggbhbq9syVx4ORoxU76k8Uxym316C42HYqWJq71O17KhJAEw9H/r0o+dLAdCvHFKTlnjWdITh+R0maeyKPbNg+r25Sg0Q2DoqRP5ereLgrBhbBruFZ8AJ0Dqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5eqyBJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5eqyBJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD34C433F1;
	Tue, 27 Feb 2024 13:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041099;
	bh=dbfcXWoa9UhulJ0c/FG3C67WmfGloDGs45yCbDl0iHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5eqyBJUJRXIHBFE0/sncfP/RNQ5S1mRvTvufniUDIEVYv93IbWw5kUPTbfaLNNZp
	 Os2DFJsxVkyihQGyNNN6isMTW63y+SykzFIlcVdc7bDzDGuC9LWo3EuYYjcE63L4j1
	 ksuoGLLud0Ns5lAJtT/9Jg+hgNSy0il7IszpxeVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 220/334] selftests: mptcp: simult flows: fix some subtest names
Date: Tue, 27 Feb 2024 14:21:18 +0100
Message-ID: <20240227131637.869373743@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 4d8e0dde0403b5a86aa83e243f020711a9c3e31f upstream.

The selftest was correctly recording all the results, but the 'reverse
direction' part was missing in the name when needed.

It is important to have a unique (sub)test name in TAP, because some CI
environments drop tests with duplicated name.

Fixes: 675d99338e7a ("selftests: mptcp: simult flows: format subtests results in TAP")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -267,7 +267,8 @@ run_test()
 		[ $bail -eq 0 ] || exit $ret
 	fi
 
-	printf "%-60s" "$msg - reverse direction"
+	msg+=" - reverse direction"
+	printf "%-60s" "${msg}"
 	do_transfer $large $small $time
 	lret=$?
 	mptcp_lib_result_code "${lret}" "${msg}"


