Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D99352087;
	Tue, 26 Aug 2025 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216832; cv=none; b=jedjud86YSMy7FV9P8ZBE2VDvzHXAyXd2p+SoqmfENRD+rDhlm9oGHklzTvZMDgbc0iGS52305wQqk606mxXrktZa3DHIrfRCN1B+R/CJBQBNu+wvQmf+QHaGqvgWxpEnf+gen+aH1fjHFOlh+4Z1aTNwPsiUcjVHVJlTw+1LTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216832; c=relaxed/simple;
	bh=Cm3iy6wQDtFKPBfzj5LWbq5QUTSwxW2Sdar9UUF5QtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO6R48tYheeKIeLpDGMFRPlmjg35JikuiFB/b/A9oAeHibgs/NAJtJ0m+W4vJE3vA1of9e7uwsnjAjE3zZx9LHQ0wCoHMUkK9y6Vtrv2GyNiarmsyaK8G/YoDo0NR0ju4mou4LzQAi9A6LV1UUvQLxXpSylv2e6EchOcl2Q+voA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tl1p1fjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tl1p1fjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB411C4CEF1;
	Tue, 26 Aug 2025 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216832;
	bh=Cm3iy6wQDtFKPBfzj5LWbq5QUTSwxW2Sdar9UUF5QtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tl1p1fjl6ov3KM5ZDr+NUZIzLotPsm/VwVaeJd1J5Bji0S7LySVAj+gmau4k9MdDi
	 9sN2M2CWDVFTWKUmKj4gxRPg1LjGtSn/P41HYr9EmiFCNvM94Z0swpk9D/6dCS6Fem
	 i0szJlFgrvYjeJqMJip27Buy1AP5sprTJ1Hyey+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 559/644] mptcp: drop unused sk in mptcp_push_release
Date: Tue, 26 Aug 2025 13:10:50 +0200
Message-ID: <20250826111000.382657822@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit b8e0def397d7753206b1290e32f73b299a59984c upstream.

Since mptcp_set_timeout() had removed from mptcp_push_release() in
commit 33d41c9cd74c5 ("mptcp: more accurate timeout"), the argument
sk in mptcp_push_release() became useless. Let's drop it.

Fixes: 33d41c9cd74c5 ("mptcp: more accurate timeout")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c886d70286bf ("mptcp: do not queue data on closed subflows")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1568,8 +1568,7 @@ static struct sock *mptcp_subflow_get_se
 	return NULL;
 }
 
-static void mptcp_push_release(struct sock *sk, struct sock *ssk,
-			       struct mptcp_sendmsg_info *info)
+static void mptcp_push_release(struct sock *ssk, struct mptcp_sendmsg_info *info)
 {
 	tcp_push(ssk, 0, info->mss_now, tcp_sk(ssk)->nonagle, info->size_goal);
 	release_sock(ssk);
@@ -1626,7 +1625,7 @@ void __mptcp_push_pending(struct sock *s
 			 * the last round, release prev_ssk
 			 */
 			if (ssk != prev_ssk && prev_ssk)
-				mptcp_push_release(sk, prev_ssk, &info);
+				mptcp_push_release(prev_ssk, &info);
 			if (!ssk)
 				goto out;
 
@@ -1639,7 +1638,7 @@ void __mptcp_push_pending(struct sock *s
 
 			ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
 			if (ret <= 0) {
-				mptcp_push_release(sk, ssk, &info);
+				mptcp_push_release(ssk, &info);
 				goto out;
 			}
 
@@ -1654,7 +1653,7 @@ void __mptcp_push_pending(struct sock *s
 
 	/* at this point we held the socket lock for the last subflow we used */
 	if (ssk)
-		mptcp_push_release(sk, ssk, &info);
+		mptcp_push_release(ssk, &info);
 
 out:
 	/* ensure the rtx timer is running */


