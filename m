Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212359;
	b=SsAD3Vfu4klEIB1t//SJHtK386W+lNxNdtDcFKXQ+6HmEkycm3rlhF37eNXQc11EZRT9
	 +mPbPgZ78dkwR72Ly3vXsHbE68FWVbtQvblcubsWBZVbTy1aj2b6+oS9geA/tWHq1GABK
	 OEjuPBoyLJ9lyuiCi/P6tPlgeApDwufLJcosX3gYqTeeRJrKyLL2OasMbOZyex4u2okQr
	 uNNnTU1LDtvJjRwlsEpW6a8/z+i3LD4SnOSAzaogHXEADtEOq/gKm8QNBXbEC+G2zz2lF
	 8WhQOZ/m/LsP+YoJNbQCdText4GtpZvi+oK+oiCZ0eOIk9EZbVxLnR3HhmYMo3lDCrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LNMRxQ+nPRDI9DfI7/Jm/4kNJMNgv7ueXZpHUHhG0Ik=;
	b=TwagkGXR3CouivoJXsZq6pY7+HHJxmp5fRh23J5kcXSQkkBsk/9cqWaQDGGhiGglZHkF
	 DSckFhBjh+6HVLiO/EDDqfkQ+s7cNgu2aS3d7CqLgqT//xU7z0u4/FoUeeFFoCk7ebKMH
	 UfGWpMMcOt3wf2bAcRUlDaE3L2gLpWEGyBd7w1ml9BQaXv4vaolPHIKXWGB68X9Vd/6bb
	 jMfJyF8ncB08oJSRqV31n/HsfOyU7z8ZuPbSE0QJlzuKjxsLAeuejaJq/Za/8DCUvXyIl
	 IyOKyZdn12jbfHF3aOf31NkRTXGr61zuZePD3uTONMowZhfpvGY6dcSeWIOw7avowYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZFy+V0Bs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6936B606A31A;
	Wed, 28 Oct 2026 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZFy+V0Bs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84DE1F01825;
	Wed, 28 Oct 2026 18:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212359;
	bh=LNMRxQ+nPRDI9DfI7/Jm/4kNJMNgv7ueXZpHUHhG0Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFy+V0BskCc47L4yy2e6ZK6VdempTIAWrbZynqplp4DsZzW1OuTTL3228WdfVGlCY
	 tacZrualvmXihH6hy8j2lgjcBBcxwi6RQRWLD2Jb0YFtTuOFMfjeyONc33XXYqv4t0
	 swQibc/hGN2z3z2bTUjIwkLzBQsYwc+IlmN3vaYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0127/1887] mptcp: pm: reset retrans_time when ADD_ADDR entry is reused
Date: Wed, 28 Oct 2026 17:37:03 +0100
Message-ID: <20261028170502.127131007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit f968190c0b42ea2004dc1426359a53ec365a7a37 ]

When an ADD_ADDR entry is reused, the timer is re-armed, because the
goal is to re-announce an ADD_ADDR, and eventually retransmit it if
needed.

In this case, the retransmission counter should be reset as well, so the
re-announced address gets its retransmissions back instead of relying on
what was left before, and possibly not being able to retransmit it.

Fixes: 304ab97f4c7c ("mptcp: allow ADD_ADDR reissuance by userspace PMs")
Cc: stable@vger.kernel.org
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-0-b8f496d71664%40kernel.org?part=4
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-9-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted mptcp_pm_announced_alloc() in pm.c to mptcp_pm_alloc_anno_list() in pm_netlink.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 0d8316bc50775..532f75d29124d 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -428,10 +428,10 @@ bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
 
 	add_entry->addr = *addr;
 	add_entry->sock = msk;
-	add_entry->retrans_times = 0;
 
 	timer_setup(&add_entry->add_timer, mptcp_pm_add_timer, 0);
 reset_timer:
+	add_entry->retrans_times = 0;
 	add_entry->timer_done = false;
 	timeout = mptcp_get_add_addr_timeout(net);
 	if (timeout)
-- 
2.53.0



