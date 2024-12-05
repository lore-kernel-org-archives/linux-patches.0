Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DA118E028;
	Thu,  5 Dec 2024 09:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733390857; cv=none; b=Qedt+GAtQAK2XSFMismHsSJiDDSXZzAtOuCLYaR+FG42flcBFcg5tILS5w6idM53U/C03MfldkrfWTznKV4e+kVuf9NHS5yuJ5Y3Sa5pzuxj5cSZNoviFy681CsJ7oMGjpsADgrZCV+jyALxOEWEn4q5woUe4QIvb7cKoP6XIac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733390857; c=relaxed/simple;
	bh=Kv1oegbIuBj+bRVgx2yuah3tYOZ7jP9hLeTNPPI8eM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpq/zp4NgXTVDJLjPvdprbF/dY9YKfHinJLgiyjMUZ2h6z9PDx/z7hb7Yl05UAVFKpGlA+TaO6zm9V8jN+3VoG1XPFn1j/JFdHcyRBucG3qRsn3OEYdXkm3eavCz+xbev2AzdPt9G2dGjURkyi0Wfe2tDghwjT28asYV3DGiA/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruM+KNnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruM+KNnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B7AC4CED1;
	Thu,  5 Dec 2024 09:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733390856;
	bh=Kv1oegbIuBj+bRVgx2yuah3tYOZ7jP9hLeTNPPI8eM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ruM+KNnvxw6+yXSZbjX1N1ZVvIpayLAnNfvrrzUofA4HmwnSYuS8iqQ7Fzv85jlmo
	 Cm/X65LDu3iDj8muk7zzG6ZtsQS1dx9kmEHxL1Ll02s0lP/kGE9Gk0JOcnXNpo1owZ
	 mAD3KHEIzfnt5e05qbrLYnwCXLoKCiLnIcjwe3eo=
Date: Thu, 5 Dec 2024 10:27:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: James Clark <james.clark@linaro.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>, stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>, Ian Rogers <irogers@google.com>,
	patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Yang Jihong <yangjihong@bytedance.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	Howard Chu <howardchu95@gmail.com>, Ze Gao <zegao2021@gmail.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Weilin Wang <weilin.wang@intel.com>, Will Deacon <will@kernel.org>,
	Mike Leach <mike.leach@linaro.org>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>, Leo Yan <leo.yan@linux.dev>,
	ak@linux.intel.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.infradead.org,
	Sun Haiyong <sunhaiyong@loongson.cn>,
	John Garry <john.g.garry@oracle.com>,
	Justin Forbes <jforbes@fedoraproject.org>
Subject: Re: [PATCH 6.12 470/826] perf stat: Uniquify event name improvements
Message-ID: <2024120517-reason-icing-8e77@gregkh>
References: <20241203144743.428732212@linuxfoundation.org>
 <20241203144802.097952233@linuxfoundation.org>
 <f2ada8a7-165b-41fb-8b7b-3c0d16bb8216@leemhuis.info>
 <deb83bf5-2342-479c-b1bd-7f8c49f5b1d4@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb83bf5-2342-479c-b1bd-7f8c49f5b1d4@linaro.org>

On Thu, Dec 05, 2024 at 08:54:15AM +0000, James Clark wrote:
> 
> 
> On 03/12/2024 5:24 pm, Thorsten Leemhuis wrote:
> > On 03.12.24 15:43, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Ian Rogers <irogers@google.com>
> > > 
> > > [ Upstream commit 057f8bfc6f7070577523d1e3081081bbf4229c1c ]
> > > 
> > > Without aggregation on Intel:
> > 
> > My 6.11.y-rc and 6.12.y-rc builds for Fedora failed when building perf.
> > I did not bisect, but from a brief look at the error message (see
> > below) I suspect it might be caused by this patch, which is the
> > second of the patch-set "Event parsing fixes":
> > https://lore.kernel.org/all/20240926144851.245903-1-james.clark@linaro.org/
> > 
> > To my untrained eyes and from a quick look I guess the first patch
> > in the series needs to be backported as well:
> > perf evsel: Add alternate_hw_config and use in evsel__match
> > https://lore.kernel.org/all/20240926144851.245903-2-james.clark@linaro.org/
> > 
> > This is 22a4db3c36034e ("perf evsel: Add alternate_hw_config
> > and use in evsel__match") in mainline. I tried to cherry-pick it
> > on-top of 6.12.2-rc1, but there were a few small conflicts.
> > 
> > Ciao, Thorsten
> > 
> 
> Yes I imagine both commits are required. Another option is to not backport
> this one. It looks like it's mainly to fix a test, nothing is missing or
> wrong from the output, just the formatting is off.


Thanks, I'll just drop this patch from the stable queue for now.

greg k-h
