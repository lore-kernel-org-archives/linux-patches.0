Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F290189905;
	Wed,  9 Jul 2025 08:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752050161; cv=none; b=D3Zx1BbDo8Bzyle+4o+RWzI9kFhtpnwR64XGeAbif9xnrywZo2vfSploKswlfByVUCJgQVpoIpw6OmLB3s/0SNWmiKeHBn12vk8AXolA6Zq+n58a2iT1Z4GvybWqJrJATutBTaCG3lRWYTIGJcRv9j3Vmm9EK1s63h0BuAByqXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752050161; c=relaxed/simple;
	bh=H/6KWOCh1Otuc6u/FpnmW+1tC+m+cq8bRv2psw4pl3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WB5tNnWBg6NzU6htIFSG09VM082FcKSaar/WDcIVkC2nDpL/FAwHUTbumztxqbL56Ox29aycWLleOZFYF9dfVSQIi6AVZk1QXC1PAdUwa9m+2oLQdJntw1Y4BT7bqO9htp5n0TaDDkkUkLQSQv1q3w8PxQWmNhfMAXIliVAOBsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYHcikUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYHcikUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3540C4CEEF;
	Wed,  9 Jul 2025 08:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752050161;
	bh=H/6KWOCh1Otuc6u/FpnmW+1tC+m+cq8bRv2psw4pl3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tYHcikUK9hlnoRMosGzRBlcSwIHywgG/zp6z1BJTwNX+wT/fOKWpH8o1AfZv9KMph
	 /OAJpYt63NFMbt8B7OYyQEsP6MjWb6/rxp7eNpTmErz0NQ+Cgl+xX+WoL8SItWJxEv
	 /4amOFG5L1E2uOEEApb33j4+uXnYBavz6vBCBNgI=
Date: Wed, 9 Jul 2025 10:35:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 029/232] firmware: arm_ffa: Add support for
 {un,}registration of framework notifications
Message-ID: <2025070906-marathon-uncorrupt-de38@gregkh>
References: <20250708162241.426806072@linuxfoundation.org>
 <20250708162242.198209294@linuxfoundation.org>
 <20250708-jumping-strange-lemming-1bfc92@sudeepholla>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708-jumping-strange-lemming-1bfc92@sudeepholla>

On Tue, Jul 08, 2025 at 08:34:00PM +0100, Sudeep Holla wrote:
> On Tue, Jul 08, 2025 at 06:20:25PM +0200, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > 
> > [ Upstream commit c10debfe7f028c11f7a501a0f8e937c9be9e5327 ]
> > 
> > Framework notifications are doorbells that are rung by the partition
> > managers to signal common events to an endpoint. These doorbells cannot
> > be rung by an endpoint directly. A partition manager can signal a
> > Framework notification in response to an FF-A ABI invocation by an
> > endpoint.
> > 
> > Two additional notify_ops interface is being added for any FF-A device/
> > driver to register and unregister for such a framework notifications.
> > 
> > Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Message-Id: <20250217-ffa_updates-v3-16-bd1d9de615e7@arm.com>
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > Stable-dep-of: 27e850c88df0 ("firmware: arm_ffa: Move memory allocation outside the mutex locking")
> 
> I understand these are being added in order to resolve the dependency
> from 27e850c88df0, but this patch adds new feature. I would like to
> drop 027/232, 028/232 and 029/232 from the queue. I already knew this and
> had backports ready for
> 
> Upstream commit 27e850c88df0e25474a8caeb2903e2e90b62c1dc - 030/232 here
> Upstream commit 9ca7a421229bbdfbe2e1e628cff5cfa782720a10 - 190/232 here
> 
> I will send then now.

Great, thanks, I'll drop these all and take your backports instead!

greg k-h
