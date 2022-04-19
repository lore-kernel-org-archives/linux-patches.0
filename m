Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A48E1374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 17:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F796C385A5;
	Tue, 19 Apr 2022 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1650388488;
	bh=mELWcw2sy0MMiNjuZqc4S/H0jeZKg3LDM5gQ37ppmTM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0fTdrXa+xN84sGny+1DH9fIfghOFUvKiy8pIjWw7qu4S2j+sa64jrD/ICI/4VVTZa
	 P936S3QT4ijD0Xv76BLvZLqJhfLigDgcZoB8LCQjxZXjHuCcbFyBRFsw98s6+wls7E
	 HScLj1bIxF2e5jKv14AGTOm44yS2M4vdVzmotkYo=
Date: Tue, 19 Apr 2022 19:14:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Luck <tony.luck@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
	ashok.raj@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v3 05/11] platform/x86/intel/ifs: Read IFS firmware image
Message-ID: <Yl7uBWwobfYAWcIZ@kroah.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-6-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419163859.2228874-6-tony.luck@intel.com>

On Tue, Apr 19, 2022 at 09:38:53AM -0700, Tony Luck wrote:
> +/*
> + * Load ifs image. Before loading ifs module, the ifs image must be located
> + * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
> + */
> +int load_ifs_binary(struct device *dev)

Shouldn't all of your global symbols start with "ifs_"?  Your other ones
seem to, what went wrong here?

Also, how about "ifs_load_firmware()" makes more sense.

thanks,

greg "naming is hard" k-h
