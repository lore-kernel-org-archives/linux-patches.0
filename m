Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19508D53F;
	Thu,  7 Nov 2024 06:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730961482; cv=none; b=sEtyeoDrdsXIYWcRTE4DwZcJDUXygueBrO5nKQvoRxyWL4vyU1mt2ndH62yjCoyadWfZvDibnBHsZVPjp+ObEQGzjFstjKfCDkLHZLjHYq7gGbq1qr1peh2oNHpwIM7i07QYka5FkImbQv9a12T5o566LNrIWzD+l4QZc9oRya4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730961482; c=relaxed/simple;
	bh=T4TgS+4aaAOaTl1qmoEDzqZ6WyctMMKHQz5ckqGi+vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=np+jCn+zgIT/c1RgkXdRB/bwl0OdBRToZBPGBnfXDYGH6fMB7j1qKewTNx+9TIdP0Rcg43MJwFxIte8BdNzJ2TrJTe7M/49q5+4H7InlsT28tZGWy/Rt0Vi7cBy1O/Wnij9yT7dwEmHevG9rptT+JggEnNbqdNqcuehB8tDqVpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liDr7jlK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liDr7jlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41775C4CECC;
	Thu,  7 Nov 2024 06:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730961481;
	bh=T4TgS+4aaAOaTl1qmoEDzqZ6WyctMMKHQz5ckqGi+vg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=liDr7jlKUzEU5NYMq1aabaGqP1o3eoYWS5UZJOIQH3KuGxu4dp8Yg/S27wZBvRazV
	 JlS7yHpZyxPvIv+uJnTzgSUPaex0XqFXFY6bJYePGjBeiU0xlYdb9HeN9njld0ONb3
	 5a7paBP2tczwDFVv/ZVdfudjs2tmzDMc7sxNxkHg=
Date: Thu, 7 Nov 2024 07:37:43 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com,
	vbabka@suse.cz, greearb@candelatech.com, kent.overstreet@linux.dev,
	stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 6.11.y 1/2] rcu/kvfree: Add kvfree_rcu_barrier() API
Message-ID: <2024110700-undertone-coastline-7484@gregkh>
References: <20241106170927.130996-1-surenb@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106170927.130996-1-surenb@google.com>

On Wed, Nov 06, 2024 at 09:09:26AM -0800, Suren Baghdasaryan wrote:
> From: Uladzislau Rezki <urezki@gmail.com>
> 
> commit 3c5d61ae919cc377c71118ccc76fa6e8518023f8 upstream.

No, that's not the right git id :(

This should be 2b55d6a42d14c8675e38d6d9adca3014fdf01951, right?  Let me
go change this...

thanks,

greg k-h
