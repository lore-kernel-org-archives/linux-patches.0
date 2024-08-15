Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DC51AD3EF;
	Thu, 15 Aug 2024 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732935; cv=none; b=Suju2eS7ckxitHJEdoJv6gLdefsL7eo1aLToOX/oZ63R6WM1dJvVpkDMVOfKTvn8gH0z0bGoS0aSOE4I21n+8243vIQ3EVRbDW1aFzWlcaNOxruxzrJJdKIQUms/XGFvfTpMRtQDmtjaTvrHQqkSSnsqOJvMD9cOXgKV60fbhjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732935; c=relaxed/simple;
	bh=Z6w5qav3MVci0tUCV+P4OY3Ge8b+mhw4nEsNXGvaLII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaP/8EpLB6caxer2+M6tr8C5n7JjCY00R3t12kXo8QjkArahhMLGjt3URZjE/0TQCRiWezoXYqSQyRlfboCcrlkSadMZestw82MaPDRWKmRP0USokG0rQfzH9/WJWaQ67OdVOsHm0EbSxMDU5hZUoZjw17jJh+iuo5U94cQl9go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg4saXHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg4saXHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C75EC32786;
	Thu, 15 Aug 2024 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732934;
	bh=Z6w5qav3MVci0tUCV+P4OY3Ge8b+mhw4nEsNXGvaLII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wg4saXHYdb50MGjy+16/XVTrdLGqVbDAIY0zPNkY88oBTNyTCAOCd9In2UubDiTnV
	 lKNwGPCh8ao24rHW54GAaLNa8RmlVkR+WAs7iVBGMOJeKHrh+ezdArVfIV3ETeaJYQ
	 E5sD+HrKKHr5xutQuUVY4phbmB48206m2Fr/nYms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.10 332/352] mptcp: export local_address
Date: Thu, 15 Aug 2024 15:26:38 +0200
Message-ID: <20240815131932.290798364@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit dc886bce753cc2cf3c88ec5c7a6880a4e17d65ba upstream.

Rename local_address() with "mptcp_" prefix and export it in protocol.h.

This function will be re-used in the common PM code (pm.c) in the
following commit.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6834097fc38c ("mptcp: pm: fix backup support in signal endpoints")
[ Conflicts in pm_netlink.c and protocol.h, because the context has
  changed in commit 4638de5aefe5 ("mptcp: handle local addrs announced
  by userspace PMs") which is not in this version. This commit is
  unrelated to this modification. Also some parts using 'local_address'
  are not in this version, that's OK, we don't need to do anything with
  them. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    9 ++++-----
 net/mptcp/protocol.h   |    1 +
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -84,8 +84,7 @@ static bool address_zero(const struct mp
 	return addresses_equal(addr, &zero, false);
 }
 
-static void local_address(const struct sock_common *skc,
-			  struct mptcp_addr_info *addr)
+void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr)
 {
 	addr->port = 0;
 	addr->family = skc->skc_family;
@@ -120,7 +119,7 @@ static bool lookup_subflow_by_saddr(cons
 	list_for_each_entry(subflow, list, node) {
 		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
 
-		local_address(skc, &cur);
+		mptcp_local_address(skc, &cur);
 		if (addresses_equal(&cur, saddr, false))
 			return true;
 	}
@@ -533,8 +532,8 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	/* The 0 ID mapping is defined by the first subflow, copied into the msk
 	 * addr
 	 */
-	local_address((struct sock_common *)msk, &msk_local);
-	local_address((struct sock_common *)skc, &skc_local);
+	mptcp_local_address((struct sock_common *)msk, &msk_local);
+	mptcp_local_address((struct sock_common *)skc, &skc_local);
 	if (addresses_equal(&msk_local, &skc_local, false))
 		return 0;
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -372,6 +372,7 @@ void __mptcp_close_ssk(struct sock *sk,
 		       struct mptcp_subflow_context *subflow,
 		       long timeout);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,


