Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B9724F35
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 16:23:50 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e727329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e727:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 69FBD1EC042F;
	Fri, 11 Nov 2022 17:23:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668183828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=RQAgICrjFnZQrLGvUgI/C7Q9GLfgPJ4P+LW0OtdT8rs=;
	b=moouNAFTAV7IcV/mP/nZqLe47DxjlL2ZUaRES6YJT6CZgM57NspuSpLyzVWCPkqJ6rbcKk
	xY4bYHmZCLalHnrmbMD8dlM6xo8pYJ/OsbcktfAFK7mP9LgQI0vvRWlWMcxxoEg28NyBwv
	ww4At+bFDSflMdaQCtpe9l4jVRdxDdY=
Date: Fri, 11 Nov 2022 17:23:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
	tony.luck@intel.com, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com, thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
Subject: Re: [PATCH v2 09/14] platform/x86/intel/ifs: Use generic microcode
 headers and functions
Message-ID: <Y253FKtLnmV3r7Kj@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-10-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221107225323.2733518-10-jithu.joseph@intel.com>

On Mon, Nov 07, 2022 at 02:53:18PM -0800, Jithu Joseph wrote:
>  static int scan_chunks_sanity_check(struct device *dev)
>  {
> -	int metadata_size, curr_pkg, cpu, ret = -ENOMEM;
>  	struct ifs_data *ifsd = ifs_get_data(dev);
> +	int curr_pkg, cpu, ret = -ENOMEM;
>  	bool *package_authenticated;
>  	struct ifs_work local_work;
> -	char *test_ptr;
>  
>  	package_authenticated = kcalloc(topology_max_packages(), sizeof(bool), GFP_KERNEL);
>  	if (!package_authenticated)
>  		return ret;

Bah, how big is that thing so that you can't simply do a bitfield on the
stack here instead of kcalloc-ing?

> @@ -203,67 +174,33 @@ static int scan_chunks_sanity_check(struct device *dev)
>  	return ret;
>  }
>  
> -static int ifs_sanity_check(struct device *dev,
> -			    const struct microcode_header_intel *mc_header)
> +static int ifs_image_sanity_check(struct device *dev, const struct microcode_header_intel *data)

Yet another static function - no need for the ifs_ prefix.

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
