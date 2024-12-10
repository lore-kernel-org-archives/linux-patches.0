Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D9C23DE9A;
	Tue, 10 Dec 2024 12:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733832983; cv=none; b=rmZ2ngRK8QkL+mPx7jTYTaq7Nv62U5FwZKvVIWzwdtkRwJqkEtCMyDqRvJ+2lfkjsJ9Q5+FdomgO2wgKk13AeyA/VBfbsjzLKipxYrex1Ufkp95iqcWXRGoVVZkc4Z+ME7hjPY1o2QQaxkzO9Or6IYcu6ncU01lUFZDpC81KwpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733832983; c=relaxed/simple;
	bh=Ft1YjHqSMgJ6RqovNv0wv3AniPVftdV/WIQwPQsjKPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9HmBTsgSGSb/cjxz/ZQr2aDWUDzSv7CAM0/VnsUhPgT8/8KuVBwfhUa+jXwkCnp5E7SGJOJZo7xGhCSBOH+9KTEGdHPdK4EePFDmLCL0ZDzHMF/dtVq7NbacDozOOd9903uKTbkYp9/cSwAq/ucqyYz9C9HsIhzVNb7dGluqtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlFaED5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlFaED5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C984C4CED6;
	Tue, 10 Dec 2024 12:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733832982;
	bh=Ft1YjHqSMgJ6RqovNv0wv3AniPVftdV/WIQwPQsjKPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YlFaED5a6Au36wNVQU8vIhdWmePboXSesZgeyNksFd6nN+bPfaJsxadfarUKTOug9
	 oHqc/i+8FeJRksXxFiFQ9I349ueiq/fpbISK3FSf4pj1q4Ux3gUtUqSccSpViBAdcf
	 BtSn/1KNYZ19/W3RpPciYLfmHlDYUSpuPxUmFASs=
Date: Tue, 10 Dec 2024 13:15:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Hui Wang <hui.wang@canonical.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, sashal@kernel.org,
	hvilleneuve@dimonoff.com
Subject: Re: [stble-kernel][5.15.y][5.10.y][PATCH v2] serial: sc16is7xx: the
 reg needs to shift in regmap_noinc
Message-ID: <2024121020-abstract-ashy-cbe6@gregkh>
References: <20241210113126.46056-1-hui.wang@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210113126.46056-1-hui.wang@canonical.com>

On Tue, Dec 10, 2024 at 07:31:26PM +0800, Hui Wang wrote:
> Recently we found the fifo_read() and fifo_write() are broken in our
> 5.15 and 5.4 kernels after cherry-pick the commit e635f652696e
> ("serial: sc16is7xx: convert from _raw_ to _noinc_ regmap functions
> for FIFO"), that is because the reg needs to shift if we don't
> cherry-pick a prerequisite commit 3837a0379533 ("serial: sc16is7xx:
> improve regmap debugfs by using one regmap per port").
> 
> It is hard to backport the prerequisite commit to 5.15.y and 5.10.y
> due to the significant conflict. To be safe, here fix it by shifting
> the reg as regmap_volatile() does.

Please try, submit the series of upstream commits first and then if it's
too rough, we can evaluate it later.  As-is, I can't take this, sorry.

greg k-h
