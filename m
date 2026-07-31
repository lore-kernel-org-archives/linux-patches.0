Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF502D73B5;
	Fri, 31 Jul 2026 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785480721; cv=none; b=BjFfNX0gw+JX5bMreYU2QHmGc3hCQrSLi1WzUZFjFq85KCp4ocjx22QKvWQJ2tqouOHg/iW3w3/ZA5Sn7VBwxnDOWDey/uc61V4KBpq58JVLVVzdC/c3GgW1s/08jE5zDXJ2yHIi8kk+a9XTtzZ1hOcMTy2uMnosS/m3bC3nf18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785480721; c=relaxed/simple;
	bh=AszQVZRJz0ONLC4QpsqMtsXzFqjzpbc5zC4KVzU9xwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvMXtzwDHldwV9DS8Fw19QEABBIwOf45SP3suDpPjJgRFeo4qHBZeRnr2pj+6rWv/n6fEK216jy8ifcirpm1QKlyYbzxrgdMwX2cohIHcWP2IzKB7JXv7t8SuTYjVDr6QI38f4Au6C0jQtvqZDTHW18vYhnT/xSSNMrcjsurf3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2n+SnIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2n+SnIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2234F1F000E9;
	Fri, 31 Jul 2026 06:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785480719;
	bh=om9isnjWb/V/NVbvFJ0siCFHz6iecGimWSbp26SLNEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=w2n+SnIni1RjhgV73p+6/pIp80k5knbaAsvqTxHiSn4RzO+7g0wr0A0QHcMhOBV4X
	 NEKbrrCislvQ5i/kU0+KR2cJZlrLSqpouuvnhYrIUHCC6IFtkuE1CCSXGEtaPW39+p
	 rG2vyI2kvRRfFaX8GAqmZpxd3xlt0/etI7+ZYXXY=
Date: Fri, 31 Jul 2026 08:51:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: johan@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org,
	ulf.hansson@linaro.org, zhoubinbin@loongson.cn
Subject: Re: [PATCH 6.6 456/484] mmc: vub300: fix use-after-free on disconnect
Message-ID: <2026073134-vindicate-kissable-e3e6@gregkh>
References: <20260730141433.390818444@linuxfoundation.org>
 <20260731033117.506282-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731033117.506282-1-guanwentao@uniontech.com>

On Fri, Jul 31, 2026 at 11:31:17AM +0800, Wentao Guan wrote:
> Hello,
> 
> The backport is wrong and not as is discribe in the title.
> It just renames the goto and I don`t know what the backport fix not in the tree
> for 'git log v6.6.147 --grep="mmc: vub300: Use devm_mmc_alloc_host() helper"'
> not found it fixes for, so I see just drop the patch.

Odd, yeah, let me go drop this one, good catch.  something went wrong on
my side...  I'll also drop it from the other queues.

thanks,

greg k-h
