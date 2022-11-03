Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB21C6FAE
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 11:34:01 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e7e7329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7e7:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 249AE1EC02FE;
	Thu,  3 Nov 2022 12:33:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1667475234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Qs4hUdgc6XfK6+u+jATsj/xYBvk9R0dYRu6hfumrWWM=;
	b=CpbjgLDCkhafud9CVGmu3piO0/el4l2ToIh3NWYRx40Q88/ejA4cmk5ZmkQ8RrXutPr34S
	jE4PM4hziKt1KWtSngD+g7gArhO6NpfGvpnsoKPdLg8vWx2Vuk7wI2AW5OQCcKFb6B4Nqd
	hiciUs1lN0RCzr94NAyTH0E5c0TcPOM=
Date: Thu, 3 Nov 2022 12:33:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: Re: [PATCH 07/14] x86/microcode/intel: Expose
 microcode_sanity_check()
Message-ID: <Y2OnHuSHgIMGxcUH@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221021203413.1220137-8-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221021203413.1220137-8-jithu.joseph@intel.com>

On Fri, Oct 21, 2022 at 01:34:06PM -0700, Jithu Joseph wrote:
> IFS test image carries the same microcode header as regular Intel
> microcode blobs. Microcode blobs  use header version of 1,
> whereas IFS test images will use header version of 2.
> 
> microcode_sanity_check() can be used by IFS driver to perform
> sanity check of the IFS test images too.

So I'm very sceptical about such reuse.

The moment we decide to change something in the microcode loader, we're
going to have to

* test the IFS driver too

* and I suspect we won't even be able to because we'd probably need
special hardware and those special blobs which you probably don't
distribute freely.

And yes, right now that function should be doing the SDM-sanctioned
dance about verifying the table and thus should also be generic but
judging from past experience, things do get different in time and
implementations do get changed so even if it is a trivial change to
microcode_sanity_check(), we would still need to test the IFS driver
too.

So I'm wondering if it wouldn't be simply easier on everyone involved if
you just copy the bits you need into your driver and use them there as
you wish.

Then the testing burden won't be an issue and there won't be any
potential cross-breakages.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
