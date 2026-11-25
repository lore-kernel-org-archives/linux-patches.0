Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618938;
	b=omxaRFV/EQ75pyiQhKdlXi8jeMdj6P7O82r202IBnDwvI45SjL8LMJo6xgKvPGoafTI8
	 Ph2CTx4N26soPtw8Usuc7cnJPZ9fae9MExtih7LMzrWsgbmPmC1sFDtFOXR/jTB9hPMET
	 m2TEUiDw3FvuTR/QbsjLP//tneJYs2h3w1qen7fqUM6KogWbIszFl/MEN2voTB189dbjf
	 smQXIUjJg5INzAOrCVWFpNQyMmxgSdEK+i4buKox52kIEIVYVrR+WJDhHI1iDayAfQ7l/
	 jcXxa0sW60KXPkdNtaPMQVlEuxZHCEBRncrDmVVnbOuaMZRmLib3AOR6DrCg0B9VRhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/eDcZI5ttOe0XHN5L1wW8BA5EgIb8ZGOteat0fZifhg=;
	b=KG1qJLIJhacF+bSO/O74tp3r9xN0klB/SLKt24+VICwxJlBic30k0+0JxnoCxFlb0qvP
	 ojSc7rFTquKsDlNttlJUc7c/bd/mTSnaTNs7RsC0Ss/BCBd+1IUp/fJ2tfc5mrZ+NGWeQ
	 4jsNgLaP5r8cvY10aQiFz6jZh3zQke739DjYRQWkmtG/qkRjuKJS1N8X8Hhv0wlpRuuz7
	 SEXM2WvLLg3iSbOKBlnrkSkwcJcd1T2KcgScs+DGlt4+BmHvP66A6/JqFYi5pTwWTWEi7
	 2Qnp6HCSk9FM8rvCRK3M4vamP41cK/B/c6lc1oq2PnuhvXzHV+s+q4HZ25ybh2XbcdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSeNmJL1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12B3606A31E;
	Wed, 25 Nov 2026 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSeNmJL1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23171F000C0;
	Wed, 25 Nov 2026 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618937;
	bh=/eDcZI5ttOe0XHN5L1wW8BA5EgIb8ZGOteat0fZifhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSeNmJL1OteI8WQHS0e5XImzjif6meTjZxYg5S58vKQUjrbld9UxaUzrSsyhZmBx9
	 rLctXcblQ0eg05FcC7Fg4dX4PodinqP7hx695IfqGzbM6+ZsQrakosZiji+ReIVnEN
	 2Nh3xj7uKIvBjVtNsPIulQbhMqAnF9GL9MYjiSLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0435/1005] SUNRPC: preserve timeout policy when cloning clients
Date: Wed, 25 Nov 2026 15:29:33 +0100
Message-ID: <20261125143831.941738034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 5b0ac1f82201c2ab2d9c31ed568cc782bac6a399 ]

rpc_clone_client() and rpc_clone_client_set_auth() leave the
timeout argument unset, causing rpc_new_client() to use the
transport defaults instead of the parent's configured
timeout. This also affects pNFS data-server clients and
changes their request timeout and initial RTT calculations.

Use the parent's cl_timeout when no timeout is specified.
Preserve explicitly supplied timeout overrides.

Fixes: 1b63a75180c6 ("SUNRPC: Refactor rpc_clone_client()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 73f8469767d32..3d9d7c930f352 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -653,6 +653,8 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	}
 	args->servername = xprt->servername;
 	args->nodename = clnt->cl_nodename;
+	if (!args->timeout)
+		args->timeout = clnt->cl_timeout;
 
 	new = rpc_new_client(args, xps, xprt, clnt);
 	if (IS_ERR(new))
-- 
2.53.0



