Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6A529CE7;
	Wed,  2 Oct 2024 13:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877165; cv=none; b=ocy1zMpxDPh61BvvSXbfIeHHcOQSbc0ATd26EPQrkkFeGsDxtuwF5zWdQvj/DYNZTCN79wjgBAXb//9MiDRyJUYPHJ8nfkgKFGQ+ziGBdqYwibfur+207q7ththLTR9EPTDmajmrVIoC3eqw/WWXv3BNdD4I1sgaW7IJeoNlH0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877165; c=relaxed/simple;
	bh=s2XjHzMYxCVsfrx03oSXkRpIaooVMHHhVIqZllUnNm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0V4ar2Hd3ilNaB5NkHX/YcVbPA5il1ufq4pHaT3kHhR43i90PnmduN4UxMmIK6tW05FgB1XZVXnvZe5YeXdfqZ+OtPiW5FQ+SHbZHLP845ELBc+WvYUpUhBmALfkMuvID86+Ny3VGwEJRLkiKbVO7/GHdVx43sEX10KsH39n3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqPdvogV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqPdvogV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C938EC4CEC2;
	Wed,  2 Oct 2024 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877165;
	bh=s2XjHzMYxCVsfrx03oSXkRpIaooVMHHhVIqZllUnNm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqPdvogVlnDyZrUuSxcA2cOcbLPsWlJP5uzA1z8Cr5camKTPplI3GlEBCaT8iXNCl
	 BkZmJHF3cCArN3q3E5Gl1SXBjCp4qctEN54/gzsAQgaH2+By5JYLKhmPBlOVYWBGGD
	 F2Pa4R4mCub+w7VA9VSzJBNzuuxWVt06FzKtxVaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Mingcong Bai <jeffbai@aosc.io>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.11 686/695] tpm: export tpm2_sessions_init() to fix ibmvtpm building
Date: Wed,  2 Oct 2024 15:01:24 +0200
Message-ID: <20241002125849.903115350@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kexy Biscuit <kexybiscuit@aosc.io>

commit f168c000d27f8134160d4a52dfc474a948a3d7e9 upstream.

Commit 08d08e2e9f0a ("tpm: ibmvtpm: Call tpm2_sessions_init() to
initialize session support") adds call to tpm2_sessions_init() in ibmvtpm,
which could be built as a module. However, tpm2_sessions_init() wasn't
exported, causing libmvtpm to fail to build as a module:

ERROR: modpost: "tpm2_sessions_init" [drivers/char/tpm/tpm_ibmvtpm.ko] undefined!

Export tpm2_sessions_init() to resolve the issue.

Cc: stable@vger.kernel.org # v6.10+
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408051735.ZJkAPQ3b-lkp@intel.com/
Fixes: 08d08e2e9f0a ("tpm: ibmvtpm: Call tpm2_sessions_init() to initialize session support")
Signed-off-by: Kexy Biscuit <kexybiscuit@aosc.io>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1362,4 +1362,5 @@ int tpm2_sessions_init(struct tpm_chip *
 
 	return rc;
 }
+EXPORT_SYMBOL(tpm2_sessions_init);
 #endif /* CONFIG_TCG_TPM2_HMAC */


