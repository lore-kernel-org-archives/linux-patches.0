Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF10539B
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 15:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668440023; x=1699976023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XsLpyqom0Ng9wFWrYB4Wm5KxBEufr/zzcnGuXMOFcws=;
  b=iduqp5RQdCCuiiCVNCV8cwLymvxuEg/RyM6p4Ub4Y6LwpJk9uI8j5cWA
   iuqYPgUKlaaRjwY5HV6CuQViJus20Bx49EbNUpC+uY6tG/erF3levxMKk
   qkAfCDpI1uqKBjfjdw3iZXqcx26UxpYF+9yE4CiGmUEml0Ad+XKF8qekX
   zMvwxWa0uY0tKcXc5vP+tZgsBeekP3KrLQlV6vokzpARRrcGAgIcnoQVZ
   XeDrbk4hsHtT/Bp/70JsbUWMKu9weki+qzG/3ELmRDhQteRhg7YL+djdb
   Av4atXMDBPt11AUEBVLnFPQ7cb3bnkoU/QrT4PUaSnfwQzGiyrkEBG17P
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="295362179"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="295362179"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:33:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="669697768"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="669697768"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:33:42 -0800
Date: Mon, 14 Nov 2022 07:33:40 -0800
From: Tony Luck <tony.luck@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@alien8.de>,
	Thiago Macieira <thiago.macieira@intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>,
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
Message-ID: <Y3Jf1GmQKy3Dnz6V@agluck-desk3.sc.intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com>
 <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <Y3HrLpTdxqUPWW3F@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3HrLpTdxqUPWW3F@kroah.com>

On Mon, Nov 14, 2022 at 08:15:58AM +0100, gregkh@linuxfoundation.org wrote:
> On Sun, Nov 13, 2022 at 12:48:40PM +0100, Borislav Petkov wrote:
> > Replying to both with one mail because it still feels like there's a
> > misunderstanding.
> > 
> > On Sun, Nov 13, 2022 at 08:37:32AM +0100, gregkh@linuxfoundation.org wrote:
> > > No, please do not force the driver to resolve a filename path in the
> > > kernel.
> > 
> > No, I don't mean to do any filename path resolving - all I suggest is to
> > echo into sysfs the full filename instead of the number. I.e., this:
> > 
> > for i in $(ls /lib/firmware/intel/ifs_0/*.scan);
> > do
> > 	echo $i /sys/devices/virtual/misc/intel_ifs_0/current_batch

Bug ... $i is a full path here. I think Boris meant:

	echo ${i##*/} > /sys/devices/virtual/misc/intel_ifs_0/current_batch

> > done
> 
> Sorry, yes, that is fine, I was objecting to the previous "write any
> path/file to the sysfs entry and the kernel will parse it" that was
> happening in the original series.  A filename, without a path, that
> always loads from the existing in-kernel firmware path locations is
> fine.

Just to set the record straight, the previous patch did *not* allow any
path/file. It seems that you misread that original patch.

Whole thing is here:

https://lore.kernel.org/all/20220708151938.986530-1-jithu.joseph@intel.com/

But the important bits are in the commit comment:

  Change the semantics of the "reload" file. Writing "1" keeps the legacy
  behavior to reload from the default "ff-mm-ss.scan" file, but now interpret
  other strings as a filename to be loaded from the /lib/firmware/intel/ifs
  directory.

and the code:

+		if (strchr(file_name, '/'))
+			goto done;

Is there some other function/macro that we should have used to check
that user input was a filename and not a pathname that would have made
this clearer?

I do agree that overloading semantics of the "reload" was icky. Changing
the name of the sysfs file and dropping the "1" means reload default has
made this a better interface.

-Tony
