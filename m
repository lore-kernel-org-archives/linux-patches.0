Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B522C381B1;
	Tue, 23 Jul 2024 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721757357; cv=none; b=Xc420LIZ6XSl0MTVdR5tITNctXujiN9o2CpmCvlZ7cdMh+xRJXcbULYlyHrC97hZfVPwJX6EGMuKspbRD67dJ34/gwC1exCczKYNRWLozC8CYeLjkGMomBRLI8dQpgRovMN38BuXLsToWEy+Ke34vTuk/GXCkGyoBF+SyfQhYE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721757357; c=relaxed/simple;
	bh=u5xGKZobgp6DBTYDE5ebYCAj53cT/WQp/xakcr338eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsCvuyW14XdCBaWB33lt5e4asAUc3XKARE2UB2VLhMD5R/pLYmRmOURtDC8Zf3qlEkz1iP/3w7eO9K9oANacOz+OePzvOVlhS8Xqw/CsAHS4lj+O9Ojdi9Bhxo8DqHhKVXJU+AWKJqFoZtaUjg5xm+FQzuxz3Y5aG2YK27aPXrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wtn1PZvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wtn1PZvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31584C4AF09;
	Tue, 23 Jul 2024 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721757357;
	bh=u5xGKZobgp6DBTYDE5ebYCAj53cT/WQp/xakcr338eo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wtn1PZvgNO2h+HkQ+EwvEF+qOrxqb2uF6bofWCslGzQv0Ugtl+S8LFRsjE78bWrgb
	 dUPkW7y8Yg954d40wBy4NEAruS5losQQGa5mpYxNKaoS4kh1MOfeqZqdME+Qw5ODBg
	 3ujTX8ldNURdOMmosWhCQIfj71tlsdWy8/nXBi2E=
Date: Tue, 23 Jul 2024 19:55:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: libaokun@huaweicloud.com
Cc: stable@vger.kernel.org, sashal@kernel.org, patches@lists.linux.dev,
	hsiangkao@linux.alibaba.com, yangerkun@huawei.com,
	libaokun1@huawei.com, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 6.1 1/3] netfs, fscache: export fscache_put_volume() and
 add fscache_try_get_volume()
Message-ID: <2024072345-glitter-emboss-29a1@gregkh>
References: <20240719134338.1642739-1-libaokun@huaweicloud.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240719134338.1642739-1-libaokun@huaweicloud.com>

On Fri, Jul 19, 2024 at 09:43:36PM +0800, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> [ Upstream commit 85b08b31a22b481ec6528130daf94eee4452e23f ]
> 
> Export fscache_put_volume() and add fscache_try_get_volume()
> helper function to allow cachefiles to get/put fscache_volume
> via linux/fscache-cache.h.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Link: https://lore.kernel.org/r/20240628062930.2467993-2-libaokun@huaweicloud.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Stable-dep-of: 522018a0de6b ("cachefiles: fix slab-use-after-free in fscache_withdraw_volume()")
> Stable-dep-of: 5d8f80578907 ("cachefiles: fix slab-use-after-free in cachefiles_withdraw_cookie()")
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  fs/fscache/internal.h         |  2 --
>  fs/fscache/volume.c           | 14 ++++++++++++++
>  include/linux/fscache-cache.h |  6 ++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)

All now queued up, thanks.

greg k-h
