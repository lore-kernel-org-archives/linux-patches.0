Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024227;
	b=xZGLPxcETlKxXYtPhkXyW8aVF1l2G1vGFCs0VRfdeR9OPE2EqtsHvAbCJmD7ilH9/CTd
	 usfWWaTI+wQ5xj/KJSMNLivdJlAvWtufHr8VOUmLEhyBV/uBHQAVzGk3hUqD7fPLKbA67
	 fRGlOXpmmXxumJu93hqMCudlSMs3aU//a89DrPkkBw/WR0Z0KS3daB/5RzJxa8V+6Habx
	 YCuoMOIHdjUadvVv/SqADcpfjGO9AYUiDgfjAnqWPZtckdAeTWcAVkadG9VcYLJZ7edVA
	 AmFPk4fiG8z1ZqF0jyI6kqe4ib1ZO0peAs4hsAkp2UfBDBh57LZW5IKn8clfw8RR/Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sr5kS/QKQ5xS01QX33SCcxFPSqMJR3/RD6C/sTx4o7Y=;
	b=ybgU4CrtnjNd0Ryd6OsbiWfNckrQ1Bt3A9L5RU4A3ylMHrBWOt2nRlv99DTndqqAz/Vb
	 OZelmEUV7F60271x1JzCvfPaANkwdzmgpUTw3BX3vVgzjmvvrDcFuiQcradWK8XI/Tji3
	 MI2GHkGC/vqh28ZQyOzdSjPKZSFBngXygklxlJeWCYbeUPnbhYui2C+8IVECZZTVDchrl
	 FKbULu2BogCYjNf+5QxEVqB45574jefwzRcIcNlnFHR5j2qy0hVUcOG6yvzOXlIIG64DO
	 nq9icp6DhID/TxSeL8pxaDpQuSYLZR6QhhaPuVcBOYtP6PbxhHk3PpZFUEZ406ThZuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbs6qkVR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E55606A325;
	Wed, 18 Nov 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbs6qkVR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5493F1F000C7;
	Wed, 18 Nov 2026 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024226;
	bh=sr5kS/QKQ5xS01QX33SCcxFPSqMJR3/RD6C/sTx4o7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbs6qkVRLVT2IDEL9OStZHq2lBVoOo551qMVeH6ywb7L79vrU7YFdHwOHEau7HdvX
	 LyBoQF7tEbl+yr/T1ctUAaHR4uNb1wHfqUF/1dvjWgrs7+nchpjzhNBNtDKvKG4rbV
	 b57xO9pytZOJC7bpNju3q8a55cHza8qE8kNjrZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0609/2151] x86/boot: Remove redundant "cc" clobber in memcmp() and document it
Date: Wed, 18 Nov 2026 15:39:04 +0100
Message-ID: <20261118150144.116173618@linuxfoundation.org>
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

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit 94509668fccfa098e0a3d57e7093a9afd88aea9f ]

The "cc" clobber remains recognized for source compatibility, but it has
no meaning anymore; it is automatically generated without condition-code
constraints:

  https://lore.kernel.org/all/57b0d188-b256-bde4-43e6-99dae4f59d60@suse.de

Comment out the redundant "cc" clobber for documentation purposes.

  [ bp: Massage commit message. ]

Fixes: a8c171c107c0 ("x86/boot: Add volatile, clobbers and zero-length test in memcmp()")
Reported-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260921-pvh-kasan-inline-v10-1-08da47943d8e@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/string.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 3a2bba7c25e9d..fa9623988826b 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -36,11 +36,15 @@ int memcmp(const void *s1, const void *s2, size_t len)
 	/*
 	 * Make sure ZF is properly set in the len==0 case because in it,
 	 * RCX==0 and the REPE; CMPSB won't get executed.
+	 *
+	 * The "cc" clobber has no meaning anymore, just source compatibility.
+	 * On x86 the flag status bits are automatically added to the clobber
+	 * set when there are no =@ccXY constraints. Keep it as documentation.
 	 */
 	asm volatile("test %3, %3\n\t"
 		     "repe cmpsb"
 		     : "=@ccnz" (diff), "+D" (s1), "+S" (s2), "+c" (len)
-		     : : "cc", "memory");
+		     : : /* "cc", */ "memory");
 	return diff;
 }
 
-- 
2.53.0



