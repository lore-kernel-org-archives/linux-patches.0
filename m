Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343C453B9
	for <patches@lists.linux.dev>; Fri, 11 Aug 2023 09:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30406C433C8;
	Fri, 11 Aug 2023 09:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691746196;
	bh=v6D48UKTGegLfjLTlU1nSeUP+3kTAFFYh/SkxueOLkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZIEAaR7vzgIbUi75wxr1306a5tqHH2rbBWo6jt8pqwuRMSqp+G7ieHBuepAaXR80
	 I9BwPjvQhjdiUeOYSX20g1qJJtmsKYtczo9RV11acFFSZdzsVJ8b/Zu9ib2SuDVAeU
	 zjQno2ID/hEnrK8Jz7r/X1CWTPNEXoFMDXBmArQ4=
Date: Fri, 11 Aug 2023 11:29:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 000/323] 4.19.291-rc1 review
Message-ID: <2023081139-cozily-untaxed-ca9c@gregkh>
References: <20230809103658.104386911@linuxfoundation.org>
 <252c7673-53ee-4c4b-e5ef-5bb2c0416154@roeck-us.net>
 <fff0f61e-4260-f91a-2254-65daaffae45d@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fff0f61e-4260-f91a-2254-65daaffae45d@roeck-us.net>

On Thu, Aug 10, 2023 at 07:24:32AM -0700, Guenter Roeck wrote:
> On 8/10/23 06:55, Guenter Roeck wrote:
> > On 8/9/23 03:37, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.291 release.
> > > There are 323 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Building sparc64:allnoconfig ... failed
> > --------------
> > Error log:
> > <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso-note.o: missing .note.GNU-stack section implies executable stack
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso32/vdso-note.o: missing .note.GNU-stack section implies executable stack
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> > sparc64-linux-ld: init/main.o: in function `start_kernel':
> > main.c:(.init.text+0x77c): undefined reference to `arch_cpu_finalize_init'
> > 
> > Building sparc64:tinyconfig ... failed
> > --------------
> > Error log:
> > <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso-note.o: missing .note.GNU-stack section implies executable stack
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso32/vdso-note.o: missing .note.GNU-stack section implies executable stack
> > /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> > sparc64-linux-ld: init/main.o: in function `start_kernel':
> > main.c:(.init.text+0x764): undefined reference to `arch_cpu_finalize_init'
> 
> Introduced with v4.19.290.

Thanks for the report, I'll fix these up separately after this release.

greg k-h
