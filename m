Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D846FAE
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 11:35:20 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e7e7329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7e7:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 06E531EC02FE;
	Thu,  3 Nov 2022 12:35:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1667475319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=8mjUNpD1eY1Wg8bY70xQ5Vy5Mhil2Ie2JJEz5vxPrxI=;
	b=iYaJOpik9I3FNFs4THlB8SKSC473ivKylGctMCq921VaSqqwSlR3BIlZjUM4WaOjX+QRRL
	yjKUzga+BcrLP6pV6G8eUa/EELRyGV4YIioDo2QhD+CvE4KfBx7MFyLZ+L7NUjL9AkTu4y
	2ERMpn/qXRLocJcnML4qOBT+xAUMRRY=
Date: Thu, 3 Nov 2022 12:35:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: Re: [PATCH 08/14] x86/microcode/intel: Meta-data support in
 microcode file
Message-ID: <Y2OndqGYc+52zQ6c@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221021203413.1220137-9-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221021203413.1220137-9-jithu.joseph@intel.com>

On Fri, Oct 21, 2022 at 01:34:07PM -0700, Jithu Joseph wrote:
> From: Ashok Raj <ashok.raj@intel.com>
> 
> Intel has made extensions to the microcode file format so that it
> can also be used for In Field Scan.

And this basically confirms what I just said in my previous mail: you
want to do IFS-specific changes already.

So please copy all code into your driver and reuse as you like so that
there are no cross-breakages.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
