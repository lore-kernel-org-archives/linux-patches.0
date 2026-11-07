Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062143;
	b=fFt4jkLw7/BDdXWNQLoLRNbOjBcBjsZcZRlbF8zjR7YOuoE10xZH7yss3T9j/tT3rPbY
	 87Woa0nebADB1NIxuJp6hQsYnGolU6cg5UTcJ2dc6i3m6Xduuo7W+JM2Sm07HDPcPZbnz
	 JR7BEYo7oHr5e8XbNpDW7f5c65MTdSNflBnlvWhi+/M+orRBMiudFLZnl6MDPxPcRLz/H
	 qZ5nUG6EWgWYanZzg6VHl3fenR4Zvdz5PoWrsS5K6LBk8ytNR/m8Dxzc1dcTf/1cLkTRX
	 sCphYutHO2OA5jhu4pooqUJPQwGtQR+Au81ngcEnzZ4gkFH0xJFr7ApVHEmfGUdJ9UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6s2lDvxeiAEF5u0QjzaEAcHSnbSdsQy57q+WKGrM6vg=;
	b=AdIoOZGmz/mOb7vEDq0LgLyEf7y+pyVaHv26CjbGPsg94pX25yKS0XVmukjRMqP4Zteh
	 a/qzIa/0JS3g9jl7fOtj9e7Kchjb3gRkIJciHsr2Jbm9RTVDqT3gz3oGCLAuhUVYm8XSB
	 bVi6luRngU1X9eDxyuARC91pKguFL5XznA2+HHlSAwgsvvK0Mxh5QdVNpyOncLa/1EP5s
	 Kk0FoLGo5rYgud8aktjAle2ZG66/bB7KKrCOnkb6OOEW7knH0feRIcPCjdritF/087ZqT
	 QnCBrSE1EUrZ8PaKGfbq4gMr03vnOKSnkfHdTSq0m7kINbFuITZck0a+JIauApG2QVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEUJ6XbP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C34606A653;
	Sat,  7 Nov 2026 14:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEUJ6XbP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266E61F008A1;
	Sat,  7 Nov 2026 14:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062143;
	bh=6s2lDvxeiAEF5u0QjzaEAcHSnbSdsQy57q+WKGrM6vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEUJ6XbP73uqh/Y2aCYkbJ0kS6souxpTJm3g0AcePOMv7JVD9Y/R+HIP65Te/nn8D
	 2bCPdw6AefC1zKr1DZ5PxZ83tU92XDw0Gz3vm5Bv3iucHvlWwk//pp/3iTNu7UeYW/
	 TnaaLnqdHb0s8BteK3NzRbYGo/KmFg8vj6rMMO3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1108/1536] pseries/plpks: clear signed update authentication buffer
Date: Sat,  7 Nov 2026 08:52:04 -0500
Message-ID: <20261107135028.822757839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



