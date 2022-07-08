Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534D92579
	for <patches@lists.linux.dev>; Fri,  8 Jul 2022 15:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCE2C341C0;
	Fri,  8 Jul 2022 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657294085;
	bh=KAfXERdqbtilgXrs/mlOi+seJobFePGOK/Z/qHdIrPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fa0QzF3gez7GOGb5Jbc4Q5RU38Yl6LieKGxFgCPAKWHXPxMdnzStPP6p/w9bxY83G
	 feiBvLdAehuZ8+c7W6CBmtJzwRrcSLnSTbhAUyPGpLRpNPJ/qPMn2Gzsf2EhBbkQQt
	 2TmHxpdM+28JFO/k4wcovTDi5Ob1TsDCjD8X35lk=
Date: Fri, 8 Jul 2022 17:28:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, ashok.raj@intel.com,
	tony.luck@intel.com, ravi.v.shankar@intel.com,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] platform/x86/intel/ifs: Allow non-default names for IFS
 image
Message-ID: <YshNAh6awfPFmxzU@kroah.com>
References: <20220708151938.986530-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708151938.986530-1-jithu.joseph@intel.com>

On Fri, Jul 08, 2022 at 08:19:38AM -0700, Jithu Joseph wrote:
> Existing implementation limits IFS image to be loaded only from
> a default file-name (ff-mm-ss.scan).
> 
> Change the semantics of the "reload" file. Writing "1" keeps the legacy
> behavior to reload from the default "ff-mm-ss.scan" file, but now interpret
> other strings as a filename to be loaded from the /lib/firmware/intel/ifs
> directory.
> 
> Situations where multiple image files are helpful:
> 1. Test contents are larger than the memory reserved for IFS by BIOS
> 2. Increased test coverage
> 3. Custom test files to debug certain specific issues in field

Ick, but now what namespace are you saying that path is in?  If you need
debugging stuff, then put the api/interface in debugfs and use it there,
don't overload the existing sysfs api to do something different here.

> Fix the below items in adjacent code
> - Return error when ifs_image_sanity_check() fails in ifs_load_firmware()
> - Correct documentation "ifs.0"->"ifs"

That should all be a separate patch, you and Tony know better than this.

{sigh}

greg k-h
