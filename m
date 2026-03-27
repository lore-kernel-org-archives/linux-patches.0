Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CC83CA4A2;
	Fri, 27 Mar 2026 09:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774603096; cv=none; b=iQ3C3ECLQOHJEpegTyakhowu4vOc5Uf4bgd/OK4HToNwIWJcJAfUAUjg+/r510+cfWNq1CaExSnQ10LuP+HNYy398Jcmx+6zXd08N5lh5tpunbYlzv4qrdtnySjbp4h2Z8R+rs6Aj7QfpBWoai1xSd/GDdBw78gEVf3EYV1dHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774603096; c=relaxed/simple;
	bh=EdZE4OSQJ5jcy+T+KWJVJdsHRhqdz9413qk1sHzTPOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULExfaxKo+m/+6CytB4Mh9GyRNO30kZF5CeiOtdeG7mhWwC8MGlECC/neBcYYDSCB9D0scPfqIJ0s86nXQqJGOxSeHZTazCcVSVEjZMeGEkcRcvstxdFjDYGz/mNLsfBLmxMnFyrOPZxrTo/JA9RxPiJhUBXZWzE0MeWCBrgwKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsQTH7m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsQTH7m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB33EC19423;
	Fri, 27 Mar 2026 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774603095;
	bh=EdZE4OSQJ5jcy+T+KWJVJdsHRhqdz9413qk1sHzTPOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsQTH7m8ePru7c0sy4eNd/mRAkAQI8WTiLS1J7yZtNThprzbeZMb3AQoZ2FIisOJL
	 GT9TIP+YQXW54oLAmgxPbfupDogNxCSuvEyBoqDZZ8mVnazGdrje6uL7t7CZfqJxqq
	 qQggKw/j8vWRvGhekGIkKLO+Jvs0vhal1hkDFEPA=
Date: Fri, 27 Mar 2026 10:17:51 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhuacai@loongson.cn>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	Tianyang Zhang <zhangtianyang@loongson.cn>
Subject: Re: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
Message-ID: <2026032736-reproach-dipper-f6bc@gregkh>
References: <20260323134526.647552166@linuxfoundation.org>
 <20260325000600.57287-1-ojeda@kernel.org>
 <7f616aa1.4eda2.19d27b31b8c.Coremail.chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f616aa1.4eda2.19d27b31b8c.Coremail.chenhuacai@loongson.cn>

On Thu, Mar 26, 2026 at 09:12:22AM +0800, 陈华才 wrote:
> Hi, Greg, Sasha,
> 
> 
> > -----原始邮件-----
> > 发件人: "Miguel Ojeda" <ojeda@kernel.org>
> > 发送时间:2026-03-25 08:06:00 (星期三)
> > 收件人: gregkh@linuxfoundation.org
> > 抄送: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org, "Miguel Ojeda" <ojeda@kernel.org>, "Huacai Chen" <chenhuacai@loongson.cn>, "Tianyang Zhang" <zhangtianyang@loongson.cn>
> > 主题: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
> > 
> > On Mon, 23 Mar 2026 14:39:56 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.12.78 release.
> > > There are 460 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> > > Anything received after that time might be too late.
> > 
> > Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> > for loongarch64:
> > 
> > Tested-by: Miguel Ojeda <ojeda@kernel.org>
> > 
> > loongarch64 failed to build for me:
> > 
> >     arch/loongarch/kernel/machine_kexec.c:139:13: error: static declaration of 'machine_kexec_mask_interrupts' follows non-static declaration
> >       139 | static void machine_kexec_mask_interrupts(void)
> >           |             ^
> >     ./include/linux/irq.h:698:13: note: previous declaration is here
> >       698 | extern void machine_kexec_mask_interrupts(void);
> >           |             ^
> > 
> > The `static void machine_kexec_mask_interrupts(void)` for loongarch64
> > was not removed because it was adjusted in:
> > 
> >   429bf3f04c24 ("LoongArch: Add machine_kexec_mask_interrupts() implementation")
> Yes, 429bf3f04c24 ("LoongArch: Add machine_kexec_mask_interrupts() implementation")
> should be reverted for this version. But why you ignore Miguel's report?

Sorry, but your footer email:

> 本邮件及其附件含有龙芯中科的商业秘密信息，仅限于发送给上面地址中列出的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制或散发）本邮件及其附件中的信息。如果您错收本邮件，请您立即电话或邮件通知发件人并删除本邮件。 
> This email and its attachments contain confidential information from Loongson Technology , which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it. 
> 
> 


Caused me to miss this as my filters shove it aside :(

Anyway, my fault, I'll go take your revert now, and do a quick release
to resolve this issue, sorry about that.  They "joys" of doing stable
releases while traveling at a conference at the same time...

greg k-h
