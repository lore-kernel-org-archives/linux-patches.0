Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064340;
	b=RLT4yuLjKXJJ4QpslD3UWajBrHO961DfO63Pu4IcXhXdooAHuz3w4TLRtwh87ftnengi
	 ORQ0AVM/I4UxAUmai960JXskTcfgI0WnqEowIc3cngTJmfP9TES5tLsmefOAxkNtMyX9z
	 0oDzMHzK1nOLZjkZIlsWBCQpXetS5IgKpD4WxuDeriHStgXbf4JECGvRgyz9tZBwCoeo+
	 NgUN2rc6sV3h7gzSYSYzUYPvuvpWaVj2LlVQLBNbJHzosD4Qr9en0TBA+zQ1ujh0mKahp
	 QwfC7D8lhV3Vihsr52StJxjkdeVLunfCSrpcf5zNK35oAqjLWYT1d6r1Gbr8tPW7/ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DS420GZDOM7X7KBR6yfc0sLakE1njJPgsE1Pj3ZJodE=;
	b=NPMuoHa+8XUibJNJC/T2S3xYCi3h43O/E2NbN2t8PfYTUtAS8Hz0iF3zJjqYX+NO0ODF
	 mpbc+cdjdhLTEKtDT9npMIAcjuvuo0t+BstqQM07dQhK392y/9p2yyB4k2fzopbpjKSbA
	 A9AGhEvU3tT2gwIY0FJI1ldguD4bjM28N9RCYXcNe2JyV1XP97IHP7/aSyDXmZWQqOGMo
	 pxb4blzyDbxPx1cd4JhVcSKSiBrkVep+Hq2qT+jwkAXMLebtOFnDMVgB7WcoTTva6pB69
	 qvykLHRRB0qyIfKaevdIgkboK2ZwfeKLRbFvMJ9ZgIPtfuCzxMEIhfA2jHkpRTLgH+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCzVMcC1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10196606A33A;
	Sat,  7 Nov 2026 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCzVMcC1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13481F0089F;
	Sat,  7 Nov 2026 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064339;
	bh=DS420GZDOM7X7KBR6yfc0sLakE1njJPgsE1Pj3ZJodE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCzVMcC1R50kfe3wjqqw4lnR5X8pdifoTSqv3O4UxZTYDPrXVhsaN1yfSIGLQ5Rgt
	 rhHEC6mswPXTbKllOIfw1J8LP2Jb2SEEkydVOBbVrHqfkekZXsauzAh03sPnRfFmsC
	 e1hTd220lSE/9kk8KsWd0PRSZVZMWaU1tPtuwhDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0376/1257] pseries/plpks: fix error handling in plpks_read_var()
Date: Sat,  7 Nov 2026 08:44:32 -0500
Message-ID: <20261107134949.937623476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit d52a1659cb1718f93166ab8dd8621237e564a1c4 ]

When a PLPKS variable is initialized without a policy and used to read an
object with the PLPKS_WRAPPINGKEY policy set, the hypervisor returns
H_AUTHORITY along with the object's policy. However, plpks_read_var()
currently treats this the same as any other H_AUTHORITY failure and returns
an error without propagating the policy information to the caller.

Distinguish this case from other H_AUTHORITY failures and propagate the
returned policy to the caller while preserving the authorization error.
Remove the explicit assignment of zero to rc on H_SUCCESS, as it is
redundant.

Also validate the PLPKS variable pointer before dereferencing it.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-2-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 23e4e2a922fcf..7e56b3dcacbc7 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -822,6 +822,9 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 	u8 *output;
 	int rc;
 
+	if (!var)
+		return -EINVAL;
+
 	if (var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
@@ -856,22 +859,21 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 				 virt_to_phys(var->name), var->namelen, virt_to_phys(output),
 				 maxobjsize);
 
-
 	if (rc != H_SUCCESS) {
 		rc = pseries_status_to_err(rc);
-		goto out_free_output;
+		if (rc != -EPERM || !retbuf[1])
+			goto out_free_output;
+		goto out_copy_policy;
 	}
 
 	if (!var->data || var->datalen > retbuf[0])
 		var->datalen = retbuf[0];
 
-	var->policy = retbuf[1];
-
 	if (var->data)
 		memcpy(var->data, output, var->datalen);
 
-	rc = 0;
-
+out_copy_policy:
+	var->policy = retbuf[1];
 out_free_output:
 	kfree(output);
 out_free_label:
-- 
2.53.0



