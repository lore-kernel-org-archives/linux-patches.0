Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C766193084;
	Wed,  6 Nov 2024 07:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730876965; cv=none; b=BjUHFxjisnWmCmOjekLIMgMO/iRExN4y6MDXHIIhk8SQ6JWY2V+wQWMJEZqTAlq0JORYs0q6PE8VSFmADfySk0UyHQoHfNSbtu13nbxv+byFkaaPREOFxvhb5LulXv7nUssRqQoCUyzCR420Zz8fMyuvbVJmzV8qL2nkh3CiBok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730876965; c=relaxed/simple;
	bh=BaX33cEw4kB5c/aQBYKrh07u/obGduyi1uiRlTqdf8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkYd2WFtqxRZx27iA9lAZvEW0uTuqZ1tW/JM3fKiRjv+9caSmCadGz2wN2YF/bU+a+biOvxIxnFJjBcS5xrXOPBCXntHoi+XiTh/tQxzpjUh7FKbi7qJTQSBW9UeQ5pRb6y653yEQ8JM0ol03l3txJ083KYURHii2lFDhqJugj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pilsonyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pilsonyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE6AC4CECD;
	Wed,  6 Nov 2024 07:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730876965;
	bh=BaX33cEw4kB5c/aQBYKrh07u/obGduyi1uiRlTqdf8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pilsonyubuNvvsHd3BaloyW7Vy/5HRsEZRCJz21BIi6MeEzKwwnAut9O7kZ+clecj
	 2gAX5lyIsXKtPw8tIktdq49Tb+Mqn1v34VoLpPi4dDDjkOuXgZmEHhrIRQYmv0v409
	 lb4TSHAdRcEzhbyARQJWSoUqF5wJLX0VAa/GzxEQ=
Date: Wed, 6 Nov 2024 08:09:06 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com,
	vbabka@suse.cz, greearb@candelatech.com, kent.overstreet@linux.dev,
	stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 6.11.y 1/2] rcu/kvfree: Add kvfree_rcu_barrier() API
Message-ID: <2024110639-astute-smokiness-ea1d@gregkh>
References: <20241021171003.2907935-1-surenb@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021171003.2907935-1-surenb@google.com>

On Mon, Oct 21, 2024 at 10:10:02AM -0700, Suren Baghdasaryan wrote:
> From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
> 
> From: Uladzislau Rezki <urezki@gmail.com>
> 
> commit 3c5d61ae919cc377c71118ccc76fa6e8518023f8 upstream.
> 
> Add a kvfree_rcu_barrier() function. It waits until all
> in-flight pointers are freed over RCU machinery. It does
> not wait any GP completion and it is within its right to
> return immediately if there are no outstanding pointers.
> 
> This function is useful when there is a need to guarantee
> that a memory is fully freed before destroying memory caches.
> For example, during unloading a kernel module.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/rcutiny.h |   5 ++
>  include/linux/rcutree.h |   1 +
>  kernel/rcu/tree.c       | 109 +++++++++++++++++++++++++++++++++++++---
>  3 files changed, 107 insertions(+), 8 deletions(-)

We need a signed-off-by line from you, as you did the backport here,
please fix that up and resend this series.

thanks,

greg k-h
