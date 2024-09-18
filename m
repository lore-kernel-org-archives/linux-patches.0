Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAB24C81;
	Wed, 18 Sep 2024 06:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726640273; cv=none; b=LuejiAJl7sa+YbYbxmvR08zfwTL+Mot6Slhjb3M2CiOW2xRVRsdeSIQgjrlf1s9rkFk89ZPvU3WRze7hoTcrQ5ZSy6bR8mAJd1axO410GhECEerxPaPWbDmFV+unn1NyqnV5dBvdIrMzlBWxCssmQQ8uoM0vER7q3By7ixM8ZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726640273; c=relaxed/simple;
	bh=mnz9j2x2YzhnswsUfHWRaw2A7mM5nYT9gnsWg81ILYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8T7mIwXJn/Cptb56hjwyADoLfyFHjwouUT+pfgLwhE+SDNMRhpBznbWjIRX6JWOiPrhxffbLkfPpfrFOy5NbiShIdNcaBOe9dL0CxCOThAdExGX4lUn+KYw3YUEV/TXrU9yIH105sAOnuYzMaGboPyk2hbhTztGAwBC40MTTlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIWxKYy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIWxKYy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C2FC4CEC3;
	Wed, 18 Sep 2024 06:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726640272;
	bh=mnz9j2x2YzhnswsUfHWRaw2A7mM5nYT9gnsWg81ILYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pIWxKYy1rLtC4LqQekTtJkUeSfJKDEgi/Vnc26jgJM6yAxn+SeDptOlmSznDlLDjG
	 FHwGL455Vet2FK0ghCSzVIUUNCfADFisC4do7Nu942KehQhkCEKUA6W9Wu3z2tZC+R
	 1OGvA4xcdGpwSnj87jSQatzpQWJnC6yUxM2WmJZk=
Date: Wed, 18 Sep 2024 08:17:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 32/91] s390/mm: Prevent lowcore vs identity mapping
 overlap
Message-ID: <2024091833-maturely-mushiness-a97d@gregkh>
References: <20240916114224.509743970@linuxfoundation.org>
 <20240916114225.569160063@linuxfoundation.org>
 <Zuliy6DOi47cD-cZ@tuxmaker.boeblingen.de.ibm.com>
 <2024091750-upwind-shaking-6fa2@gregkh>
 <ZumdjDsZoGlVSMDr@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZumdjDsZoGlVSMDr@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>

On Tue, Sep 17, 2024 at 05:17:32PM +0200, Alexander Gordeev wrote:
> On Tue, Sep 17, 2024 at 01:15:10PM +0200, Greg Kroah-Hartman wrote:
> > > Could you please drop this commit from 6.6-stable?
> > Why just this one?  What about 6.10.y?  6.11?
> 
> Thanks for pointing out!
> 
> Yes, please drop it from 6.10 as well. There is no relocatable lowcore
> support in 6.10, which this patch fixes up. And it is already included
> in 6.11, starting from v6.11-rc5.

Great, it turned out to also break the build, so that's a good reason to
drop it :)

now removed,

greg k-h
