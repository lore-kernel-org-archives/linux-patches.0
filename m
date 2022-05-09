Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F0D1FC0
	for <patches@lists.linux.dev>; Mon,  9 May 2022 16:56:15 +0000 (UTC)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 05F011EC04A9;
	Mon,  9 May 2022 18:56:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1652115369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=7lpb50R3zwIu2G3tyk1yvdZ54QsxXH26Abyw68QhTVY=;
	b=kZ2vb5Dq0zLAVqs6/OU7hsQVgPdPmhmTE+pGDaSjnXrI6Y9slOcw6gqWXpuJ+0VMWDHAVO
	vDDuIpxJGsgINtJM1RTIoAsXDDBnIlMkklVQLFUwPOGkuhSAfsm+OhpX6THsEGK5MxDYyy
	LTCFprBt9z25m1YiEoL+ZEtIBJ8GMe8=
Date: Mon, 9 May 2022 18:56:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
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
Subject: Re: [PATCH v7 06/12] platform/x86/intel/ifs: Check IFS Image sanity
Message-ID: <YnlHr6Is7xq+cBRH@zn.tnic>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-7-tony.luck@intel.com>
 <YnlB6iAp4fjM0Cw9@zn.tnic>
 <ddd29688b88b4176957ef5dd8731d90a@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ddd29688b88b4176957ef5dd8731d90a@intel.com>

On Mon, May 09, 2022 at 04:51:56PM +0000, Luck, Tony wrote:
> The checksum is just a "did this file get corrupted check". The file contains
> SHA256 checksums for each of the chunks. These checksums are digitally
> signed. Checking of these is done by microcode when the file is loaded into
> BIOS reserved memory (where it is inaccessible to OS and I/O).

That sounds like something I was hoping to hear, good. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
