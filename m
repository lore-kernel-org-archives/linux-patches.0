Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442A6249E0
	for <patches@lists.linux.dev>; Wed, 17 Jan 2024 19:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705519898; cv=none; b=DODFJMzlgYGrtmWDROY5EuWCQ+oYY0Ux781qch44wFaSBgLtYyxiEdQv7GKUR7nKJY6s3z//z5mI2/yx8IPBKv/rjKyEp/fHSkto+NHZgw1mvPWwD/aFTXURC36RjCSaEKEieHpzpdEUiwEKK+/uBYllxQTV+LE1mxkA1Bp7PY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705519898; c=relaxed/simple;
	bh=RQIr6Kts6RKQbAUAW6opi0FtsYiev60PYalY1DM5tRY=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:From:To:Subject:Date:
	 Message-Id:X-Mailer:X-Original-To:Delivered-To:Received:
	 X-Original-To:Delivered-To:Received:Received:X-IronPort-AV:
	 X-IronPort-AV:Received:IronPort-SDR:X-IPAS-Result:IronPort-PHdr:
	 IronPort-Data:IronPort-HdrOrdr:X-Talos-CUID:X-Talos-MUID:
	 X-IronPort-Anti-Spam-Filtered:X-IronPort-AV:X-IronPort-AV:
	 X-Amp-Result:X-Amp-File-Uploaded:Received:Received:DKIM-Signature:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Google-Smtp-Source:
	 X-Received:Mime-Version:X-Mailer:Content-Type:X-UID:X-Keywords:
	 Content-Transfer-Encoding; b=nMjAEDiewdxIQzkev1F/lu94bDFFB4ADlz3yNMxm5LzvQuSCXJ0AZDyUnnDp3htXZaiFaDV2UcWJITXfLcmeA/OovoIpJN7moC60UJzj+GcdqeVdWC9hyaoLJYM6l3GzHyNiYixMXHZwbovvcYvSibOPeAZQdu6Cp6CUPguY6OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WiPGQ14j; dkim=fail (2048-bit key) header.d=google.com header.i=@google.com header.b=PKgTmXOn reason="signature verification failed"; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WiPGQ14j";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="PKgTmXOn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705519896; x=1737055896;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RQIr6Kts6RKQbAUAW6opi0FtsYiev60PYalY1DM5tRY=;
  b=WiPGQ14j1jYHb3PUTZaba5dMmZgSM9ai3ztjNB3rxfaGp/ap17J4JTaE
   c4mMmaIq8ug4uR955CD+rfEBK5ZgIIL0lQLWJ3Ijs4i2F/fwDIqrElUcV
   fHRa7Y66eMGng2faHBSSeXCr3+avyYwK/U234O+oPib7rhvAtR+s62PTi
   bcq9ozGTMbXEW8JTgvN3RO8DQjECeo1mJ1bvGWu6OigGtcTOBAUhTgwlK
   h72TOwv9cEtTwpJTcbsv/cTWc4sphu3S1IO+gDFpt0jLkiGm7X6SyRB1Q
   3fdVBV/72pD0wTP+Js1eDy66QiWmAQhqDUfWwBiASpbVbYZzYv2SWI8ir
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="147647"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="147647"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 11:31:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="957603267"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="957603267"
Received: from viggo.jf.intel.com (HELO ray2.amr.corp.intel.com) ([10.54.77.144])
  by orsmga005.jf.intel.com with ESMTP; 17 Jan 2024 11:31:34 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
