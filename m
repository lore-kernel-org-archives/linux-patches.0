Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B7C401A31;
	Wed, 13 May 2026 12:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778674213; cv=none; b=JuaCtKRr/LS9AMD4B6zvzeFsLXcG+bqJxwgBPR35zxaDlSgEQFaMazZPdPBFoIId1Qu7PTRTuorEhj23LtAqm5mCxtLA4RZGr0yRp5IXaQCg4/gKLVduqMS0elt+cVIdKYXSg9Zx+PC8+mq6PkTFO0+DbFkJppAH8pdi9/hEqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778674213; c=relaxed/simple;
	bh=JKwN8dmZXEClE+fK8GUPvuEHt9gjM8rK2QbGN3Uo7gA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JXxGkABvUo77ZYs5ZiUdyF2co1K1HepiyLWHBA9P0PlAbvBPCMFfGw9l/6crBknVh6QGBkjGcR8btegbE9OPOWrIFtuGcclLbpOIbri/lWYPh/ibJIsge/iZowbiNeBghajtyycMU/mSEhXAcixq1a4tFMOoYgMMEjN2p43p1I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=gh9vx97A; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="gh9vx97A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778674172;
	bh=vpbQGnXHQ6rbRoqrWc3zGGoA7XdxcAEv1U4GtZxM2bw=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=gh9vx97AwQUdmO02nOXX855aOsM6onpANAaQ/yztrt9p7VWWCXb46/1clNu5SR0AI
	 gBjRqX6RP4/yeqAxBHGpFB2pWESMmO1NeO8dvrQcPHv3y5StrcLExhN4wp19ZFy/tu
	 K9zrLCN+0HiBSsuWGRK8ckvIYKRTHwj/KkWza/f4=
X-QQ-mid: zesmtpip3t1778674167t5c855f5e
X-QQ-Originating-IP: hcVhJ1pdrvfrXKoRsasb6OQdrv5przJNpiKckO5dNVs=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 13 May 2026 20:09:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1320149752102977563
EX-QQ-RecipientCnt: 14
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: chenhuacai@kernel.org,
	chenhuacai@loongson.cn,
	dave.hansen@linux.intel.com,
	guanwentao@uniontech.com,
	kvm@vger.kernel.org,
	lixianglai@loongson.cn,
	loongarch@lists.linux.dev,
	maobibo@loongson.cn,
	ojeda@kernel.org,
	patches@lists.linux.dev,
	seanjc@google.com,
	stable@vger.kernel.org,
	zhaotianrui@loongson.cn
Subject: Re: Re: [PATCH 6.18 091/270] LoongArch: KVM: Compile switch.S directly into the kernel
Date: Wed, 13 May 2026 20:08:08 +0800
Message-Id: <20260513120808.339792-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2026051311-lullaby-wrecker-7d23@gregkh>
References: <2026051311-lullaby-wrecker-7d23@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MXXYX9LoP3t5widySIYGICm1x+FsEnNDR1Pbn3oYvJDad3+oBHG3IBY4
	SSS2LGufNGjgc1pV8zbtDkM2EX2HhETMvJ4o+/RMBNc2mn7qnIsMclFSVs+h+LSeAgtGy2n
	1vSNW8WSGpSGvfL1Cy+8uj4jJmQiTJBg7BfoXnkErywsDYUpzKrJo4U670/SwI7JnWyJLsY
	EOhh+aBlPgAmx7rcssIQhbIoxXbupIZ/dEBrsaAN0iH8ynbfHBdf2KJ3knvmjZkWq8I5ETK
	FEHlByd5s7kLd+cZEREeWmrnE2gw1XHqpCJXtNMkEs19+ysG98f324PK+G1PPNylH/kBcPC
	i+NvRxJHtj8UHx5V/Cq4Y7RouKQZuTVFTeUDQlRXQp5zQ7XuTtshlo3jEMNISaHdFUaldrS
	cNuLYMWeqF1O+3R9RpYp/wOTxMmQKkC1wLQ0gWoWbw/GqdosWB5ziv2zW2dyNYxLNREX4Oi
	iOBNjPbQqt1azL9PNIOmqj3JXDY75A/gyEGrDQNqCQ1AWrA9FHApcX1jM0HE0tUMX8EGnyP
	cihgUyiPt4UVCW4CaTrcxZibzb3K8HHcDOo29IWtuWTF8ia1ymATUGE8F34vOWGE/NLiROy
	O/CgT7gbNAoez13pw4XzFXljHw4UvlvQABF+e9zW7NKsjAUyRmIak8O9kqQ2tHYUPHV3VQI
	cdcuy5N9mwviBv5uLWAJzEwzdBiY51/HHIzyQBbsEXxOkvVO9M57SuG4H11mPfzXdDPyMsd
	+SRmrPJZUIoLxuAhW7unk6qVk51A8WJ7NGpuHaRCP8oH+UMF2EAFlM7t8+FVEysSP/B2/3J
	7iDwA9Nj8+uftqcCgP9uDFKgwYcvMa6FODzP/KibIPSrASe4SaHwQVOJN2Ilj465aLGr+0B
	Iz8+Ma/vZPyOv2UNtl84GaTObf/6SEbsJSB6tYBDG9EOID2q9WxqeD3NiaDAotnMzjGRfeG
	vrSdhIXINmXcqM783PBn99Gd3Ezu1njybdG/sXmEjeHvg3OzX7yRCaQhoEUnLsCbYrHQ5Af
	WytoCpQNkaoYSdboZ4FyK4NH69PtkWOQEBqpxIP/iUQ4BDYIiTnLXkk5JjwlDAR6xP+3XdI
	hILVvNPDZB0Ku6xX8DBxtkrxJf8cArIHjXlPTApOf/4LjjtvTugUU1DgKv16aCifp4NPFk9
	UbbN3BPbAne+A3w=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

