Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621967;
	b=fePic+wec00PbQPBaR899MUUeRDohmw1la3DUO93iIrZoc4pvRvIQtTb+YhvQXb/ax3Y
	 KtSPQhOvpGBlsZxK/0lbkC9F7AY5VOvhzEuE0bZQU3mmaTjAnsQ2sFFd4uW0eKR9V3IkY
	 9xKH5ljmoP5MUO/DQMhGIlzOD0Tc7pepBgYCt5Hf2skatmppb3ShDgoVtxjb9UJeCZG/K
	 I8vlr6oxFBQj/JiUSpX8AQn23+l9hFJYnSbFPJ2AEQp1HYOQREn6gBIizC6aF+Cp2ySx9
	 7Ib1/R6jpp6maieehUa1duw0LQ/NtswtxK7/vEEcGjdBnfatVm331cnmA+r4HS6bJGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XQpEky/6BBDAFu/PaUHn1S9bXujiaMMJo3WIfq9yTkU=;
	b=mbf6LjhbysGmY/ZMl9lweGyV1IWEGu/quhvFF5uoE7GnRJtthjZxNSFMrHN/eVx2z/cj
	 rognXoZRm6ZSoVXoj8waEyI4Vjo/AGlNNNmv4E08mrnzDFx25fON7wpnIoTEGoFu+hi2d
	 QZJPSnLpwY/8TnyhKM+v+haaW5O0L+V0hzP9Oof4NeU81ATaC5XJxoBhiZ2kLgt92pukN
	 yYL8TYrRxdJfH75tGRMH721hJ75tyKIBoxpt/gq7iKBgnVMBqT3Mr0rBG/h7aD8gKR5kK
	 MxdPzHccXXiCfco3ZUTXPxEmwJrCmgk+1hIAuMI1Yf6E0Igp/NQRemz+scMG3URvKCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VjS5SVxZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58796606A321;
	Wed, 25 Nov 2026 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VjS5SVxZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2342A1F000C4;
	Wed, 25 Nov 2026 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621966;
	bh=XQpEky/6BBDAFu/PaUHn1S9bXujiaMMJo3WIfq9yTkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjS5SVxZ4Fn9EHaH2W/oefwJHx25D08h1xMyAxzLhKCFa5Cub9Zw8D98YWy84vIem
	 tK0KCNNbGL4Qtl3PmfdeOcJ7INA8BypWF8XfKk0oN719fGGCzw6lggaJWrOzrc4bKu
	 2cRC3LcmAdYhUVUvTbbThz/bY21j5X+SIocg/Vlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 387/990] SUNRPC: preserve transport security policy when cloning clients
Date: Wed, 25 Nov 2026 15:29:14 +0100
Message-ID: <20261125143831.157121479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 7783534ce5fee57adf1b9025745c9af2e1ce2ccd ]

RPC client cloning does not copy the parent's transport security
policy into the new client. Clones consequently lose their TLS
policy and certificate/key serials, even though the shared
transport remains protected.

When NFSv4 migration replaces a cloned client's TLS transport, the
missing security policy causes xs_setup_tcp_tls() to return -EACCES.

Copy the parent's cl_xprtsec into the clone arguments before
creating the new client.

Fixes: 500053191297 ("SUNRPC: Plumb an API for setting transport layer security")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index a234c9fedbdfd..30c996750bd4b 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -653,6 +653,7 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	}
 	args->servername = xprt->servername;
 	args->nodename = clnt->cl_nodename;
+	args->xprtsec = clnt->cl_xprtsec;
 	if (!args->timeout)
 		args->timeout = clnt->cl_timeout;
 
-- 
2.53.0



