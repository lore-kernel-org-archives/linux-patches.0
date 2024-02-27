Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8456613B78F;
	Tue, 27 Feb 2024 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043489; cv=none; b=KEg8YuC9O2iVYZGvovwyEGrFSYaC9qCFskm2GxqWKb8LDXRONJ5f5p9z1/cFiuFPAZW2835Yv6cpTAqoJyZxNl56Fd0AtRkq6LbYmphiju8Jz3ijtFJNhOyjZTBQoRgDE+JVuvjjbTYOIcLH6bluFCQuydqAFcbULqiqCNdibmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043489; c=relaxed/simple;
	bh=HMzUSWLnYM2gmTwzSjZYCYRKUaWCUeIjfkcl9HL4ADE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJDK8Vjb9jhLR2rdKgpW9mesxZS+VYEU/vJ7UD7Al8jzgXKExUDoHU6yJEKVJdcwOjH0L6Kq1IKTU35g2t5gZhLeoioz6kPhwFEM2aEqU8ln9nwYUM6yRhMe2NZxE+zUpj/lvkjkteN42ZPXKcs9ys80/wtyByEYqzX7fa5ykMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfLmgJj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfLmgJj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158FCC433F1;
	Tue, 27 Feb 2024 14:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043489;
	bh=HMzUSWLnYM2gmTwzSjZYCYRKUaWCUeIjfkcl9HL4ADE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfLmgJj/cQT1zccEUXFH1m3BJIQWAQl548bhTWzX0RRi4Peccudvz0RnyDk7MQu2C
	 grjmNy3iJbacd4bi/1LBCxVY/+E6xDcshfeV2WvEOvjhoHKqkMaqDVEBPf7Fwp77QQ
	 mXHGCx5/wPUI2F+Ml4PqOVQT26w08Sjwcsz5VFz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 126/195] mptcp: make userspace_pm_append_new_local_addr static
Date: Tue, 27 Feb 2024 14:26:27 +0100
Message-ID: <20240227131614.606100332@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

commit aa5887dca2d236fc50000e27023d4d78dce3af30 upstream.

mptcp_userspace_pm_append_new_local_addr() has always exclusively been
used in pm_userspace.c since its introduction in
commit 4638de5aefe5 ("mptcp: handle local addrs announced by userspace PMs").

So make it static.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    4 ++--
 net/mptcp/protocol.h     |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -25,8 +25,8 @@ void mptcp_free_local_addr_list(struct m
 	}
 }
 
-int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
-					     struct mptcp_pm_addr_entry *entry)
+static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
+						    struct mptcp_pm_addr_entry *entry)
 {
 	DECLARE_BITMAP(id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 	struct mptcp_pm_addr_entry *match = NULL;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -834,8 +834,6 @@ void mptcp_pm_remove_addrs(struct mptcp_
 void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
 					struct list_head *rm_list);
 
-int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
-					     struct mptcp_pm_addr_entry *entry);
 void mptcp_free_local_addr_list(struct mptcp_sock *msk);
 int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info);
 int mptcp_nl_cmd_remove(struct sk_buff *skb, struct genl_info *info);


