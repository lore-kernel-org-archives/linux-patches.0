Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F752367B5;
	Mon, 19 Jan 2026 10:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768817171; cv=none; b=hHtRartmvo9g9gUpfK47yAerL5bc0mocmKRZ4f5aPHuQ9pEOm3n9sAEUlNG0Q4AnHRS7kMKk7J4XIEWCaC+FjcIW76FR4Wa+DxTkgzygoie0I/bLBJXvRphkqzQi6Za7vPdI6ZV1t0v+HdBWmKsQNBMRi21tb56eL2fGTI6fT58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768817171; c=relaxed/simple;
	bh=8QRWWbOkUq4m+ZkNC2dmvI6jjv3AkqS9xFcaTXtXzHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WRkFsUYvEUw/OTjzpq5qwavAedEzWlm40S6lcPofyZWydsBWP0z/0QLMLhZVz1RfQGw4IJ+CddQgCU3/Wm1fCX+CCvz+TY14bYsP6ifK72kRnIhNTfYcKbl0PbLjGD+FjI8E8qHlxdIQ4cDMUTuPK2Iz9G+0c891Py7CxjEq+S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSRXGpsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSRXGpsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AA2C16AAE;
	Mon, 19 Jan 2026 10:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768817171;
	bh=8QRWWbOkUq4m+ZkNC2dmvI6jjv3AkqS9xFcaTXtXzHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KSRXGpsGzZRkQz9h9XLQQpC7LMfkoKaOdVcVB4u7+APA7tAEjsGlLUX0SaT53OFAA
	 3DnnAfTB2C2WM5cIHvpdHueJ6li5To0syQhCDBHEdera6lfGK/HoxZ0W7Vf6GMAPOZ
	 PxbPSsjU8mVzaoiIerFZ0MWnqkt39JZU7fjj9kA4=
Date: Mon, 19 Jan 2026 11:06:08 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Keerthana Kalyanasundaram <keerthana.kalyanasundaram@broadcom.com>
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
	stable <stable@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 423/451] tls: Use __sk_dst_get() and dst_dev_rcu()
 in get_netdev_for_sock().
Message-ID: <2026011944-wielder-ignition-dee8@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164246.242565555@linuxfoundation.org>
 <4ca8d0770343eae44e19854cf197c76017a7c1ad.camel@decadent.org.uk>
 <CAM8uoQ-F++6iScZBzntmF=KhHRK3=rQvc-oug3KAXPddJPqR-Q@mail.gmail.com>
 <CAM8uoQ_7HD0AtJLqXsRvO=F2knq=BtrdTM2Fv0Dd4h-4oYebNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM8uoQ_7HD0AtJLqXsRvO=F2knq=BtrdTM2Fv0Dd4h-4oYebNw@mail.gmail.com>

On Mon, Jan 19, 2026 at 03:09:32PM +0530, Keerthana Kalyanasundaram wrote:
> Hi Greg,
> 
> I have backported the two additional patches required for the 5.10.y tree
> and submitted a v2 series. You can find the updated patches here:
> https://lore.kernel.org/stable/20260119092602.1414468-1-keerthana.kalyanasundaram@broadcom.com/T/#t
> 
> 
> Could you please consume these in the next version, or alternatively, add
> the two missed patches (commit IDs 5b998545 and 719a402cf) to the current
> queue?

I've dropped them all from the 5.10.y tree now, and from the 5.15.y
tree. Can you also resend that series?

thanks,

greg k-h
