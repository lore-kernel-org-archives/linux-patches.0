Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064316;
	b=T2bIKwLZZSoLtxZpJBfYsLMwHzXRMd1oSsFq62uvesV4fH1HLB8tSjZF8iliVcLUx2Mq
	 aka7x5EygS56yEo8vZvGMYEePPPJwPKEMszuS1SKBjltj1xGObrv8ekbLqYRc360JM2A5
	 mxVTlsnlSrLZmFvWBaxiy7UKFRIXVAOHHhk+elh20YByPjf8dEFwp00voMdsjz3LPAMpf
	 br/n4riLhonj0f3/enCzlpMbaT9qoiketrm2kk+LmLBk0SCf4CYXgOILZc/fW9errb6cC
	 Btt1xNzRpEOmLUVRO+0yMsSlmAtJBiEv1/UvUygRgdEyXzq44lH62RfhZ2wjRGMabjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=69BhrXdiIt5DxP7Xijg+VNmYM8j1ntVfK9uqxiVyOTk=;
	b=4ofn1RUt554/pubxRVO/Ufi7gtLkKlAPC7hx9PhOa29UamP64YyZJcpNYoSNEYeNYHXL
	 8rTjIz5uxAKaUNRqm4UJo3YnAxk7KMMaceuNscPO0TmAyp3cgUgSA/JeO2x85TjCJOw9/
	 npQjQ4M832IE+7xgPGP5kuwFuuwAXAMIuWPE7AlqDYSHInlSZVxmqXyaY7VKvBu9GAudz
	 RUdP42OkCxV6Qk/UtWCNzoqq6FlN+xczCLi92cLQRiSJLb7cElrT9EMZaXzWp9d6TI7xO
	 XjgNoBZx36jAjlQdmi9wyghXYE8GFMUkUQ+pQjPiXGdim/VgzM3qPDdTKj2747vW0qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHDe8a4F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1737606A9FF;
	Sat,  7 Nov 2026 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHDe8a4F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBCF1F0089F;
	Sat,  7 Nov 2026 15:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064316;
	bh=69BhrXdiIt5DxP7Xijg+VNmYM8j1ntVfK9uqxiVyOTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHDe8a4FI6F7xe8tjesbAEQgcLqnCI8Suc8ePCkx03Nqj6VOe3ymfs00i9y+E01XX
	 3HQijQc/Gzd9KkzMAjk4/QlvIqWDCUx7peSh9SuoQSchwWqVjD8yJjir8RMVZpNZZ4
	 BsxkvHTI6nPES4itBL8vYv67M6Vq9UIDZb9SCe6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0379/1257] pseries/plpks: clear sensitive PLPKS buffers
Date: Sat,  7 Nov 2026 08:44:35 -0500
Message-ID: <20261107134950.016818189@linuxfoundation.org>
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
index e3ae2cd78247a..8dbf85e9714c2 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -754,7 +754,7 @@ int plpks_write_var(struct plpks_var var)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -812,7 +812,7 @@ int plpks_remove_var(char *component, u8 varos, struct plpks_var_name vname)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -878,11 +878,11 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 out_copy_policy:
 	var->policy = retbuf[1];
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



