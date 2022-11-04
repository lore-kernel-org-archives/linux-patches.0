Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336DBAD56
	for <patches@lists.linux.dev>; Fri,  4 Nov 2022 22:14:27 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e7a4329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7a4:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A8D821EC02DD;
	Fri,  4 Nov 2022 23:14:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1667600064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=ecezFjV64/LD06J6jguRRXZl22Q3tcFx+db0PLVvgdI=;
	b=qJ9EzN5E1tRwW+/5g4DykyP+6H7FDc8rEd4+5XkwNMX7Ge9cskSIhebAZcuEXBsFPSDrdZ
	V2+9hv+kpnXecyKREX149KhAAmic9mpikaoE5CatmsWroS8HFQ47mbqeWFvVYRSjzfI15A
	BYJrMhT38FkgH3McnP3Qaa5HQHZz1A4=
Date: Fri, 4 Nov 2022 23:14:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: Re: [PATCH 07/14] x86/microcode/intel: Expose
 microcode_sanity_check()
Message-ID: <Y2WOwEkjg4jR1rN8@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221021203413.1220137-8-jithu.joseph@intel.com>
 <Y2OnHuSHgIMGxcUH@zn.tnic>
 <a4107510-add4-3d85-ed2f-2f5e8c32a350@intel.com>
 <Y2TuhwiGFJ1M1V7u@zn.tnic>
 <4ee6073a-461e-562d-5c00-d1b371288b63@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ee6073a-461e-562d-5c00-d1b371288b63@intel.com>

On Fri, Nov 04, 2022 at 03:02:42PM -0700, Joseph, Jithu wrote:
> Wanted to check with you, if it is okay to rename the first "reserved"
> field in microcode_header_intel to "metasize" today (as shown in the
> diff below) or would you prefer to do that too at a later point ?
> (doing so today will help to avoid redefining an IFS specific header
> struct, with this as the only change )

No objections - it is not used by the microcode loader anyway.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
