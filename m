Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B5D74297
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714328502; cv=none; b=gjAM6IOhANFkTYzOMh8sNOXq+tSQX/8WrLUhYBFiP4sQ6dWNHt3eVdln4Aq7Uw8ogR7dpNoanCM07i1fPgw/Uq2Ei0O14B/WvrE7XSbSlMrIquOuBSNyVlCt2+AN90Ub12P8PQh+gZP4s3fe/rQ+gszFhUJwSNl7HVKGNreSK2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714328502; c=relaxed/simple;
	bh=M86GfhVMIvWlMlsSsZz/umvtEwpZopH5N8yx6cGPFZ4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=io9jAx2GirgFoyti1vJRJcHuiC3ZBrZtCrlzEaP2ykVlTSAMzFdksztSkLBYSx0kUXu4jkXu3ne9SUucgY2DPrP2vrQ9qrO7Q2V8vK/L57yhb1aXx4OXKc6nCzZYYGDyKVAvLW3ECPBfrx+yk2fCvVPkc8Xfqbr4Tr1Rt0bhu1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Th59lYrA; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=MEqkWJ4Y; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Th59lYrA";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="MEqkWJ4Y"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BF34640E00B2
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:38 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Mof1F_blV-4t for <patches@lists.linux.dev>;
	Sun, 28 Apr 2024 18:21:32 +0000 (UTC)
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6AB4F40E0205
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 18:21:32 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Sun, 28 Apr 2024 20:21:31 +0200
Resent-Message-ID: <20240428182131.GCZi6Tq2leBuD16qs1@fat_crate.local>
Resent-To: patches <patches@lists.linux.dev>
Received: from mail.alien8.de
	by mad with LMTP
	id iMXuBBmdy2VZ6wYAc81XFw
	(envelope-from <tglx@linutronix.de>)
	for <bp@alien8.de>; Tue, 13 Feb 2024 16:47:21 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 09E6A40E023B
	for <bp@alien8.de>; Tue, 13 Feb 2024 16:47:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yJV0x2z0YlnC for <bp@alien8.de>;
	Tue, 13 Feb 2024 16:47:15 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id B516540E00B2
	for <bp@alien8.de>; Tue, 13 Feb 2024 16:47:08 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1707842826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+dvFIQrqQTgdp0PWYvdUIBcrXKWbLfN+L54sJujZLQ=;
	b=Th59lYrAk1dq4WV/r01HYpBcn+t4amw21YTL4RYEqXRFNtPQ3/CA5ZcukkdiwR30Q5UYXV
	RgbJcd02Sn6wsMsxb1CMK/MqOJNPNobDa8iqLw+T8i/iiLWegWPNpfkaOU6FiCQ8DiqoNL
	CKKFm4ieEMoSuViR5N22EmbgT0ZKnofaAQ3eOH2H58zzn7/QJb9kftOZFaV50+qGtE1DxR
	Zoz0XF59U6hOvWNcMWPYNm+Sly559tfIcEJ9XSjpkTNP6u0qbU9ep32XLlLGvVRsTERJnz
	E4S9873EE/yfISZr3kEYOKLvULK1dD42OPO/qC9Gwn2HQPskrHqY/136CD8pbA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1707842826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+dvFIQrqQTgdp0PWYvdUIBcrXKWbLfN+L54sJujZLQ=;
	b=MEqkWJ4YHJMmTLvGxipB6ZbSCGZ6XM8fDNM0t5yyx6U8W/yzbDlHz+B4fGtoj0KVY00dkt
	kiveS+IsJ8phjwDw==
To: Adrian Huang <adrianhuang0701@gmail.com>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, Adrian Huang <adrianhuang0701@gmail.com>, Adrian Huang
 <ahuang12@lenovo.com>
Subject: Re: [PATCH] x86/apic: Fix APIC MSR access error when x2apic is
 disabled
In-Reply-To: <20240130145601.7063-1-adrianhuang0701@gmail.com>
References: <20240130145601.7063-1-adrianhuang0701@gmail.com>
Date: Tue, 13 Feb 2024 17:47:06 +0100
Message-ID: <87eddggvlh.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B516540E00B2
X-Spamd-Result: default: False [-3.50 / 20.00];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[linutronix.de:s=2020,linutronix.de:s=2020e];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_SPF_ALLOW(-0.20)[+mx];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_TRACE(0.00)[linutronix.de:+];
	 DMARC_POLICY_ALLOW(-0.50)[linutronix.de,none];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 NEURAL_HAM(-0.00)[-1.000];
	 FREEMAIL_TO(0.00)[gmail.com,redhat.com,alien8.de,linux.intel.com];
	 RCVD_COUNT_ZERO(0.00)[0];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 ASN(0.00)[asn:48314, ipnet:193.142.43.0/24, country:DE];
	 FREEMAIL_CC(0.00)[kernel.org,gmail.com,lenovo.com];
	 BAYES_HAM(-3.00)[99.99%]
