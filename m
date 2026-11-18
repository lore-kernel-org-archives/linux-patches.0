Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045339;
	b=HZzlC6y8RNq30yG1BJnIup+sRgF4JsaTEdD3hjWBtez+rL7Wz1BcwEC40Xmf0qWytesj
	 QOtiTCl7S2iqwCyh5wqopO9Uifwmr9+EKdYm3iJXiN1HHe53CPbtf7GeuGI+VH6ZeBn3B
	 uHw0V/pG6wq5S8j5HXlxHKCLjmRxtxsXFhlNFTqm2lK0GSxNtnC0w+3SSdN2u3uKvOtl3
	 JvKxM7o3Y0CVcssLq+BwXGuzO/6X87+LA2V239e2p/waZJpDXSa6x1SW/achFxHvxyvwy
	 AuMJCR8UutGg4E5P++LQxOPBWLua+F55xh3epeZCV+3WV3B18gzXAO56t0siBiiHTag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Ofnqq1Gegb/Z8ylatdZmYUnWuWHA+IxDSF19xa4Uds=;
	b=roj2EbTmNx4UWnmaJUu9XJC584h+kgJUfkbU3eMAuD+8cCWvQtyJ9MhlhWD/Bbn9zkNR
	 rMrkH2SFrBimYxvWEtse+1X2g4uNDXxoE+OoSeclXVlh4X0zqly7Dk5ZVjUpXy5ECL7s1
	 wA7KQLSoiDsSz6yF8mUz/IpT1GV5j0ap8xnE+SqG8pw9nIDhAmLIuwugvTqrr3VxrKbsR
	 /0+oDe35hDwNgbuPsW27hB4vGb/OTt+jv8CHcG8aSrbXaZRJ6wrMqAOyG9Q6gyLkBaBU2
	 ua2q41TS41Oinw4CSQHVMjsq/pLBINV5l12xtdCcF4Y2mRVrUA2YSy4qPb1t4+LwNvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AY/MVNqx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFC760A2606;
	Wed, 18 Nov 2026 23:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AY/MVNqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EB81F000C4;
	Wed, 18 Nov 2026 23:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045339;
	bh=2Ofnqq1Gegb/Z8ylatdZmYUnWuWHA+IxDSF19xa4Uds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AY/MVNqxiL1dv8t10AV1B8GpNgEHNyX/QMU2OzlhuYO4VWeOsoBNq52Gb5xgvXM2i
	 2vqrIlGkR3M44zfKg9BY5xVeTRiythlQ5WTdJGDL3jdNjIHbiOW2z+SgjoX61SP107
	 J6RB9aXixZtPPpvbMGqV86OnJq1Opm4kiHULVyrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0841/2857] pseries/plpks: clear sensitive PLPKS buffers
Date: Wed, 18 Nov 2026 15:31:15 +0100
Message-ID: <20261118150231.856741748@linuxfoundation.org>
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

[ Upstream commit fe18716ff314eb32299048fd64242d31b4e852cf ]

PLPKS read, remove, and write operations use authentication buffers that
contain passwords. The read output buffer may also contain sensitive data.
Freeing these buffers with kfree(), without wiping the contents, can leave
sensitive data in memory.

Use kfree_sensitive() to wipe the buffers when freeing them.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-5-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index d1eb6f0433fe7..00137d6a303cd 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -438,7 +438,7 @@ int plpks_write_var(struct plpks_var var)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -476,7 +476,7 @@ int plpks_remove_var(char *component, u8 varos, struct plpks_var_name vname)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -542,11 +542,11 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 	rc = 0;
 
 out_free_output:
-	kfree(output);
+	kfree_sensitive(output);
 out_free_label:
 	kfree(label);
 out_free_auth:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
-- 
2.53.0



