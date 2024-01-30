Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400657351A
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714328502; cv=none; b=WbnfYG+k+egCsW/4+z3ZpcXOsp4LKkGvnXrie/yBh1m9OT9hI31YHd3fk1N1dhvNJljRtTmfY+MbHeEUxSm369AZYZHWJbUajUMKoEWJ3a+bbuSCMkax+yKKY4OvQrdimXUXDpTFkGT92uPMGwcytu/5nT0CAc2VAh0ZvOiQdZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714328502; c=relaxed/simple;
	bh=/oqmtpSqgS0oRYpjoZJXvxx1gq9IQS5Ja+JYSs4hW1s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=csGJBxb/5ehvmuSV9LVZ1u4jzmQ6Y26ZCAjfZJ3uXOfXFy//lMsOlbgNlmfX35GQ9XnJqAUAlS2Eoo9TuXGfKAL5Hl2ErxGn4agMyavaK8HsiMOXp1uCWQ8imq4I3Mf0gqc9Pqb0sa2ba5h4GVfUAWtkAQAtV/40wIqpFo48GB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=alien8.de; dkim=permerror (0-bit key) header.d=gmail.com header.i=@gmail.com header.b=BHD3++oE; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=gmail.com header.i=@gmail.com header.b="BHD3++oE"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 103D840E024C
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iR_UBxx4buas for <patches@lists.linux.dev>;
	Sun, 28 Apr 2024 18:21:28 +0000 (UTC)
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 61BE440E00B2
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:27 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Sun, 28 Apr 2024 20:21:19 +0200
Resent-Message-ID: <20240428182119.GBZi6Tn-FVCl-zOo3Y@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from mail.alien8.de
	by mad with LMTP
	id kRD/L2EOuWVl5A4Ac81XFw
	(envelope-from <adrianhuang0701@gmail.com>)
	for <bp@alien8.de>; Tue, 30 Jan 2024 14:57:37 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AA70340E01BB
	for <bp@alien8.de>; Tue, 30 Jan 2024 14:57:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ymxEqr1rL-u0 for <bp@alien8.de>;
	Tue, 30 Jan 2024 14:57:31 +0000 (UTC)
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 3BABB40E016C
	for <bp@alien8.de>; Tue, 30 Jan 2024 14:57:23 +0000 (UTC)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1d76671e5a4so28627365ad.0
        for <bp@alien8.de>; Tue, 30 Jan 2024 06:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706626641; x=1707231441; darn=alien8.de;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qgdF93aCFnFU++AdEyhzJAawndOS4U2ZSHllF/Afcf0=;
        b=BHD3++oEKzUbeGTmWKHcE94hioRz5EQsj/eSdsf0KzyANLcXxwJSitWx6oOhEOUy4B
         34lFPn2S3zcPyafNoYmCXHeNaEzsWpDl52xTa3QyXRxfxUP0fvjd3Qc3jsLEmeih+9Dw
         xEQ+KJBsTV1DYIWss8PT8TgE9ECdxUEKkMYeHwQGqw1ETSJ8QX8DU5ERuAVYlISgV9Ce
         x2suLqXAMPmIOfz+4liNurhleVm6BtgkF4HbibCQLdHPrOf0aYjCRJnOXxjGU/fQzTjt
         BFhKOcRPkdNBGHi9lC7QnayovzD2ZUxWHUQd8MUgAtqVwqb03vc96yaaGvWgFByPO1y2
         kgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706626641; x=1707231441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qgdF93aCFnFU++AdEyhzJAawndOS4U2ZSHllF/Afcf0=;
        b=Uxg9OvwI3bWWYU2Bn04ooWlthLwuUfOCYWBGEQ6zcEwaT2kAFPudPvioTQQ//WU6v9
         BQq9L5OD0lUnWvzz7IfrMXKKnGgGyGjsyky9LQpJhIV1pdRF9JNGHzgrTgVfNHK0Ee9j
         lEpZ1J4vFvJS5vXOs1koIdjV3r2IQFUGPmMyW/Tvi6aOQK46GZyDXz0ratQaAOhLMARt
         9jQ4DZE2i6XMyVQO927RIYAPCkQZHYbUczzhUnUQJjewnVX7ms8/TFLEDhMuX/W3g+NP
         FePFAAJbSHC5IVfycJ4Z9qFfh2OJMVtjqMTt4Ocamu9UEAyBaDZOWR5CFF7J9GNKNHjb
         4C7A==
X-Gm-Message-State: AOJu0YwkXWl6wDFOHZnnAgo7ujb3pGhMc4bo4YRSFc/IGGCluyDaWI9M
	DRuguWUFPP5YifgSvwuLKKjTVltIfBaAGUOG40RisOnuGRA3w+hC61xMsBK9Rk520w==
X-Google-Smtp-Source: AGHT+IEzTXPryEhY5ACsO17SDG1eY2YeK28gwBSFRp5XjIUqSN3VxRinsO6zJGlqOrY/QXu+QoDCpw==
X-Received: by 2002:a17:903:2d1:b0:1d5:8ce6:e4b1 with SMTP id s17-20020a17090302d100b001d58ce6e4b1mr9313826plk.43.1706626641298;
        Tue, 30 Jan 2024 06:57:21 -0800 (PST)
Received: from AHUANG12-3ZHH9X.lenovo.com (220-143-209-60.dynamic-ip.hinet.net. [220.143.209.60])
        by smtp.gmail.com with ESMTPSA id w7-20020a1709029a8700b001d755acec64sm7251656plp.189.2024.01.30.06.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 06:57:20 -0800 (PST)
From: Adrian Huang <adrianhuang0701@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org,
	Adrian Huang <adrianhuang0701@gmail.com>,
	Adrian Huang <ahuang12@lenovo.com>
Subject: [PATCH] x86/apic: Fix APIC MSR access error when x2apic is disabled
Date: Tue, 30 Jan 2024 22:56:01 +0800
Message-Id: <20240130145601.7063-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 3BABB40E016C
X-Spamd-Result: default: False [-2.63 / 20.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 ARC_NA(0.00)[];
	 RECEIVED_SPAMHAUS_PBL(0.00)[220.143.209.60:received];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_FROM(0.00)[gmail.com];
	 R_SPF_ALLOW(-0.20)[+ip6:2607:f8b0:4000::/36];
	 MIME_GOOD(-0.10)[text/plain];
	 PREVIOUSLY_DELIVERED(0.00)[bp@alien8.de];
	 RCVD_COUNT_THREE(0.00)[3];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2607:f8b0:4864:20::636:query timed out];
	 DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 MID_CONTAINS_FROM(1.00)[];
	 NEURAL_HAM(-0.00)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_ENVFROM(0.00)[gmail.com];
	 ASN(0.00)[asn:15169, ipnet:2607:f8b0::/32, country:US];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-2.83)[99.26%];
	 FREEMAIL_CC(0.00)[kernel.org,gmail.com,lenovo.com]
X-Rspamd-Server: mad
Content-Transfer-Encoding: quoted-printable

From: Adrian Huang <ahuang12@lenovo.com>

When appending the 'iommu=3Doff' kernel parameter, the kernel complains
about the following error message [1]:

unchecked MSR access error: RDMSR from 0x802 at rIP: 0xffffffff94079992 (=
native_apic_msr_read+0x12/0x50)

The root cause is that:
  1. x2apic_mode is configured as '1' in check_x2apic().
  2. apic_x2apic_cluster (assigned to global variable 'apic') is
     selected in default_acpi_madt_oem_check().
  3. x2apic_disable() is invoked in try_to_enable_x2apic().
     Call path:
       enable_IR_x2apic
        |- try_to_enable_x2apic
          |- x2apic_disable
            |- __x2apic_disable
            |- apic_set_fixmap
              |- apic_read_boot_cpu_id(false)
  4. read_apic_id() in apic_read_boot_cpu_id() invokes
     native_apic_msr_read(), which leads to the error message.
     Call path:
       apic_read_boot_cpu_id
         |- read_apic_id
           |- apic_read
             |- apic->read() ['apic' points to apic_x2apic_cluster]
	       |- native_apic_msr_read

Since x2apic mode has been disabled by writing MSR_IA32_APICBASE in
__x2apic_disable, the upcoming MSR accesses will trigger the MSR
access error. Note that APIC and x2APIC registers are accessed via
MMIO in xapic mode and those regiters are access via the MSR-based
interface in x2apic mode [2].

Fix the issue by checking if boot_cpu_physical_apicid has been
initialized.

[1] https://gist.github.com/AdrianHuang/9e5ce38d410af3ccd0b5ac1703e032bc
[2] Chapter 16, AMD64 Architecture Programmer=E2=80=99s Manual Volume 2:
    System Programming

Fixes: d10a904435fa ("x86/apic: Consolidate boot_cpu_physical_apicid init=
ialization sites")
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
---
 arch/x86/kernel/apic/apic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4667bc4b00ab..6700d6f266ca 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1703,6 +1703,9 @@ static __init void apic_read_boot_cpu_id(bool x2api=
c)
 		boot_cpu_physical_apicid =3D native_apic_msr_read(APIC_ID);
 		boot_cpu_apic_version =3D GET_APIC_VERSION(native_apic_msr_read(APIC_L=
VR));
 	} else {
+		if (boot_cpu_physical_apicid !=3D BAD_APICID)
+			return;
+
 		boot_cpu_physical_apicid =3D read_apic_id();
 		boot_cpu_apic_version =3D GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
--=20
2.25.1

