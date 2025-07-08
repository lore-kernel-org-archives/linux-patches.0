Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3272980DA;
	Tue,  8 Jul 2025 07:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751959236; cv=none; b=GsclcG8oTcf+fNYrjg9g6A9ffgijYSd4fRF7XvpG3Yo2EqC/3Kui4VvpdDIWZj9gXe5uyrpL9BEsABKHHRA8hrUo6X8VaI8y+qIBMs28uuSaG8VpnUBTwGNubm8ZdcmMWb2XjNchyiaX0/jPVqh7nRoV9qDo0uHa/MqyrFou0s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751959236; c=relaxed/simple;
	bh=mYTkCzzsoYkeW4PXtxoU1WJ4TpRUDvstxE81xoplf2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRP7JpkNm5i9ftb2GsH2dDfFP4ITRAV8DC8U2Egl563CgbWHr/yN7vPePoYZ/eyFL0cWqDUtL3XNZU6eUPM9hzsY9f7fm/ozA7yCWtfxdnOJAQOytF/1oItrRDA241F9WeON5UXrZmLjhRU1mOqoQjCdrLxsui/SZpMg+4OxlzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4NjKAAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4NjKAAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C311FC4CEED;
	Tue,  8 Jul 2025 07:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751959236;
	bh=mYTkCzzsoYkeW4PXtxoU1WJ4TpRUDvstxE81xoplf2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B4NjKAAa9tfQ0w5wVPuhlB7sdpvdkDNjXFZfyKrcuONzu2mWQKVnfGRv3yVyjee+K
	 KfYP7Y0osxnIcDxFhS3kZmuDEWPB/Y4iwUd57y37lBswPdk089A+eMFKyYcsAeWGgS
	 F88ZatZUca/7qwzZZ6QTM8cVCtVK1Pm/Ln7nIg68=
Date: Tue, 8 Jul 2025 09:20:32 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: chuck.lever@oracle.com, masahiroy@kernel.org, nicolas@fjasle.eu,
	patches@lists.linux.dev, stable@vger.kernel.org, dcavalca@meta.com,
	jtornosm@redhat.com, guanwentao@uniontech.com
Subject: Re: [PATCH 6.6 129/139] scripts: clean up IA-64 code
Message-ID: <2025070857-junkman-tablet-6a45@gregkh>
References: <20250703143946.229154383@linuxfoundation.org>
 <E845ABA28076FEFB+20250708032644.1000734-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E845ABA28076FEFB+20250708032644.1000734-1-wangyuli@uniontech.com>

On Tue, Jul 08, 2025 at 11:26:44AM +0800, WangYuli wrote:
> Hi all,
> 
> This commit is a refinement and cleanup of commit cf8e865 ("arch:
> Remove Itanium (IA-64) architecture"). However, linux-6.6.y and earlier
> kernel versions have not actually merged commit cf8e865, meaning IA-64
> architecture has not been removed. Therefore, it seems commit 0df8e97
> ("scripts: clean up IA-64 code") should not have been merged either.
> 
> I stumbled upon this while tracking the v6.6.69 update. It appears
> commit 358de8b ("kbuild: rpm-pkg: simplify installkernel %post")
> depends on commit cf8e865. We should perhaps consider reverting both
> of these commits and then refactoring commit 358de8b to prevent any
> issues with the IA-64 architecture in future linux-stable branches.

Is ia-64 actually being used in the 6.6.y tree by anyone?  Who still has
that hardware that is keeping that arch alive for older kernels but not
newer ones?

thanks,

greg k-h
