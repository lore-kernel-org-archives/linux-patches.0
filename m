Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B261D8469
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 19:04:07 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e773329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e773:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BC03B1EC0304;
	Mon, 14 Nov 2022 20:03:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668452639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=TvJ+UE/GU6N+bzHIS1Z6JgJ7axC3eCCZB2aZePqwuuI=;
	b=RSiC2bcdmaneRJBumhyokJqDZ5FMfLhBifoRh+KV4gXUWcR9RO/dCmkaDZbroPB1uzbspL
	BX826okxjtSp99mkPwxnC/NSkWqw95qyDYUfOlMNFuAGr5npe9PM3kSoCPlPRLkVmq9Ss6
	OVKXrhj62SlXtiRATftf8Ai1zJytkKc=
Date: Mon, 14 Nov 2022 20:03:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Message-ID: <Y3KRGx/yNfS78zQ2@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com>
 <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <Y3EJ93xzgC/1v0WV@a4bf019067fa.jf.intel.com>
 <Y3EUPKWDefnkeObR@zn.tnic>
 <45aa0f69-2523-3cba-8f41-b1351f16b78f@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45aa0f69-2523-3cba-8f41-b1351f16b78f@intel.com>

On Mon, Nov 14, 2022 at 10:13:44AM -0800, Dave Hansen wrote:
> So, what's the point of the sscanf() to check the *filename* other than
> saving some potentially expensive request_firmware() calls?

The point is to do a first sanity check. The other tests are of course
mandatory.

Which brings me to another bastardly idea:

Let's say you have sequence numbers 0-6.

Now someone comes along and changes them all to x-y, where both x and y
are > 6. Or removes the sequence numbers completely.

Now you go and echo your sequence number into current_batch and nothing
happens. But the sequences *are* there - just not named in a magic way.

Now *my* idea would work because you don't care what the filenames are.
But you don't want that and you want do some silly sequence numbers
which the user has to go and connect with what's in the directory.

If this were microcode and arch/x86/, I would've never accepted it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
