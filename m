Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016895;
	b=285skYMEK0sVADe4638mvfFKLW10/GDWySMHipVs4rxKwCyo9SBMxob9z01V6PFSUybH
	 rYqWu2eVo2savauvpvl46H98eIp+Rh91fhNsNzkA78jbQsd7ZsjtGcGSIdglZRXglNUXw
	 iEwTfxxzQ2h12orSdAaalTguGpRQnZZCZe9TptJU2B6NqlBTF5FXspgRIECFtgIxaxqqt
	 OiI8JxSF7OZzbbuUAaTUaLVeESMxSAV+UmoyyS26+cW0MSxPdh7BDvQ7Ga8nm2AdCTWTo
	 G/yBpcQ93A9FD/fkCTjDng3w8DXIadqxZZERthfwJHY1gtZWPBB1qjXQhYCmEfk18aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=S46Au7jC0GWH2Adfk3MmlY931I/Bn0TPcVsnjLOTpQI=;
	b=RObfTr7B6RQd3GENmgugJwyNXmBVosB9AY562tMEWCXUO48FgRSq5cNCjnKksfU0f51E
	 7D1NfRiFrcCGusbmVGpgvRn8X2XbRelLVnAfemI4vM767JClgE0OZVU5o3zl1lz5Amaz4
	 7inAgN3+qtcvt6TDQi9tKVreCthfD1NuDqlwWf7BKb0JzKYvM3+Q6i6LUqKswD4ihjQUA
	 sSYrNURykr1SayjVtTdAKVy9z2e+CTqPYyn8LVFGmVoV8b3Kdmzb6ewdpf6+vIHDHHbS0
	 7dUYCmtmQ/vii3xAAz8rFKaReS+7HtFRIVAAYW/mi7vSy5CAtQ8TNNvXyZHynpkvgHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O9/yv9v3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E8606A320;
	Wed, 18 Nov 2026 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O9/yv9v3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1152F1F000C4;
	Wed, 18 Nov 2026 15:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016895;
	bh=S46Au7jC0GWH2Adfk3MmlY931I/Bn0TPcVsnjLOTpQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9/yv9v3ml/MCDPibEscy+qj1Pe4BKDI9adffZ38C7Xfmf+OtgmKx5TptaWfUA7gH
	 fZl9H/kk1VppGb9BBr3OnYpZpeUyIceHCl90bkHhfDBMDRQ4Pej3m/Xe3egGJSkUTA
	 6xW665D4vOl7IOR4MKVmnI3uDjl2zcmMu8eWpsvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0689/2651] crypto: asymmetric_keys/pkcs7 - Check all signers before waiving authattrs rejection
Date: Wed, 18 Nov 2026 15:32:09 +0100
Message-ID: <20261118150312.659118900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 553c623a12f4928a2889cf1bba0bd8885f0bdd4f ]

pkcs7_check_authattrs() only looks at the first SignerInfo when deciding
whether rejection of authenticated attributes may be waived.  For the
remaining signers it checks only that authenticated attributes are either
present on all signers or absent from all of them.

This means an unmatched ML-DSA signer can be placed first, followed by a
trusted RSA, ECDSA, or ECRDSA signer.  Verification skips the unmatched
signature and accepts the later trusted signer.  The first signer still
leaves the waiver enabled for the whole message, so the non-ML-DSA signer
can use an exception intended only for ML-DSA.

Check each SignerInfo's public-key algorithm before leaving the waiver
enabled.

Fixes: 91db696adea4 ("pkcs7: Allow authenticatedAttributes for ML-DSA")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/pkcs7_parser.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 6e3ffdac83ace..7f00e45a33cf6 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -111,6 +111,12 @@ static int pkcs7_check_authattrs(struct pkcs7_message *msg)
 		if (!!sinfo->authattrs != want)
 			goto inconsistent;
 
+#ifdef CONFIG_PKCS7_WAIVE_AUTHATTRS_REJECTION_FOR_MLDSA
+		if (sinfo->authattrs &&
+		    strncmp(sinfo->sig->pkey_algo, "mldsa", 5) != 0)
+			msg->authattrs_rej_waivable = false;
+#endif
+
 		if (!sinfo->authattrs &&
 		    sinfo->sig->algo_takes_data)
 			sinfo->sig->hash_algo = "none";
-- 
2.53.0