X-Rspamd-Server: mad

On Tue, Jan 30 2024 at 22:56, Adrian Huang wrote:
> When appending the 'iommu=3Doff' kernel parameter, the kernel complains
> about the following error message [1]:
>
> unchecked MSR access error: RDMSR from 0x802 at rIP: 0xffffffff94079992 (=
native_apic_msr_read+0x12/0x50)
>
> The root cause is that:
>   1. x2apic_mode is configured as '1' in check_x2apic().
>   2. apic_x2apic_cluster (assigned to global variable 'apic') is
>      selected in default_acpi_madt_oem_check().
>   3. x2apic_disable() is invoked in try_to_enable_x2apic().
>      Call path:
>        enable_IR_x2apic
>         |- try_to_enable_x2apic
>           |- x2apic_disable
>             |- __x2apic_disable
>             |- apic_set_fixmap
>               |- apic_read_boot_cpu_id(false)
>   4. read_apic_id() in apic_read_boot_cpu_id() invokes
>      native_apic_msr_read(), which leads to the error message.
>      Call path:
>        apic_read_boot_cpu_id
>          |- read_apic_id
>            |- apic_read
>              |- apic->read() ['apic' points to apic_x2apic_cluster]
> 	       |- native_apic_msr_read
>
> Since x2apic mode has been disabled by writing MSR_IA32_APICBASE in
> __x2apic_disable, the upcoming MSR accesses will trigger the MSR
> access error. Note that APIC and x2APIC registers are accessed via
> MMIO in xapic mode and those regiters are access via the MSR-based
> interface in x2apic mode [2].

Nice detective work.

Aside of that apic_read_boot_cpu_id() invokes cpu_set_boot_apic() which
accounts for the boot APIC another time.

> Fix the issue by checking if boot_cpu_physical_apicid has been
> initialized.

That works by some definition of works, but why invoking
apic_read_boot_cpu_id() in the first place?

x2apic_disable() knows for sure that X2APIC was enabled early due to
x2apic_state. So it can tell apic_set_fixmap() to _not_ invoke
apic_read_boot_cpu_id(), no?

Something like the untested below.

> [1] https://gist.github.com/AdrianHuang/9e5ce38d410af3ccd0b5ac1703e032bc

That's not really helpful as it's a full dmesg and does not provide any
more information than the above decoded stacktrace.

> [2] Chapter 16, AMD64 Architecture Programmer=E2=80=99s Manual Volume 2:
>     System Programming

Neither this as people who fiddle with X86 APIC internals should know
where to find that information, no?

Thanks,

        tglx
---
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4667bc4b00ab..7fc6d5c2c38c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1808,7 +1808,7 @@ void x2apic_setup(void)
 	__x2apic_enable();
 }
=20
-static __init void apic_set_fixmap(void);
+static __init void apic_set_fixmap(bool read_apic);
=20
 static __init void x2apic_disable(void)
 {
@@ -1830,7 +1830,12 @@ static __init void x2apic_disable(void)
 	}
=20
 	__x2apic_disable();
-	apic_set_fixmap();
+	/*
+	 * Don't reread the APIC ID as it was already done from
+	 * check_x2apic() and the apic driver still is a x2APIC variant,
+	 * which fails to do the read after x2APIC was disabled.
+	 */
+	apic_set_fixmap(false);
 }
=20
 static __init void x2apic_enable(void)
@@ -2095,13 +2100,14 @@ void __init init_apic_mappings(void)
 	}
 }
=20
-static __init void apic_set_fixmap(void)
+static __init void apic_set_fixmap(bool read_apic)
 {
 	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
 	apic_mmio_base =3D APIC_BASE;
 	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
 		    apic_mmio_base, mp_lapic_addr);
-	apic_read_boot_cpu_id(false);
+	if (read_apic)
+		apic_read_boot_cpu_id(false);
 }
=20
 void __init register_lapic_address(unsigned long address)
@@ -2111,7 +2117,7 @@ void __init register_lapic_address(unsigned long addr=
ess)
 	mp_lapic_addr =3D address;
=20
 	if (!x2apic_mode)
-		apic_set_fixmap();
+		apic_set_fixmap(true);
 }
=20
 /*
