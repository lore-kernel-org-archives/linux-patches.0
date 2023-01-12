Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B6818D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 16:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B8C433D2;
	Thu, 12 Jan 2023 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673542147;
	bh=VQBygNuP8yrIEuw0qYWh/djMhCafZON+WlX6T9VzRik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mJ2uK8ydeG+r7kGt3EX8LMB0MXD+CCkIr5sg71RfxpDSNcQgbn9ypA23TA9xOarvL
	 tPk7a4w9h9nYlnM3w7FoHZR9Qx/hVjrXaDv2jvUh8QSIqCtUMnTZNtVl5nZ3hgp58H
	 kIEIaYGpY9ru6uyZoiL/Ktp5/iBwZqx4U7osI2z0=
Date: Thu, 12 Jan 2023 17:49:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luben Tuikov <luben.tuikov@amd.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	AMD Graphics <amd-gfx@lists.freedesktop.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 108/148] drm/amdgpu: Fix size validation for
 non-exclusive domains (v4)
Message-ID: <Y8A6AC9DrYfO1c4+@kroah.com>
References: <20230110180017.145591678@linuxfoundation.org>
 <20230110180020.610387724@linuxfoundation.org>
 <e4b4b0ca-b6e6-70ae-1652-3df71df53ab4@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4b4b0ca-b6e6-70ae-1652-3df71df53ab4@amd.com>

On Thu, Jan 12, 2023 at 11:25:08AM -0500, Luben Tuikov wrote:
> Hi Greg,
> 
> The patch in the link is a Fixes patch of the quoted patch, and should also go in:
> 
> https://lore.kernel.org/all/20230104221935.113400-1-luben.tuikov@amd.com/

Is that in Linus's tree already?  if so, what is the git commit id?

thanks,

greg k-h
