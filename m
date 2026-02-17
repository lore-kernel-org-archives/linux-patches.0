Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC6F29A1;
	Tue, 17 Feb 2026 20:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361247; cv=none; b=Jamj1IdhMgX5ECLx3o4J+A6ZlJclOk795B2VgyzjEsHn5iet7HjcHfZeYmSKIO2YyY40a+68NZU5z8jtyeazXlEMijsIDdFDLOqvlnE5yro3PInDI0DDHeFzJivJbobBvdfo2rWTN8hQFOJkeGp/iKRQiYa/qMFaF/rbOmyvmTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361247; c=relaxed/simple;
	bh=zmavyfpG/qktzPnfuBoj+gWDk59vJO2FyZiYH9s6nbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WoFKViiInseBSWSJ6tRi0eQCCobYzJq0kZitKQ+9XIbm0BTfFIqASNaPwz+d3zfafUNhycMVP+an4ALna4FydODJI8pmXVgJgQf23pUn0ICVDedv+kCB/J5sTrNt/+tLKU0yIQzJMep0l1XgWDs89Pm4cVQr6YbjJ7kOWfYvbLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaEtV9O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaEtV9O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBCDC4CEF7;
	Tue, 17 Feb 2026 20:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361247;
	bh=zmavyfpG/qktzPnfuBoj+gWDk59vJO2FyZiYH9s6nbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaEtV9O+qMHcsZZrN4itbXW1JvvhuOYjjF2GsFVHzVrJTbjm8d4Q9Fk0kRGXQTV5U
	 nqzOiRziuH0h4tUZPMsUSP/wfzajj5ov3TVi4TnXjvgBoUGK0JmmjP62oQsXLIAMlw
	 ANZi6sQ+7mbuaJ4Zswvl4i3ThTzSojH7HwKHjKII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 45/64] selftests: mptcp: check subflow errors in close events
Date: Tue, 17 Feb 2026 21:31:41 +0100
Message-ID: <20260217200009.193434125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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
[ Conflicts in mptcp_join.sh, because in this version, commit
  20ccc7c5f7a3 ("selftests: mptcp: join: validate event numbers") has
  been backported with adaptations to display results correctly, see
  commit 5dc9170eee96 ("selftests: mptcp: join: validate event numbers")
  for more details. The same type of adaptations had to be made here as
  well. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   25 +++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3212,21 +3212,28 @@ userspace_pm_add_sf()
 	sleep 1
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
 
-	printf "%-${nr_blank}s %s" " " "event ${ns} ${evt_name} (${exp})"
+	printf "%-${nr_blank}s %s" " " "event ${ns} ${evt_name} (${exp}${attr_name})"
 
 	count=$(grep -cw "type:${evt}" "${evts}")
 	if [ "${count}" != "${exp}" ]; then
@@ -3234,6 +3241,18 @@ chk_evt_nr()
 		fail_test
 		dump_stats
 		cat "${evts}"
+		return
+	elif [ -z "${attr}" ]; then
+		echo "[ ok ]"
+		return
+	fi
+
+	count=$(grep -w "type:${evt}" "${evts}" | grep -c ",${attr}:")
+	if [ "${count}" != "${attr_exp}" ]; then
+		echo "[fail] got ${count} event attributes, expected ${attr_exp}"
+		fail_test
+		dump_stats
+		grep -w "type:${evt}" "${evts}"
 	else
 		echo "[ ok ]"
 	fi
@@ -3375,7 +3394,7 @@ userspace_tests()
 			chk_subflow_nr "" "after reject" 1
 			userspace_pm_add_sf $ns2 10.0.1.2 0
 			wait_event ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
-			chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
+			chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2 error 2
 		fi
 		kill_wait "${tests_pid}"
 		kill_events_pids


