Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8B6D22
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 13:45:09 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e727329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e727:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 751C61EC042F;
	Fri, 11 Nov 2022 14:45:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668174301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=srsG+bHZex+4E5+pgOdTVgAoS4ma0+NJPyJOWN0aC9c=;
	b=sFdKam8a6ZqS8S6GcAq2ykRTWDcGmTI1Dveq0uv7eDptxDGID2yfsdO4T41sY7FcPGcc4T
	IAe2GOZSxZTNcmgKJkkMxWE8wwgNgJRtwRhSLQYamfM9Ln+7Q1hSUvijv3VI7QXs9y2MyY
	pDnz9krBckGV7WLhUcGq5pvo5I2CdQ8=
Date: Fri, 11 Nov 2022 14:44:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
Subject: Re: [PATCH v2 04/14] x86/microcode/intel: Expose
 find_matching_signature() for IFS
Message-ID: <Y25R15D2uMCsROS1@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-5-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221107225323.2733518-5-jithu.joseph@intel.com>

On Mon, Nov 07, 2022 at 02:53:13PM -0800, Jithu Joseph wrote:
> IFS uses 'scan test images' provided by Intel that can be regarded as

Why is that in '' quotes?

> firmware. IFS test image carries microcode header with extended signature
> table.
> 
> Expose find_matching_signature() for verifying if the test image

Yeah, not "expose" but "reuse".

> header or the extended signature table indicate whether an IFS test image
> is fit to run on a system.

> Move the function to cpu/intel.c and
> add intel_ prefix to the function name.

That is not needed in a commit message - it is visible from the diff
itself.

Please remove the "what" in all your commit messages.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
