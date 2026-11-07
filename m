Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064336;
	b=1XPTKLsDpsQouH9SOumdS2yI2TPwf+jp3DbjqFTxavVypLU5WukmkuHbM+WfkB67JiQc
	 jcmyvk/PCMItOCflAInQeHarks4JuH51MStAob5rPTtuxcbLF6CUwBwPhBeO4BfSh555i
	 dyyjQ/Kf/OBBkCJ5H0OBV5VR5Ymp45wlN7h49LS5+ss44EwtPrtdZP6VCsVpTNhJFVbpG
	 HCTH/a9VUTQYptx3fcdXyjkEeAOtTi7p27Gt+g8GAHtXqAi42WRl88wUTZqCfH7dsD5sn
	 E8K1iQbosSGvV6VnPk5JwLF/I/NNuERVWGj+6OocArcT2mAWvoaDt2oflS70efZYbsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WYWXl1afOkwDJrIFRyWcWVZ6BmCF23abSxwSISZfyw0=;
	b=e0oYFbLgJknvkD2w0O+6uFqUNPCd4PsunVxLExNuSqkKZa/i0irjEAEVoM82TCDaYGVT
	 sh3/HTknmLzjIavGxfpOIgrmZqIz6aMfr82ZSKyE8eeoKB5Oufko/uLHkhxw2u8f2n7xb
	 Gg92NSXm7RoL6VgBS99jybr+6f60bamgCRhR9YId9TR2yAdjfXgOkm0qYj/qZD8Acd8lu
	 ODtx1rjgZ9QZNXGxIsfKRu6a/21U2XEV5G0p3Q3JY29wYckvjNYo3Ky1rV7TsvTn/bCzA
	 hDG1yWJdkDi8n2OSdj95yXUVhjYmoRycu1cv1a8Nuw/buLGH8kTkbrZj4ybdaMjCu8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciVmG9UJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528F606A33A;
	Sat,  7 Nov 2026 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciVmG9UJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0135A1F0089F;
	Sat,  7 Nov 2026 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064336;
	bh=WYWXl1afOkwDJrIFRyWcWVZ6BmCF23abSxwSISZfyw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciVmG9UJC0462kNTSmJQpBdCS0W6utcmPHmHyw3FSN1aPIBM8mH/GNqRrHAX88xwL
	 4zn/jnSGJnRRdLQ+gYYeuj/25bS7RejCyxhTeFe5SJ+mvoNEnHF2d9oFvH4QoD7je5
	 JBm1E5+j8BHpFw3Qb7DQQluXmGUCrTT92DL9QL7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0383/1257] pseries/plpks: fix self-reference in plpks_var initializer
Date: Sat,  7 Nov 2026 08:44:39 -0500
Message-ID: <20261107134950.128164255@linuxfoundation.org>
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

[ Upstream commit abcccecf4aa4b681f50eb7d7de93fc9a0a61c181 ]

In plpks_gen_wrapping_key() and plpks_wrap_object(), strlen(var.name) is
used to initialize var.namelen within the same struct initializer. This
references a member of var before initialization of var is complete.

Use the compile-time length of PLPKS_WRAPKEY_NAME instead.

Reported-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Fixes: 133aa79e211d ("pseries/plpks: add HCALLs for PowerVM Key Wrapping Module")
Cc: stable@vger.kernel.org # 7.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-9-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index b057e378a6b39..896eda3eb65f4 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -939,7 +939,7 @@ int plpks_gen_wrapping_key(void)
 	int rc = 0, pseries_status = 0;
 	struct plpks_var var = {
 		.name = PLPKS_WRAPKEY_NAME,
-		.namelen = strlen(var.name),
+		.namelen = sizeof(PLPKS_WRAPKEY_NAME) - 1,
 		.policy = PLPKS_WRAPPINGKEY,
 		.os = PLPKS_VAR_LINUX,
 		.component = PLPKS_WRAPKEY_COMPONENT
@@ -1034,7 +1034,7 @@ int plpks_wrap_object(u8 **input_buf, u32 input_len, u16 wrap_flags,
 	bool sb_enforce_bit = wrap_flags & BIT(1);
 	struct plpks_var var = {
 		.name = PLPKS_WRAPKEY_NAME,
-		.namelen = strlen(var.name),
+		.namelen = sizeof(PLPKS_WRAPKEY_NAME) - 1,
 		.os = PLPKS_VAR_LINUX,
 		.component = PLPKS_WRAPKEY_COMPONENT
 	};
-- 
2.53.0



