Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FFF33F8D2;
	Thu, 13 Nov 2025 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040137; cv=none; b=gyJvzsMlZvCIXajIPmcH5U2P6VEf69zmWpm2JWEGWgJ7rewI4CsQABSO1TtQweh5AuPY/W4+NwQeC+nJZmCPMNEuhdz+L5VoeCnBhmdEdyhG/tklEbBg5jW3iAlKtUkyqoc+4mBNzSvVZ1QQ4in9C38BPzXr0qpgStqIEQ8baP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040137; c=relaxed/simple;
	bh=2tikzxEHnmdkbUqaFaA988rollYf1y6GcLUgGwj7ekE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwuWqifkHlFjdtajxVUh/ZK+WkIbI6pLaroj4qSeE2hQZNoCWhqrcd+0DODhJqRK8vb8rPpB0QJFPU5Jtm1rySWHW2nOo2j+9ofBnw4UlqEeUqG8dY5MN0a4j1jK3Tciv/mjlwYT+LfS28y6914fqhv1UHoL7Ix39LBidETYshs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTx28SKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTx28SKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55252C4CEF5;
	Thu, 13 Nov 2025 13:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763040136;
	bh=2tikzxEHnmdkbUqaFaA988rollYf1y6GcLUgGwj7ekE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mTx28SKrpAv8HJij+nUqzAAwSFH7Lb9RM0nU8Fp2QIwgioPnwFxElbUHhFAVOETZy
	 OYX79AEqwveFkBOraZC5MGM7zllMmx4DNMITFwlmpLnGUqu/y7L6w13Gu+6/WXkmS7
	 LbWDR2CQxCxGV5BOy7a3kDxOrn66LoitUX+XR1qc=
Date: Thu, 13 Nov 2025 08:22:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com, Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
Message-ID: <2025111355-confound-anyplace-6719@gregkh>
References: <20251111012348.571643096@linuxfoundation.org>
 <5b13fb12-66ac-4502-a93b-d79692cc7b81@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b13fb12-66ac-4502-a93b-d79692cc7b81@oracle.com>

On Thu, Nov 13, 2025 at 03:48:53PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 11/11/25 06:54, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.58 release.
> > There are 562 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> > Anything received after that time might be too late.
> 
> link.c: In function ‘is_x86_ibt_enabled’:
> link.c:288:37: error: array type has incomplete element type ‘struct
> kernel_config_option’
>   288 |         struct kernel_config_option options[] = {
>       |                                     ^~~~~~~
> In file included from /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:8,
>                  from main.h:14,
>                  from link.c:17:
> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/build_bug.h:16:51:
> error: bit-field ‘<anonymous>’ width not an integer constant
>    16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e));
> })))
>       |                                                   ^
> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/compiler-gcc.h:26:33:
> note: in expansion of macro ‘BUILD_BUG_ON_ZERO’
>    26 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a),
> &(a)[0]))
>       |                                 ^~~~~~~~~~~~~~~~~
> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:103:59:
> note: in expansion of macro ‘__must_be_array’
>   103 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> __must_be_array(arr))
>       | ^~~~~~~~~~~~~~~
> link.c:291:22: note: in expansion of macro ‘ARRAY_SIZE’
>   291 |         char *values[ARRAY_SIZE(options)] = { };
>       |                      ^~~~~~~~~~
> link.c:294:13: warning: implicit declaration of function
> ‘read_kernel_config’ [-Wimplicit-function-declaration]
>   294 |         if (read_kernel_config(options, ARRAY_SIZE(options), values,
> NULL))
>       |             ^~~~~~~~~~~~~~~~~~
> In file included from /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:8,
>                  from main.h:14,
>                  from link.c:17:
> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/build_bug.h:16:51:
> error: bit-field ‘<anonymous>’ width not an integer constant
>    16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e));
> })))
>       |                                                   ^
> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/compiler-gcc.h:26:33:
> note: in expansion of macro ‘BUILD_BUG_ON_ZERO’
>    26 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a),
> &(a)[0]))
>       |                                 ^~~~~~~~~~~~~~~~~
> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:103:59:
> note: in expansion of macro ‘__must_be_array’
>   103 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> __must_be_array(arr))
>       | ^~~~~~~~~~~~~~~
> link.c:294:41: note: in expansion of macro ‘ARRAY_SIZE’
>   294 |         if (read_kernel_config(options, ARRAY_SIZE(options), values,
> NULL))
>       |                                         ^~~~~~~~~~
> link.c:291:15: warning: unused variable ‘values’ [-Wunused-variable]
>   291 |         char *values[ARRAY_SIZE(options)] = { };
>       |               ^~~~~~
> link.c:288:37: warning: unused variable ‘options’ [-Wunused-variable]
>   288 |         struct kernel_config_option options[] = {
>       |                                     ^~~~~~~
> make: *** [Makefile:249: link.o] Error 1
> make: *** Waiting for unfinished jobs....
> 
> 
> I see this with bpftool build.
> 
> let us drop this commit ?
> 
> commit: c8271196124a ("bpftool: Add CET-aware symbol matching for x86_64
> architectures")
> 

Already dropped.

thanks,

greg k-h
