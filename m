Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE6219478;
	Wed, 31 Jul 2024 05:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722404975; cv=none; b=TA9zDRY23VXptguIs/WCQ0JBrmcirmAJmWz2k3YXBFf4zP0CAkOOPk4vOoq3AfPaLHfPaA5FAqxwgIcWWe02lcbQ6qEQaLxgBEpSiz4D37ZwQjvoV2jlWYcxKs5gKxrIEdM1lYK8Qy6xr5Do5rHqE2uMRrQkEkrz0cLlyxJTJsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722404975; c=relaxed/simple;
	bh=eXcqmBndTRpa3HNOD/A4teZbbIWh1ws+bEzJUZzfvvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skjNYjVytUIvxLUv/36uRbvpyawfSnPIMLBNGdZS76goyDKeOi/hJiOUiRgAVAeceUDGZmiO+iOVxcDppIMYPT7dkf8oz37Rp4dShdCoABoPqgP7+4s2ugv44pSEdn5LKSmc+A1q0Sqg1UHWHfvhdOTmC8CvPWGkNN+DT3LtaWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJMM6kZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJMM6kZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B28C116B1;
	Wed, 31 Jul 2024 05:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722404975;
	bh=eXcqmBndTRpa3HNOD/A4teZbbIWh1ws+bEzJUZzfvvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HJMM6kZp7xj7CSUeRmCnZuFfDCyuEnAs/2sN9qPBY8t1ijzGe5Nb3ykH7+eAtCRVf
	 xBe6/4QndBhwqek3Ed9OBV+2S8Rd2SZBuy1ugcfIOnBA1Fr4cRY99V27qNuXQ66viL
	 /BeEiz599qYtjOAEfWr0wCkE+3+enHS8RlflbGqY=
Date: Wed, 31 Jul 2024 07:49:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc1 review
Message-ID: <2024073112-stir-glue-d1b5@gregkh>
References: <20240730151724.637682316@linuxfoundation.org>
 <86c0c9ee-f1f3-414a-bde3-c171bbce85c1@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86c0c9ee-f1f3-414a-bde3-c171bbce85c1@gmail.com>

On Tue, Jul 30, 2024 at 04:03:30PM -0700, Florian Fainelli wrote:
> On 7/30/24 08:37, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.10.3 release.
> > There are 809 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf failed to build with the following error:
> 
> In file included from tests/pmu.c:7:
> tests/pmu.c: In function 'test__name_len':
> tests/pmu.c:400:25: error: too few arguments to function
> 'pmu_name_len_no_suffix'
>   TEST_ASSERT_VAL("cpu", pmu_name_len_no_suffix("cpu") == strlen("cpu"));
>                          ^~~~~~~~~~~~~~~~~~~~~~
> tests/tests.h:15:8: note: in definition of macro 'TEST_ASSERT_VAL'
>   if (!(cond)) {        \
>         ^~~~
> In file included from util/evsel.h:13,
>                  from util/evlist.h:14,
>                  from tests/pmu.c:2:
> util/pmus.h:8:5: note: declared here
>  int pmu_name_len_no_suffix(const char *str, unsigned long *num);
>      ^~~~~~~~~~~~~~~~~~~~~~
> In file included from tests/pmu.c:7:
> 
> this is caused by 958e16410f96ee72efc7a93e5d1774e8a236f2f5 ("perf tests: Add
> some pmu core functionality tests")

Thanks, now dropped.  I'll do a -rc2 in a bit so that tests can verify
this works properly.

greg k-h

