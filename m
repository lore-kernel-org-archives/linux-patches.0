Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22863064B
	for <patches@lists.linux.dev>; Wed,  8 Nov 2023 16:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNj3aHzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2038EC433C9;
	Wed,  8 Nov 2023 16:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699459948;
	bh=gb1qNw0Ii7MCjpbOgCoGg4Iun+7X7SqHTMt3LvFNhQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SNj3aHzSdFCwyGCZyNQ27hywyQwoGB/31seJzJ0d7uqRXeoVQ+b4gO3pr4oslvCVm
	 ive4sPxwT6i5kj9+Q5OlUw/nCezPwJWYzzRvoOoM5sTExyj1R8ZSC3qcirsV0WtlLQ
	 T2byH5lH6zne0rKMEjcRzJ0e4DU0ET512vAEksSc=
Date: Wed, 8 Nov 2023 17:12:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johnathan Mantey <johnathanx.mantey@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 062/131] ncsi: Propagate carrier gain/loss events to
 the NCSI controller
Message-ID: <2023110837-maturity-clean-6e78@gregkh>
References: <20231009130116.329529591@linuxfoundation.org>
 <20231009130118.189922269@linuxfoundation.org>
 <8734xg2seb.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734xg2seb.fsf@intel.com>

On Wed, Nov 08, 2023 at 07:08:21AM -0800, Johnathan Mantey wrote:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > 5.4-stable review patch.  If anyone has any objections, please let me
> > know.
> > 
> 
> I have discovered an undesirable side effect caused by this change. If it
> isn't too late, I'd like to see this change set dropped.

And what is that side effect?

This is already in the following released kernels:
	5.4.258 5.10.198 5.15.134 6.1.56 6.5.6 6.6
so please, fix this in Linus's tree and tag the fix for the stable
backports as well and all will be good.

thanks,

greg k-h
