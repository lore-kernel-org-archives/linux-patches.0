Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C0C7EEE2;
	Tue,  9 Apr 2024 08:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712651308; cv=none; b=idUkIuYpA0gfmrEi2+aPaybNsNuhYGMIdcnkt3BicWIYc9n5Crzo0cT5PJM8dJ943+mNZQL0oCAIScGXs7XpoSch7RPUIislyvvHLPY/N1wjVSO/csPEqxczeaRIM7Q0Ias4nUujoAgV+vu3Y88w2Xr/C4LqphOtKJBIet03zgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712651308; c=relaxed/simple;
	bh=W42QOMw1jdxfH3ToIuTAwLUWtrNMpSOB1/ZirGy7eB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFSNmqNz12c/jYm8skxo4ytAy++g7AvHOc+1uVpnhvULqktqIPyJga31U062h+EK3lptAgrfIh6mvTEgI/rlyhzR41sJb0Zh/TmudiInuNnqtrXr8fNWUKjEpKd8jWKbtdfIRlgsvlH54f5nNag4yo71gNMiuRPzDhygAZAhcnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDPDETnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDPDETnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63552C433C7;
	Tue,  9 Apr 2024 08:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712651307;
	bh=W42QOMw1jdxfH3ToIuTAwLUWtrNMpSOB1/ZirGy7eB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IDPDETnbbN27IMju1OsYpPIdAf6EvPEB5Z3fgXFPBrIt6Fdbiz/srk7fMZ8LGT+bh
	 /nLhDbZ1Ivai7q2lOfQbla7pvL/kKAoG8LrAGdd+jhYx+aFwH1CL7B02lxOpUPYEAw
	 hQ4oKF+H053e9bLmZ6DuU5xT3ikpIa0B/QxkfX+c=
Date: Tue, 9 Apr 2024 09:12:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH 6.8 131/273] usb: typec: ucsi: Check for notifications
 after init
Message-ID: <2024040929-twitter-reenter-0935@gregkh>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125313.358936582@linuxfoundation.org>
 <ZhQc+AoLGkrJB1to@cae.in-ulm.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhQc+AoLGkrJB1to@cae.in-ulm.de>

On Mon, Apr 08, 2024 at 06:36:08PM +0200, Christian A. Ehrhardt wrote:
> 
> Hi Greg,
> 
> On Mon, Apr 08, 2024 at 02:56:46PM +0200, Greg Kroah-Hartman wrote:
> > 6.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Christian A. Ehrhardt <lk@c--e.de>
> > 
> > [ Upstream commit 808a8b9e0b87bbc72bcc1f7ddfe5d04746e7ce56 ]
> > 
> > The completion notification for the final SET_NOTIFICATION_ENABLE
> > command during initialization can include a connector change
> > notification.  However, at the time this completion notification is
> > processed, the ucsi struct is not ready to handle this notification.
> > As a result the notification is ignored and the controller
> > never sends an interrupt again.
> > 
> > Re-check CCI for a pending connector state change after
> > initialization is complete. Adjust the corresponding debug
> > message accordingly.
> 
> As discussed previously, this one should not go into the stable
> trees without the follow up fix that is in you usb-linus tree but
> not yet in mainline. This applies to all stable branches. Let me
> know if you want a separate mail for each branch.

No need, thanks for catching this, again, our fault.  Now dropped from
everywhere.

greg k-h
