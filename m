Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF871742;
	Mon,  8 Apr 2024 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582498; cv=none; b=Zimh0VW0j6ymzci9YNUjdu81b0wtMC0zqJjX8ino4gRoIfQ/6xnRZGOJYzr7zogNvKB8Rr0f8J7cciUsP9l5eZNBlTQlUvkskHF7iqFWjRl63EVCxf99LW9dO/CUP3t7kHEV8yJ5lO8ihY9+Uz4m0xio5IsNLDDi8Jteeg8mcXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582498; c=relaxed/simple;
	bh=xRRxZWgaYADFwRE4uEQY+cVTDH/G9WuKUMmT7sFCfGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHBIaV7S8aOdr9FDGxmG0rqg8gzGsAqpiGZGsiWCDFmKDWJm8n4ZQ8zN1pBAXCCU9xdhWJFcX6zbGxTRfIyUD94bzbxzDyNyGf9U8oerfMk0q98fmDpF8TR0TUVIGholx12TKj+zimBMh52c+Fc3Q8wh3X8LB8An8LIqOLJZ+k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMrZ8L4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMrZ8L4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65077C433C7;
	Mon,  8 Apr 2024 13:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582497;
	bh=xRRxZWgaYADFwRE4uEQY+cVTDH/G9WuKUMmT7sFCfGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMrZ8L4xeBCZqp0ja3fDwouyK5aCLo1o6+mYpNE3f12z3jLXbdthbSfVglwRIk09k
	 +W/bQ9Vxv+JyLqDylXC+IIVUB5itqtktOiYngOcLrYsA0JjpkoUyL3akpiCLTIBQzT
	 fXqbOvOfqGcoNBQ4qMs0O1NrOkrKb06UVWwcMyC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 081/273] selftests: mptcp: join: fix dev in check_endpoint
Date: Mon,  8 Apr 2024 14:55:56 +0200
Message-ID: <20240408125311.816451733@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 40061817d95bce6dd5634a61a65cd5922e6ccc92 upstream.

There's a bug in pm_nl_check_endpoint(), 'dev' didn't be parsed correctly.
If calling it in the 2nd test of endpoint_tests() too, it fails with an
error like this:

 creation  [FAIL] expected '10.0.2.2 id 2 subflow dev dev' \
                     found '10.0.2.2 id 2 subflow dev ns2eth2'

The reason is '$2' should be set to 'dev', not '$1'. This patch fixes it.

Fixes: 69c6ce7b6eca ("selftests: mptcp: add implicit endpoint test case")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240329-upstream-net-20240329-fallback-mib-v1-2-324a8981da48@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -773,7 +773,7 @@ pm_nl_check_endpoint()
 			[ -n "$_flags" ]; flags="flags $_flags"
 			shift
 		elif [ $1 = "dev" ]; then
-			[ -n "$2" ]; dev="dev $1"
+			[ -n "$2" ]; dev="dev $2"
 			shift
 		elif [ $1 = "id" ]; then
 			_id=$2
@@ -3589,6 +3589,8 @@ endpoint_tests()
 		local tests_pid=$!
 
 		wait_mpj $ns2
+		pm_nl_check_endpoint "creation" \
+			$ns2 10.0.2.2 id 2 flags subflow dev ns2eth2
 		chk_subflow_nr "before delete" 2
 		chk_mptcp_info subflows 1 subflows 1
 


