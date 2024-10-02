Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3FE1A2561;
	Wed,  2 Oct 2024 09:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727862700; cv=none; b=ACZUmjpj52NL9MugwKC+xyGztugwnSJdqQNNr8WHW5+bf51J5rGTf7ybHacu19qenvYFAKrwMrw04BE4LrYgGMiZNUQQxDtLSWm7HmLko2vYxVXVWnR5NClLPch3fPE70Gxm1YIxifZDb0zhT0qPZHXMIQqvf5ADi7uk1IMt2Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727862700; c=relaxed/simple;
	bh=q3QAIigrSFIlqE6DsjXhqXWu5LwiPL7Y+y83xImc2xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNBA62kxIRkMzI66MZiz1VYkkpQSj3Rni2t90hA3vV3fhoDwpIS2n5Wp1DcTh9Szey6/J2IfmARCNmUu+YE9yOtVnXl1kIG3zse5r+ne1TYOhMNV7mUasP+UYPhPrD1G+wWUg9jMmk+nebcDTUrd43OLS4EDLgGerRTQKJs0m/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tm2Mx/BY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tm2Mx/BY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0350FC4CEC5;
	Wed,  2 Oct 2024 09:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727862699;
	bh=q3QAIigrSFIlqE6DsjXhqXWu5LwiPL7Y+y83xImc2xE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tm2Mx/BYbIsDTQC7gwW76Nd0/2zcgOdOA7Q/SOwY5Zd3ragg68mAg2I4/m75z2Ks3
	 Bu7f++DJScRmcf6yOsxc08rHBL032nrXRnssLScRRL/tPuna0HaugdsH9gnbaR8CTP
	 QWl5dv1soa/5by/Li5R4UogJ9LHWrRq21XFHYc9Q=
Date: Wed, 2 Oct 2024 11:51:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 033/440] arm64: dts: qcom: sm8250: switch UFS QMP PHY
 to new style of bindings
Message-ID: <2024100218-unlined-undefined-1f15@gregkh>
References: <20240730151615.753688326@linuxfoundation.org>
 <20240730151617.057892121@linuxfoundation.org>
 <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GGH0J9z3NCq=jH5PKQewPdrhUiNk-Bu9yKvX8yhsTWDtQ@mail.gmail.com>

On Tue, Oct 01, 2024 at 10:57:55PM +0530, Sumit Semwal wrote:
> Hello Greg,
> 
> On Tue, 30 Jul 2024 at 21:25, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> >
> > [ Upstream commit ba865bdcc688932980b8e5ec2154eaa33cd4a981 ]
> >
> > Change the UFS QMP PHY to use newer style of QMP PHY bindings (single
> > resource region, no per-PHY subnodes).
> 
> This patch breaks UFS on RB5 - it got caught on the merge with
> android14-6.1-lts.
> 
> Could we please revert it? [Also on 5.15.165+ kernels].

Can you please send a revert patch and I will be glad to apply it.

thanks,

greg k-h
