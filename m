Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF6B7A
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 20:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA87C3411E;
	Sun, 10 Jul 2022 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657483253;
	bh=w6tJSYNrKJ/3hIAuBny3C5gPPvX4dgzLghBONrfuJ84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oNglLUMJnxxjxFLbgHKWHcntBfGbLSldCsc3FbfccFdDJ/jXzg7KaI6omhGOGM9lS
	 +fr8xHZpGuxZe0Uw4HTuhmXsuglG9GoqS9yZWR7slYCW1ib0iP6b2RcFCF0nAE0Rsv
	 KItxMtEPrDo5jhwQQ14NpRje+0SyU3ZXQ0tIkEpw=
Date: Sun, 10 Jul 2022 22:00:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>, markgross@kernel.org,
	ashok.raj@intel.com, ravi.v.shankar@intel.com,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/2] Documentation: Correct IFS reload documentation
Message-ID: <Yssv8a2/wzLlAQQn@kroah.com>
References: <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
 <20220710182521.60642-1-tony.luck@intel.com>
 <20220710182521.60642-2-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220710182521.60642-2-tony.luck@intel.com>

On Sun, Jul 10, 2022 at 11:25:20AM -0700, Tony Luck wrote:
> From: Jithu Joseph <jithu.joseph@intel.com>
> 
> The location where the scan image is stored is incorrect
> in the current documentation. Fix this.
> 
> Fixes: 34604d289167("Documentation: In-Field Scan")

Our tools will complain about this line, please use the correct format
so you don't get grumpy emails from the linux-next maintainer.

thanks,

greg k-h
