Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31796197533;
	Thu,  6 Jun 2024 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683155; cv=none; b=N+d+QeVQk/LPU/c5nRl3N9jhONLVEQnbm7KD2E476giEWHcD7O5UO8YTFv7rHhLWUgSj9lMapibruRf+/Bpq4nWsUcovWfFJHpjMl354+I12tSyWELCS/CewRuItGWuMSI+1QWoCGkEsffvPIuRQFWQnKZLdh9uK/9cX+p5m9mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683155; c=relaxed/simple;
	bh=uij4OvpAi0SwUZMeNLdifvMxT0TrjqbdFcfU1iB1eCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et3B1DxiZqVhZBCPs+d43/mkPa30qxYI4/b58cIZe3bME1igM650tfMkvBg48szRootM/MMDq+ezrIRbiamL5/ZltKwV1m6tmHWosh/R7EVCoI0J4Mi+JrYn44GWIJ+wNQ5y61i2GEklOLGaFv91M08OBt1h54wPiT4VBNsfobg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhmjXnoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhmjXnoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1089AC2BD10;
	Thu,  6 Jun 2024 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683155;
	bh=uij4OvpAi0SwUZMeNLdifvMxT0TrjqbdFcfU1iB1eCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhmjXnoPyV3f6GWpGjwPCaVueDdS6AfGOjyiSeCrFVncwht+j/Xla6K2UhKKmok/h
	 FRzoGr7fgZpFrecHvXvAQhN4jlxOGwBocAQXd9r0JizxJqpy6WcUVebQKB8MRW3yiS
	 goQm7Zww3HnuuV9s6Nbp/4v/2TdaG/Oq8j7BwPHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Simo Sorce <simo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 026/473] KEYS: asymmetric: Add missing dependencies of FIPS_SIGNATURE_SELFTEST
Date: Thu,  6 Jun 2024 15:59:15 +0200
Message-ID: <20240606131700.730693148@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 9d2fd8bdc12f403a5c35c971936a0e1d5cb5108e upstream.

Since the signature self-test uses RSA and SHA-256, it must only be
enabled when those algorithms are enabled.  Otherwise it fails and
panics the kernel on boot-up.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404221528.51d75177-lkp@intel.com
Fixes: 3cde3174eb91 ("certs: Add FIPS selftests")
Cc: stable@vger.kernel.org
Cc: Simo Sorce <simo@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -84,5 +84,7 @@ config FIPS_SIGNATURE_SELFTEST
 	depends on KEYS
 	depends on ASYMMETRIC_KEY_TYPE
 	depends on PKCS7_MESSAGE_PARSER
+	depends on CRYPTO_RSA
+	depends on CRYPTO_SHA256
 
 endif # ASYMMETRIC_KEY_TYPE


