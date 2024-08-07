Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B4881AB1;
	Wed,  7 Aug 2024 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043530; cv=none; b=kHjpd+LqJ8UW6kyuGkYX/D4JZHWUeLraXirz63yexKEsAEWvbLTPt80O5/APF0fwsfqqmvJXX5nknUE0NUHCAPpktJRrrc1z4sEbRv9u4mEpj5hEPBL6xVupqhwDCMVp2kAeLUIyxBdLBlVJ/s4XrGa0XPYYU9PR/F/jaQ1CS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043530; c=relaxed/simple;
	bh=kpShPT0TuOtlYQ0sVJQoAt1r1bm98Qqh7PdX4f1hfXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPpgz+Y4UmKQfTevBqMGiarC3p6ZeYp62nats4e0NyyZqqJI59K3Wvgytnj/UjScHyLbE2sUnoWr8Xne3QcHGbBzOUz8X52zrhtXk0l7eeimLStnrn/2ftvjKzOONprTVchlLvD9Q1gQwycP0i7sKKsDq5HBAuaEvdOHXmkeP0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKGFUoem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKGFUoem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BADC32781;
	Wed,  7 Aug 2024 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043530;
	bh=kpShPT0TuOtlYQ0sVJQoAt1r1bm98Qqh7PdX4f1hfXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKGFUoemhTqh0fNy4CYv3P11DSQyRzxJWJro3dH8si5s1ahpn0p6gg5tiSP7S5iCr
	 o1lKvBtvbsHIL9CfKg+mY+s8yqFwi/JAHSKa1TETj23WtXEmDHXmPIJK6ZYhFg+nUt
	 jeZcuFOuUvWTdoZkKPBJYIk4OyCW3UDFLRWn35jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 116/121] mptcp: pm: only set request_bkup flag when sending MP_PRIO
Date: Wed,  7 Aug 2024 17:00:48 +0200
Message-ID: <20240807150023.199529762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
@@ -476,7 +476,6 @@ static void __mptcp_pm_send_ack(struct m
 	slow = lock_sock_fast(ssk);
 	if (prio) {
 		subflow->send_mp_prio = 1;
-		subflow->backup = backup;
 		subflow->request_bkup = backup;
 	}
 


