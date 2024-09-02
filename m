Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498F213E04C
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 10:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.248.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271367; cv=none; b=omY14qcUmKM/MDO+olCfqdJhG+/V6+yOEN2TpZzLhbAk8+MTc5po55EZHtakCtsAJK1s8/9TtrW7WuEsPWOUq9R7FCl5STGpRwg4xOIahMJgqyv2qEROCzdnTNYcZMhuEh+E+yjY9ByUKzcMHhli+lnoiN9qqMYLFP0Nr6Zbt7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271367; c=relaxed/simple;
	bh=yu05MG49Y96wNnlCUSqbQDKyaIQsanfK87VEISGQHk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJdZkqIQ4FIN9JpOghu3rdS5hzR3c2QraDcTJntwA928jhuqh1rHHlhEidyh8nK1XT6VCHyoVXwzRom9smq6YMqGMOS2oiL+m2L7hGBa3Y7vyvtN8mJ5mwLXeNL/i4MBsPb4mZN/S3PcuAmzzLzDqdXBTR/Z0NCW2JuNYJvjrGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=W+ObnJhf; arc=none smtp.client-ip=159.100.248.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="W+ObnJhf"
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.154])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 866702619F
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 10:02:42 +0000 (UTC)
Received: from nf1.mymailcheap.com (nf1.mymailcheap.com [51.75.14.91])
	by relay4.mymailcheap.com (Postfix) with ESMTPS id 99035203E4;
	Mon,  2 Sep 2024 10:02:34 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf1.mymailcheap.com (Postfix) with ESMTPSA id 3785840096;
	Mon,  2 Sep 2024 10:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1725271354; bh=yu05MG49Y96wNnlCUSqbQDKyaIQsanfK87VEISGQHk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+ObnJhfIKWvb+1dMGalYrT5Vh3kRfxKBZNDWa7ZP91OWY/vPWOGoUDJzb0yW5YZf
	 6K+u7qqWuEDR9oHFznf3lciugjSm/iv+xD3g0C0pQN26AJt4zOBN8YU1XYlSH8x8BK
	 ugs/GMTWGyh+MA7/ItgyiA5l1dBXOZ6D4uv/k8LA=
Received: from localhost.localdomain (unknown [58.32.40.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id B44AD4107A;
	Mon,  2 Sep 2024 10:02:31 +0000 (UTC)
From: Kexy Biscuit <kexybiscuit@aosc.io>
To: gregkh@linuxfoundation.org
Cc: jarkko@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	stefanb@linux.ibm.com,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	kernel test robot <lkp@intel.com>,
	Mingcong Bai <jeffbai@aosc.io>
Subject: [PATCH v2] tpm: export tpm2_sessions_init() to fix ibmvtpm building
Date: Mon,  2 Sep 2024 17:58:36 +0800
Message-ID: <20240902095835.16925-2-kexybiscuit@aosc.io>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.780395041@linuxfoundation.org>
References: <20240901160817.780395041@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: nf1.mymailcheap.com
X-Rspamd-Queue-Id: 3785840096
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.40 / 10.00];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[]

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
---
V1 -> V2: Added Fixes tag and fixed email format

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
2.46.0

