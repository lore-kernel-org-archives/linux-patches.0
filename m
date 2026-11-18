Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033348;
	b=Xg/5JQIF+XAfEVAtSAZzMO4xNjAZxoPiRbZjZpJVk/f/C6mgrr4IcrxpWkgupOX6pa22
	 LtL4IKZIkf1AFv2My+TdR5hayuViTdoMNeO2IMcerdQdHSJULOU+8jZwPRyjZ0rL+sSIb
	 nxPW64ZbWMWV9R7Bftq6X6Uok86OQzc7n0ImMGFiSRycj9a840ilVPSNuzQ9qq/75Z9L2
	 8MG24rovh5duCoKU/cGWzm74x/hGHTse/vlJXK1jMnG/G9qHe1Ym28BRWIIpeu5QVpbsM
	 aRfp8CsGWzQ4PkpRm+Eb7rkJFvjl0FTvWm65zC0nvoC4woYEuyoG7irTb9WSakdlycA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JT7ZE7JIxY9403q3xBTuWv/vwDyWM3juDNBPiUhuIxg=;
	b=kolswr7blSij5tI1Yta6/VY2NVQBstedEPMLFOUM6mie3r6YA5YrUXOgZpzJlXXBfnw+
	 xSp41TniBAHixkmtY34B6YDvevqiHVf5E2ViEWpJ997viE5cLLaI9V/nf/wSVPS7cZdVk
	 ogngTTz3euf5TPuYqgBsnal31BR+GH4A9Gu/c75r1+6/WD91Zq3lFF1XwPxxZcUsBSLEh
	 5KSOjpwRf71lxZHdlc5Fk/oBsnlSIsh7WCLGhjbkEMf6RLICfBXwLLwt9zCUjNYPOD3XP
	 k9Jw3EVHe61MvVJjsuHygP7W+SeDbCki6Bk2l+y7SNnJWoHgijsCwCXQiVH2DPPBcog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u+Y/UeHx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A541C606A320;
	Wed, 18 Nov 2026 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+Y/UeHx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5801F000C5;
	Wed, 18 Nov 2026 20:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033348;
	bh=JT7ZE7JIxY9403q3xBTuWv/vwDyWM3juDNBPiUhuIxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+Y/UeHx7XQB+PFduUMfOJZp5DtWqkePMFojTQKiDK0nMLGVTY+5RZjsoJfr2/Jlj
	 8dKVEPJ8k5Z78yJmG60QuCvHAi2/t+A5LynB1a4LmLFz4QLxwbl7R9b7xEtGNaN81m
	 oJpWsch0uUyubnMHRn715k6n6F4X+HjFSr8CD0+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 1735/1756] soc: qcom: pmic_glink: Drop redundant pg assignment before taking lock
Date: Wed, 18 Nov 2026 16:04:22 +0100
Message-ID: <20261118150118.631901259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 1ac98d6484c4a53e9b3ed1f59d03a2dd2d287b70 upstream.

Commit e9f826b0459f ("soc: qcom: pmic_glink: simplify locking with
guard()") was on top of a fix [1] which was moving the 'pg =
__pmic_glink' assignment into the critical section.  Unfortunately the
actual fix was not applied and instead rebased version of the next patch
got in.  The resulting code is in general correct, but now there is a
duplicated assignment 'pg = __pmic_glink'.

[1] https://lore.kernel.org/all/20240822164815.230167-1-krzysztof.kozlowski@linaro.org/

Fixes: e9f826b0459f ("soc: qcom: pmic_glink: simplify locking with guard()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250111172326.101779-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/pmic_glink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -238,7 +238,7 @@ static void pmic_glink_pdr_callback(int
 
 static int pmic_glink_rpmsg_probe(struct rpmsg_device *rpdev)
 {
-	struct pmic_glink *pg = __pmic_glink;
+	struct pmic_glink *pg;
 
 	guard(mutex)(&__pmic_glink_lock);
 	pg = __pmic_glink;


