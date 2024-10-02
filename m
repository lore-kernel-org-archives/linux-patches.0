Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29E91D0940;
	Wed,  2 Oct 2024 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879065; cv=none; b=q+cyEDYOPSBiOm+3ySQdK0aw3H3f2TzN3X55O9SzZCmh2C7uTje99nGIfEoEw/KUfaIlcaTFDHxtv7Ds9XXzf6uYdxJiGhgRoujOiVrftAYicMp2DdNbYMnP/0iiLcLzZ1K3F+9+8rUdLS3vS5xg3v/QEAej3DkFOYiRHnQE6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879065; c=relaxed/simple;
	bh=flgrD24pWeuoAntMIUJy0i8CcBV5wW3DRU3O0qpbbSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIvDgj4vTEZ1Sfb9WyU5vbtA51nQk9A+tQgsr5x6f+N1XlqlDWFfRC2g2L+ZSj7+sszzvY5zoFK/i0/hXeDO8ijYC1ZTQ9bd7OQc+chYxlA4rcFEEzDdvG2tGCxV11Y8wCezoA4CDmxy+bLSpMTiUHHF+S+/w5YBox59qHh10xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMQD5iHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMQD5iHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55998C4CEC2;
	Wed,  2 Oct 2024 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879065;
	bh=flgrD24pWeuoAntMIUJy0i8CcBV5wW3DRU3O0qpbbSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMQD5iHM8PsbjGLxs4ygSNp9e9kLxtRu5D/HJbRgF9vWi38Z3eM4XRiR42hfT6a+x
	 6T7ZgqAWI8Zmb+K8S6x64/XwLd/3qBqa11CV1cwKU2hl6sATn3zvZWmwLhVp6QP6sn
	 AdMu9scUdjY4xBSFplubMjLEYmcAtWyBpIIU+Vi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Mingcong Bai <jeffbai@aosc.io>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.10 626/634] tpm: export tpm2_sessions_init() to fix ibmvtpm building
Date: Wed,  2 Oct 2024 15:02:06 +0200
Message-ID: <20241002125835.833759959@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/char/tpm/tpm2-sessions.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index d3521aadd43e..44f60730cff4 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1362,4 +1362,5 @@ int tpm2_sessions_init(struct tpm_chip *chip)
 
 	return rc;
 }
+EXPORT_SYMBOL(tpm2_sessions_init);
 #endif /* CONFIG_TCG_TPM2_HMAC */
-- 
2.46.2



