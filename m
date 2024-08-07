Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0567933CD2;
	Wed,  7 Aug 2024 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043764; cv=none; b=E0c1/TWdx12you0nnKOVaHn93H8CJ4SjkzBYDSZIUlXb3E7dCwzQNZDs44u/Hcpqb0qb/L+J+dfp0A8ZWBMneDIqkFGxG8iszkyqvzGmzBD25KI0Y8BwNIlNKtWvXWvWNdHipvoyGE6GO7UdHCj7Pampgx93ANZbUT/TqrLXHT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043764; c=relaxed/simple;
	bh=qo8Of/PXnwKTkmjQj/O0eIw5/nomtk7jZPVO5F/nAYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZBXyGZ+R0aNnv6B3idmGVUARKJgvbInj3ZNB8k8y+ZqjyHev1+06imcW0AHtgJP5++Jk+AJm1WxQ4tek/7937HQmzkY5uoWjM13dH0g+8cTq4jwbk4FuF151x+6YtVMTuQkrUZQB7qhOaLHjobY8yFsS64lnWmNGe3d5i+K+w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBWRKFzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBWRKFzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA3CC32781;
	Wed,  7 Aug 2024 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043763;
	bh=qo8Of/PXnwKTkmjQj/O0eIw5/nomtk7jZPVO5F/nAYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBWRKFzUt3tGppB4NDcIuL9qNmkqBDabBqKmqQSVh7ei3E3lXJk+A+yxcRGvLA/KG
	 8K9YyaUT3N1gXUxSCzDplijmzjczABGbBdMqKHforeUpkkJYgljjeNIrqqbayqFs3+
	 Z9BHakKveCPdJqXGXr20LoH2g/WEdPp7I7CEQQ28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 84/86] mptcp: pm: only set request_bkup flag when sending MP_PRIO
Date: Wed,  7 Aug 2024 17:01:03 +0200
Message-ID: <20240807150042.068153821@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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
@@ -481,7 +481,6 @@ static void __mptcp_pm_send_ack(struct m
 			msk->last_snd = NULL;
 
 		subflow->send_mp_prio = 1;
-		subflow->backup = backup;
 		subflow->request_bkup = backup;
 	}
 


