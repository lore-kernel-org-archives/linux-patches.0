Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EF46FC1
	for <patches@lists.linux.dev>; Sun, 13 Nov 2022 18:27:35 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e71a329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e71a:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9C9641EC0391;
	Sun, 13 Nov 2022 19:27:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668364053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=21CpvpDBbPHMKQnvN45fDGXEyhhg/R2gooRGDPjtnGk=;
	b=IdNxS6zABn6XekQGA46JRbKmJdxOU4a08jxXPy/NcI6aOOV5CQ/x/tKPZhkjtmReLma+MP
	sYGieyk9AW+mjb0Vny+mDWmmrWO16u5zRMp+CqfuT8JEUsLziMGeQN/zsXCJuCLJ+7AWX9
	ElbLsGT8L3W8cPOybp8GECQ2AfDLPAs=
Date: Sun, 13 Nov 2022 19:27:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Thiago Macieira <thiago.macieira@intel.com>,
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
Message-ID: <Y3E3DkX4wHRgSUlJ@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com>
 <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <5e65889d-d68c-b29d-6cea-7b4ce4c87b4a@intel.com>
 <Y3EiKUzpShqwzEf6@zn.tnic>
 <f307b37f-26de-cb8f-e199-f327f2c7f807@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f307b37f-26de-cb8f-e199-f327f2c7f807@intel.com>

On Sun, Nov 13, 2022 at 09:55:00AM -0800, Joseph, Jithu wrote:
> Then we were told not to specify a filename via sysfs file (apologies
> for being repetitive)

Yeah, I'm unclear on why that is either and am hoping that Greg will
clarify. He fears that there will be file path resolution which I'm not
even thinking about.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
