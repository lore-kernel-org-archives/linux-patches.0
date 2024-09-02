Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924C628683
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 01:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.241.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725242227; cv=none; b=LAiYuZNfTmLe7SeVfj9/btC3+6r6iaGJWGJY0HOHgsF2dRWbGcDU8rVPgsFMPg+D1L5BsTovcJquYbrfRdcK5BJKzpxfWBVfBxdfh6r1kLDI9RUR4HbYwj+J/UQtpaNA1ScUkSIm0yiI9SbPpZoX7Cz5Igc6fUIbzD6vwLRcccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725242227; c=relaxed/simple;
	bh=R/yiV9s8Z3jqlBYw2L7Um1OXYJNKCGfHGoDM/ulLzxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmhPwv3ycAPwe2RScMBoIGX6VZXwWplXa2Be4M9DGsdVB8KyZeByJGL58ss2Q0rJJXcI8Jh76ndCuDeGX4Z808MGpIBTvudbKMhEypdOB9+b2eetWHhTcBnQBg1Ez7ABMdNjxa+NzkNUUcyRKqW/T5/B3GVeTPeGOMLqoXGjf0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=tHn15Xxm; arc=none smtp.client-ip=159.100.241.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="tHn15Xxm"
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.113.132])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id D388B20113
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 01:56:57 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 9EE3E3E8D0;
	Mon,  2 Sep 2024 03:56:49 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id A2ACE40095;
	Mon,  2 Sep 2024 01:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1725242207; bh=R/yiV9s8Z3jqlBYw2L7Um1OXYJNKCGfHGoDM/ulLzxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHn15XxmiK31Fem9XJirBWFI+EuAXxmZsPtGfU56ahUIAkRYi1R+egnX0WDB35BVi
	 cmH6+gN/nh5RMqJVUEY3SRl+r6lFwvSru31+Trm0MBJc2ttoYT4ol4HmIMpUmn3G8b
	 w8mAPP85WPxCp4eXY9w4ALzDrqTVt7fKwz9487VY=
Received: from localhost.localdomain (unknown [58.32.40.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 8840040CF0;
	Mon,  2 Sep 2024 01:56:41 +0000 (UTC)
From: Kexy Biscuit <kexybiscuit@aosc.io>
To: gregkh@linuxfoundation.org
Cc: jarkko@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	stefanb@linux.ibm.com,
	kernel test robot <lkp@intel.com>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Mingcong Bai <jeffbai@aosc.io>
Subject: breaks ibmvtpm to be built as a module, since tpm2_sessions_init isn't
Date: Mon,  2 Sep 2024 09:54:31 +0800
Message-ID: <20240902015430.54159-2-kexybiscuit@aosc.io>
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
X-Rspamd-Queue-Id: A2ACE40095
X-Rspamd-Server: nf2.mymailcheap.com
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
X-Rspamd-Action: no action

------------------

From 3e43cfa3466178ec7f4309031647e93565bc70bf Mon Sep 17 00:00:00 2001
From: Kexy Biscuit <kexybiscuit@aosc.io>
Date: Mon, 2 Sep 2024 08:26:38 +0800
Subject: [PATCH] tpm: export tpm2_sessions_init() to fix ibmvtpm building

Commit 08d08e2e9f0a ("tpm: ibmvtpm: Call tpm2_sessions_init() to
initialize session support") adds call to tpm2_sessions_init() in ibmvtpm,
which could be built as a module. However, tpm2_sessions_init() wasn't
exported, causing libmvtpm to fail to build as a module:

ERROR: modpost: "tpm2_sessions_init" [drivers/char/tpm/tpm_ibmvtpm.ko] undefined!

Export tpm2_sessions_init() to resolve the issue.

Cc: stable@vger.kernel.org # v6.10+
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408051735.ZJkAPQ3b-lkp@intel.com/
Signed-off-by: Kexy Biscuit <kexybiscuit@aosc.io>
Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
---
 drivers/char/tpm/tpm2-sessions.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index d3521aadd43ee..44f60730cff44 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -1362,4 +1362,5 @@ int tpm2_sessions_init(struct tpm_chip *chip)
 
 	return rc;
 }
+EXPORT_SYMBOL(tpm2_sessions_init);
 #endif /* CONFIG_TCG_TPM2_HMAC */
-- 
2.46.0

