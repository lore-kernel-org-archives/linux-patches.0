Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448F6197527;
	Thu,  6 Jun 2024 14:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683135; cv=none; b=FQO5RO5/cKjaCuDcT/V/GbuULrCGtDVt2K6r6NA0kNSuYAnFN+q5icwnfLOMJ57bsKnazZCG2LRra/xRdBSfZdF+vzIV9RD64o2wBatisSY5o69JJ9VH2WP+0EUb7akjgmK/I905LhAVo22JxOkGRifkBI9uQRWErhfZt2xNRE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683135; c=relaxed/simple;
	bh=rUM+9sPk0Ei61jOo3McePxfUteBhYm8T0m4xKcU3MDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKSAIOee4RXgcGOT8fH3IXzWcF6hTdCqhAZy+bsH+7Yu1EfYb461xPc1XPtkyM1ZZTvJ4I/pusfTG2IjLYmKDN9Xfbr9Gh2UqjeoIMElyrdtNaoWxPc+9kl6NM2xsgH0I8hkawUKSFvgyc+z5OU5P0lHoMLxfI+oxWFKRXrte6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYjSJ/lH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYjSJ/lH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2328FC32781;
	Thu,  6 Jun 2024 14:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683135;
	bh=rUM+9sPk0Ei61jOo3McePxfUteBhYm8T0m4xKcU3MDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYjSJ/lHt2jqUyxv7xREzul1yvgYeJBNIZG77DN3UXmgN7Gv/lZArfBVuRptibmP0
	 ZvpcMmuB5AtWnlx6TWVC25BC4zXBRyBenduzk+UxhVxJPzsT/cbcnlzbnoyIOcoALo
	 ax9T9PqEeLj0pLnNJS7Iu+lgKkrVvEr5dz9Y5EY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Simo Sorce <simo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 033/744] KEYS: asymmetric: Add missing dependencies of FIPS_SIGNATURE_SELFTEST
Date: Thu,  6 Jun 2024 15:55:05 +0200
Message-ID: <20240606131733.517274835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -86,5 +86,7 @@ config FIPS_SIGNATURE_SELFTEST
 	depends on ASYMMETRIC_KEY_TYPE
 	depends on PKCS7_MESSAGE_PARSER=X509_CERTIFICATE_PARSER
 	depends on X509_CERTIFICATE_PARSER
+	depends on CRYPTO_RSA
+	depends on CRYPTO_SHA256
 
 endif # ASYMMETRIC_KEY_TYPE


