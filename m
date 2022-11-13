Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8BD7E5
	for <patches@lists.linux.dev>; Sun, 13 Nov 2022 22:41:00 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e773329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e773:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B7EFC1EC02DD;
	Sun, 13 Nov 2022 23:40:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668379256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=q6qApWsmJ9Ez30h5inmNVLzzV4IIlxvn+kq5fZSc6wA=;
	b=ogGDDoyVnAa0TF1K4T6Pfrr9sLDVXeT8lkRv+RSX41PlXZtI7+cpdqDxf2+sH8FjsNJuju
	gfPWxd4HM7hYu0mYum0pt2dtQX7ouzExDiH/TroLLNarmPSf6uFQ4GUdrYLg9dc42au6HD
	wbr3wgUCwsf+mlSzqlbaeCeYcp7em4A=
Date: Sun, 13 Nov 2022 23:40:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thiago Macieira <thiago.macieira@intel.com>
Cc: "Joseph, Jithu" <jithu.joseph@intel.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"Luck, Tony" <tony.luck@intel.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>,
	"Mehta, Sohil" <sohil.mehta@intel.com>
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs
 entry
Message-ID: <Y3FycwHICRlwG2GW@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <5e65889d-d68c-b29d-6cea-7b4ce4c87b4a@intel.com>
 <Y3EiKUzpShqwzEf6@zn.tnic>
 <2206677.iZASKD2KPV@tjmaciei-mobl5>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2206677.iZASKD2KPV@tjmaciei-mobl5>

On Sun, Nov 13, 2022 at 01:21:41PM -0800, Thiago Macieira wrote:
> I'm assuming that the kernel would provide different error conditions for 
> those. But handling those in shell scripting is very difficult: you'd need to 
> start a subshell and parse stderr.

You call that "very difficult"?!

> And this is part of my argument of why it's unlikely people will use their 
> shells to do this. That shell function is easily another 10 lines of 
> scripting, if it's meant to do its job properly. To make that easier, we've 
> developed two tools, one of them the OpenDCDiag tool I linked to, but both 
> just happen to be written in C and C++ instead of shell.

I've told you already that having a special tool is always more
problematic. I guess you'll make your own experience distributing it but
if you see pushback and people start complaining, you shouldn't wonder
why.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
