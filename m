Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7612B34EF03
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 03:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785468730; cv=none; b=RiRRu6JHx1HtI1ZgQCR0C3A0pA2WtJFBxMyKtOt68sBGgmAoAG7V19+1fsJ2+ej8Cm60MCrg5tvoF4AHFW5XMZVW9Z1LdiBXtnCTY4eZAK5MiD0AnlMms8wLjwGBEDixZprHxX8+b2Ae3XNHzpsJQiE0OhIYseKBO1ieguQQ4Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785468730; c=relaxed/simple;
	bh=m3SF3EmkbyN7XFycwPvGNY3KFlF9kVAkQn6eh2TOc4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l0ifpwQ6mvNnIQVoVQ8KaYjJsEGZjBFhHsq3d8R2mNDIOQVOnugaqWAcXCCNPdeADtxAJ0xQ+uFSsRRoJ9J9GpWxVzTgQB6I4ZQg9bos6cmehNI8fhax4KYvoioMeoR9XV7GlvncYyNenS1TNVfuOmu31GzSRXr7PbpSbepMyPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=eFSe6Jn0; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="eFSe6Jn0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785468688;
	bh=m3SF3EmkbyN7XFycwPvGNY3KFlF9kVAkQn6eh2TOc4o=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=eFSe6Jn0Uc0lZ1l9vFCAmfLTlPWVzosvkRRJuQAZTB8lXeiWn2QEihmTSjzpla5Mz
	 GSQvYkyDGjXB6w2Zi9qQu+eWAByPAdei9VBT+GXXCJEFUVUdgIn1jLa7L+K9cZkqaG
	 U/P+2IxiIWSfqk56DPjDv6DTqScORLbAkOjnivTc=
X-QQ-mid: zesmtpgz9t1785468679t62b16907
X-QQ-Originating-IP: wdzzQ4FBZk/ChllTNrQG1tk6QNHTK2fzgbi4uFIGNB8=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 31 Jul 2026 11:31:18 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6352075475337103940
From: Wentao Guan <guanwentao@uniontech.com>
To: gregkh@linuxfoundation.org
Cc: johan@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	ulf.hansson@linaro.org,
	zhoubinbin@loongson.cn
Subject: Re: [PATCH 6.6 456/484] mmc: vub300: fix use-after-free on disconnect
Date: Fri, 31 Jul 2026 11:31:17 +0800
Message-Id: <20260731033117.506282-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260730141433.390818444@linuxfoundation.org>
References: <20260730141433.390818444@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: McJfg7Aee/FZFbDifl1xePySr8bDKWMEts/v/cexhsQwftDOG/+L5yLg
	lAOb3hGF8NTg9nHb+fMXsqEDVH9SwBU57SbCDHWCC54jTJdhAQBy3kKJOxhFDnJhj+ClGF/
	uEQzUYlGpDtVuTt3aXLYqBiYhhiw0EJ5fpsswoU3rq20tNYe7Q6bCV3AwlyUwjr40Fo+H3c
	cbULRgCMrAVSqJc0B2wYrqix/+oMW/C3RaFSoGBZU15gP7kWL8smLQpLdaTM9ArkidQCx8R
	kE8anSI/4p1z47oQq++3+VjXrUrLvKhqloC96ta48TRApiFL+ONOsHF2pGuT3FFozVSSY3y
	TobeaHrjzhWuvsKmNa420AhX+t6yBf4drYb2PgPWWh2ZFoAPeqvtHi68ldDYHsGx87AVCWS
	9Dz1Lm0AIeJYBO+R2rcOIrfhXIxspTa/t2mVIM/dm8m7BIKlxUdXl0/cMsKOBxadvU6FXzG
	He3Wnn17twRAcE571TxsWa6nrpVimFxGXKqT0kl4q1KBhXy7KwYb0I8xjyHbZsysIYAK1AE
	CSE/L7LkNA6myxldM6mOvihyOqxUAAgQJvPKt2RG8USqYhYcjaXQd80IxZHc9urhsTcXXiw
	MUPvpN/2qASQMXdMTaZ1cM9Ol2oJ4bSd4vs6u55LfwJd4wyYGcjxdx922vdCarbD5W6c1op
	jUAQCVEzScCdjjaYiTPX8/8Aw9INlSbEm6o4B1FiLSdptQQFrA9648DHzEYZX/ThfW+pi0W
	unO1tIM2i1SRGc8z434km8PfOdnDZrak6ivsn0qkIIUbMGTjCjX2WCzo/WG/NCxPopudVYM
	tCXOcIxlddeY11fn6sqYcnJZ9fwIAY7Akt3u9YzIMhqOrVMdCrq2arbmLTlbew1fXDgevZY
	M3lQINetd92rKKXcgikeXhF8hfxA9gmKRhexUo8MZr31TXyLwuIck8/IRq87wE3/++FRYCT
	AR7iXFOtx3FgLQFPEZXfjqm3BhhKkBneDP4WaSPFZFtnPI9wRipIroIc7yWkeEdN85ySvd2
	Pw74CxBlIuoWrDc6m2FA03ar72WoA=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Hello,

The backport is wrong and not as is discribe in the title.
It just renames the goto and I don`t know what the backport fix not in the tree
for 'git log v6.6.147 --grep="mmc: vub300: Use devm_mmc_alloc_host() helper"'
not found it fixes for, so I see just drop the patch.

BRs
Wentao Guan

