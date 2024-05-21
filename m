Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0A550246
	for <patches@lists.linux.dev>; Tue, 21 May 2024 07:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716277820; cv=none; b=qFbY8c7hEWcG+tGxDKgniKYD7WRF0FCGV8sYfgL2Ac5Oa8N59fXOy7+rmuRcOhQjZ64sXC1MyFU9//9dPMlm5+iaotrnOLlZOQwCCqphuSerEbABYD3nKqIuDw3Yo+bXIPX4lB5BPQky2b9TONHbSlaeAmptj/GVmWgRJd0t4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716277820; c=relaxed/simple;
	bh=L/Vg3azzF1AwIKur+spgX2StqpWHdR2fCI0O12zbwSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4cCxeDov9ESw2TyfFRgTweMgdo0qKqNjgw/vyM9zcRF7KsIwrjvfSlnJ+6+3be4VJpAYtfY3v9iVLOPwzVz+fUwzl5mABXpQgUr8lbz9ROGl0VcFhIrv475urxWELsSIP75Ia88HZ9XZ5MbAP5qVVWi32tUkKzm2Qdf4Fu1tlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=AvpIwQgu; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="AvpIwQgu"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BAD0840E02A7;
	Tue, 21 May 2024 07:50:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id AmG9K47KQcgt; Tue, 21 May 2024 07:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1716277810; bh=zhriVY1YS+s2GEj2LKPeJWhuxKvrjyAYCIq8RfPBJmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AvpIwQguEOYipaAs1bqZf9/1aizrJp2VZs+MIa4qYBj8OM+yUXvGDzqwbtozuO5J2
	 e8GQ9/s6/EwMPYkF/1Obts1F6p8npJwJ5j4YIGN1e+yQ4oRzr2yJsxPlQaCvz1tlxv
	 EEAKPz9iPha0lY5n50fUVrunpcedc8+5guTc3niIZOp23OKhfYFpnqfNK+uXwpK2jC
	 VITHotBZsh78UXx7GM+MZTwXVCdq1JvIvBk2i5Yqrbrjk4kprjZn3Oxdne3leiS7qO
	 GTgLZDGUUYocUmxy7IXknRk4exZudgbFgsdtxr4vW1e+G2Vn95J6kQ+MVQT8/F3IAs
	 CagJ9IdpDAoPgKGawFLI13NlBq/4FQT7D/3lvgCosJH5MF4nQSkX05FyIiF6j/gxJP
	 1E98yMy/Cf+eV851+hB5NArK+xAjZR0+YqDofd1xChB5pNoF5qRObGfeJlbn10Tmzr
	 MBsQN7HJrbE5uNNMhOkxs9tXGRTc1b4BRWwv1JQUOec5lxJcP2MwtI41jr59Qk2/Wf
	 KiLhWj13UOGFUMfhQx4OLuTsg3J+vESA2prJt5cQ+6mrczjar1Nau+P+TgERTK6dYr
	 aM8Q5CyXUc3z1eAsYBxp0Z5KfgwdMRVpYcTbVuOY2fkT+XZAAarm+RO5WYhkO2vVAa
	 nW476cxFb6Hf+9IiueKkmAfw=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1859240E01A3;
	Tue, 21 May 2024 07:49:55 +0000 (UTC)
Date: Tue, 21 May 2024 09:49:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 02/49] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <20240521074947.GAZkxSG_u08uLDqZ_m@fat_crate.local>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240520224620.9480-3-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240520224620.9480-3-tony.luck@intel.com>

On Mon, May 20, 2024 at 03:45:33PM -0700, Tony Luck wrote:
> Fixes: 644e9cbbe3fc ("Add driver auto probing for x86 features v4")

Do you really want to backport this to everything since 2012, as that
patch is from then?

> @@ -690,6 +690,7 @@ struct x86_cpu_id {
>  	__u16 model;
>  	__u16 steppings;
>  	__u16 feature;	/* bit index */
> +	__u16 flags;
>  	kernel_ulong_t driver_data;
>  };
>  
> @@ -700,6 +701,9 @@ struct x86_cpu_id {
>  #define X86_STEPPING_ANY 0
>  #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
>  
> +/* x86_cpu_id::flags */
> +#define X86_CPU_ID_FLAG_ENTRY_VALID	BIT(0)

I would definitely not want to have those visible in userspace.

IOW, something like this:

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index 54a71c669ce9..b6325ee30871 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -53,6 +53,9 @@
 #define X86_CENTAUR_FAM6_C7_D		0xd
 #define X86_CENTAUR_FAM6_NANO		0xf
 
+/* x86_cpu_id::flags */
+#define X86_CPU_ID_FLAG_ENTRY_VALID	BIT(0)
+
 #define X86_STEPPINGS(mins, maxs)    GENMASK(maxs, mins)
 /**
  * X86_MATCH_VENDOR_FAM_MODEL_STEPPINGS_FEATURE - Base macro for CPU matching
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ca3468ad06ff..4338b1b4ac44 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -690,6 +690,7 @@ struct x86_cpu_id {
 	__u16 model;
 	__u16 steppings;
 	__u16 feature;	/* bit index */
+	/* Solely for kernel-internal use: DO NOT EXPORT to userspace! */
 	__u16 flags;
 	kernel_ulong_t driver_data;
 };
@@ -701,9 +702,6 @@ struct x86_cpu_id {
 #define X86_STEPPING_ANY 0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
-/* x86_cpu_id::flags */
-#define X86_CPU_ID_FLAG_ENTRY_VALID	BIT(0)
-
 /*
  * Generic table type for matching CPU features.
  * @feature:	the bit number of the feature (0 - 65535)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
