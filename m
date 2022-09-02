Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529D566E1;
	Fri,  2 Sep 2022 11:31:25 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4MJwj11jcpz4xG9;
	Fri,  2 Sep 2022 21:31:17 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, llvm@lists.linux.dev, Kajol Jain <kjain@linux.ibm.com>, patches@lists.linux.dev, Tom Rix <trix@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20220830151256.1473169-1-nathan@kernel.org>
References: <20220830151256.1473169-1-nathan@kernel.org>
Subject: Re: [PATCH] powerpc/papr_scm: Ensure rc is always initialized in papr_scm_pmu_register()
Message-Id: <166211825227.554590.4969553793169461587.b4-ty@ellerman.id.au>
Date: Fri, 02 Sep 2022 21:30:52 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 30 Aug 2022 08:12:56 -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   arch/powerpc/platforms/pseries/papr_scm.c:492:6: warning: variable 'rc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>           if (!p->stat_buffer_len)
>               ^~~~~~~~~~~~~~~~~~~
>   arch/powerpc/platforms/pseries/papr_scm.c:523:64: note: uninitialized use occurs here
>           dev_info(&p->pdev->dev, "nvdimm pmu didn't register rc=%d\n", rc);
>                                                                         ^~
>   include/linux/dev_printk.h:150:67: note: expanded from macro 'dev_info'
>           dev_printk_index_wrap(_dev_info, KERN_INFO, dev, dev_fmt(fmt), ##__VA_ARGS__)
>                                                                           ^~~~~~~~~~~
>   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
>                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
>                                       ^~~~~~~~~~~
>   arch/powerpc/platforms/pseries/papr_scm.c:492:2: note: remove the 'if' if its condition is always false
>           if (!p->stat_buffer_len)
>           ^~~~~~~~~~~~~~~~~~~~~~~~
>   arch/powerpc/platforms/pseries/papr_scm.c:484:8: note: initialize the variable 'rc' to silence this warning
>           int rc, nodeid;
>                 ^
>                 = 0
>   1 warning generated.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc/papr_scm: Ensure rc is always initialized in papr_scm_pmu_register()
      https://git.kernel.org/powerpc/c/6cf07810e9ef8535d60160d13bf0fd05f2af38e7

cheers
