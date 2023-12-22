Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1881E1DFC3;
	Fri, 22 Dec 2023 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5NA4c9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F038EC433C8;
	Fri, 22 Dec 2023 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703255471;
	bh=UfxXwhVnnC9MwOhStHNLMQSE8zh6K26Jmnr6uqXI5OM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H5NA4c9IdcUrILe9LijRtez+WTkILLwQ4/XhpZAwbySkGcNWW3YQ5mNG0qnIXKa5v
	 ckYDoqNbb8kdcAiEFqj6aTNr13ek5dCYAeYFDggz3uYx/GjTD1w6+e8aTeQ0WTbZX/
	 GIgFpHWpixI62RS6rT3qiq3qzBijcLspAPRVin0E=
Date: Fri, 22 Dec 2023 15:31:11 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Uli v. d. Ohe" <u-v@mailbox.org>
Cc: jkosina@suse.cz, me@khvoinitsky.org, patches@lists.linux.dev,
	sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.6 097/530] HID: lenovo: Detect quirk-free fw on cptkbd
 and stop applying workaround
Message-ID: <2023122231-curly-contour-9795@gregkh>
References: <20231124172031.066468399@linuxfoundation.org>
 <2feecc09-3310-4733-a65e-50b9f5dc7325@mailbox.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2feecc09-3310-4733-a65e-50b9f5dc7325@mailbox.org>

On Fri, Dec 22, 2023 at 03:15:34PM +0100, Uli v. d. Ohe wrote:
> I have one of the affected keyboards with original, unmodified firmware, so
> it should use the old "workaround" to function properly.

<snip>

You should respond to the original patch submission on the mailing list
for the input system, not much we can do here on the stable list for a
commit that is already in all of the branches, sorry.

thanks,

greg k-h
