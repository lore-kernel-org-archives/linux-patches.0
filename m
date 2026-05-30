Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF13AB285;
	Sat, 30 May 2026 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165760; cv=none; b=u5VeW5vjJwAg8R6tZys60rGekUG+CGgd/y4J+YkiZa/Bsvi7XRAG9tPM4g3ZleLhaQZMZL2QPpWk2plqQ0XVs+sm1t4axJyTUErlymB2X97U8TpvXM14vLiTGu5F7PlGtFYWdKKkA67rbm9xivG/8L+RJCx5cjn16eu6l8GXQk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165760; c=relaxed/simple;
	bh=NovPGiWONCRjWZY98mtI7vdesw0G6JZzsRLpf9YIs8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTXwXO1+kUMY7+kSed+sYpFEbkOPpXJC5EMm9KOv8Be8PcVyIGpiew93buTBpKzLnJv3Yz8sK/PF7Ac3RyqlZp1kNXUSn7UGNFuBCbE/l81/bDMahfuqlAcdCXC2ZUBdIDWOGC+CgoyVFKKUOG6f12EzMBaK16kwBZxSHxtGYQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyipZRrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyipZRrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CAB1F00893;
	Sat, 30 May 2026 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165759;
	bh=Dd/VV7fvU/lW7yEmi2ycKiuBgTN9YA2JpZF4cLAOhJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyipZRrG+r6RFQqetnhNNfOPRXHSB3YnLbRe7uxJhdbIdv86o5vv6PsRjnjNFrUR+
	 KnT9efISbWGY9LFwJuSsAF61KxabruUrSnqM5OIExtn6I1tjytkbFqZB9Djnfp7cua
	 L6/N+90H7SAdCX/tm+Y8sw1I4+EHDi4lZVGLNeZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 172/589] tpm: avoid -Wunused-but-set-variable
Date: Sat, 30 May 2026 18:00:53 +0200
Message-ID: <20260530160229.322134727@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