To: patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH] x86/fpu: verify xstate buffer size according with requested features
Date: Wed, 17 Jan 2024 11:31:39 -0800
Message-Id: <20240116234901.3238852-1-avagin@google.com>
X-Mailer: git-send-email 2.34.1
Received: from ray2 (localhost [127.0.0.1]) by ray2.sr71.net (Postfix) with ESMTP id 2C90F6A7 for <dave@localhost>; Tue, 16 Jan 2024 15:49:59 -0800 (PST)
Received: from linux.intel.com [10.54.29.200] by ray2 with IMAP (fetchmail-6.4.27 polling linux.intel.com account dave.hansen folder Inbox) for <dave@localhost> (single-drop); Tue, 16 Jan 2024 15:49:59 -0800 (PST)
Received: from fmsmga001.fm.intel.com (fmsmga001.fm.intel.com [10.253.24.23]) (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits)) (No client certificate requested) by linux.intel.com (Postfix) with ESMTPS id 704AC580DB4 for <dave.hansen@linux.intel.com>; Tue, 16 Jan 2024 15:49:17 -0800 (PST)
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="927662622"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400";  d="scan'208";a="927662622"
Received: from orsmga101.jf.intel.com ([10.7.208.22]) by fmsmga001-1.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 15:49:16 -0800
Authentication-Results: mtab.intel.com; spf=None smtp.pra=avagin@google.com; spf=Pass smtp.mailfrom=3-RWnZQYKC_QWrWcejckkcha.YkiZWra.dWjoajhejqt.ejpah.Yki@flex--avagin.bounces.google.com; spf=None smtp.helo=postmaster@mail-yb1-f202.google.com; dkim=pass (signature verified) header.i=@google.com; dmarc=pass (p=reject dis=none) d=google.com
IronPort-SDR: 65a715fb_zSb+0PeTstvp3Z/O6XlGsKSWkCYNIA6W+tSCuvfvI7naIYP O1GaLrUfAL4dQwoMBx3WUSofxF6I9KvgA8YKp4g==
X-IPAS-Result: =?us-ascii?q?A0H4AwCFFadle8rbVdFagQmECIFRMwQLSIRTkWOcL4J7A?= =?us-ascii?q?xhNAQEBAQEBAQEBCUQEAQEDBIR7AodKAh4HAQQ0EwECAQIBAQEBAQMCAQIBA?= =?us-ascii?q?QEBAQEIAQEBAgIBAQECAQECBAMBAQEBAhABASQYBhAOJ4VsDYJcARCBDF0CB?= =?us-ascii?q?gM2AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBEQJHWhEEGQEBNwEoDAImAjUBB?= =?us-ascii?q?QEiARIigl6CYAMFqAmBBUKLO38zgQGCCgEBBgQDAgOCWq42gWEJFIEGLoVbg?= =?us-ascii?q?kABgVCCdYEig0GBIRuBSUSEfYEFAYFbAoU7gmiCGYNCkGkJQYEIBB0DgQZvG?= =?us-ascii?q?w8eNxEQEw0DCG4dAhEiPAMFAwQyChIMCyEFE0IDQwZJCwMCGgUDAwSBMAUNG?= =?us-ascii?q?gIQLCYDAxJJAhAUAzgDAwYDCjEDMFVBDFADThcfGhgJPA8MGgIbHg0nIwIsQ?= =?us-ascii?q?AMRBRACFgMkFgQ2EQkLJgMqBjoCEgwGBgkpNCYWCQQlAwgEA1QDI3QRAwQKA?= =?us-ascii?q?xQHCwd7ghkDCQMHBSwdQAMLGA1IESwUIQYOGwY+bweXMQcBPBsjFIIFMT0CH?= =?us-ascii?q?JJdkWmgXYQbiFWYQRozqhEBmFIgoyOFFxAjgVcjPIEgMxoIGxWDIk8DGQ+OL?= =?us-ascii?q?AsLg1aQGiMyOwIHCwEBAwmJIoFGAQE?=
IronPort-PHdr: A9a23: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
IronPort-Data: A9a23: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 Zus
IronPort-HdrOrdr: A9a23:Zwew/qAYuY+MQ3/lHemV55DYdb4zR+YMi2TDGXoBLyC9E/bo7v xG+c5w6faaslcssR0b6LS90cu7MBHhHO9OgbX5VI3KNGLbUQCTXeRfBOXZslrd8u7FmtK1F5 0MT0GzMrLN5CBB/KXHCcCDfeod/A==
X-Talos-CUID: 9a23:Y4HuN2M7FyUOHO5DQCBM+G4JROIcUVLc8lPoPFabSl91R+jA
X-Talos-MUID: 9a23:kYtltQRBAkqorCTaRXTnlg8lKd956ZjpGU8rvb8eosWlGAlZbmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="390474958"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400";  d="scan'208";a="390474958"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from mail-yb1-f202.google.com ([209.85.219.202]) by mtab.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 15:49:14 -0800
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe053d5d91so14202172276.2 for <dave.hansen@linux.intel.com>; Tue, 16 Jan 2024 15:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20230601; t=1705448953; x=1706053753; darn=linux.intel.com; h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject :date:message-id:reply-to; bh=6BtsE2x/AkNe3yH4rPWS1VC4ZtcATA4Da7HNUY3aGzQ=; b=PKgTmXOnFQa8E4yQx0eZarramtbOg9RxElVQ12xAOVCvO2FC1sOBd6nSOSvZXVcYs8 1JIkv+OfFDz3Tvm29A//xNc2dQ1545FU9Bf2ms+W+Uc96Bj9KWsQTLA2w1uwSvd6j9JA GgY8Wg+SQr7j26Dx9f/cu5pJgWrWuUMafZOdGMMVieWnogbv5gtNYgQEg32NFXI+pBPI CYH6owTarBDlbUJBNJwJbNwO0QeFmOQv6BDLWeMWpyzJ/Mq9H/GBusrOkg1QdoWuaoRi jOxBaR3lq+2n0RTyShjWherfOZf4f/G4nfr21B88kpqzHhlKBRiDtRHwXkWQ9tB1A8hV X5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net; s=20230601; t=1705448953; x=1706053753; h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state :from:to:cc:subject:date:message-id:reply-to; bh=6BtsE2x/AkNe3yH4rPWS1VC4ZtcATA4Da7HNUY3aGzQ=; b=C8rE1rnhcfiBWIByMG9oKhQHL+/iEyveUcLETKi8em7EshMXAXpuwfg2PYjZjmlcKM GmPJp/D0aiBh2hfpVvc6xXgw4UhBqEDwP9Ilf4YFmnSRV1U6dDKA64FPa7pUN4BDQqXx 4ekV8f1dh/6FbF6Cgry6o+UeCdw0wOeJQLvMPOBfGASq7+5cVotxYgoUA3vpDkAFsY+5 ExwZ0aGEVqIkjQdBMZsEiqzOyiGXzEkNdpCG+pLZsYvQoZyUiuvW3GYdqjkZ7NDRF1Tq uGCt61B0SQFg+cW8pcFf4vxh/LZpz0CuGS1FJ6E3no/3Wr00vxh6bRVFecgiJRdR3g6y /o3Q==
X-Gm-Message-State: AOJu0YxOu7dxncwazj+shSrZngEO02DIu/3Cc5ibDcgd72MkFMCSagR5 I6WHPkVa9o5eaP+63Q2gKyyTRpLYsmWGeEHFvQ==
X-Google-Smtp-Source: AGHT+IHDKQEkmhIXluNZ7P31ItJSPFfe/OMhwIrXaKB6KcgUa2M11vBPBDzTRMbJyTuMhwZpIiZUOyLCHP4=
X-Received: from avagin.kir.corp.google.com ([2620:0:1008:10:7a82:eb14:6296:8b59]) (user=avagin job=sendgmr) by 2002:a25:7387:0:b0:dc2:1bde:b7ed with SMTP id o129-20020a257387000000b00dc21bdeb7edmr1020049ybc.8.1705448953533; Tue, 16 Jan 2024 15:49:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Content-Type: text/plain; charset="UTF-8"
X-UID: 139759
X-Keywords: NonJunk                                                                      
Content-Transfer-Encoding: 8bit

