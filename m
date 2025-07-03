Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8D815442C;
	Thu,  3 Jul 2025 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555328; cv=none; b=pdKmbuO4mVZmQnPqsiYkceyG5ckjIHWk+RF0bERb+oeFagLBSeIS5eCQqU1zruYICNPbdmWuqXsO4aJAEEH675neq2XQ0CNBqljRrv2RoAeFRTQv6a9ThXTk0oIYujFSY42UxsLjMz+NNc8d/ua8muTHHFwDxyskeim543zZsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555328; c=relaxed/simple;
	bh=PtVuJok8uHKE6gFX92WyYklDlUbtgVl5aL3u1drfqec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQrLo18dbpBpqa1Bbnx7gNl0K8wQrNpFRRPpS9GxxE+w5253heyGYX2q7s2YT27LLbR6PEspuQ9KskQeYx7+ICDkoBSOH9Bge/CsCe/wOufvCh65RZLXsZqixpIhTWTjnT+5e8m7pud2pJ/UhhKF5PjrhonYzMJprmkCwC1c7yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmjIfari; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmjIfari"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02439C4CEE3;
	Thu,  3 Jul 2025 15:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555328;
	bh=PtVuJok8uHKE6gFX92WyYklDlUbtgVl5aL3u1drfqec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmjIfarif2YJPkxjC0qEEvMEVjiQJmbYaGBZyNhmlgWx6qqTse1FhgJW7+YPz7OOB
	 jqp0kDyvzZMWZhjuO9kCFnRuO2h9gD8M4/Oy98Fq8w0ohIRbfNVQIqrQjKW9784vcJ
	 IDoEn5vhJLkKKY08HtboWabIhcPthscjd+NPh5T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 244/263] crypto: powerpc/poly1305 - add depends on BROKEN for now
Date: Thu,  3 Jul 2025 16:42:44 +0200
Message-ID: <20250703144014.199811202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit bc8169003b41e89fe7052e408cf9fdbecb4017fe ]

As discussed in the thread containing
https://lore.kernel.org/linux-crypto/20250510053308.GB505731@sol/, the
Power10-optimized Poly1305 code is currently not safe to call in softirq
context.  Disable it for now.  It can be re-enabled once it is fixed.

Fixes: ba8f8624fde2 ("crypto: poly1305-p10 - Glue code for optmized Poly1305 implementation for ppc64le")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index 370db8192ce62..7b785c8664f5d 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -110,6 +110,7 @@ config CRYPTO_CHACHA20_P10
 config CRYPTO_POLY1305_P10
 	tristate "Hash functions: Poly1305 (P10 or later)"
 	depends on PPC64 && CPU_LITTLE_ENDIAN && VSX
+	depends on BROKEN # Needs to be fixed to work in softirq context
 	select CRYPTO_HASH
 	select CRYPTO_LIB_POLY1305_GENERIC
 	help
-- 
2.39.5



