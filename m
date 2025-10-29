Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCE32F9D8C;
	Wed, 29 Oct 2025 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733244; cv=none; b=MS0Z7e81umbHhSck4lb4kvzVUKh6OnesDwk/guoT8LV1aoDRob7UXhrDKN4/2de828UiasT9IXVCl9P6bq/ZoZi7b6aBI/3AAxlFgnD2v4MDSH4TwHtG3TLcEQVS3348EsHi2+vOTSTC/qtehuIRPagoaH7wArgMqDXnLtqeXKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733244; c=relaxed/simple;
	bh=c1TdOkjnOZlP2GlxsfJ8OdXIv90bptzTXeSYdiA20y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XaGMgtmrWyk1YqktBxxReSU6x1HSUVz/CimHw3h85rzvQ/EXm0IcRIv3upVHpeG3Y+n+sc/hwGTfYg9VE0P7ptJotyR1OzI2Kf0YkQHBfAJwXEDXXmohMcAyO/dF4vJ4tRA8g1UlCJpOb4ERCgsehjP0djSRrGcdpKxIfZsiCQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVCNxP7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVCNxP7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177DEC4CEF7;
	Wed, 29 Oct 2025 10:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761733243;
	bh=c1TdOkjnOZlP2GlxsfJ8OdXIv90bptzTXeSYdiA20y8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lVCNxP7jh+pVgUXZpvb7QItK8Ppjl081PVO1vlc1XqmAS0BA22dbat+UDNgn3jIUi
	 6iti6n6oK0P20Svf5naPb5WSKlHWtxTZVk1NHG3v4wQ5YS8TJHEGqbtdQklcuK/+he
	 Eg6cg60X9lS4D26z7n/fByPyAdqXuTqcvw9AINDM=
Date: Wed, 29 Oct 2025 11:20:38 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vijayendra Suman <vijayendra.suman@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/123] 5.15.196-rc1 review
Message-ID: <2025102912-cosmetics-reflector-ab4f@gregkh>
References: <20251027183446.381986645@linuxfoundation.org>
 <86abc1a6-6bed-460c-80fd-a74570c98ac8@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86abc1a6-6bed-460c-80fd-a74570c98ac8@oracle.com>

On Tue, Oct 28, 2025 at 09:11:58PM +0530, Vijayendra Suman wrote:
> 
> 
> On 28/10/25 12:04 am, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.196 release.
> > There are 123 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/
> > patch-5.15.196-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf failed to compile with following errors at compilation.
> 
> BUILDSTDERR: tests/perf-record.c: In function 'test__PERF_RECORD':
> BUILDSTDERR: tests/perf-record.c:118:17: error: implicit declaration of
> function 'evlist__cancel_workload'; did you mean 'evlist__start_workload'?
> [-Werror=implicit-function-declaration]
> BUILDSTDERR:   118 |                 evlist__cancel_workload(evlist);
> BUILDSTDERR:       |                 ^~~~~~~~~~~~~~~~~~~~~~~
> BUILDSTDERR:       |                 evlist__start_workload
> 
> 
> There is no definition for evlist__cancel_workload
> 
> Following are references of 'evlist__cancel_workload'
> tools/perf/tests/perf-record.c:118:	evlist__cancel_workload(evlist);
> tools/perf/tests/perf-record.c:130:	evlist__cancel_workload(evlist);
> tools/perf/tests/perf-record.c:142:	evlist__cancel_workload(evlist);
> tools/perf/tests/perf-record.c:155:	evlist__cancel_workload(evlist);
> 
> 
> Commit which need to be reverted.
> b7e5c59f3b09 perf test: Don't leak workload gopipe in PERF_RECORD_*

This is already being reverted in the latest -rc release, does that not
work here for you?

thanks,

greg k-h
