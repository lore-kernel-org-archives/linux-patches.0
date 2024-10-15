Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9924F1D8A1E;
	Tue, 15 Oct 2024 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728990632; cv=none; b=jtro8TwmlBPySbxxIzgT7idjmmJoADVTwNzYeffp8spoa/IVcZR5kASeLbmymu4Th34X9/h1YyQT/X95W0bvf8AlGrmVhxzrZpdNome+DsT6v9yDVNKEWitGiLFW6e9POKBtUpXXoExsroRU8K6GWZze+CET8I6qgmU90sF1Ifs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728990632; c=relaxed/simple;
	bh=5aeyu7uYwG5DbyLuOUrkdyPSoIVIgnN8aSc3vEfPZko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMgNmdcSDV2Yw9f2uQp8ho8H90edB0BQ+gEjz4EG46dbr+ShHD4m/ljZBBK/fKTIQrBQ6GPFJDJMNkGO+BjtVNk+J76+UMvC3WeKRQaCp2u45KXr2oiCiaO5drPbINtU/aKQyyQ9paOiS6YGmL5wRxq+jyGebyzw5hv9ne1wjXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENbINzWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENbINzWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF58C4CEC6;
	Tue, 15 Oct 2024 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728990632;
	bh=5aeyu7uYwG5DbyLuOUrkdyPSoIVIgnN8aSc3vEfPZko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ENbINzWKQ1ZfE+FvEJLhMNiqk7edL7FDZBQ1cSXZFCak+odzJT0JPts2eIZAE+Bg7
	 4reoEFrfhZnCWmxBAx/nKn+xg9zbJo6SRv+lhK6+hHTc5X5MERaZW0lbH0JT49WG4i
	 JLxvs3eH2mDSjdcqBiERxYvCjl5Mlm20i3d7eE+8=
Date: Tue, 15 Oct 2024 13:10:28 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
Message-ID: <2024101514-blurred-nappy-547a@gregkh>
References: <20241014141044.974962104@linuxfoundation.org>
 <CA+G9fYsPPmEbjNza_Tjyf+ZweuHcjHboOJfHeVSSVnmEV2gzXw@mail.gmail.com>
 <cdb9391d-88ee-430c-8b3b-06b355f4087f@kernel.org>
 <6dd1f93f-2900-41cc-a369-1ce397e1fb52@kernel.org>
 <20241015094645.7641-F-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241015094645.7641-F-hca@linux.ibm.com>

On Tue, Oct 15, 2024 at 11:46:45AM +0200, Heiko Carstens wrote:
> On Tue, Oct 15, 2024 at 10:51:31AM +0200, Jiri Slaby wrote:
> > On 15. 10. 24, 9:18, Jiri Slaby wrote:
> > > On 15. 10. 24, 9:05, Naresh Kamboju wrote:
> > > > On Mon, 14 Oct 2024 at 19:55, Greg Kroah-Hartman
> > > Reverting of this makes it work again:
> > > commit 51ab63c4cc8fbcfee58b8342a35006b45afbbd0d
> > > Refs: v6.11.3-19-g51ab63c4cc8f
> > > Author:     Heiko Carstens <hca@linux.ibm.com>
> > > AuthorDate: Wed Sep 4 11:39:27 2024 +0200
> > > Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > CommitDate: Mon Oct 14 16:10:09 2024 +0200
> > > 
> > >      s390/boot: Compile all files with the same march flag
> > > 
> > >      [ Upstream commit fccb175bc89a0d37e3ff513bb6bf1f73b3a48950 ]
> > > 
> > > 
> > > If the above is to be really used in stable (REASONS?), I believe at
> > > least these are missing:
> > > ebcc369f1891 s390: Use MARCH_HAS_*_FEATURES defines
> > > 697b37371f4a s390: Provide MARCH_HAS_*_FEATURES defines
> > 
> > And this one:
> > db545f538747 s390/boot: Increase minimum architecture to z10
> 
> All of this is not supposed to be stable material.
> 

Agreed, I'm dropping this compile s390 patch, thanks for the build
testing everyone!  Something went wrong with the testing on our end,
odd...

thanks,

greg k-h
