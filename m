Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4495D29A0
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 19:03:24 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e741329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e741:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E9BF01EC0426;
	Wed,  2 Nov 2022 20:03:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1667415802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=RVyN7kuq7UHk5zEp061nN94sGhj7lHSPMVlNMnUJTf4=;
	b=dAjjIwJTXnj0LfdeDLwrrAsn/C8xEntX/jQpngLatvWStx4/nqIcV5ph5m6R4++l+gM8Uu
	tMP42jEztjPGyP1il2jMRc/MXv3KLvKcTVeHgZHwJCecMz+U2CdcXu+QBkMKF/dfhmZMoX
	C5ycdIbDZg2rCE6TBuOmoWrjBDyhht4=
Date: Wed, 2 Nov 2022 20:03:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: Re: [PATCH 05/14] x86/microcode/intel: Expose
 find_matching_signature() for IFS
Message-ID: <Y2K+9jfb5xiYE3eU@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221021203413.1220137-6-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221021203413.1220137-6-jithu.joseph@intel.com>

On Fri, Oct 21, 2022 at 01:34:04PM -0700, Jithu Joseph wrote:
> IFS uses 'scan test images' provided by Intel that can be regarded as
> firmware. IFS test image carries microcode header with extended signature
> table.
> 
> Expose find_matching_signature() for verifying if the test image
> header or the extended signature table indicate whether an IFS test image
> is fit to run on a system. Add microcode_intel_ prefix to the
> function name.

This doesn't look like the right design to me:

If this is going to be generic CPU-vendor related code which other
facilities like the microcode loader can use, then the prefix should be
intel_<bla>. Just like intel_cpu_signatures_match().

Then that code should either be in a lib-like compilation unit or simply
in arch/x86/kernel/cpu/intel.c. Just like intel_cpu_signatures_match().

Ok?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
