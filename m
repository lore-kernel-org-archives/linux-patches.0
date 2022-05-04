Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5202583
	for <patches@lists.linux.dev>; Wed,  4 May 2022 16:29:04 +0000 (UTC)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8ACF11EC0505;
	Wed,  4 May 2022 18:28:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1651681732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Pwo4stPQS5Epzgq3/I8V0NR8mbENabR0dFZP2E8j8AY=;
	b=qaXmgIitUirGKOzWMmXfBfPhHrQwFKJhis4aXI7O3YhyJJUuFJE1nUzD28zKlHW1pJwJOW
	YpcFEuS2JbvzPT8pxSx9ae1KJnDWarb2/P8OmW0gKaUZsjGOlxLWjyKuy2mJx9NzCQGSWT
	Via2Eiq2+oYOj2UC1ZQa2/gcI9fqdKQ=
Date: Wed, 4 May 2022 18:28:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [PATCH v5 03/10] platform/x86/intel/ifs: Add stub driver for
 In-Field Scan
Message-ID: <YnKpw2kGY2FEFWcW@zn.tnic>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <20220428153849.295779-4-tony.luck@intel.com>
 <87zgjxk2kt.ffs@tglx>
 <eedc3fa9ec47494590be66ad66f90bb7@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eedc3fa9ec47494590be66ad66f90bb7@intel.com>

On Wed, May 04, 2022 at 04:24:50PM +0000, Luck, Tony wrote:
> > We really don't need more match id tables with gazillions of CPU models.
> 
> Sadly we do :-(

So what was the reasoning about CPUID bits being so expensive so that we
need to match models? Ditto for the splitlock situation - that thing is
supported on a bunch of models but nope, not a CPUID bit in sight. What
was the convincing argument that made hw folks give a CPUID bit to the
PPIN thing? Perhaps we could use it there too. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
