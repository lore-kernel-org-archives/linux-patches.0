Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036179;
	b=okdGxdoAwsyKtLkSNfKBDqNZuYm7UcGKbes6/q9Nh/KNnKbWsfBFZYWNjW+UGsSaFPw6
	 c8nRCSyuXuun/LtkIoA2SYhbnBEZMZkpCQa5BRZTf5h8YmZj+TISUpgVoxpottZYWyliX
	 WpggJFARTSf23clzxAdRgVz3/Ig4PPls043qQXxO7M7Vid0OM3tH9C5PiR8pwxac+eDpS
	 8HQs/lP4XJ99xuQiKsyBwXm2WTpe3zzLHCMTm1qZ3fkypKI/FtiIDRaXAP0WmjW1syqHV
	 aJrQA2fuZ+NQ7latxtrfEbyJSDbmG3iTmVE8nSeA+yOy2LIj4XeYoVMigueXhccDidQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l/8HSIFxYK/aq8eFrHz7tc/ayUijo3RbJw/ga3Srqh4=;
	b=mgja9NsZyjRPLbTQOP3laeLrkJYjLnwKNP4OE1S9/GqxgXORn3W765svADyd2NOLG7QD
	 Fo1f3dgXYk7f55PjOJ66qj1LM2Bv9puIEH5L8WuuS4mX+ybmUXGcn3MLQI33j5/Iw+X3O
	 EWwm4e3KeOEz/U9dn9/F8810EymlvdMuyPx+KvYbYoiw6QxQMzVLUF53wtRof6QafoenF
	 CdxzpEEwtK0AvEeCplHSP8eeWHYGWhvpN4XnIHDEMF9GRHAZCIqqk8PharSjnrQ9j5hCk
	 MfBlbm4nXlg/LrRBqs6xE5BfRvY+OQPsszpxh4jsVDerPCfrl/AvNHLwejGio3WDreQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bk1fy+9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3160A2607;
	Wed, 18 Nov 2026 21:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bk1fy+9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F77B1F000C7;
	Wed, 18 Nov 2026 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036178;
	bh=l/8HSIFxYK/aq8eFrHz7tc/ayUijo3RbJw/ga3Srqh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bk1fy+9GSYP4SwI7seYPXMHQqXZbWLq1ocOOBE2Vm1/L54LnqS/9F4OZO94kx+GTU
	 A+49Q/RktBLuyqxJ1IaixG8RBC0nllmxoxyuDBKpLI1Nh53ZtggEjgLRnHXwQoRrt4
	 VfCih7os28YgfpSbdMEKWWHcYjLFyP6ra2tWVSHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0965/3318] pseries/plpks: fix error handling in plpks_read_var()
Date: Wed, 18 Nov 2026 15:26:27 +0100
Message-ID: <20261118150348.611447651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fe7a43a8a1f46..9a5e2871daef2 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -562,6 +562,9 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 	u8 *output;
 	int rc;
 
+	if (!var)
+		return -EINVAL;
+
 	if (var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
@@ -593,22 +596,21 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
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