> On Wed, May 13, 2026 at 07:58:10PM +0800, Wentao Guan wrote:
> > Hello,
> > 
> > > On Wed, May 13, 2026 at 11:06:20AM +0800, Huacai Chen wrote:
> > > > On Wed, May 13, 2026 at 5:53 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, May 12, 2026, Miguel Ojeda wrote:
> > > > > > On Tue, 12 May 2026 19:38:12 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > > > >
> > > > > > > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > > > > > >
> > > > > > > ------------------
> > > > > > >
> > > > > > > From: Xianglai Li <lixianglai@loongson.cn>
> > > > > > >
> > > > > > > commit 5203012fa6045aac4b69d4e7c212e16dcf38ef10 upstream.
> > > > > > >
> > > > > > > If we directly compile the switch.S file into the kernel, the address of
> > > > > > > the kvm_exc_entry function will definitely be within the DMW memory area.
> > > > > > > Therefore, we will no longer need to perform a copy relocation of the
> > > > > > > kvm_exc_entry.
> > > > > > >
> > > > > > > So this patch compiles switch.S directly into the kernel, and then remove
> > > > > > > the copy relocation execution logic for the kvm_exc_entry function.
> > > > > > >
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> > > > > > > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > > > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > >
> > > > > > For loongarch64, I am seeing a bunch of errors like:
> > > > > >
> > > > > >     arch/loongarch/kvm/switch.S:201:1: error: unrecognized instruction mnemonic
> > > > > >     EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
> > > > > >     ^
> > > > > >
> > > > > > `EXPORT_SYMBOL_FOR_KVM` does not exist in 6.18. Does this need a subset
> > > > > > of commit 6276c67f2bc4 ("x86: Restrict KVM-induced symbol exports to KVM
> > > > > > modules where obvious/possible")?
> > > > >
> > > > > Either that or just convert EXPORT_SYMBOL_FOR_KVM() => EXPORT_SYMBOL_GPL().  If
> > > > > that's somewhat scriptable for ongoing LTS backports, that's probably the best
> > > > > option.  EXPORT_SYMBOL_FOR_KVM() will only work for 6.18, and the list of backports
> > > > > needed to get EXPORT_SYMBOL_FOR_MODULES() working on older LTS kernels looks to
> > > > > be non-trivial
> > > > >
> > > > > If we do end up backporting EXPORT_SYMBOL_FOR_KVM() and others, we might as well
> > > > > also grab a subset of 01122b89361e ("perf: Use EXPORT_SYMBOL_FOR_KVM() for the
> > > > > mediated APIs") to ensure a kvm_types.h stub is present on all archs.  That way
> > > > > EXPORT_SYMBOL_FOR_KVM() usage in arch-neutral code will also work.
> > > > I have already noticed Greg about this before.
> > > 
> > > You did?  Where?
> > 
> > Small problem, I guess where he means is 'stable-commits@vger.kernel.org', is a
> > not public maillist? I want to find it in 'lore.kernel.org' but not found... 
> 
> It's a public list, anyone can sign up for it.  Don't know if lore
> archives it, but I'm sure that someone does...

Thanks for your reply. It is interesting that now i found them in
https://marc.info/?l=linux-stable-commits&m=177859589029820&w=2,
and https://marc.info/?l=linux-stable-commits&m=177859840800303

BRs
Wentao Guan
