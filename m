Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063052;
	b=B4dJfgibRS50v8HWehjCilbwKRt7Wniqbpn+nixkrji5Isze6q02WWmLtJGorTDH4b25
	 /jS+aMwCZUWUv6Mz1OAYpX4IANewpUXNMyDUzc+OohnK8fl0yMgLyjEemlzhBUfq2lCbc
	 5p98BP9wvBFoMUmSTymQW2U2c7HYNAlFHPjYTfejb4KmlN6KQnjF8jF4Io9G8RBRPdX74
	 i4OJ950+nTMaO0Xtrt9rw7xT4rzYJAsnya6Uc248U0kwaFCPzL7IlUf6jwCOBMv7ikZVi
	 PBrmrLIvYL/a0JejIHIKpy9gOaEcnfPFob1UoSWxXICnwE2kpZhGirAkCtq1QJcW3hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YDZx9BlEXe/84WmaxJliUzSY1pSVGzTVlndhchEPlEM=;
	b=j31TzZ9RxOvqYnDRCfXTCurENihYyPlVWalyFADV1sOW3z95odA84YLs8GZWTeE+PUT1
	 s/tBXsv/HDVo/nhT+IHfjRO126U56LgPvFcvlv7wi/1avODGCuZBIHwLMHB4JIIIEC4tc
	 yF7t/KDrvq0PlkrPr0Q48U2ERBF4t8YHYioAoKIiYl+cQ6vFAJPPWl/Um0c/un8iSLvfT
	 v02PhbSwRf5u8CN0bIn01gQEr5fXh1Om3UjwYVbgaEeVg2QNkRFi272iWMp9ejd2nHFS/
	 XycBTO5cFJ/XqLvcUJta+cImcOj6JoD1Oe5aRYWqj+4L1e3A3YEZG/zPCDqx9WgbAcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCAphJQr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD6F606A331;
	Sat,  7 Nov 2026 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCAphJQr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D021F0089F;
	Sat,  7 Nov 2026 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063051;
	bh=YDZx9BlEXe/84WmaxJliUzSY1pSVGzTVlndhchEPlEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCAphJQrOA65z2RFw6tLqwET9aGplLH5IhcWv8zjpwqtL+gEJw1G37nxYAQ6z96I/
	 C0sOwZ3veX1WfkU/AWaO0NOgTlmfryYIX8q62itOCjIDcTQdC2P40JirdSErrd++j2
	 tmlPRhAp0kJxfDApi7s/+255e8LaOP/rrafIfO2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 296/869] pseries/plpks: clear signed update authentication buffer
Date: Sat,  7 Nov 2026 08:49:38 -0500
Message-ID: <20261107134902.233700267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit 63de55024e7c85975f4410380323edb05b186d7c ]

The PLPKS signed update operation uses an authentication buffer that
contains a password. Freeing this buffer with kfree(), without wiping
the contents, can leave sensitive data in memory.

Use kfree_sensitive() to wipe the buffer when freeing it.

Fixes: 899d9b8fee66 ("powerpc/pseries: Implement signed update for PLPKS objects")
Cc: stable@vger.kernel.org # 6.3
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-7-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index dbfbf12bda3c0..719f7e513c5a4 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -479,7 +479,7 @@ int plpks_signed_update_var(struct plpks_var *var, u64 flags)
 
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
-- 
2.53.0



