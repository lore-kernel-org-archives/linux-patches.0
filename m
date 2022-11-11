Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516661EA00
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 14:37:38 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e727329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e727:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 55BF01EC050B;
	Fri, 11 Nov 2022 15:37:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668177456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=XoIfnPx5anyIgOtrmn9qEj57defnQ2RkyAT8E7rwRzk=;
	b=qAHNnVHN2AP3ZI9fbs4A/MPndo3qgRLcS/D4Atq18vgDDJhXDf2mObqDL5Li3FWNOKhg3g
	tjxHqfhJaWedVi8r8CyigdFtn7qeZlU9Ph4N4QUohNLTUJFxVVDPYcT08gfQpytUaiq9xp
	QZvJvd+T5ZkPhH8yWGvUWQyPRXSK6w0=
Date: Fri, 11 Nov 2022 15:37:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
Subject: Re: [PATCH v2 07/14] x86/microcode/intel: Use a reserved field for
 metasize
Message-ID: <Y25eMMwi+9GolAmJ@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-8-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221107225323.2733518-8-jithu.joseph@intel.com>

On Mon, Nov 07, 2022 at 02:53:16PM -0800, Jithu Joseph wrote:
> Intel is using microcode file format for IFS test images too.
> 
> IFS test images use one of the existing reserved fields in microcode
> header to indicate the size of the region in the file allocated for
> metadata structures.
> 
> In prepration for this, rename first of the existing reserved fields

Unknown word [prepration] in commit message.
Suggestions: ['preparation', 'peroration', 'prep ration', 'prep-ration', 'preparations', 'reparation', 'perspiration', "preparation's", 'proportion']

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
