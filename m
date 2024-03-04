Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4248B1C6AB;
	Mon,  4 Mar 2024 21:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588803; cv=none; b=byqwiVMgLQoteG9nknt7Jb4XF96y0xdVPRg5MpWvyMMJ20HBgiTWCOuTko3YrT5bjb+GCzbeVRV+YHo5j4jFvzJOw7/lZc/pF1VWXSyEtboCXDrLRf4tiIwz+VHIb2iYvOKilCsw3PcF3SHAV8EjSbx+Q+3mkBT2b4QLLQP99OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588803; c=relaxed/simple;
	bh=sAk81ZY7boZD1caiqbHzuWxVSPPHFyqhC0CJcDgjae0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0SXq9QqlsRbmXIyFtAKDrFHZcf2E/lIIV+Jpe32JJFFouOw7XYYOAY67Zx0LLa8lj+tp+KYAsXxxiS845w9dt6Sx6oDIwEmg/hY3xzVh5/wSwsG6u0KVO4uQGRZ9tsxVcgHIw1Xf00SZMpjunOrIJcrqEkvBXo5sKfpl7qBBzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5LQBgQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5LQBgQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8606C433F1;
	Mon,  4 Mar 2024 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588803;
	bh=sAk81ZY7boZD1caiqbHzuWxVSPPHFyqhC0CJcDgjae0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5LQBgQsixcTaPGElJY3/DXgg28SBIDSOr9xU8dbNsYMsCQsSa6UM04m4+SkMO4E2
	 1HylawCoOd5dlmsggmHSazxI/vGNXWEm0GNjMFHgtCFtmZ0YXjQY39Joj+TYBucysM
	 xnkaEwRuJVDYskQb2H9WGG/2Oj0UfjH/oJMYUkUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 103/215] selftests: mptcp: join: add ss mptcp support check
Date: Mon,  4 Mar 2024 21:22:46 +0000
Message-ID: <20240304211600.297499420@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 9480f388a2ef54fba911d9325372abd69a328601 upstream.

Commands 'ss -M' are used in script mptcp_join.sh to display only MPTCP
sockets. So it must be checked if ss tool supports MPTCP in this script.

Fixes: e274f7154008 ("selftests: mptcp: add subflow limits test-cases")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-7-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -144,6 +144,11 @@ check_tools()
 		exit $ksft_skip
 	fi
 
+	if ! ss -h | grep -q MPTCP; then
+		echo "SKIP: ss tool does not support MPTCP"
+		exit $ksft_skip
+	fi
+
 	# Use the legacy version if available to support old kernel versions
 	if iptables-legacy -V &> /dev/null; then
 		iptables="iptables-legacy"


