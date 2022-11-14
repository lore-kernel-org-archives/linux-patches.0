Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E5E187C
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 07:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0292BC433C1;
	Mon, 14 Nov 2022 07:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668410161;
	bh=QZ2hDN7ENnP9xgo+76D84xuEYJANb+AhzKCDG45trzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mTLTwTou6gugHVLBfC5kKM/9XlWijH3RpGVEbYyOow99SXMMh9K3DeJa/JNLR/8T3
	 cvvCuWUoRzz/ACbIYI1HsoNKcxa0DFHjk4almwRjVnbhJ0WtFtkE0+xrOuZtsEJo9w
	 bG6yp73fWu/4Bx+XuQoYoUf+DbeW5xUzNC/S7EzQ=
Date: Mon, 14 Nov 2022 08:15:58 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thiago Macieira <thiago.macieira@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
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
Message-ID: <Y3HrLpTdxqUPWW3F@kroah.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com>
 <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3DZmKYV+8HBtZ+Q@zn.tnic>

On Sun, Nov 13, 2022 at 12:48:40PM +0100, Borislav Petkov wrote:
> Replying to both with one mail because it still feels like there's a
> misunderstanding.
> 
> On Sun, Nov 13, 2022 at 08:37:32AM +0100, gregkh@linuxfoundation.org wrote:
> > No, please do not force the driver to resolve a filename path in the
> > kernel.
> 
> No, I don't mean to do any filename path resolving - all I suggest is to
> echo into sysfs the full filename instead of the number. I.e., this:
> 
> for i in $(ls /lib/firmware/intel/ifs_0/*.scan);
> do
> 	echo $i /sys/devices/virtual/misc/intel_ifs_0/current_batch
> done

Sorry, yes, that is fine, I was objecting to the previous "write any
path/file to the sysfs entry and the kernel will parse it" that was
happening in the original series.  A filename, without a path, that
always loads from the existing in-kernel firmware path locations is
fine.

thanks,

greg k-h
