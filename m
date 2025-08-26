Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB788340D9E;
	Tue, 26 Aug 2025 11:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208641; cv=none; b=fRQdcNDqISmTyFIPrRmDkMcSqgaKML8CzNqosuggmdrK4ZE4sTK1bOeVaq7RGvoMAqxeLx0FdBTIPnBtES8mM3ApzsNVkXGeJmKqlLi3bJ5tfgFAJ61h8Kke6IV2IsJTC60qpkT01HhyDxmV54PImBJSmzJ2zD7PvxUqF8y65Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208641; c=relaxed/simple;
	bh=qvuyInjaBJxkY/JSVmbJhNvwTfvT1KCqfIvirvE+5qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wi2egNC12HmQ3WNkTMgpoteuCmFHnqwDMYanBNNuvG/bq9ffQVbjK2RxoUwNgXldCeismP+wqIAZ+Y17tef4444Q2b5HUMyDfDydBgetyyCSc19gWU24eq1TnGbpGVu3e073yDLj5BHE43qza5hyyVqVx6Z777hlmk1qbQJoQx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l14UQX2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l14UQX2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170FDC4CEF1;
	Tue, 26 Aug 2025 11:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208641;
	bh=qvuyInjaBJxkY/JSVmbJhNvwTfvT1KCqfIvirvE+5qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l14UQX2MhiHCr5tOQa59/A8gunR5H9D0JIjHPlss1a+saIWnuMXpWbCQHRXXjSOtw
	 Rq352fxtDxDI467FjcCEkb4JPZtXktmLdZUBlswvyWNUii4lrlJ8ftmNNT3oDY2+My
	 aVi0j5IWM0XB1lEI4qOjdoHLkg6u6EAjynZT2Lck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 190/322] mptcp: remove duplicate sk_reset_timer call
Date: Tue, 26 Aug 2025 13:10:05 +0200
Message-ID: <20250826110920.557502307@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 5d13349472ac8abcbcb94407969aa0fdc2e1f1be upstream.

sk_reset_timer() was called twice in mptcp_pm_alloc_anno_list.

Simplify the code by using a 'goto' statement to eliminate the
duplication.

Note that this is not a fix, but it will help backporting the following
patch. The same "Fixes" tag has been added for this reason.

Fixes: 93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250815-net-mptcp-misc-fixes-6-17-rc2-v1-4-521fe9957892@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Before commit e4c28e3d5c09 ("mptcp: pm: move generic PM helpers to
  pm.c"), mptcp_pm_alloc_anno_list() was in pm_netlink.c. The same patch
  can be applied there without conflicts. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -372,9 +372,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 		if (WARN_ON_ONCE(mptcp_pm_is_kernel(msk)))
 			return false;
 
-		sk_reset_timer(sk, &add_entry->add_timer,
-			       jiffies + mptcp_get_add_addr_timeout(net));
-		return true;
+		goto reset_timer;
 	}
 
 	add_entry = kmalloc(sizeof(*add_entry), GFP_ATOMIC);
@@ -388,6 +386,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
+reset_timer:
 	sk_reset_timer(sk, &add_entry->add_timer,
 		       jiffies + mptcp_get_add_addr_timeout(net));
 


