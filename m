Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CC01DDE7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 14:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPKL6JDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70021C433C8;
	Tue, 31 Oct 2023 14:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698761501;
	bh=qH88Mbb+SW0qvCKdGJJEXx1r2kzMD56r2Gn5h4h1Ftk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nPKL6JDCvOC707jaBFWCGSrp6XdGFajCf7VpGfVHtmEw39eTN4XOKjvJIOpaHQXAa
	 qkM2Sq4cTUcyBXx6n/5XGwcyyxjpgYpVHgTteCO5tqlVDc6FGsXnEg6aMNXjt3kHfx
	 FqbiydJE8nAZFozU+qYRl64AmilnNA2QFVvkQoAA=
Date: Tue, 31 Oct 2023 15:11:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Baokun Li <libaokun1@huawei.com>
Cc: stable@vger.kernel.org, sashal@kernel.org, tytso@mit.edu, jack@suse.cz,
	ritesh.list@gmail.com, patches@lists.linux.dev,
	yangerkun@huawei.com
Subject: Re: [PATCH 5.15 1/3] ext4: add two helper functions
 extent_logical_end() and pa_logical_end()
Message-ID: <2023103129-variably-surfboard-d608@gregkh>
References: <20231028064749.833278-1-libaokun1@huawei.com>
 <2023103126-careless-frequency-07c1@gregkh>
 <e8b4cdee-55ad-647f-e209-db0c8ed07c3f@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8b4cdee-55ad-647f-e209-db0c8ed07c3f@huawei.com>

On Tue, Oct 31, 2023 at 09:17:23PM +0800, Baokun Li wrote:
> On 2023/10/31 20:51, Greg KH wrote:
> > On Sat, Oct 28, 2023 at 02:47:47PM +0800, Baokun Li wrote:
> > > commit 43bbddc067883d94de7a43d5756a295439fbe37d upstream.
> > Why just 5.15 and older?  What about 6.1.y?  We can't take patches only
> > for older stable kernels, otherwise you will have a regression when you
> > upgrade.  Please send a series for 6.1.y if you wish to have us apply
> > these for older kernels.
> Since this series of patches for 5.15 also applies to 6.1.y, sorry for not
> clarifying this.

Ok, thanks, now queued up.

greg k-h
