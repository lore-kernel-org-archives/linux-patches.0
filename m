Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009EF8483
	for <patches@lists.linux.dev>; Wed,  1 Feb 2023 18:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18537C433D2;
	Wed,  1 Feb 2023 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675275558;
	bh=b+wlHDCzi8AdBnLpjdjGeEQLMS0qfahPSzCmwkMSiqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ptKD62LX78owda4w+Y0RYSwG/OXKHYW9gSEjj671KQR76Ta78vlE4GMdxxs917kzR
	 PCfbb2N85zBghqkfACFMRL+3ZxXNtYLf4aSBG0SAHb6yFKqDEANTmgwPUc4JdE0Bql
	 UNksukzT9Zu1Bgzqhmcu/MxeVgzk4miNdZdxRHbw=
Date: Wed, 1 Feb 2023 19:19:15 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Joseph, Jithu" <jithu.joseph@intel.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"Macieira, Thiago" <thiago.macieira@intel.com>,
	"Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>,
	"Mehta, Sohil" <sohil.mehta@intel.com>
Subject: Re: [PATCH 4/5] platform/x86/intel/ifs: Implement Array BIST test
Message-ID: <Y9qtI+CZaX051rLo@kroah.com>
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230131234302.3997223-5-jithu.joseph@intel.com>
 <Y9nyWVNtfBEny66w@kroah.com>
 <SJ1PR11MB6083EBD2D2826E0A247AF242FCD19@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083EBD2D2826E0A247AF242FCD19@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Wed, Feb 01, 2023 at 05:22:18PM +0000, Luck, Tony wrote:
> > > +/* MSR_ARRAY_BIST bit fields */
> > > +union ifs_array {
> > > +   u64     data;
> > > +   struct {
> > > +           u32     array_bitmask           :32;
> > > +           u32     array_bank              :16;
> > > +           u32     rsvd                    :15;
> > > +           u32     ctrl_result             :1;
> >
> > This isn't going to work well over time, just mask the bits you want off
> > properly, don't rely on the compiler to lay them out like this.
> 
> What is this "time" issue?  This driver is X86_64 specific (and it seems
> incredibly unlikely that some other architecture will copy this h/w
> interface so closely that they want to re-use this driver. There's an x86_64
> ABI that says how bitfields in C are allocated. So should not break moving
> to other C compilers.

Ok, but generally this is considered a "bad idea" that you should not
do.  It's been this way for many many years, just because this file only
runs on one system now, doesn't mean you shouldn't use the proper apis.

Also, odds are, using the proper apis will get you faster/smaller code
than using a bitfield like this as compilers were notorious for doing
odd things here in the past.

> Is there going to be a "re-write all drivers in Rust" edict coming soon?

Don't be silly, it's been this way for drivers for decades.

> 
> > Note, we have bitmask and bitfield operations, please use them.
> 
> We do, but code written using them is not as easy to read (unless
> you wrap in even more macros, which has its own maintainability
> issues).

It shouldn't be that hard, lots of people use them today.

Try and see!

thanks,

greg k-h
