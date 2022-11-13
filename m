Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3732A1850
	for <patches@lists.linux.dev>; Sun, 13 Nov 2022 15:58:58 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e71a329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e71a:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CC4291EC0518;
	Sun, 13 Nov 2022 16:58:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668355136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=vCiMS/elp3sdK9l9eDxJDQCzDCE3T5vFzE6vazFsbBM=;
	b=DSbieSiNqZOW6fR/TDrRpN1E5WfowfQQZlgvbudSRIArMVsmYyMeFGn1k3YT14pjzXdDxM
	2el/q+/MHG5vflunPWJzoDbPO6GCMucVTCM+qp1wAn7Oi3AkQcVjJtHTnkD+4pAJuAt+WQ
	HJsR4PR1WNY80AcGMd7VbzXUUB5ieTM=
Date: Sun, 13 Nov 2022 16:58:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ashok Raj <ashok.raj@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Thiago Macieira <thiago.macieira@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>,
	"Mehta, Sohil" <sohil.mehta@intel.com>
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs
 entry
Message-ID: <Y3EUPKWDefnkeObR@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com>
 <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <Y3EJ93xzgC/1v0WV@a4bf019067fa.jf.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3EJ93xzgC/1v0WV@a4bf019067fa.jf.intel.com>

On Sun, Nov 13, 2022 at 07:15:03AM -0800, Ashok Raj wrote:
> Do you expect the /lib/firmware/intel/ifs_0/ to contain *ONLY* files for
> this platform? For microcode we have everything in the public release
> included here.

Same as microcode, as I said further down in my mail:

"And, ofcourse it would check the format of that string against family,
model, stepping and sequence number (btw this way you drop your
limitation of 256 for the sequence number which you don't really need
either)."

> In the above proposal, you can *ONLY* put files for this platform
> unlike simply copying everything released and let the kernel pick the
> right one since it does the ff-mm-ss-*.scan lookup. Only the batch
> number is supplied from user space.

No, see above. You check the filename against the current f/m/s. Just
like microcode.

> Even in the current implementation, user doesn't need to know f/m/s.
> That's something the driver selects automatically, just like what
> microcode does for reload.

Basically what I'm saying all this time.

> Isn't it simple now? No need to check if user supplied the right f/m/s
> since its not a user input, kernel composes that automatically.

Let's see

* try echoing a magic number into some sysfs file

vs

* simply try *all* files in a directory

Latter is even simpler because you don't have to explain anything about
sequence numbers - the user doesn't need to know.

> The tool we have is not for a simple test run. That can easily be done with
> a shell script. The tool does a bit more like handling retries if the test
> was not scheduled. The fundamental pass/fail simply output is what the
> kernel provides.

Because a simple script can't handle retries based on the values read
from that sysfs file?

Yeah, right.

> I don't think the current proposed interface expects a f/m/s. The entire
> IFS design was sort of mimicking the microcode interface.

Ashok, you prove for the nth time that you don't really read my emails.
Sorry, try again.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
