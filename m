Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346AB168C4;
	Mon, 27 May 2024 19:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837511; cv=none; b=UrHCPCHJ37wVM/uSGc05PKNJJ8kRP7JLyfzNTax0GCGDTuIR6gRUow3H3rQoLJnfXUhXpu8KqlOFXNB5xeV35Vt0D+jQfAmDijffRGTHJFTeWsVRzSs23OwclpT05eA4UiIc8Nubr+rsimeuop1Na8+zf83XnsynJLj1ZMhCGnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837511; c=relaxed/simple;
	bh=2TrKMomm91ojMgO5hoIiGU/iil1SLdXIIc8IdV+HHVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dddA/6Azwea55AG4m06DahbkLOkfjSiyOvU0AOmWsTPd6S5jGQRFiMS2f+fb7qd5Wn5IUsdqkMvsbJyU3NbiSLcO1nUFhLACtEfgum6Q1eZo1/D9bCQBiz00Rti1KUEv7+458ZeeuZ/y5B2hvb2XP2o0ppMHZjLcHy+Rxi10M/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVhp0kHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVhp0kHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1CDC2BBFC;
	Mon, 27 May 2024 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837511;
	bh=2TrKMomm91ojMgO5hoIiGU/iil1SLdXIIc8IdV+HHVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVhp0kHFG7X8VmRIz8wObyhLTmCTkGI7848mcMf9qbIqgDVaH23jCNrNosbly9zVV
	 PELJo59kQHMaL2QB9zjFYxeZ/V9MyemLQ27DxAJXRVV89vUs9o844kp5s2kj0MWHv9
	 1nH+lAWoCudDRbmbLPVv6Hbdd9FGwqNhvJhfSxwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Simo Sorce <simo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.8 038/493] KEYS: asymmetric: Add missing dependencies of FIPS_SIGNATURE_SELFTEST
Date: Mon, 27 May 2024 20:50:40 +0200
Message-ID: <20240527185629.945400115@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


