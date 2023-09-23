Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B48CA68
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 08:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F5DC433C7;
	Sat, 23 Sep 2023 08:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695457702;
	bh=cXYllov6kwwjbsZToxpPEImhIzItaoo6s+C0oXgoYtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AVHkhWie5TxAG8s6ZWh8m1ws6syV9uvAWgY8N8D3+hvfF5YtP1qvaq5GdpIclLa/j
	 LRbyQcoS1siQso9AptdqUwdRZih/s9dZGeo7LugvIMTPJ+kRzd7vBuJU8fdeT15Oed
	 VhVXh6wgFppxpKlXJyp69mdQqCC9O9TDs8wn+v9Q=
Date: Sat, 23 Sep 2023 10:28:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>, Sasha Levin <sashal@kernel.org>,
	Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH 5.4 296/367] clk: imx: pll14xx: dynamically configure PLL
 for 393216000/361267200Hz
Message-ID: <2023092310-shuffle-wildlife-0784@gregkh>
References: <20230920112858.471730572@linuxfoundation.org>
 <20230920112906.208711780@linuxfoundation.org>
 <6e3ad25c-1042-f786-6f0e-f71ae85aed6b@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e3ad25c-1042-f786-6f0e-f71ae85aed6b@pengutronix.de>

On Thu, Sep 21, 2023 at 09:03:09AM +0200, Ahmad Fatoum wrote:
> On 20.09.23 13:31, Greg Kroah-Hartman wrote:
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> [snip]
> 
> > Cc: stable@vger.kernel.org # v5.18+
> 
> Objection: This fix is only applicable starting with v5.18, as before
> commit b09c68dc57c9 ("clk: imx: pll14xx: Support dynamic rates"), there
> was no dynamic rate calculation that would substitute the hardcoded
> parameters removed by my patch.

Ok, thanks, now dropped.

greg k-h
