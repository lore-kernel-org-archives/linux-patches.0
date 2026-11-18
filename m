Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026613;
	b=raKWgaozXOtDjgehImzDDaFv1UU8cpZslvLklvK4oGcu6NiPiGSzJ1aIjZXqqmvMKD3H
	 iE0Q+ZP/qTfIMxYYdtohFjH+OXTZCSd4vAzzO/PySEPwXaG8JF6FONfE40VyO0zy7IAMd
	 iBm2WLGG4NMks6VX9akYBGk337my1lLKV9HUOmdw7/squZVk7i9oKs3bC14kBsqvECDmW
	 CUccJfmBeGT8BBctl/WAiKl32BCQHHtFhi0hb8S0OagheqN1Yr3Dj7rkt0HRGbSDvpttn
	 ULm87L7W1I4Q4GTMX+SnCJQh6YJIgAbWzL1kZkmALhFtYsg9/XA3zhayMd+XuCzT4VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+9uHwEUFX/fZyThO/yVFMYA5HYei8PkALco5ZxjEiA0=;
	b=bZ0TAsRFvkSggvFLsJoqoToOGG9zLJR4hObhfvUe/60ieNn32FOv/5jnv+8/sOHJTMqZ
	 ExPv+wBTi9IRnZj0pXeSAlLs3+1MQAJI4sHyng//MRwteTu96yKipJMvtF4yFWOB9uft4
	 2j2AbyPAUqI7u5GCkmMcTaLFuJ5R8IkA0/v9G7UWZ1kiN9tTeRnZyKGkp9eHE4zbDdE+t
	 ehdOwxs5jBo9BY9M5ad0EPKWs2Qsqjac9vCCegS4t15nBX4bcwBVGCh/e84b30fo3Bnwm
	 gndqXj6CQ4UixpcamZFvv2nkI1sV4a9430Y7lrIKr9axVnom2wntFUb5x17cmWs9t5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW4Z1W8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545F0606A331;
	Wed, 18 Nov 2026 18:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW4Z1W8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B91B1F000C4;
	Wed, 18 Nov 2026 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026612;
	bh=+9uHwEUFX/fZyThO/yVFMYA5HYei8PkALco5ZxjEiA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OW4Z1W8fbedE89s8CFyjXSfdXtsb/xTa0d2N3LISgf0wdHCOm7Ls7hU3YOVHEtPIW
	 Ejf8XstRK/G+QNYFfyj8UjDd4b2roSCZ4UP6RbQ0vM2Dau+I1GFEop5XIz7bFOLLrz
	 95uSzAKxaPKUsLMgs833UK2ggbYEqhgqGoyedIUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enju.kohei@fujitsu.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1496/2151] arm64: rsi: Correct type of realm_config::hash_algo
Date: Wed, 18 Nov 2026 15:53:51 +0100
Message-ID: <20261118150216.368561316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 6cb070eca9e9b..c2359ec01da7b 100644
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



