Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C8E1C03
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 06:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF90C433C7;
	Wed,  2 Aug 2023 06:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690959189;
	bh=FpU2fyhNMs7CHd9y1zToO5EeJxJhSPteDxDb++5tacw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p71HyxiJx9QcD7JeKHHHb/gShyaHoJUJGdr3TJ7jDIQpsJpW2Kb0gcBZAiugw9BNv
	 C6fxiJ3XlBsU2NCkq4K/iIqZVDuWeq82IE7vIw+nFTWKPeFfy18mAUB8eNOLxyc9pW
	 e/Cs1dbir9xYJY+kWLQLlcvx8W8cs2lGOS8ahMhQ=
Date: Wed, 2 Aug 2023 08:53:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, Aaron Lewis <aaronlewis@google.com>,
	kvm list <kvm@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 6.4 000/239] 6.4.8-rc1 review
Message-ID: <2023080245-papaya-simple-cd09@gregkh>
References: <20230801091925.659598007@linuxfoundation.org>
 <CA+G9fYsv5dFJfjNq7O+CW3J9jEV0zDQiOR+8dyacwhpDih0xJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsv5dFJfjNq7O+CW3J9jEV0zDQiOR+8dyacwhpDih0xJw@mail.gmail.com>

On Wed, Aug 02, 2023 at 08:22:59AM +0530, Naresh Kamboju wrote:
> On Tue, 1 Aug 2023 at 15:11, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.4.8 release.
> > There are 239 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Following kselftest build regression found,
> 
>     selftests/rseq: Play nice with binaries statically linked against
> glibc 2.35+
>     commit 3bcbc20942db5d738221cca31a928efc09827069 upstream.
> 
> 
>     To allow running rseq and KVM's rseq selftests as statically linked
>     binaries, initialize the various "trampoline" pointers to point directly
>     at the expect glibc symbols, and skip the dlysm() lookups if the rseq
>     size is non-zero, i.e. the binary is statically linked *and* the libc
>     registered its own rseq.
> 
>     Define weak versions of the symbols so as not to break linking against
>     libc versions that don't support rseq in any capacity.
> 
>     The KVM selftests in particular are often statically linked so that they
>     can be run on targets with very limited runtime environments, i.e. test
>     machines.
> 
>     Fixes: 233e667e1ae3 ("selftests/rseq: Uplift rseq selftests for
> compatibility with glibc-2.35")
>     Cc: Aaron Lewis <aaronlewis@google.com>
>     Cc: kvm@vger.kernel.org
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
>     Message-Id: <20230721223352.2333911-1-seanjc@google.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> Build log:
> ----
> x86_64-linux-gnu-gcc -O2 -Wall -g -I./ -isystem
> /home/tuxbuild/.cache/tuxmake/builds/1/build/usr/include
> -L/home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/rseq
> -Wl,-rpath=./   -shared -fPIC rseq.c -lpthread -ldl -o
> /home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/rseq/librseq.so
> rseq.c:41:1: error: unknown type name '__weak'
>    41 | __weak ptrdiff_t __rseq_offset;
>       | ^~~~~~
> rseq.c:41:18: error: expected '=', ',', ';', 'asm' or '__attribute__'
> before '__rseq_offset'
>    41 | __weak ptrdiff_t __rseq_offset;
>       |                  ^~~~~~~~~~~~~
> rseq.c:42:7: error: expected ';' before 'unsigned'
>    42 | __weak unsigned int __rseq_size;
>       |       ^~~~~~~~~
>       |       ;
> rseq.c:43:7: error: expected ';' before 'unsigned'
>    43 | __weak unsigned int __rseq_flags;
>       |       ^~~~~~~~~
>       |       ;
> rseq.c:45:47: error: '__rseq_offset' undeclared here (not in a
> function); did you mean 'rseq_offset'?
>    45 | static const ptrdiff_t *libc_rseq_offset_p = &__rseq_offset;
>       |                                               ^~~~~~~~~~~~~
>       |                                               rseq_offset
> make[3]: Leaving directory 'tools/testing/selftests/rseq'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Links:
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2TNSVjRCfcIaJWQNkPwDQ9jn2ls/build.log
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.4.7-240-g2c273bf138a4/testrun/18770115/suite/kselftest-rseq/test/shardfile-rseq/details/

Odd this didn't also show up in 6.1.  I'll go drop the offending commit
for now.

thanks,

greg k-h
