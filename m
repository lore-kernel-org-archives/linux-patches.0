Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047445;
	b=F+ZSgWQd3nkRTBGV21SaUfUzaFPWbO16XZxUQxz4NzcD1GIMO79wul6V3Spjlp7b0JPy
	 G5KQZZsP8JgF1xWO41iSWNymshVeC3DttFg+FZQTxTFCnz/wcajQ9nKoGhPLlHt6eaJEP
	 JeXufPs1LknQhTOY7YPYBObIs1AiX0f3OhiunaUDe2DozFxO0p1AYbTs9e+ZLAGoflEep
	 2HcZ9FzvJbhOj1mNL89D5TngwQjPnhP4dDBP/jh/l3xvMz9Pm0pBpyMOXDOYSUjMYHoeZ
	 EH6XUA00P9aeHaRSgTXpn2Bc7Os/7YGkOtZEaC2Jg+DgUmJF9Uli+egl8rF0DrIHorg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+hqUcBjuZsXUk0eV27N5oG7M7oBvMgje+32aEEsdPE=;
	b=lkSP+Lk4l3WyxouW4eKWL57f33Hn4lgN0Dn2ljwK2/BgS7SHvy8PcNemM/moZ+WrBC19
	 2H1BNCSd8MU8z+l83tXPW6qhWYK2DFdl8bd1V7kt7XtKhaxJ8H3UFvSGQ1cX+sUWKiJkp
	 +T4q4yYg+RucddqR3sHzdyH8ZM2XMvQ7YwgWWZGJGeydAcd2MTDF8GY3YMmlxS/tyCfOR
	 jrptOOnP0anNc2/OnBntKe3Pr72c/GTpulum6TVwRfg+6CcGh0eDzdXgZnxP7GskaNptj
	 O1P9v0qIOh+EQPAxgHk3JNczerXFlmVRf/B1BQeNbyGW94pgv0IhWslcY+P9X8MJUNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2pJttT3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BAF606A320;
	Thu, 19 Nov 2026 00:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2pJttT3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825451F000C4;
	Thu, 19 Nov 2026 00:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047445;
	bh=H+hqUcBjuZsXUk0eV27N5oG7M7oBvMgje+32aEEsdPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2pJttT3YgIgAdejHVV1G4O0HlAa8Fvqw65awo9y1tpfLnFgLnh3F5kKemgN2MOZe
	 3y8zQ9/HlDrt6KvJjVnbEG8xDa+2QK6UfLOGMtqYfrq24TXhpvaJlL6DGsljKwNVpW
	 YrKpo7RdmzgIiziOoNmchKza3D0A8fcHkZs/tux0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1600/2857] pseries/plpks: fix error handling in plpks_read_var()
Date: Wed, 18 Nov 2026 15:43:54 +0100
Message-ID: <20261118150258.983569887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index b66a980478fec..b15e841b19791 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -489,6 +489,9 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 	u8 *output;
 	int rc;
 
+	if (!var)
+		return -EINVAL;
+
 	if (var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
@@ -520,24 +523,23 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 				 virt_to_phys(var->name), var->namelen, virt_to_phys(output),
 				 maxobjsize);
 
-
 	if (rc != H_SUCCESS) {
 		pr_err("Failed to read variable %s for component %s with error %d\n",
 		       var->name, var->component, rc);
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
 	kfree_sensitive(output);
 out_free_label:
-- 
2.53.0



