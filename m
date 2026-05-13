Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF8A40243B;
	Wed, 13 May 2026 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778673620; cv=none; b=qirkcXiJ6R10TxxEizCY7+MC5m3aqpzyrOHtweZ5ex9XOD3P9lU9nTLh9YJcW58kBUeJa/zE5zOoFqMe/oxSn5nxoUYAJWwe13KpTFjb1gbXKXsc2j0ClmPYcyGRJwN8keuy3fhhYwK/nRZ9buGt4TWTDZJ/XYPFln6uLdXoGU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778673620; c=relaxed/simple;
	bh=763pFe1J8vID9eAOLiyYmWwQJg6mRSiyJJD/9SABoV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B8XPgaRb59YzmBKWEmE8HDJcO62MzfZOlQA+jeX4sfj/qu38RfWpiUym+XWaY1fS7vx0KYdUz0YIDk6ArtgCqE4owsfHNPJxn6hBTal9Q0NzU+IAff2nlLTmwf8LzbwEzmiAhb60Cw5F1QLpvATuDIXPMGIumQLFKXiPUr7WOs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=m3Zde32I; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="m3Zde32I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778673573;
	bh=xEH2z8WCWcgrophkMiTtUC2J3DxjG4vcq5q2behA75Q=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=m3Zde32IhdJKzfQP0hDa9BLPeDit5CC5w0kzk4mWZWC2RSl5N40T7vG3bhGBZlFGD
	 0gxHJ5o45JXG77kZWio1uNbVogqk9Nlg6y3NYAiC9x/n//pyxe0OZ8BoabwU9ChDIU
	 yL93k0sDNgH51dnnPKdQpiIgak/QPz2/az2lom3M=
X-QQ-mid: zesmtpip4t1778673570t776de1df
X-QQ-Originating-IP: viOzyJ1fnQCzw4A7aaGWbCFEU/bkgfmroHrcN7wPcDI=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 13 May 2026 19:59:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 842056211250941492
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: chenhuacai@kernel.org,
	chenhuacai@loongson.cn,
	dave.hansen@linux.intel.com,
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
Date: Wed, 13 May 2026 19:58:10 +0800
Message-Id: <20260513115810.338478-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2026051319-lazily-machine-5ab3@gregkh>
References: <2026051319-lazily-machine-5ab3@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MjZkc9TfnG+XR3/U2Vek5hMrZ0KIyoRlMiLsEOsDLSnfCagxbnbjTagi
	6LCsqLWxKgx93dFPt7KlkC5Ddt9W1dm7jv0X8Kizo8ZXm41NPt9TxCautUQxCEF8t5EdNYU
	kowg51GryMWVyEJCWmIeEoNlPLeYMPJqJtW+aDkh6QJzaiAq96Ki5a/0K9oaHVgD7OQMrfs
	Smpm29EQnv+i3EoGBe+uUWGgCMn1jOAa+Ua5tr2kCjVC56Kmv5COJ/hcTdKlzh7LihwFI92
	kqsOwzLmC3A9uWp7anVZ/HM1bbVeCGsmPfE4c58ns7/hU8yVZKz52/BCX0SBr4Qpg6dnng4
	Ghuw1ykvHiDXPMtdBQMVjnzLgmdz5U38vS+a2H1f1Hf8apEKXDG+EolsLQma0rz4da/VqoR
	SaOIb6YaFUuZiJuYibkjV2SkFy53PZWhuKjPhW2Lc+gMT49Wu9wZbytEu7MQVXhVXu95LuW
	M1vFXfUPbzD40qjGEwY/ToYQyKmNujaF0iHcheyxJEhA5LNnz1CoKzg3wM4n+G2Pk4m9L35
	nDpWGIuTQ0aJnbzUmoN/LpcucsFAJX4gfAxAB63GABIeDBb6Rur6xrPpwpBoMtRJjKpvjsA
	hHhmDS+0g/Io5mpARJUrks3NukSzwA8UY/02PyNenm6ZM+3Nu9AsBQBz/2AUq/255jn5s4d
	KFXtIm4iFGIuoRTRbeRcb5AQdnsgze59BGvuupAeNW24DvpBw1u/5Gwsx7Hyijo5b8nG7XA
	nOgHLaIGEoFuwBywURbcMp41YNCQ6IEW8N1j0TkWUDy/KzfJbfhedDB/VUve/F4OltkGifU
	pZB6aCIoZRPaNJ3JNxNTvynXW8RzaXC2FMLzkMW5IYZMf+ZTut+/zbG8EQvEuJ53uSHZ+5/
	92Z6thvzGyer2H8cAjvwhyP+bZGPZ1lfKE+E3xiDoDBAqlR+oJCGhflA3ThvQ4Dn00B6aMx
	uEGgai2VQEG45wrJnhzf31z6m44+JjuFZzeWp3/3L1JtowE8fOlgb7nqjvbv22mHyHMcb+j
	WGcPQl+mGY0wk+Gxd2sr+d8ySf1hfIsNC2LdQ778KF4TFeRXAsYIL1xoA2BuUeaFxTBewHT
	w==
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

Hello,

> On Wed, May 13, 2026 at 11:06:20AM +0800, Huacai Chen wrote:
> > On Wed, May 13, 2026 at 5:53 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, May 12, 2026, Miguel Ojeda wrote:
> > > > On Tue, 12 May 2026 19:38:12 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: Xianglai Li <lixianglai@loongson.cn>
> > > > >
> > > > > commit 5203012fa6045aac4b69d4e7c212e16dcf38ef10 upstream.
> > > > >
> > > > > If we directly compile the switch.S file into the kernel, the address of
> > > > > the kvm_exc_entry function will definitely be within the DMW memory area.
> > > > > Therefore, we will no longer need to perform a copy relocation of the
> > > > > kvm_exc_entry.
> > > > >
> > > > > So this patch compiles switch.S directly into the kernel, and then remove
> > > > > the copy relocation execution logic for the kvm_exc_entry function.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> > > > > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >
> > > > For loongarch64, I am seeing a bunch of errors like:
> > > >
> > > >     arch/loongarch/kvm/switch.S:201:1: error: unrecognized instruction mnemonic
> > > >     EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
> > > >     ^
> > > >
> > > > `EXPORT_SYMBOL_FOR_KVM` does not exist in 6.18. Does this need a subset
> > > > of commit 6276c67f2bc4 ("x86: Restrict KVM-induced symbol exports to KVM
> > > > modules where obvious/possible")?
> > >
> > > Either that or just convert EXPORT_SYMBOL_FOR_KVM() => EXPORT_SYMBOL_GPL().  If
> > > that's somewhat scriptable for ongoing LTS backports, that's probably the best
> > > option.  EXPORT_SYMBOL_FOR_KVM() will only work for 6.18, and the list of backports
> > > needed to get EXPORT_SYMBOL_FOR_MODULES() working on older LTS kernels looks to
> > > be non-trivial
> > >
> > > If we do end up backporting EXPORT_SYMBOL_FOR_KVM() and others, we might as well
> > > also grab a subset of 01122b89361e ("perf: Use EXPORT_SYMBOL_FOR_KVM() for the
> > > mediated APIs") to ensure a kvm_types.h stub is present on all archs.  That way
> > > EXPORT_SYMBOL_FOR_KVM() usage in arch-neutral code will also work.
> > I have already noticed Greg about this before.
> 
> You did?  Where?

Small problem, I guess where he means is 'stable-commits@vger.kernel.org', is a
not public maillist? I want to find it in 'lore.kernel.org' but not found... 

BRs
Wentao Guan
