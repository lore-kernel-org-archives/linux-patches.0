Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058853;
	b=j3g4Ce+vgIBbx3FaebEF/FRw5fu/iDI0tukJCZ/yvWxZ9qy61O23OG2b4X3QCNnNdQiM
	 XGWUcTETwKSs51+S1d7+cs0EkQ04Lb3FyDFcoNW6nt/hqduDNTQZGugmPn0YfPHVYgxg1
	 E6tbEyRh+9yVmfsa8gc5+TS4wSoM4uvuk5n+druU8TrIEzkVay9bVVzGSLrDOr4U63Pqn
	 yK75LxCpHk5M6gx3vI0bIUu7jiIXgfRITgg40qJuwgJYUHPJ1x9H3ax5bj3LDTm0/4ZrP
	 dy/7zsqrPsbZOCE9LJg1v/D8zKVg1pemyadAxwv4iKOaW9dEGdNStINrzRrvbmXswdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bg0Pm9wnxC/lcaoj2N6ARstFkkycTNq2PkuRvwwzXXE=;
	b=Yfg239Wq4/tzd4uJWT8Kda3+MsyRd+lZFpsolKldFtXurG1PR2YByO4os/WfIdtjmLX3
	 yaKwX3j2KVFAkf07epLW/4sos5wV8JELqKHjWSM2jjDGSQyoSMGWBbeDROmhS06AdJfG/
	 zTn4/wNul5GvVmmZ2QLJVEDmszoCcohvf+PI0P63BFIjjCAcZtwMSj+7cRswLTC92tVar
	 7S3PNMFdMcUEQ21R6bwhoTBFjMoDAeHptygIdfM11ZLtK6u2nL3HMZzexgGcoE5kCVJ2U
	 cXpe9zh/ggQuqLnlNUrRmEwUCkRt0engNaUkpKNmdLb1xgEPNLqilVH6CeoidI7mawQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PthIWe7E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0475606A32F;
	Thu, 19 Nov 2026 03:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PthIWe7E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE491F000C4;
	Thu, 19 Nov 2026 03:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058852;
	bh=bg0Pm9wnxC/lcaoj2N6ARstFkkycTNq2PkuRvwwzXXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PthIWe7ET/2cQdVm3Ou8z0q05qS5UuwKZOuk8Oi6ELHDSsHzIjEkBgbARsKB7vkDK
	 6I6kJpk5ghpRS0FUyDAeNBUDwtVnTaEdp0OuK3aIpFe+f33jUyGeB/1I/gj8otmvvP
	 V9KG2DC10euVAhUatj+5MRnXeVBlFN5PLGuCoH+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0635/1848] SUNRPC: trace an accepted transport before publishing it
Date: Wed, 18 Nov 2026 15:44:33 +0100
Message-ID: <20261118145942.266320570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 06f90cf104fc21ee01e7ef1eb80e092173089b9f ]

svc_handle_xprt() publishes a newly accepted transport before tracing
it. svc_add_new_temp_xprt() places the transport on sv_tempsocks and
clears XPT_BUSY, so another nfsd thread can dequeue it at once. If the
peer has already closed the connection, that thread runs
svc_delete_xprt(), which drops the list reference, the only reference
the new transport holds. trace_svc_xprt_accept() then reads the
transport's addresses and network namespace from freed memory.

Before publication the accepting thread owns the transport
exclusively: XPT_BUSY is still set from svc_xprt_init() and the
transport is on no list. Emit the tracepoint there.

Fixes: 11bbb0f76e99 ("SUNRPC: Trace a few more generic svc_xprt events")
Cc: stable@vger.kernel.org
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/d15495bff2247e3f9d4f9ef36df8e246a3898380.1789220778.git.zhilinz@nebusec.ai
[ cel: trace before publication instead of taking an extra reference ]
Signed-off-by: Chuck Lever <cel@kernel.org>
[ sashal: Adjusted context to preserve the existing unbraced else clause. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 60782504ad3e7..db1f565cc8ec0 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -811,8 +811,8 @@ static int svc_handle_xprt(struct svc_rqst *rqstp, struct svc_xprt *xprt)
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
 			newxpt->xpt_cred = get_cred(xprt->xpt_cred);
-			svc_add_new_temp_xprt(serv, newxpt);
 			trace_svc_xprt_accept(newxpt, serv->sv_name);
+			svc_add_new_temp_xprt(serv, newxpt);
 		} else
 			module_put(xprt->xpt_class->xcl_owner);
 	} else if (svc_xprt_reserve_slot(rqstp, xprt)) {
-- 
2.53.0