From: Andrei Vagin <avagin@google.com>

Users must provide buffers that fit states of all requested features.
Otherwise, the kernel can be stuck in an endless loop:
 * xrstor faults outside of the provided buffer.
 * fault_in_readable scans the buffer and restarts the first step
   because the entire buffer is present in memory.

Fixes: fcb3635f5018 ("x86/fpu/signal: Handle #PF in the direct restore path")
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 arch/x86/kernel/fpu/signal.c | 23 +++++++++++++++++------
 arch/x86/kernel/fpu/xstate.c |  2 +-
 arch/x86/kernel/fpu/xstate.h |  2 ++
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 558076dbde5b..fea02fe7f712 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -27,28 +27,39 @@
 static inline bool check_xstate_in_sigframe(struct fxregs_state __user *fxbuf,
 					    struct _fpx_sw_bytes *fx_sw)
 {
-	int min_xstate_size = sizeof(struct fxregs_state) +
-			      sizeof(struct xstate_header);
-	void __user *fpstate = fxbuf;
+	struct fpstate *fpstate = current->thread.fpu.fpstate;
+	void __user *buf = fxbuf;
 	unsigned int magic2;
 
 	if (__copy_from_user(fx_sw, &fxbuf->sw_reserved[0], sizeof(*fx_sw)))
 		return false;
 
+	/* Restore enabled features only. */
+	fx_sw->xfeatures &= fpstate->user_xfeatures;
+
 	/* Check for the first magic field and other error scenarios. */
 	if (fx_sw->magic1 != FP_XSTATE_MAGIC1 ||
-	    fx_sw->xstate_size < min_xstate_size ||
-	    fx_sw->xstate_size > current->thread.fpu.fpstate->user_size ||
 	    fx_sw->xstate_size > fx_sw->extended_size)
 		goto setfx;
 
+	/* xstate_size has to fit all requested components. */
+	if (fx_sw->xstate_size != fpstate->user_size) {
+		int min_xstate_size =
+			xstate_calculate_size(fx_sw->xfeatures, false);
+
+		if (min_xstate_size < 0 ||
+		    fx_sw->xstate_size < min_xstate_size ||
+		    fx_sw->xstate_size > fpstate->user_size)
+			goto setfx;
+	}
+
 	/*
 	 * Check for the presence of second magic word at the end of memory
 	 * layout. This detects the case where the user just copied the legacy
 	 * fpstate layout with out copying the extended state information
 	 * in the memory layout.
 	 */
-	if (__get_user(magic2, (__u32 __user *)(fpstate + fx_sw->xstate_size)))
+	if (__get_user(magic2, (__u32 __user *)(buf + fx_sw->xstate_size)))
 		return false;
 
 	if (likely(magic2 == FP_XSTATE_MAGIC2))
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 117e74c44e75..35a1ccbba55d 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -556,7 +556,7 @@ static bool __init check_xstate_against_struct(int nr)
 	return true;
 }
 
-static unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
+unsigned int xstate_calculate_size(u64 xfeatures, bool compacted)
 {
 	unsigned int topmost = fls64(xfeatures) -  1;
 	unsigned int offset = xstate_offsets[topmost];
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 3518fb26d06b..93ed710e76ac 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -69,6 +69,8 @@ static inline u64 xfeatures_mask_independent(void)
 	return XFEATURE_MASK_INDEPENDENT;
 }
 
+unsigned int xstate_calculate_size(u64 xfeatures, bool compacted);
+
 /* XSAVE/XRSTOR wrapper functions */
 
 #ifdef CONFIG_X86_64
-- 
2.43.0.429.g432eaa2c6b-goog

