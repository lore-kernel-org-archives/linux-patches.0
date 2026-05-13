Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5742A3EDAC1;
	Wed, 13 May 2026 10:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778668536; cv=none; b=ae5rfDK1sqjrBfFebajV09PqizYope4WDXUbrF/I3zuv+ueRNJmY3drPfQJiUCrPKvXKQjJ2Et3nh9iYhtUguvO05G0+xQFfRG+OKwpCFvH6xRiI2FVexfut2TByL6A9FPiKHfdLN/filKibyq3aYALcW5l8Cems4ENCS6hs3cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778668536; c=relaxed/simple;
	bh=ndNdYCwI/1n4Yejm+049VB4MQiSWshqvGEZ7KYKXSCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o+emeT9onXFwJ/7Rkhw4vIY3DKElrhPjLQtjwmfr3jhjNvq0Mwbet1ANtn5qn6N25t0TLcxt10CF6WBV4/lS8cSnJpvvDftMQIPo82piE5sgvPjvM0hLh1tmmHrYhQD1eO+Mfm8QOCS2etSz/yneSd877jR1H87Xl2ghSNBCnfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2UtalOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2UtalOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F8CC2BCB7;
	Wed, 13 May 2026 10:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778668536;
	bh=ndNdYCwI/1n4Yejm+049VB4MQiSWshqvGEZ7KYKXSCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2UtalOGYIFVK0zq7AIuCZ8qMlKaRww9+itAKZR+lIBqd/4gJj3CbrROmvvpnplKh
	 +zoxXA4jV66Y6gzsQIWgcPKCFrWiQsTyp6hFpVTvEp2/jM4MiGe+nC63K2SiKuWKJj
	 v8JwXllwdVGyuXWkcFBOS1DMu8SFEPw+m46Flf+Q=
Date: Wed, 13 May 2026 12:32:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.18 000/270] 6.18.30-rc1 review
Message-ID: <2026051347-charting-giggle-0660@gregkh>
References: <20260512173938.452574370@linuxfoundation.org>
 <20260513050115.290871-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513050115.290871-1-guanwentao@uniontech.com>

On Wed, May 13, 2026 at 01:01:15PM +0800, Wentao Guan wrote:
> Build tested in our x86,arm64,riscv config successfully without error.
> 
> Tested-by: Wentao Guan <guanwentao@uniontech.com>
> 
> LoongArch build failed, you can drop the commit to build ok:
> git revert a45361144d5a65dd3b7183fd7b511d9cdc143503
> Revert "LoongArch: KVM: Compile switch.S directly into the kernel"
> 
> BRs
> Wentao Guan
> 
> LoongArch fail log before revert:
> arch/loongarch/kvm/switch.S: Assembler messages:
> arch/loongarch/kvm/switch.S:201: Error: no match insn: export_symbol_for_kvm(kvm_exc_entry)
> arch/loongarch/kvm/switch.S:226: Error: no match insn: export_symbol_for_kvm(kvm_enter_guest)
> arch/loongarch/kvm/switch.S:234: Error: no match insn: export_symbol_for_kvm(kvm_save_fpu)
> arch/loongarch/kvm/switch.S:242: Error: no match insn: export_symbol_for_kvm(kvm_restore_fpu)
> arch/loongarch/kvm/switch.S:251: Error: no match insn: export_symbol_for_kvm(kvm_save_lsx)
> arch/loongarch/kvm/switch.S:259: Error: no match insn: export_symbol_for_kvm(kvm_restore_lsx)
> arch/loongarch/kvm/switch.S:269: Error: no match insn: export_symbol_for_kvm(kvm_save_lasx)
> arch/loongarch/kvm/switch.S:277: Error: no match insn: export_symbol_for_kvm(kvm_restore_lasx)
> make[4]: *** [scripts/Makefile.build:430: arch/loongarch/kvm/switch.o] Error 1
> make[3]: *** [scripts/Makefile.build:544: arch/loongarch/kvm] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:544: arch/loongarch] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> defconfigs:
> https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9
> 
> Log:
> Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
> Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Wed May 13 11:15:19 CST 2026
> Linux version 6.18.30-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
> Linux version 6.18.30-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Wed May 13 11:40:11 CST 2026
> Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
> Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed May 13 10:57:44 CST 2026
> 
> 

Offending commit now dropped.

thanks,

greg k-h
