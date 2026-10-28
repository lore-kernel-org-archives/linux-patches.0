Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212999;
	b=CXiKxReFLz0Xa4FpaFzoS0iKHz+3twPjZ5sFblTyjkKA6P5u65oY5b8F8Wqw5QczbwbL
	 vzXdbIqKUuKFvGffB2c7eJJrv97fS1sTSUsRIwcBfXaeAKBrqCWCU541Lm8MdfaldWuiX
	 Q/MJ/5k4l/7pdIOxozI7jI7F/ySGiLSbGcArYxuNMwgQncdJp4YSXFRTrDUDJyPGe3lI1
	 Dcty+NI7wYjsqZvgAYBm+Rt3JJmxxLHVXGhPWn2jowa8UIrSe16ODdkktru+7rBJ/NVpr
	 8ElZ7vRObSVaSghSQk762y7bwvMzTr6DAvgrG9myNSMceqSmKEsJp0YIfiM1+ZbBX7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oDG2MaDmM49cdYsOvPLuduS/R3e2Uqtx74lo74Tbp1A=;
	b=sCRFMMLPxFFhzm3StnD8QUwEtIzwkGCqJf6vWKl0OLS7rqGlVOgJtoPJYQvpZbQBVt0s
	 0+hZu84aCyTFCZuTZMBzTeAgGpir7q8CAS1IU6AVRDzkGUausdd0Y1X+7VqH1IvXj1geo
	 va3hdyVH0XQbr7F4x3OSzqWHRGStYNg0yR/oWZ/xJsXn31WqevrIrFRxkpaHB7MMnodhZ
	 2LVDewumvVMaO8su2jbvRNZnvrcOxwc+xWcywi2FGW8I6aZ8egRTGuJQCVxZgIdKVj1/s
	 xfaRC35SgUd9V1ROjEAuPPafefYTWwxWAS6k1zt1CoUzTQ5vKmiTCXB4p7JruS3IC/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMwQljuj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363D8606A31C;
	Wed, 28 Oct 2026 18:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMwQljuj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AA21F01825;
	Wed, 28 Oct 2026 18:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212999;
	bh=oDG2MaDmM49cdYsOvPLuduS/R3e2Uqtx74lo74Tbp1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMwQljuj3xdesEwrnu21NKU+Np4DxQ0OALr1kjkEulCums5BYKXcEA7nQjTAdc2QE
	 42F6pM5ao79H2VqdTAC6UgFSVI+9GMoXZPQbWnTCSvSBl5oAGLXnbAzZzReLt3AKJ4
	 85Fh26tcycg7/mot0bcjxb41Asmw3K3pm3LGEAuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0352/1887] SUNRPC: reject duplicate CREDS_VALUE options
Date: Wed, 28 Oct 2026 17:40:48 +0100
Message-ID: <20261028170507.239534136@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

[ Upstream commit 2e4ce62385c1b8a887c5370af058ac7b52a8eaf9 ]

gssx_dec_option_array() walks the wire-supplied option array and, for
every entry whose name matches CREDS_VALUE, calls
gssx_dec_linux_creds() on the same struct svc_cred. That helper
unconditionally installs a fresh groups_alloc() result into
creds->cr_group_info without releasing whatever pointer was already
there:

    for (i = 0; i < count; i++) {
        ... decode name ...
        if (length == sizeof(CREDS_VALUE) &&
            memcmp(p, CREDS_VALUE, sizeof(CREDS_VALUE)) == 0) {
            err = gssx_dec_linux_creds(xdr, creds);
            ...
        }
    }

A reply that carries two CREDS_VALUE entries therefore overwrites
cr_group_info on the second iteration and orphans the group_info
allocated by the first call. The earlier free_creds path only
releases the last cr_group_info via free_svc_cred(), so the first
allocation's refcount stays at one and its kvmalloc-backed storage
is leaked. No in-tree caller of gssp_accept_sec_context_upcall()
expects more than one CREDS_VALUE per reply.

Fix by tracking whether a CREDS_VALUE option has already been
decoded and returning -EINVAL on any subsequent match, so the
free_creds path releases the single group_info that was installed.

Fixes: 1d658336b05f ("SUNRPC: Add RPC based upcall mechanism for RPCGSS auth")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-tier2-v1-3-d026a1415e0b@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_rpc_xdr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sunrpc/auth_gss/gss_rpc_xdr.c b/net/sunrpc/auth_gss/gss_rpc_xdr.c
index ac9ae42a69762..967943ae61c62 100644
--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
+++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -231,6 +231,7 @@ static int gssx_dec_option_array(struct xdr_stream *xdr,
 				 struct gssx_option_array *oa)
 {
 	struct svc_cred *creds;
+	bool creds_decoded = false;
 	u32 count, i;
 	__be32 *p;
 	int err;
@@ -281,9 +282,14 @@ static int gssx_dec_option_array(struct xdr_stream *xdr,
 		if (length == sizeof(CREDS_VALUE) &&
 		    memcmp(p, CREDS_VALUE, sizeof(CREDS_VALUE)) == 0) {
 			/* We have creds here. parse them */
+			if (creds_decoded) {
+				err = -EINVAL;
+				goto free_creds;
+			}
 			err = gssx_dec_linux_creds(xdr, creds);
 			if (err)
 				goto free_creds;
+			creds_decoded = true;
 			oa->data[0].value.len = 1; /* presence */
 		} else {
 			/* consume uninteresting buffer */
-- 
2.53.0



