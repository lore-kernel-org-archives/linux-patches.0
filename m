Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937553715E;
	Sun, 11 Aug 2024 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723373822; cv=none; b=qEauCd5aWRCxdlrqloIaEOqxFxukjFIeSQPirRd4mdyKp0QfdH4HEuNTyIV1Q2D9Bjxx5bUMMr/xAHeYD0PGi6xAlBJtJSdVCFzg501HzEGvrdyoBawZGcsjfuU/F4ZJDYGLIixhrK75aMEG+GCe1ncCyVTH+s6ek4wNSgIrRGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723373822; c=relaxed/simple;
	bh=T083lSWLrhtsBNsnEzSR0ylGHEz5iYuOOaaRs4j28cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApTXlnAsIAjt0sLPlQsycSp+UVRHlKx327GjJ5rYJVflTNKzYnRYS8PFrxsyqsHfGvf+3eg+dAf+6AQFqMzhvoSBs74Asckshif2UYzFtUqOmF/2mbCxiUXalr8uubnOQFL49Wn7LsOJdOksyvuMshK05E2c6qe5SFj9bi578zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aOu5MQ/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aOu5MQ/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5707AC32786;
	Sun, 11 Aug 2024 10:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723373822;
	bh=T083lSWLrhtsBNsnEzSR0ylGHEz5iYuOOaaRs4j28cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aOu5MQ/GImq7k15JiYi0CJoq5GV7dbSmVg0UGr0kc3Z9GrJwV9nC6kLEDYP2VqXu9
	 p234pM/fSJIrUE5kO7R1y2j/gRRVdWtF5X/bgU0aXOiukCLavp96DZnWHg6VAw+nJW
	 mLjghmqLkdcz834eq/2DjyoYCTdy+1x6HeeKv89E=
Date: Sun, 11 Aug 2024 12:56:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kevin Holm <kevin@holm.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	David Hildenbrand <david@redhat.com>,
	Lu Zhongjun <lu.zhongjun@zte.com.cn>, xu xin <xu.xin16@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Yang Shi <shy828301@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 001/123] mm/huge_memory: mark racy access
 onhuge_anon_orders_always
Message-ID: <2024081124-clothes-dazzling-c257@gregkh>
References: <20240807150020.790615758@linuxfoundation.org>
 <20240807150020.834416694@linuxfoundation.org>
 <27a85289-1fe4-4131-b5d6-6608ef699632@holm.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27a85289-1fe4-4131-b5d6-6608ef699632@holm.dev>

On Wed, Aug 07, 2024 at 05:06:54PM +0200, Kevin Holm wrote:
> On 8/7/24 16:58, Greg Kroah-Hartman wrote:
> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> Did the back port [1] I submit just get missed? It fixes a regression I
> reported [2] with high resolution displays on a dp link after a hub in the
> amdgpu driver.
> 
> [1] https://lore.kernel.org/stable/20240730185339.543359-1-kevin@holm.dev/
> [2] https://lore.kernel.org/stable/d74a7768e957e6ce88c27a5bece0c64dff132e24@holm.dev/T/#u

It's in the queue to apply, and has nothing to do with this specific
commit oddly...  I'll get to it this week, hopefully.

thanks,

greg k-h
