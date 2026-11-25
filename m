Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618940;
	b=AfLA6x9x16MOdPVSbBWAcObAZ9rdoGkZC3jIgMKAL/Nbnk9MLpR+15MtRzK7JwX4pIZ/
	 1/NVdSX1/KrQHbS6m3uuqVn8/9SVV+9FfxRlskazIhlyCPt03FHJWSHd5KdjSVj9+iDD7
	 dKnkImtLsBGa7AclBFVHuZTopJhLw2JXAEyqep4OBCwsQXgHD0BCOxagA7kiVLDTyyL7N
	 N6iI/NWTxB8/JxO31xeoCzty24h8JrN+EwREzOhbNCC9/KPwPp/EkgK7Sff9g78iZfTju
	 4btZBoMz6oVgunwe5Pnn6tEBmX4j/dUOKyX4VskHASRh93pRDIE90JDCLGtDmk9nDRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=59Mb5DS0su73XUSJU2uRYB49joVm3VyJ/20gQe21INY=;
	b=eCSCPp3TRVIxg0bagSlc6VRDCA1l7FfCDk+X6dE4O/AKsWKI25K5Sg9NHzt8QsJCm4Yi
	 QrKvnYPv8p+uM7oouska7ej9hgseciyWpWcXe53geijLczYaCKy1k955Uqr+b6T5wVcfR
	 vSyAy+GUEvx+2GwpWa3leg8n2UA6CwOescuxusWlu4k/PH9KfFqlVMoxLFM2dLBPucoLD
	 J43L4BT2TMKQNDp7e0U4YvqqSfTDF0pGGE5Ko3nDyu2Kr1AFwLf/ZDTK3HIA4KgmDL0QW
	 Xi7eLG0Wt+hMK8okBVx/iWuUhYloBDn1Uh4pVfQSFGvl2ZiIXaAVtohaU6D62eOsI8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qeJHeS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1712606A31E;
	Wed, 25 Nov 2026 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qeJHeS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E24B1F000C4;
	Wed, 25 Nov 2026 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618940;
	bh=59Mb5DS0su73XUSJU2uRYB49joVm3VyJ/20gQe21INY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qeJHeS40Xf3BYa/qaYFM5r2zV0IRYQsjVUzpklsbI3Qz/xsmvkO03voNBfQKE05K
	 mQx1+whrlHXtWo1QWlHJC6fllWo6/+hfjeoQD45FwJ492z9XYbnxrETv/wszI4Wvtg
	 ZMr/nD5So5tm/Pu9wDXBNoftfVxSgGrJ7AlrIvtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0436/1005] SUNRPC: preserve transport security policy when cloning clients
Date: Wed, 25 Nov 2026 15:29:34 +0100
Message-ID: <20261125143831.965329680@linuxfoundation.org>
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
index 3d9d7c930f352..ba6fdd70414db 100644
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



