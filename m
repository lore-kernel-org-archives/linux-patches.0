Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E12341322E;
	Wed,  4 Feb 2026 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219147; cv=none; b=Jb+CZAya0iZ+XHybKjFb8V03IU4tMo8/91mU9r6IaQwvYSbOC10PHw1izimy6WPGu6jgoc7om4ytw2MYtwiB3h8PcGFEVS9lUVHQ7l3HTJX5Zh96H4cdDGivq0Jg9i8b/vmO3tjrYndTcjirpQOdOY1qXcnCyz9aSKnaM2qzpIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219147; c=relaxed/simple;
	bh=ASvOPFK+4y/THfHKY5WXz+Uv1LWkyU3MwvMt8laZ2Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8ZYq25XN0JnCyn8jrzSHQp4TWGyhgQJVLSobE5vLRR/MRSruw5XJiVRT2q5oObkoO0L24mp/EpcW0JJYGszFFWa99Ss2ahuUK65ILRk6Q4g2gftSiRea4G8b7wn9Sw5SYtHR+ZwhJcgAKKiszzxoZ4hbCWKnS5gSpDS3Lrc9fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8yyYmiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8yyYmiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15B7C19423;
	Wed,  4 Feb 2026 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219147;
	bh=ASvOPFK+4y/THfHKY5WXz+Uv1LWkyU3MwvMt8laZ2Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8yyYmiJpnU2IjMidvUELFNrB4jBqODqtYx28oex7ciNVHNGAT6dlc8HB4a9G6dDx
	 BH0p1mrwGbHmaudggUwIwsL++vHkQntZwsj7KFAh4mok4jxh3iBWyvghg0Mfjl5Qlb
	 RogcjTSLgCT3Q9RzQVEhe87YpknaNcRE2gYmdca8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 081/122] selftests: mptcp: check subflow errors in close events
Date: Wed,  4 Feb 2026 15:41:03 +0100
Message-ID: <20260204143854.766520613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 2ef9e3a3845d0a20b62b01f5b731debd0364688d upstream.

This validates the previous commit: subflow closed events should contain
an error field when a subflow got closed with an error, e.g. reset or
timeout.

For this test, the chk_evt_nr helper has been extended to check
attributes in the matched events.

In this test, the 2 subflow closed events should have an error.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 15cc10453398 ("mptcp: deliver ssk errors to msk")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260127-net-mptcp-dup-nl-events-v1-4-7f71e1bc4feb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3692,21 +3692,28 @@ userspace_pm_chk_get_addr()
 	fi
 }
 
-# $1: ns ; $2: event type ; $3: count
+# $1: ns ; $2: event type ; $3: count ; [ $4: attr ; $5: attr count ]
 chk_evt_nr()
 {
 	local ns=${1}
 	local evt_name="${2}"
 	local exp="${3}"
+	local attr="${4}"
+	local attr_exp="${5}"
 
 	local evts="${evts_ns1}"
 	local evt="${!evt_name}"
+	local attr_name
 	local count
 
+	if [ -n "${attr}" ]; then
+		attr_name=", ${attr}: ${attr_exp}"
+	fi
+
 	evt_name="${evt_name:16}" # without MPTCP_LIB_EVENT_
 	[ "${ns}" == "ns2" ] && evts="${evts_ns2}"
 
-	print_check "event ${ns} ${evt_name} (${exp})"
+	print_check "event ${ns} ${evt_name} (${exp}${attr_name})"
 
 	if [[ "${evt_name}" = "LISTENER_"* ]] &&
 	   ! mptcp_lib_kallsyms_has "mptcp_event_pm_listener$"; then
@@ -3718,6 +3725,16 @@ chk_evt_nr()
 	if [ "${count}" != "${exp}" ]; then
 		fail_test "got ${count} events, expected ${exp}"
 		cat "${evts}"
+		return
+	elif [ -z "${attr}" ]; then
+		print_ok
+		return
+	fi
+
+	count=$(grep -w "type:${evt}" "${evts}" | grep -c ",${attr}:")
+	if [ "${count}" != "${attr_exp}" ]; then
+		fail_test "got ${count} event attributes, expected ${attr_exp}"
+		grep -w "type:${evt}" "${evts}"
 	else
 		print_ok
 	fi
@@ -3976,7 +3993,7 @@ userspace_tests()
 			chk_subflows_total 1 1
 			userspace_pm_add_sf $ns2 10.0.1.2 0
 			wait_event ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
-			chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
+			chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2 error 2
 		fi
 		kill_events_pids
 		mptcp_lib_kill_group_wait $tests_pid


