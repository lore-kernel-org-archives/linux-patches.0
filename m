Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B1F369981
	for <patches@lists.linux.dev>; Wed, 13 May 2026 05:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778648593; cv=none; b=p4Ox2VNgL93I70Yu9iOIDktQR++Wd24G94w7C1m2uSMjmoqdc+Igivj8+Zc9WbcfBL+jko/ZqtH0qJEkkjK7dDc8LtNbpyTjUJwvPZRF9Xpbqg4sXpjU4DXhtkfR25o48QU4oH1qn0ywoF8rnWj1Vq5mDrSYAIBWOLVFZqXH8F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778648593; c=relaxed/simple;
	bh=4gA3q7ciiRF0G7m7fxZ8P/NxjZ9s4UGA3W7/Enpq65Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tRY/Qu4eIM2hvlx2NdLl6T5xbBMjwcOgivoGD4SZD3QF8jj0ZNX1FznRbOf6cAqk2vIsDefUoUqTRz0UA/h8ziGumKV2tIx6SOaqnsbWrMVXQUmzomgHK9asJiMPLhkEzDQxXGDTOBp0RcI9d4tzl9E3OZLGyUtmq54ygtQ/9Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=l29Llnwh; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="l29Llnwh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778648564;
	bh=js7vJo7lJk8HTu2JKoIX7l/r+93jcMtNo+BV2oKjclw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=l29Llnwh/XgnxIvyU86QrY/wDozqW3kHdXu/Q/EY9m4AFBp9GUtsWD3cGu+TCtPSr
	 hiHUz9pMynHNAkLbb7pZqf3BeF6Z6h5Q2UqRwgk7L+E3bx1gJhDDQ7hOzX+4EL4vA5
	 1WrTuUdhk8LKaGJtdyIafrwvc2xpdisi9jmUApXA=
X-QQ-mid: zesmtpip3t1778648558t25114775
X-QQ-Originating-IP: zR/qqHym9rnNIT9raZXIYsiMwad9BsQ+qo3BlBg3P60=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 13 May 2026 13:02:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17889130103613528545
EX-QQ-RecipientCnt: 21
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH 6.18 000/270] 6.18.30-rc1 review 
Date: Wed, 13 May 2026 13:01:15 +0800
Message-Id: <20260513050115.290871-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: OASTJNHpK0Kvsci50tkOY3edaVcn9lzop+iibm0bvlTXMJXLxZkrwSxc
	M11Df2SgmMWALQ+qzWgKS04t+XIk8XKVQ2zRxsuKzqaGJuzyr3ur3Tc7gCgqbZC+GuoG9vS
	TPXlTV/+03Z6C6XjWNdv6c5ai3dWOS+/ht4cJuRVUwrJhfJ2h4CkiBOMSgVqTBF4BqfB9fs
	ZXIPTfdVm4mFfYkHv8XTMYe/nK7poXTVYYVpfPWJr4HG1JI0HcgthNlT9CYGIzvuY5Rstoy
	UNIceAFyCkHqwQdVoi/NxMFzXNgOiF+WKISTc0aT+qw1Gh9TpA3C++UtMPhdqRLWOBodtgB
	XLKAqBtGY89Hn3n7P/cHrTSfnSMggiHz6k8n8zy30G/RZtiMoFcc1KZsF6SPq7ClgektZ/c
	ehRDsI6JsVr8CtC5m5blY2J0V23ufSoeIpobg/I40I4FTZe99cdUIVaioFfzMypImBG/wHa
	H2GcaY6PxLb/9hIss+wF/+nGuhUWCIQG+GQhDDnWKGm4TGj2Krl53CGJo91kOcWLmlG+v6g
	e59qla3OlVIYPvfcpSn881wL3G39vnWYhhoH1qHlP6C0eDFzYXzOTm58h8REeYfxYwGV7df
	qsLGp7thER4pIMwaBatfi1Q/4b28mQEQDFyiLT/VN0APFS/BB12mFEzOvfcqY/S9LB3Y1Tg
	cCWvohAFCrsMKuHEjecKvskap/dY5d1rZnvHvGm9tfrbTwsfVS3ttZ5pYA1ucB8T1FhxVKy
	KWyhelxhtUUKPeUf/yZ69iVQ5e8YXGpfTbu9hKsT4guIid6UbI+gngNjDxvKZBkhNlcxLs+
	Y3OsXkuIo5EfsT+sRzSKT96hRZdgplZvHC9oXmrwy+xu9ZhTbsrBYMPtLl3Q9WoZoKm+xw/
	zHbl0lDXYWVDgveF3YIbtd+kgdFWVY/oqaQXg6NR3A9xahP55c8SNpEplQ465Fzbe2AVn7n
	k8/FpdhtxePXtbLyHAlE4Lb6WVcZhOnSY7cm1vYYLPtl7enfocV5iQ+tuym9hiTiPsAp3X+
	TBDS5GDrOhxkXkDb/X22FszaNxHlTHByQfx+J/w9UM7wUurGZofgMs8dgYFII=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Build tested in our x86,arm64,riscv config successfully without error.

Tested-by: Wentao Guan <guanwentao@uniontech.com>

LoongArch build failed, you can drop the commit to build ok:
git revert a45361144d5a65dd3b7183fd7b511d9cdc143503
Revert "LoongArch: KVM: Compile switch.S directly into the kernel"

BRs
Wentao Guan

LoongArch fail log before revert:
arch/loongarch/kvm/switch.S: Assembler messages:
arch/loongarch/kvm/switch.S:201: Error: no match insn: export_symbol_for_kvm(kvm_exc_entry)
arch/loongarch/kvm/switch.S:226: Error: no match insn: export_symbol_for_kvm(kvm_enter_guest)
arch/loongarch/kvm/switch.S:234: Error: no match insn: export_symbol_for_kvm(kvm_save_fpu)
arch/loongarch/kvm/switch.S:242: Error: no match insn: export_symbol_for_kvm(kvm_restore_fpu)
arch/loongarch/kvm/switch.S:251: Error: no match insn: export_symbol_for_kvm(kvm_save_lsx)
arch/loongarch/kvm/switch.S:259: Error: no match insn: export_symbol_for_kvm(kvm_restore_lsx)
arch/loongarch/kvm/switch.S:269: Error: no match insn: export_symbol_for_kvm(kvm_save_lasx)
arch/loongarch/kvm/switch.S:277: Error: no match insn: export_symbol_for_kvm(kvm_restore_lasx)
make[4]: *** [scripts/Makefile.build:430: arch/loongarch/kvm/switch.o] Error 1
make[3]: *** [scripts/Makefile.build:544: arch/loongarch/kvm] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:544: arch/loongarch] Error 2
make[2]: *** Waiting for unfinished jobs....

defconfigs:
https://gist.github.com/opsiff/a840ae9e3d6857f5b7bacb9cdc49f8e9

Log:
Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (aarch64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #2 SMP PREEMPT_DYNAMIC Wed May 13 11:15:19 CST 2026
Linux version 6.18.30-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT 
Linux version 6.18.30-rc1+ (guanwentao@uos-PC) (riscv64-linux-gnu-gcc-12 (Deepin 12.3.0-17deepin8) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #3 SMP PREEMPT Wed May 13 11:40:11 CST 2026
Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) # SMP PREEMPT_DYNAMIC 
Linux version 6.18.30-rc1-g6a57bf31ed20 (guanwentao@uos-PC) (gcc (Deepin 12.3.0-17deepin15) 12.3.0, GNU ld (GNU Binutils for Deepin) 2.41) #1 SMP PREEMPT_DYNAMIC Wed May 13 10:57:44 CST 2026

