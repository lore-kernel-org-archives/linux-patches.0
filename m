Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD757472
	for <patches@lists.linux.dev>; Sun, 13 Nov 2022 23:05:56 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e773329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e773:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8BE121EC02DD;
	Mon, 14 Nov 2022 00:05:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668380754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=BT4qin+gPWCpRqhDJO1IWOIee/OFd5WLrQbMuOc14UE=;
	b=KSEbIO7vqrTq+/t+0OEnyLe3YwV6+DlE17XR0l11gbsVj3XNe6kvcsfu95gfWmzn2aDcBf
	6uxKxfl2wT50A0Tpvlghb2xthK+pSOH07RO0LNhLuTMXWMNHnXXKhNl/hKds7U43vKC+sf
	tIUW8TVI71iaEyBpViQegvjcMHiNdxg=
Date: Mon, 14 Nov 2022 00:05:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thiago Macieira <thiago.macieira@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Message-ID: <Y3F4Uq+1qi5tnmeG@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <2537334.Lt9SDvczpP@tjmaciei-mobl5>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2537334.Lt9SDvczpP@tjmaciei-mobl5>

On Sun, Nov 13, 2022 at 01:51:56PM -0800, Thiago Macieira wrote:
> Anyway, we can update the tool to print "%02x-%02x-%02x-%02x.%s" instead of 
> "%d". That's trivial to us. I just don't think it's a worthwhile change, 

As I wrote to Tony, "I guess time will show whether the sequence number
thing was a good idea."

Just remember that changing a user-visible interface after the fact is a
lot harder.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
