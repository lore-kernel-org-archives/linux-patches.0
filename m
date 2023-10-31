Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E9BA29
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 12:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4khRRqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106B6C433C7;
	Tue, 31 Oct 2023 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698756699;
	bh=PySEhp5C8YzBUnhvhTmJS2OYv1VPzdxYzHFpxj/AnEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D4khRRqSC+Y+kloJZx+inU3EixchclMzMZZF8j/6eE1eMwNhT0hkiIh6y9zSfRCvu
	 wCucDNmgdLI7oKb7WK09ehsaVvoYNwx5E6YVA1/mppKXlLoWrrsql6buFaueBUhatQ
	 GwdINQfNb+vkSG3iqdU6YukUkT6w9g8KQEc2EvOA=
Date: Tue, 31 Oct 2023 13:51:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Baokun Li <libaokun1@huawei.com>
Cc: stable@vger.kernel.org, sashal@kernel.org, tytso@mit.edu, jack@suse.cz,
	ritesh.list@gmail.com, patches@lists.linux.dev,
	yangerkun@huawei.com
Subject: Re: [PATCH 5.15 1/3] ext4: add two helper functions
 extent_logical_end() and pa_logical_end()
Message-ID: <2023103126-careless-frequency-07c1@gregkh>
References: <20231028064749.833278-1-libaokun1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231028064749.833278-1-libaokun1@huawei.com>

On Sat, Oct 28, 2023 at 02:47:47PM +0800, Baokun Li wrote:
> commit 43bbddc067883d94de7a43d5756a295439fbe37d upstream.

Why just 5.15 and older?  What about 6.1.y?  We can't take patches only
for older stable kernels, otherwise you will have a regression when you
upgrade.  Please send a series for 6.1.y if you wish to have us apply
these for older kernels.

> When we use lstart + len to calculate the end of free extent or prealloc
> space, it may exceed the maximum value of 4294967295(0xffffffff) supported
> by ext4_lblk_t and cause overflow, which may lead to various problems.
> 
> Therefore, we add two helper functions, extent_logical_end() and
> pa_logical_end(), to limit the type of end to loff_t, and also convert
> lstart to loff_t for calculation to avoid overflow.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Link: https://lore.kernel.org/r/20230724121059.11834-2-libaokun1@huawei.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> Conflicts:
> 	fs/ext4/mballoc.c
> 

Note, the "Conflicts:" stuff isn't needed.

thanks,

greg k-h
