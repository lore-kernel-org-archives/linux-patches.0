Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51169353A67;
	Sat, 25 Jul 2026 05:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784956758; cv=none; b=eZuLWKL6LfUhlPX0Qkit8LWr72I/ZH65x7iwV/z8Mzjjs0A6kXU6/C/2TfaMnU5MadQ5/Aw1/U+UclWGXKsWGVS0H5KJfzgRwx8f9KiFOcUcuvVFn0ZC4gARwxJ4mz529USuKK6nzyXD8SfdvRH/JVDpwcG6kmGrZ4SWE+mlm18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784956758; c=relaxed/simple;
	bh=x1KL3Cz0kG86RSr+lMvZgsStKND3GPa4u+QS1Z/J64M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGRae04f2IpNQ410GeZB/I5e20G3gkrFUdfkse8irVTsLb4hDGZdR0j9WXm06fcqMBh+M5dnIPbtm0Sa5ATFs4r8oE+EQepe44U0ATfLgag1B5RdO4ZOv27VOBbfX7MV/wJGpa8zlLwt1vBNvv/6g/3JruRcWRc+XKSBIJAeg0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMDeqD9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMDeqD9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61AF1F000E9;
	Sat, 25 Jul 2026 05:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784956757;
	bh=x0uXdWTbkAjcFG3ULzfaFFsBVMG9D6OLfaLsSzM8sV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CMDeqD9w9ydo5zjObva4g61ufvD8ZYONEG7DPNeH8v9uEslFLcwtXJ5vzwv/KmznW
	 AE8y52CLOBs9vAPdVk1VHLmGfsRgysFI4xwLVhp6EBtXsPWV0os5ABwEiPJ4KGJ5rY
	 pssLuU4RuO6zPbFb20E/220g9lOxSc7z0TM/2VgA=
Date: Sat, 25 Jul 2026 07:18:58 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: harshit.m.mogalapalli@oracle.com, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 6.12.y] ext4: validate donor file superblock early in
 EXT4_IOC_MOVE_EXT
Message-ID: <2026072543-overdrive-celery-11ec@gregkh>
References: <20260724143828.1668805-1-yun.zhou@windriver.com>
 <2026072404-cultivate-cohesive-9fc6@gregkh>
 <26bb37e4-e696-471b-b313-8c4e24c4884d@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26bb37e4-e696-471b-b313-8c4e24c4884d@windriver.com>

On Sat, Jul 25, 2026 at 10:43:18AM +0800, Zhou, Yun wrote:
> On 7/24/2026 11:26 PM, Greg KH wrote:
> > 
> > I already merged the original, can you send a fix-up patch that I can
> > just apply instead?
> > 
> 
> Sure, I've already sent it out. My previous understanding was incorrect.

Not your fault, thanks for the fix, I'll go queue it up later today!

greg k-h
