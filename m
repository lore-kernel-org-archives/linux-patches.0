Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F88621
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 10:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55C4C433C8;
	Tue, 12 Sep 2023 10:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694516108;
	bh=sHKKugO9ZHrlkUfenT+hGUjJb9NF61q8E7uoZuqlIv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K24iGGg6iZmRjCoxEg+q7CgM8abJKPMCHrzsJhKoHJGOCztq99hWTPGViLOCWihDS
	 MpDAS8gmkjKDnobnXDprse5mIcawO2z3bAG2s2B+L8tBwT5Jf0p1FKaG1tQebzlwl4
	 Rw4mZnGayP+WxXWlYM/KtRB39eSn8V4L3ReUO3Ug=
Date: Tue, 12 Sep 2023 12:55:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 363/739] ASoC: pxa: merge DAI call back functions
 into ops
Message-ID: <2023091247-playmaker-ferocity-e647@gregkh>
References: <20230911134650.921299741@linuxfoundation.org>
 <20230911134701.287984009@linuxfoundation.org>
 <ZP8oR4nDRDpsxLkM@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZP8oR4nDRDpsxLkM@finisterre.sirena.org.uk>

On Mon, Sep 11, 2023 at 03:46:31PM +0100, Mark Brown wrote:
> On Mon, Sep 11, 2023 at 03:42:42PM +0200, Greg Kroah-Hartman wrote:
> > 6.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > 
> > [ Upstream commit 98e268a7205706f809658345399eead7c7d1b8bb ]
> > 
> > ALSA SoC merges DAI call backs into .ops.
> > This patch merge these into one.
> 
> This is obviously not stable material.

Odd, Sasha, how did these get picked by your scripts?

I've dropped all 3 now, thanks for noticing them.

greg k-h
