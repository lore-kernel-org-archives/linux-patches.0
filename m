Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE35320D
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 11:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75130C433F1;
	Thu,  5 Jan 2023 11:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672919016;
	bh=C5S4pknLLvvDIqVA3nXAB2Mbro1adcpPdKMs0YpS8gs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=km+k6zqgpUVt4IUy5am5wYpxeJlKrLcAti6K12OnnrtGeBa0OP2EVB+6CHJL1exky
	 sLlhPK6dojydCChwth3leYyDfe3Ggc1nGxr5opYIvdMJsq1Wveegihg2zJkMMFdwAl
	 cgwwkahvCgZEKeKyySHEHffn4pt5kPJW7Sx/0YKg=
Date: Thu, 5 Jan 2023 12:43:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/63] 5.10.162-rc1 review
Message-ID: <Y7a34Ckczx8ZuczK@kroah.com>
References: <Y7UOtInxdmaIP9nH@kroah.com>
 <7BA3F66A-097C-44F2-AAC8-35ADBEAE7E12@joelfernandes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7BA3F66A-097C-44F2-AAC8-35ADBEAE7E12@joelfernandes.org>

On Wed, Jan 04, 2023 at 04:56:31PM -0500, Joel Fernandes wrote:
> 
> 
> > On Jan 4, 2023, at 12:29 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > ﻿On Tue, Jan 03, 2023 at 04:16:07PM +0000, Joel Fernandes wrote:
> >>> On Tue, Jan 03, 2023 at 09:13:30AM +0100, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 5.10.162 release.
> >>> There are 63 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>> 
> >>> Responses should be made by Thu, 05 Jan 2023 08:12:47 +0000.
> >>> Anything received after that time might be too late.
> >>> 
> >>> The whole patch series can be found in one patch at:
> >>>    https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.162-rc1.gz
> >>> or in the git tree and branch at:
> >>>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> >>> and the diffstat can be found below.
> >>> 
> >>> thanks,
> >> 
> >> Testing fails. Could you please pick these 2 up?
> >> https://lore.kernel.org/r/20221230153215.1333921-1-joel@joelfernandes.org
> >> https://lore.kernel.org/all/20221230153215.1333921-2-joel@joelfernandes.org/
> > 
> > That is not a regression from 5.10.161, right?
> 
> Yes it is not.
> 
> >  This release is only for
> > the io_uring stuff to make sure that backport was done correctly.
> > 
> > The current "to apply" queue for the stable trees is very large right
> > now due to everyone waiting to get tiny things into -rc1 instead of
> > before then, so the above two are still not yet queued up, sorry.
> 
> Sure not a problem, I can resend again later if it is still not queued.

You should have already received the email notices saying they were
queued :)
