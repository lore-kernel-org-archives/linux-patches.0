Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020241;
	b=R1WaaBnCoktDsd2L72Axic2yQeAtNHsfD7HVjrAx+v2LnB8+Gifjzxpcob+/QXXe6njl
	 EC1D/JDuSoD38XPIxKcPtOq9knWiuEz3UW25lNQVEFx3r+U12LcBPAFRChDn8xKcW8EBm
	 tcP3oQpnX7zyzBIWF+xlQDnQX5yTXALp2SMcf2itnQ2UthMLw/0dJtShVtLpYypkPOjeT
	 sUdaLib0NST//sBeyrtnS3fzyJ1utOCp+Hbth8/8v0EbOUtY1LO00iSKLdDV1QtlSqmob
	 YKSISMDIQWj2z/Qu/aasxDcyXO0Wwmz/bqGGZOgsV1zB2lYcsIMlG7FU+dAKrxUfL/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2G61dcz7o90CPq9oDIejf3l5d9zXhQgNRuPn6Z0siQo=;
	b=mGMuQUzrEjl7U/ayeqalnl2kfTvdFArGc+Q30Mg6iiViXkYKLdXmThAuXGfZO5imbBpz
	 oT0KYbceASdE8SE9ir4C6noJqDtBI9NUatypXTKltZFT/+xfXmTnZUgYSy6xjocZJbEg1
	 cz9jugj7KigieU9b8n/OWNu01hwhJIQ0LTvgonzAuXsyYH18aSBdQr09tQzk9vPzpZBga
	 sHPv9lLPKhLPaQIY3rJzXQbObAdV0NieHTpPAh5oh4/Fx6waBVlFCAHAUvVMk6w+ij5J+
	 gSAV9YOiW0DqMqMtQutAb7WyIL72OfDLty1gWmhysqScHDCfNOQ4p/M274EbGX2CQfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2sCn3Pz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B84606A32F;
	Wed, 18 Nov 2026 16:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z2sCn3Pz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92561F000C4;
	Wed, 18 Nov 2026 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020241;
	bh=2G61dcz7o90CPq9oDIejf3l5d9zXhQgNRuPn6Z0siQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z2sCn3PzzS9awemMTwnKqflpY4T+RP4OBrU5f5uUy/jaL3+axzcehMUhfGW0XaHyo
	 EpeHUrV1WILu0C8isjfnpzk1xX5/dMxScwG2LdE6b5Fz+Rnq6UURFCdw3ZhqHq/oJ5
	 xX3Twgj5g4uLsSJwPJ6XiDtNJjwWAaWbT4OKNP8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enju.kohei@fujitsu.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1839/2651] arm64: rsi: Correct type of realm_config::hash_algo
Date: Wed, 18 Nov 2026 15:51:19 +0100
Message-ID: <20261118150353.294505066@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enju.kohei@fujitsu.com>

[ Upstream commit c83237edf0adb8f8cbd9859841bbca5acc00fc11 ]

The RMM specification (DEN0137, B5.5.10 and B5.5.19) defines
RsiHashAlgorithm as an 8-bit enumeration, stored at offset 0x8 of
RsiRealmConfig, with the unused bits of the structure being MBZ.
However, realm_config::hash_algo is declared as unsigned long.

For an RMM that zeroes the unused bits, the wider type gives the same
value. An RMM that only writes the low byte (as TF-RMM currently does)
leaves bytes 1-7 with whatever the guest buffer contained, so a
comparison of the 64-bit field against RSI_HASH_SHA_* can fail. Nothing
in mainline reads the field yet, but the proposed Realm measurement
register support does.

Declare the field as u8 so the guest only depends on the byte the
specification defines. The struct size and the offsets of the other
fields do not change.

Link: https://lore.kernel.org/all/20260413084957.327661-4-sami.mujawar@arm.com/
Fixes: b880a80011f5 ("arm64: rsi: Add RSI definitions")
Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/rsi_smc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
index e19253f96c940..6271e18e5a37f 100644
--- a/arch/arm64/include/asm/rsi_smc.h
+++ b/arch/arm64/include/asm/rsi_smc.h
@@ -128,7 +128,7 @@ struct realm_config {
 	union {
 		struct {
 			unsigned long ipa_bits; /* Width of IPA in bits */
-			unsigned long hash_algo; /* Hash algorithm */
+			u8 hash_algo; /* Hash algorithm */
 		};
 		u8 pad[0x200];
 	};
-- 
2.53.0



