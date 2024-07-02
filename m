Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579D91BE876;
	Tue,  2 Jul 2024 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940706; cv=none; b=OidPzT5Dlaf91lPQot+odeR+1PJSe65WRSRcSIkY1Nc4qT/7rktGFU40QxW+IWUJy9561Sc0iJY1Ub8SGmtL6Y8jI50H0K4+RI+8njKKBmmS1G1n7Zo5Q+RjnN/ErBAP3tvvEN6naPjYJLU7IWbHGxyYOe/DWV8Te6l/UeN58wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940706; c=relaxed/simple;
	bh=lmtfx44iPpzHUTEEZyIpSXpJqnvDZT4xT72B1kDHryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZRv1YSvAAZJsdfQbYTr8Ssvb62CRVDRclKM5dyPzIEGIJTbinpZxJ/7d7n8r9P/UciHzOgapYA/uZYLNAMWgetPCl9dJ/5UWp5JReIaf6BhUgGjeglR6eOD9khsp22Jg/c7VgfBV6Dq2BlIOq/gY6cNdprR9XcT7Btg84+naNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=to+pakXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="to+pakXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD12C116B1;
	Tue,  2 Jul 2024 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940706;
	bh=lmtfx44iPpzHUTEEZyIpSXpJqnvDZT4xT72B1kDHryg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to+pakXYDZAs1xCsargf8zuFYdhgyNzvfP198VNoC8yLJJVd/Yz6q//fFU2CFx5tx
	 c80FF91C0Hd/1ITtD1k721sX9EaIULjUXTZkjQjFtGpfqCdouwVpxSm0Td9d+nel41
	 aK+erI5xM5OJ8mdFazYBrQS1469ubF8PFcxx9UqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/163] selftests: mptcp: print_test out of verify_listener_events
Date: Tue,  2 Jul 2024 19:02:07 +0200
Message-ID: <20240702170233.556504198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 8ebb44196585d3c9405fba1e409cf2312bca30ac ]

verify_listener_events() helper will be exported into mptcp_lib.sh as a
public function, but print_test() is invoked in it, which is a private
function in userspace_pm.sh only. So this patch moves print_test() out of
verify_listener_events().

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240308-upstream-net-next-20240308-selftests-mptcp-unification-v1-12-4f42c347b653@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e874557fce1b ("selftests: mptcp: userspace_pm: fixed subtest names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 4c62114de0637..305a0f6716c38 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -917,12 +917,6 @@ verify_listener_events()
 	local saddr
 	local sport
 
-	if [ $e_type = $LISTENER_CREATED ]; then
-		print_test "CREATE_LISTENER $e_saddr:$e_sport"
-	elif [ $e_type = $LISTENER_CLOSED ]; then
-		print_test "CLOSE_LISTENER $e_saddr:$e_sport"
-	fi
-
 	type=$(mptcp_lib_evts_get_info type $evt $e_type)
 	family=$(mptcp_lib_evts_get_info family $evt $e_type)
 	sport=$(mptcp_lib_evts_get_info sport $evt $e_type)
@@ -954,6 +948,7 @@ test_listener()
 	local listener_pid=$!
 
 	sleep 0.5
+	print_test "CREATE_LISTENER 10.0.2.2:$client4_port"
 	verify_listener_events $client_evts $LISTENER_CREATED $AF_INET 10.0.2.2 $client4_port
 
 	# ADD_ADDR from client to server machine reusing the subflow port
@@ -970,6 +965,7 @@ test_listener()
 	mptcp_lib_kill_wait $listener_pid
 
 	sleep 0.5
+	print_test "CLOSE_LISTENER 10.0.2.2:$client4_port"
 	verify_listener_events $client_evts $LISTENER_CLOSED $AF_INET 10.0.2.2 $client4_port
 }
 
-- 
2.43.0



