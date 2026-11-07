Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063050;
	b=rXbnDqJvhFSf26mn+HxDNB3MEn5eCVk38TPzYEZ3Gw1O4ROwNZuyBBT5Dr5+sVXlcoZA
	 OHznITz/zArV/FhOcYSJhyjUGbPsP6dX4PSUI5RHLwdCjW1ktmDvFbdOOW52Y1+ZdooYt
	 pJhBlmfk2+bpDfoDhfubTPJgASnQzBosNQBYCK9YkP0XLu4ED7GBVtnMTWEI2WUse+Crd
	 Tl8mg2sSFlRJ1DtPIF6DHGE9wOTRgKqBp2r0Gitw4M+dpL7AlsRs/+2sHcI8bjv0by5Cl
	 AmyTPRL+dfrGtWmbn2oy5bH3WTKL6rFemCsC3rgFXfc2pkqJHxfeBbzK/AOA4Xpg86Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2jKhIgadepFLKVYEN5Z79KnGD2X35jcqUxgwWAqfKfI=;
	b=1pM94HhfV4Yr1uANK6WLJOym4SGEa1TBNb9zZq0CYXUnrDj2FmNzVzgeiTgDkhlcb2ZA
	 vlwVO9GTR8UDo0RAJOy0PHCp7E+OwXgqQIrClAsuvU7UI74kcZ4C6A9+Om3gdR0FjVch6
	 degLm7a1V7vuDs4KvsyUQq0JpV7fg4R4oRVqqdgaFOSbHZYbYF33sb+MDNEvUSnbCSeqA
	 3zsTTSzlVJPa/0QKLBVMSTcJaD0d1cfdEskyzYMdAcjAVcLEpYOOVYE9+3pZ7jzuJcC3O
	 p/e6YmwS00jr9DiJq5gcHYpVeT1hnzFyyNprP6HPhF7760lGYcl2u6h1Cio0Oihib5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTd1D0JC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7579E606D808;
	Sat,  7 Nov 2026 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LTd1D0JC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235401F0089F;
	Sat,  7 Nov 2026 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063050;
	bh=2jKhIgadepFLKVYEN5Z79KnGD2X35jcqUxgwWAqfKfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTd1D0JCxliHyEb2P6j1GJRKc1ufm8pGrQfC6FsoyMxGyrQAK5ClQqC1Qr7ez5LmG
	 kHA2s3BikulVpg3Wywgf68o4woEmeMJZAniVHoB5A/WZawCfc1hXt5TmIc/wxWSK9X
	 tx81rxtJIOGv23UCmVuFg4OBdug3cxKQmsu1XDoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 295/869] pseries/plpks: clear sensitive PLPKS buffers
Date: Sat,  7 Nov 2026 08:49:37 -0500
Message-ID: <20261107134902.124099476@linuxfoundation.org>
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
index 3686d66277262..dbfbf12bda3c0 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -518,7 +518,7 @@ int plpks_write_var(struct plpks_var var)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -552,7 +552,7 @@ int plpks_remove_var(char *component, u8 varos, struct plpks_var_name vname)
 	rc = pseries_status_to_err(rc);
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 
 	return rc;
 }
@@ -615,11 +615,11 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
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



