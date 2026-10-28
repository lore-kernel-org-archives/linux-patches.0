Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208833;
	b=lfzR0m98fAuCoroNVK64GjNJ5LYWDjVx27dK5mgBaU5Nq5LeG37FZveFYJeQAnGWx/pD
	 o6t/nYIgLltYqrdIku98cX6tlE43drrPAIl8EdjdaoSF/tZp8WCdL17TGk1b04lM2BA4o
	 8eiejbjdVSrae98tEb25zzOle9ORbieUL27XrGaj+rjvh1zza5NXPKDMyJ56ldGDzrshO
	 zeRYCtgIU6F7tkl983vefVi5PTagB6fSgnBfou/vBAaLVsKrxZvbIYIH+dfHDHDEuUHvN
	 eIrKl6vPRa2NhvfJ1AdakhmWbYMoMeCrJbgOub5EsS+igqficph4JA0tFzLAAemtDuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Ew1wPi9TOqiOOOkc0r6DGHu/ZruQ2RWZ0CEBpUBIp8=;
	b=Xzi+SpHFt0I62Xx20R9pjyO4ZRcP6x2mQNSBDSOAYOmcaJiU6aURUR3FStg1RNSx2snQ
	 L+0CVuQJs7wG8CdYRA6zInSAd6wPwp+jYtBag5SB282oUVz2wQyU49AVN9zeriXKp8LVB
	 z3F9gYqSJNE/jMFA3oHrt0fddrcF8LUXuKxPXS2Apb3EVFhmtOGU1cangaOPRrmXFezFZ
	 bJsbDf2FNXlebu16zRcwVgBO0261DGW4pXJo/L+J38d7f4pcgH7pMMWyCuy60OCJyYy4P
	 ZUCfxNkvcxRoj/j90YRWa/CMHah1zOb05RbYm/A0PbSZVdD2KSC36IRTC5KkxKiBfNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVy3OBVz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1852C606A32E;
	Wed, 28 Oct 2026 17:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVy3OBVz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247941F031E0;
	Wed, 28 Oct 2026 17:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208832;
	bh=8Ew1wPi9TOqiOOOkc0r6DGHu/ZruQ2RWZ0CEBpUBIp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVy3OBVzT58hTidl8QcQGyRnLcuVt83fGWXMQ8bDet+kI15f7JEB0hNb99Du/XMOP
	 qtVhdvWbWnnk6oQKaHTZSfcsVU+VVonniNnAkN8KzaHj0kVUx2coQ2qHsfxlqikCbv
	 XA2QeCmoBgLo7F+X0p8S0HCgAfjszbIk4cWpzSD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Saenz Julienne <nsaenz@kernel.org>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Sasha Levin <sashal@kernel.org>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 258/516] staging: vchiq_arm: Avoid NULL ptr deref in vchiq_dump_platform_instances
Date: Wed, 28 Oct 2026 17:56:50 +0100
Message-ID: <20261028170009.603801872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Stefan Wahren <stefan.wahren@i2se.com>

commit aa899e686d442c63d50f4d369cc02dbbf0941cb0 upstream.

vchiq_get_state() can return a NULL pointer. So handle this cases and
avoid a NULL pointer derefence in vchiq_dump_platform_instances.

Reviewed-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1642968143-19281-17-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -2063,6 +2063,9 @@ int vchiq_dump_platform_instances(void *
 	int len;
 	int i;
 
+	if (!state)
+		return -ENOTCONN;
+
 	/* There is no list of instances, so instead scan all services,
 		marking those that have been dumped. */
 


