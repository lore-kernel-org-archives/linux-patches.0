Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D1E3EA9A;
	Wed,  7 Aug 2024 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043173; cv=none; b=mPIhS3O77OSsLLjr8TRNSHnYOzj+7Jpb3aUNvVwW/4vFTA4WVvaK+RcLFIPCQe+JSbUCXGJlxbfq0R6m0WV2S2dEIWrIcIUAZ5oWXMdxvisJTxJheeFUTHG4yB7WSUj7c7+LWqSRwL+BkiayAS8mKKIL00PUbxipdyCIeTLX3eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043173; c=relaxed/simple;
	bh=k6Iv+lysf35BOlYFFZ2rUZ5x86/3G5xZNsGCe2fa/K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=invHY36EPBLMDMTRT+wh3kUV6fqpO3Qc2qQiirmvsCX896qyXWJuBCA4nDLKNlZJxwbM+lkYRSzYvJclzyu948/yYyXHT8vIB4XxhL+JaFvQUb9XS+xLWUUzpxkTTcJsShd9GsOiQqGgQWQBoUgtDqdqdv9ZcdP0U6BltttCRig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nAH6qIPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nAH6qIPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8B3C32781;
	Wed,  7 Aug 2024 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043173;
	bh=k6Iv+lysf35BOlYFFZ2rUZ5x86/3G5xZNsGCe2fa/K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAH6qIPzwXfe1BKo8Tk0wu4GnzweCyjNHB8ph5GIehc4h9uASsLVahbf3DO7/Xajx
	 20qa/17xD+RcSlJRB4QHUJa/eUmXFjE2kCRDg1k/VNKF4sZqUv4HRCXe33BUaaq91r
	 TVSNuPMHHdi51n8MbAVvAQh6mfDrvfAD5EZFZkUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 118/123] mptcp: pm: only set request_bkup flag when sending MP_PRIO
Date: Wed,  7 Aug 2024 17:00:37 +0200
Message-ID: <20240807150024.740280159@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 4258b94831bb7ff28ab80e3c8d94db37db930728 upstream.

The 'backup' flag from mptcp_subflow_context structure is supposed to be
set only when the other peer flagged a subflow as backup, not the
opposite.

Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -471,7 +471,6 @@ static void __mptcp_pm_send_ack(struct m
 	slow = lock_sock_fast(ssk);
 	if (prio) {
 		subflow->send_mp_prio = 1;
-		subflow->backup = backup;
 		subflow->request_bkup = backup;
 	}
 


