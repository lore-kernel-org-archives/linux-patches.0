Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019E71CBEAD;
	Mon, 21 Oct 2024 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729532727; cv=none; b=Pp7FixzfYdTYkEuSWJMXqvme49CJaU8qxF/6OahyT2ypOBhxIDQRFoRDY7dUv5yTrI5zfI+5Krv4dHhe1eQuLQbkAlK26dMjVU4GMa/zu8/1vA2YJ6V2jivASd4d6WmJ+bAxGeJfLRuBPUFoRg5tBcFnzPBkgZFu+3+bUhWpQUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729532727; c=relaxed/simple;
	bh=ZlcV4f26KtcP/Nse8UgkpjiG1mu7/ySsqZuyZL33w4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+DPlKxbQ24kgBJbqrZjliGdERzOyi9WCsHXjsan/mzxw8v+wGWgV0GUFwhDUHcNHJBftpVk8uYF4C5fBhNKeRG7IKBi8g1wNu/6ZpxhlwIHw3SNQ4zoePdF9sOe2sGJxH7VuJtZD+fsr/jNthIPnkxp5bxOg1wEnzV3D6anb5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9lQpQku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9lQpQku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFD2C4CEC3;
	Mon, 21 Oct 2024 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729532726;
	bh=ZlcV4f26KtcP/Nse8UgkpjiG1mu7/ySsqZuyZL33w4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f9lQpQkuHxxAO0WTsCyBaMxb44h7J+7dh+QqtzeIJ51EqgkbeH7M7jhame0LbbelF
	 w9kjCuPrJm8HkOMRm8KIPs2/huVSOlZg/3OoNaIdNh1q4UZccAWZRPApvsCWlHDrUb
	 6flEcRDqIy482yYDc7n44Lz4FLovCa7o4ItxQZTU=
Date: Mon, 21 Oct 2024 19:45:17 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com,
	vbabka@suse.cz, greearb@candelatech.com, kent.overstreet@linux.dev,
	stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 6.11.y 2/2] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
Message-ID: <2024102104-paralyze-voting-973a@gregkh>
References: <20241021171003.2907935-1-surenb@google.com>
 <20241021171003.2907935-2-surenb@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021171003.2907935-2-surenb@google.com>

On Mon, Oct 21, 2024 at 10:10:03AM -0700, Suren Baghdasaryan wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> From: Florian Westphal <fw@strlen.de>

Any reason for the duplicated "From:" lines?

thanks,

greg k-h
