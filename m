Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ECF23EA8F;
	Sun, 19 Oct 2025 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760875793; cv=none; b=jbY1CXe4usxWLDrKr2yripjAUwVV3qsFuk1CeCJPR35pgjinfTS/JDnbV6dr5/XIzmUOgPzYWW6MhXyHurgV7yH7BCpCQlJGd2qtdotsiOHAxVOrzjQMQZRKGXlYwnp0RxNs38Q5b8k5WYgL5TpWphGljntXggQf8AepGZq/eeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760875793; c=relaxed/simple;
	bh=gJbhuLZyGzTwZtEpT+Nxw1k05SyAbolvmCBy6r57UKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRGYJ9pyuAxKUehUt5v7QvAU3sdhQrEt38F+olWjG7CKV1MRCD4ylKddy7xzEWb6UW7dUENZPC5y61Y6iGlOBpaMFZUlZ4cpRxHyJNe0Xj/8hTszvdH7JV4M0TObdu65+2bYHOWuG+o48zOtNLhMJjG+tUU92b9/v2QpYK07lic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLjGY/PS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLjGY/PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49030C4CEE7;
	Sun, 19 Oct 2025 12:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760875792;
	bh=gJbhuLZyGzTwZtEpT+Nxw1k05SyAbolvmCBy6r57UKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wLjGY/PScnWofocpF0c1sWEEuCTttFQ9QirzaI2KDH4TprOiA5fdJVY+GV862SvFB
	 upr6BfK7rRVdoo74ewQ+EoHkrc4mpLaLk6UOauwfdDY63eIUUIOSsDq3t4tojrVcs7
	 MeejCtc9OknCxXO5aAPVfxUPhLHvywwlicIcLZmc=
Date: Sun, 19 Oct 2025 14:09:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, Ali Saidi <alisaidi@amazon.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 5.15 000/276] 5.15.195-rc1 review
Message-ID: <2025101940-glare-agonize-74b6@gregkh>
References: <20251017145142.382145055@linuxfoundation.org>
 <c1b098d5-3499-4e24-aff9-6e5a293b4b1b@gmail.com>
 <acbbf30b-44cd-4f31-a979-dc576585c65b@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acbbf30b-44cd-4f31-a979-dc576585c65b@gmail.com>

On Fri, Oct 17, 2025 at 04:04:38PM -0700, Florian Fainelli wrote:
> +Ali,
> 
> On 10/17/25 15:57, Florian Fainelli wrote:
> > On 10/17/25 07:51, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.195 release.
> > > There are 276 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/
> > > patch-5.15.195-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> > > rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > perf fails to build on ARM, ARM64 and MIPS with:
> > 
> > In file included from util/arm-spe.c:37:
> > /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/
> > include/../../arch/arm64/include/asm/cputype.h:198:10: fatal error: asm/
> > sysreg.h: No such file or directory
> >    198 | #include <asm/sysreg.h>
> >        |          ^~~~~~~~~~~~~~
> > compilation terminated.
> > 
> > I was not able to run a bisection but will attempt to do that later
> > during the weekend.
> 
> That is due to commit 07b49160816a936be7c1e0af869097223e75d547
> Author: Ali Saidi <alisaidi@amazon.com>
> Date:   Thu Aug 11 14:24:39 2022 +0800
> 
>     perf arm-spe: Use SPE data source for neoverse cores
> 
> and this hunk specifically:
> 
> diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
> index 569e1b8ad0ab..7b16898af4e7 100644
> --- a/tools/perf/util/arm-spe.c
> +++ b/tools/perf/util/arm-spe.c
> @@ -34,6 +34,7 @@
>  #include "arm-spe-decoder/arm-spe-decoder.h"
>  #include "arm-spe-decoder/arm-spe-pkt-decoder.h"
> 
> +#include "../../arch/arm64/include/asm/cputype.h"
>  #define MAX_TIMESTAMP (~0ULL)
> 
> There is a dependency on this upstream commit:
> 
> commit 1314376d495f2d79cc58753ff3034ccc503c43c9
> Author: Ali Saidi <alisaidi@amazon.com>
> Date:   Thu Mar 24 18:33:20 2022 +0000
> 
>     tools arm64: Import cputype.h
> 
> 
> for tools/arch/arm64/include/asm/cputype.h to be present.

Thanks, all offending commits now dropped :)

greg k-h

