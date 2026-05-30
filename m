Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426FB33FE15;
	Sat, 30 May 2026 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160024; cv=none; b=PTozP7PDQuyNzof5/+PUjjYVGZL57n/t0upk+dOuzAcTtUh9QfcsVB665gZeRdqGopY4WkAlg1Nytp7THKMGnm2b4YWVO9x/AlWiy1Qoy5QQ0zKIvovtOKLvx6cSYIYq2M2EjbaeZr7rlUCXwJIOXxTZANnEiUtrpGX5S7fq36w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160024; c=relaxed/simple;
	bh=v0uUv9hPXPG6bhdUGaw/kVedWxgsDJsdyL5wEE/1eMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qssyzxl7BA+9sXFnux/pag4K95t7kHmpVDYQv0uW4Wdr/UqB09wExkZkGUfVtT4sJP6Te2KqmdzCzUu2DOGuGd7bSqj9cP9Q/TjGoYggHcTx/Bh/KZ3AG4NG2j01YCez2wsYZgE1xHYJnaNPw8FIHlWi/LtmEQASq6+aALUyBIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TYuEdSH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TYuEdSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340AD1F00893;
	Sat, 30 May 2026 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160022;
	bh=WayxdCoCbZiYIV7yWu9JLO8fBfRO8UpTGMnJP7zAHzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TYuEdSHVkXZHkf04inHegvSKQ3TvRFrJatIAWwXNapm/mLDCT/xuOka2cg/kl9ZS
	 ceGy+3dV2OO5k9XBUe5OFrm+sSf1DVNMyZM9NSUy8rji5Z5Kfa+Ji0F8hxFajYlBjs
	 yl7fYz08KhGIY/tefJS+wE0ztsz3wHRIMzrVuZZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 223/969] tpm: avoid -Wunused-but-set-variable
Date: Sat, 30 May 2026 17:55:47 +0200
Message-ID: <20260530160306.610250698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Arnd Bergmann <arnd@arndb.de>

commit 6f1d4d2ecfcd1b577dc87350ea965fe81f272e83 upstream.

Outside of the EFI tpm code, the TPM_MEMREMAP()/TPM_MEMUNMAP functions are
defined as trivial macros, leading to the mapping_size variable ending
up unused:

In file included from drivers/char/tpm/tpm-sysfs.c:16:
In file included from drivers/char/tpm/tpm.h:28:
include/linux/tpm_eventlog.h:167:6: error: variable 'mapping_size' set but not used [-Werror,-Wunused-but-set-variable]
  167 |         int mapping_size;

Turn the stubs into inline functions to avoid this warning.

Cc: stable@vger.kernel.org # v5.3+
Fixes: c46f3405692d ("tpm: Reserve the TPM final events table")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tpm_eventlog.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -131,11 +131,16 @@ struct tcg_algorithm_info {
 };
 
 #ifndef TPM_MEMREMAP
-#define TPM_MEMREMAP(start, size) NULL
+static inline void *TPM_MEMREMAP(unsigned long start, size_t size)
+{
+	return NULL;
+}
 #endif
 
 #ifndef TPM_MEMUNMAP
-#define TPM_MEMUNMAP(start, size) do{} while(0)
+static inline void TPM_MEMUNMAP(void *mapping, size_t size)
+{
+}
 #endif
 
 /**


