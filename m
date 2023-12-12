Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EFB21373;
	Tue, 12 Dec 2023 10:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJePFWJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F82AC433C9;
	Tue, 12 Dec 2023 10:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702377403;
	bh=H/SxjA1I5EJFAfN9IPEBJ5ge4rcadcSB+WPu1JuhjnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YJePFWJ2c2eFxpG2ydYjN1SxmBhyGU/6Y0MlbL+ZAn3wLR39fJaEo7hEz/tNHsb4q
	 7jiJuJNrq9VmEzjCiM/VEdSZhpW+H1+s/H41bK+8tern53zPUFPeLjTJ8vwGZjsh1C
	 ZJSqeXbFyFIlX+70gU0SCd/qa05S+Im6HqGPXZSI=
Date: Tue, 12 Dec 2023 11:36:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sam Edwards <cfsworks@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 126/244] arm64: dts: rockchip: Fix eMMC Data Strobe
 PD on rk3588
Message-ID: <2023121244-distrust-draw-d67b@gregkh>
References: <20231211182045.784881756@linuxfoundation.org>
 <20231211182051.468710881@linuxfoundation.org>
 <0584789e-2337-2d94-608c-81c09ca0d6d9@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0584789e-2337-2d94-608c-81c09ca0d6d9@gmail.com>

On Mon, Dec 11, 2023 at 03:05:31PM -0700, Sam Edwards wrote:
> On 12/11/23 11:20, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi Greg,
> 
> This is my first stable review and I don't know the policy on what we do
> with "won't hurt, might help, not strictly needed" cases (which I believe
> this one is). I'll instead list the reasons for/against it (to give some
> background) and will let you/others make the call.
> 
> Reasons FOR including this patch in 6.6-stable:
> - It is the correct (i.e. standards-compliant) thing to do.
> - Because of that, I'd be very surprised if it caused a regression.
> - It would be helpful to people who are backporting support for the
>   affected board(s) onto 6.6 while they wait for 6.7. (I am one.)

Great!

> Reasons AGAINST including this patch in 6.6-stable:
> - The bug it fixes is a solid, reliable crash on boot, which happens
>   virtually 100% of the time on affected boards. If it affected any of
>   the boards supported by 6.6, we'd probably have heard of it by now.

Ok, but as this is marked "Fixes:" that is why it was picked up.

> - 6.6 isn't LTS

It isn't?  That's news to me, you might want to check the page:
	https://kernel.org/category/releases.html
:)

thanks,

greg k-h
