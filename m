Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51756FC1
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 15:48:01 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e773329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e773:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 638511EC0391;
	Mon, 14 Nov 2022 16:47:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668440879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=aZfrPRU7cJWa0FklhcMR2UCGDD460EKBf2AZ+Suhhv0=;
	b=kh9zAtI0xHAL3dMgwKRzWDHAwjw6ER+syTn9ug6wcAUCDi7l8ZKFERNwLWsknsJFZNVQ+7
	+sxUe2Dg+6qFdrJ6by6hAVmzV+APRc7a3Ni/dXZEEVKmltEcQUs3rvpRaXcwA5ASJv+E4F
	vSFs1rxW3SW54379QAS1Xc2Sl2QbcjI=
Date: Mon, 14 Nov 2022 16:47:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Message-ID: <Y3JjK2G8ZFyTk1hv@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com>
 <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <Y3HrLpTdxqUPWW3F@kroah.com>
 <Y3Jf1GmQKy3Dnz6V@agluck-desk3.sc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3Jf1GmQKy3Dnz6V@agluck-desk3.sc.intel.com>

On Mon, Nov 14, 2022 at 07:33:40AM -0800, Tony Luck wrote:
> Bug ... $i is a full path here. I think Boris meant:

Kinda.

I meant:

for i in $(ls /lib/firmware/intel/ifs_0/) ...

initially. Note the missing glob at the end. This gives the filenames
only, without the path. But then I added "*.scan" without testing it.
The "*.scan" thing would've been redundant too if we did what I was
suggesting...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
