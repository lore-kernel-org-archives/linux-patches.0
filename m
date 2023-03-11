Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4857B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 07:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95641C433EF;
	Sat, 11 Mar 2023 07:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678521437;
	bh=Gg16DCykJnE2Bhw2ejexmfCb52yIzdYHCxDa3JlpAbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gzGhctNUhn4NXUQyyAwllTMN+IEjkkXebZzYti5laFRdavjcYflS/A7tZnaiI8yU1
	 I885XBkAlyECh1czT2rDSTVhF8HLOXbrFeBeeHVPUAXHkJzEwFiZtJYWLKSpJSR1Ac
	 JOptKAO5qt/aguAxHHQ21+PinmZFwIvJ5kjKvkd8=
Date: Sat, 11 Mar 2023 08:57:14 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: pvorel@suse.cz, akpm@linux-foundation.org, keescook@chromium.org,
	Jason@zx2c4.com, ebiederm@xmission.com, yzaikin@google.com,
	j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsname: simplify one-level sysctl registration for
 uts_kern_table
Message-ID: <ZAw0WoMnaBdMEDwa@kroah.com>
References: <20230310231656.3955051-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310231656.3955051-1-mcgrof@kernel.org>

On Fri, Mar 10, 2023 at 03:16:56PM -0800, Luis Chamberlain wrote:
> There is no need to declare an extra tables to just create directory,
> this can be easily be done with a prefix path with register_sysctl().
> 
> Simplify this registration.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> ---
> 
> This is part of the effort to phase out calls that can recurse from
> sysctl registration [0]. If you have a tree to take this in feel free
> to take it, or I can take it too through sysclt-next. Let me know!
> 
> This file has no explicit maintainer, so I assume there is no tree.
> 
> If I so no one taking it I can take in as part of sysctl-next later.

I recommend taking it in your tree like this, thanks.

greg k-h
