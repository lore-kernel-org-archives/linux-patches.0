Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B1979E8
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 19:51:30 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e773329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e773:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DC1641EC0304;
	Mon, 14 Nov 2022 20:51:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668455488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Ta80/lJEXeync/q9lAj53oHgjWE6aOFOeaGaQcQ6TyQ=;
	b=FR2o/Yzsr8JCyD2Uq8gYaQtwP+gGi5ljcPRkU7TKS/PC5nWn/9Jz67pqpYr8Qs15yplSj5
	g6nqB7Mgza10lwqOvjbnKOR+szMVFrjGRMvWb/sQVXtO5tSr8BoYCy9JDH3yAkw/MKvzf2
	wTCq5N16ZlpNTQFfwt0PaxKG0pbDJLY=
Date: Mon, 14 Nov 2022 20:51:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"Macieira, Thiago" <thiago.macieira@intel.com>,
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
Message-ID: <Y3KcPUqP/K6Ceo9C@zn.tnic>
References: <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <Y3EJ93xzgC/1v0WV@a4bf019067fa.jf.intel.com>
 <Y3EUPKWDefnkeObR@zn.tnic>
 <45aa0f69-2523-3cba-8f41-b1351f16b78f@intel.com>
 <Y3KRGx/yNfS78zQ2@zn.tnic>
 <SJ1PR11MB608361084E83E74EA348630BFC059@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <Y3KULFHC5JuBQdAZ@zn.tnic>
 <SJ1PR11MB60837D7324618BDB33B98C24FC059@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB60837D7324618BDB33B98C24FC059@SJ1PR11MB6083.namprd11.prod.outlook.com>

On Mon, Nov 14, 2022 at 07:38:35PM +0000, Luck, Tony wrote:
> But if this is the only roadblock to taking this patch series,
> then we can switch to filenames and make Thiago find some way for
> the container to be given the list of tests to run in the form of
> filenames.

I'm not putting any roadblocks as this is not the area I maintain. I'm
just saying that this whole scheme looks fragile to me.

I.e., I'm just playing the devil's advocate and pointing out the issues
this scheme could have. It might not but it could - we can't know of all
the possible future use cases.

So this is all your call as far as I'm concerned. Hans was fine either
way.

I'll take the next revision through tip as we agreed with Hans and after
the other, minor issues I've pointed out have been taken care of.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
