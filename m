Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00E41419B3;
	Tue, 27 Feb 2024 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042440; cv=none; b=tK/Be4QQzETKBpfq41lG21MFUil7UoJBc6ok/7LmCi5jPsUXVGgDC2MSC0+pwtV2E6WCe3WD6rp+kibEJDFSQZDeGmGuqFYtAn+hyuVd3WKicRHCcCKRJgRMOldonkIDBv8kPlpsYWhkdDpmDNuiKxxdd7iDPYvOptFAZpLrVi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042440; c=relaxed/simple;
	bh=7oSMBIEGyjHjJD40I8RvT9DCtcdgCIbd7gIs6Oe0Zcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaRdD+HHxwLUt3UYicXJ4z6cMZghvCcnZMsWO92EDEhFywV0PakRaqDJIdxt/MTBZhcB8cv2dCLcQE2vlKKXckeX0XsxMIATWNc3J7vVEqhf7/Igaqw8vjgfU4KIjSj9pri6i9KUNqcNXZvllZjYHp6GIaM04XdPKVOVSaNuQvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlOtHnAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlOtHnAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0D7C433F1;
	Tue, 27 Feb 2024 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042440;
	bh=7oSMBIEGyjHjJD40I8RvT9DCtcdgCIbd7gIs6Oe0Zcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlOtHnAjN3IV1xTCSmqiObgCXeyC2Cx9d6wNsH9N8gmNxBCZVKoT3zVAhXS5OhQ5r
	 huhMKkOwZGoXpIjqC8SwBEkk00dFvwe8iF0rG6URE8T5W+WVphecDjWkq61Gfe7Ajh
	 NQcT3NJQnBlUol5gWXbue+mqBEhSIcBjYNNhrxRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 296/299] mptcp: userspace pm send RM_ADDR for ID 0
Date: Tue, 27 Feb 2024 14:26:47 +0100
Message-ID: <20240227131635.188731114@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

commit 84c531f54ad9a124a924c9505d74e33d16965146 upstream.

This patch adds the ability to send RM_ADDR for local ID 0. Check
whether id 0 address is removed, if not, put id 0 into a removing
list, pass it to mptcp_pm_remove_addr() to remove id 0 address.

There is no reason not to allow the userspace to remove the initial
address (ID 0). This special case was not taken into account not
letting the userspace to delete all addresses as announced.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/379
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231025-send-net-next-20231025-v1-3-db8f25f798eb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Fixes: d9a4594edabf ("mptcp: netlink: Add MPTCP_PM_CMD_REMOVE")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -220,6 +220,40 @@ int mptcp_nl_cmd_announce(struct sk_buff
 	return err;
 }
 
+static int mptcp_userspace_pm_remove_id_zero_address(struct mptcp_sock *msk,
+						     struct genl_info *info)
+{
+	struct mptcp_rm_list list = { .nr = 0 };
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	bool has_id_0 = false;
+	int err = -EINVAL;
+
+	lock_sock(sk);
+	mptcp_for_each_subflow(msk, subflow) {
+		if (subflow->local_id == 0) {
+			has_id_0 = true;
+			break;
+		}
+	}
+	if (!has_id_0) {
+		GENL_SET_ERR_MSG(info, "address with id 0 not found");
+		goto remove_err;
+	}
+
+	list.ids[list.nr++] = 0;
+
+	spin_lock_bh(&msk->pm.lock);
+	mptcp_pm_remove_addr(msk, &list);
+	spin_unlock_bh(&msk->pm.lock);
+
+	err = 0;
+
+remove_err:
+	release_sock(sk);
+	return err;
+}
+
 int mptcp_nl_cmd_remove(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
@@ -251,6 +285,11 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 		goto remove_err;
 	}
 
+	if (id_val == 0) {
+		err = mptcp_userspace_pm_remove_id_zero_address(msk, info);
+		goto remove_err;
+	}
+
 	lock_sock((struct sock *)msk);
 
 	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {


