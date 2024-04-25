Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDAF74297
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714328510; cv=none; b=bOKBKTYI9XByrYdk3iMi8XbB9gIrg/YuztQztqSVjfsbSMFgks8YHalAFX6+arYIQBhx0c79HWGEY4aRyASDPJYaE33+XrGNs69JeMwd/Fk1IqXE6+Is8oRwtzw9FuyZwnfwYmqVzStesFS4+rnBjWZi47+Klk62Pi4iDHKP3MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714328510; c=relaxed/simple;
	bh=zU+HLK0DPGMZjwJN7McVaXApdO43oLoITJs1JVkgncM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=S3pKlLG+8dRB/xVdG8cK3jxWAPFJ4rnxYNlk1yOFTfkrlyNLfJEnKAt35vTycAhnW8OXzPZoCcrJdx+uM9kacbghSJj9TELaeGJnN0s2jdo15BR1FnH5J6WVFxYryCd0v5BSCV8vfe0103kXfPea5aVarv6aodEFoKM2p032oY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=O1pDocx0; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=oWaG4iRI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="O1pDocx0";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="oWaG4iRI"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3024740E0249
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id sKymE2jWPBQ7 for <patches@lists.linux.dev>;
	Sun, 28 Apr 2024 18:21:41 +0000 (UTC)
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 67FAC40E0205
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:40 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Sun, 28 Apr 2024 20:21:39 +0200
Resent-Message-ID: <20240428182139.GEZi6Ts_dRuNstwAbj@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from mail.alien8.de
	by mad with LMTP
	id IG4qBp7ZKmYhkxoAc81XFw
	(envelope-from <tglx@linutronix.de>)
	for <bp@alien8.de>; Thu, 25 Apr 2024 22:30:54 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EA19A40E01C5
	for <bp@alien8.de>; Thu, 25 Apr 2024 22:30:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RynOVu3nbrRE for <bp@alien8.de>;
	Thu, 25 Apr 2024 22:30:48 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 0E22A40E00C7
	for <bp@alien8.de>; Thu, 25 Apr 2024 22:30:41 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1714084239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hob8dDlH0Re1iEGHVPYkvQV+NW+0K67fDwBWu/fzKlI=;
	b=O1pDocx0H4iIfkF03B+XPWmGCEewSOVlZuovpnKLihhfJ+NkndIjjgMNfdSelHa34ekzDf
	wsjYQeL+xLyp9j4nrtPxD7PfDZFszztxuRKdhIa8oU8WSPuhObq1qiowexL3xEo8BbMSv1
	L+JzmzVEOORI/NQLCYd3Ek1k6vbGvUqKdHNGl5FvqLmQMLa+npXTbNsgAYoVvAjNeT+feo
	eJtii2jm43ilhCzc7c6APC5S8h/gN0Z0N7AHIbSps5uXn+uAL9V0hhCRsD+doRUJFFFtcv
	8+bBavwwk+DnOqhirXyoSNcH/0mFbMiMgSLu77Yc1zYCBAGtk97zmJnEwjjpYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1714084239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hob8dDlH0Re1iEGHVPYkvQV+NW+0K67fDwBWu/fzKlI=;
	b=oWaG4iRIGtbeSJSaM0sgGgFJKK/3V7DUzRDWJ7+lTP+0sBlI/DG1uSrTH0JTZ85KPUbmWQ
	dmtw1xABpqwaJsBQ==
To: Adrian Huang12 <ahuang12@lenovo.com>, Adrian Huang
 <adrianhuang0701@gmail.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Adrian Huang <adrianhuang0701@gmail.com>
Subject: [PATCH] x86/apic: Don't access the APIC when disabling X2APIC
In-Reply-To: <TYZPR03MB61928B8AE3F14E86069BDE6BB34D2@TYZPR03MB6192.apcprd03.prod.outlook.com>
References: <20240130145601.7063-1-adrianhuang0701@gmail.com>
 <87eddggvlh.ffs@tglx>
 <TYZPR03MB61928B8AE3F14E86069BDE6BB34D2@TYZPR03MB6192.apcprd03.prod.outlook.com>
Date: Fri, 26 Apr 2024 00:30:36 +0200
Message-ID: <875xw5t6r7.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 0E22A40E00C7
X-Spamd-Result: default: False [-3.50 / 20.00];
	 TO_DN_EQ_ADDR_SOME(0.00)[];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[linutronix.de:s=2020,linutronix.de:s=2020e];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_SPF_ALLOW(-0.20)[+mx];
	 MIME_GOOD(-0.10)[text/plain];
	 MAILSPIKE_FAIL(0.00)[193.142.43.55:query timed out];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_TRACE(0.00)[linutronix.de:+];
	 DMARC_POLICY_ALLOW(-0.50)[linutronix.de,none];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 NEURAL_HAM(-0.00)[-1.000];
	 FREEMAIL_TO(0.00)[lenovo.com,gmail.com,redhat.com,alien8.de,linux.intel.com];
	 RCVD_COUNT_ZERO(0.00)[0];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 ASN(0.00)[asn:48314, ipnet:193.142.43.0/24, country:DE];
	 FREEMAIL_CC(0.00)[kernel.org,gmail.com];
	 BAYES_HAM(-3.00)[99.99%]
X-Rspamd-Server: mad

With 'iommu=off' on the kernel command line and X2APIC enabled by the BIOS
the code which disables the X2APIC triggers an unchecked MSR access error:

  RDMSR from 0x802 at rIP: 0xffffffff94079992 (native_apic_msr_read+0x12/0x50)                                                                                                                                      

This is happens because default_acpi_madt_oem_check() selects an X2APIC
driver before the X2APIC is disabled.

When the X2APIC is disabled because interrupt remapping cannot be enabled
due to 'iommu=off' on the command line, x2apic_disable() invokes
apic_set_fixmap() which in turn tries to read the APIC ID. This triggers
the MSR warning because X2APIC is disabled, but the APIC driver is still
X2APIC based.

Prevent that by adding an argument to apic_set_fixmap() which makes the
APIC ID read out conditional and set it to false from the X2APIC disable
path. That's correct as the APIC ID has already been read out during early
discovery.
 
Fixes: d10a904435fa ("x86/apic: Consolidate boot_cpu_physical_apicid initialization sites")
Reported-by: Adrian Huang <ahuang12@lenovo.com>                                                                                                                                                                                             
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Adrian Huang <ahuang12@lenovo.com>                                                                                                                                                                                             
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/apic/apic.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1771,7 +1771,7 @@ void x2apic_setup(void)
 	__x2apic_enable();
 }
 
-static __init void apic_set_fixmap(void);
+static __init void apic_set_fixmap(bool read_apic);
 
 static __init void x2apic_disable(void)
 {
@@ -1793,7 +1793,12 @@ static __init void x2apic_disable(void)
 	}
 
 	__x2apic_disable();
-	apic_set_fixmap();
+	/*
+	 * Don't reread the APIC ID as it was already done from
+	 * check_x2apic() and the apic driver still is a x2APIC variant,
+	 * which fails to do the read after x2APIC was disabled.
+	 */
+	apic_set_fixmap(false);
 }
 
 static __init void x2apic_enable(void)
@@ -2057,13 +2062,14 @@ void __init init_apic_mappings(void)
 	}
 }
 
-static __init void apic_set_fixmap(void)
+static __init void apic_set_fixmap(bool read_apic)
 {
 	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
 	apic_mmio_base = APIC_BASE;
 	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
 		    apic_mmio_base, mp_lapic_addr);
-	apic_read_boot_cpu_id(false);
+	if (read_apic)
+		apic_read_boot_cpu_id(false);
 }
 
 void __init register_lapic_address(unsigned long address)
@@ -2073,7 +2079,7 @@ void __init register_lapic_address(unsig
 	mp_lapic_addr = address;
 
 	if (!x2apic_mode)
-		apic_set_fixmap();
+		apic_set_fixmap(true);
 }
 
 /*
