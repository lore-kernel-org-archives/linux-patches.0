Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C888A926;
	Sat,  1 Feb 2025 08:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738396922; cv=none; b=StUzuFxqnIrMp0UkmCheJxiFGKyLr6mxIWkmO6RzPslCPWwPI4/lkHcaAmLhwy/RPG0eu8mRnwXU8h0b6TBcwSyaMZ1MYZtjKwQ6fHpE9Ykw+klS7tpOY23gn9cQW4v9SZcaRcop7PxqJapSwUDOaiWY7W9FbUaq/6EdUEF2h+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738396922; c=relaxed/simple;
	bh=QMNUhnUsHsuDztU3+W1P5HHJ8lC0gLPS9tlMBXogCtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVR0egw8mD9qU1fsomRnV19MLkRkFbNM4lvqAf+l0/ArZTG2G3UcTgsoVj/zhsHiqBFXffBy0T3UQ0O7IZHnpryDQT6ulHbXTsb/XRwXZ8IwGoOJU/MUssd/3T7dOzFSjvNVdYiKPI0F6LE/bi/kEM5LcYbj7e7PCqRwrUwZxtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwdkCAyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwdkCAyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22855C4CED3;
	Sat,  1 Feb 2025 08:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738396921;
	bh=QMNUhnUsHsuDztU3+W1P5HHJ8lC0gLPS9tlMBXogCtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dwdkCAyDU7IJ76TJLkAclwDoiql86WdlfbwshjDnWaMVqdT4oV7NeE62DIHZ9FYZl
	 2PTxRWbVdRw8Ay6o/+Nkjav7qPxHvz5wg/DDjxcPqpmVA6z4e8KHVkgtTsxOFpfcGL
	 CPCbM/Di69X32rltTpFTLAvDvu18Jc3wt2i6bIxM=
Date: Sat, 1 Feb 2025 09:01:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
Message-ID: <2025020157-unsecured-map-aa0c@gregkh>
References: <20250131112114.030356568@linuxfoundation.org>
 <Z5zIZHIZxuHoymof@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5zIZHIZxuHoymof@duo.ucw.cz>

On Fri, Jan 31, 2025 at 01:56:04PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.4.290 release.
> > There are 94 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Still not ok.
> 
> In file included from ./arch/riscv/include/asm/ptrace.h:10,
> 1128
>                  from ./arch/riscv/include/asm/processor.h:11,
> 1129
>                  from ./arch/riscv/include/asm/irqflags.h:10,
> 1130
>                  from ./include/linux/irqflags.h:16,
> 1131
>                  from ./arch/riscv/include/asm/bitops.h:14,
> 1132
>                  from ./include/linux/bitops.h:27,
> 1133
>                  from ./include/linux/kernel.h:12,
> 1134
>                  from ./include/linux/list.h:9,
> 1135
>                  from ./include/linux/kobject.h:19,
> 1136
>                  from ./include/linux/device.h:16,
> 1137
>                  from ./include/linux/node.h:18,
> 1138
>                  from ./include/linux/cpu.h:17,
> 1139
>                  from arch/riscv/kernel/traps.c:6:
> 1140
> arch/riscv/kernel/traps.c: In function 'trap_init':
> 1141
> arch/riscv/kernel/traps.c:164:23: error: 'handle_exception' undeclared (first use in this function)
> 1142
>   164 |  csr_write(CSR_TVEC, &handle_exception);
> 1143
>       |                       ^~~~~~~~~~~~~~~~
> 1144
> ./arch/riscv/include/asm/csr.h:166:38: note: in definition of macro 'csr_write'
> 1145
>   166 |  unsigned long __v = (unsigned long)(val);  \
> 1146
>       |                                      ^~~
> 1147

What's it with the blank lines?

Anyway, are you all really caring about riscv on a 5.4.y kernel?  Last I
checked, the riscv maintainers said not to even use that kernel for that
architecture.  Do you all have real boards that care about this kernel
tree that you are insisting on keeping alive?  Why not move them to a
newer LTS kernel?

thanks,

greg k-h
