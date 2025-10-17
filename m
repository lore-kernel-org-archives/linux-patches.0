Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C166838DD8
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 02:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760668452; cv=none; b=NbNJ0TKSRSFC+WHvj+E4f9452/RytpQddz4a76axxftNEYQZ0kgBCtNgcZwIDYofG/hQWls95jiQTDIAICg3r4YaJpViT62knm83hulUqb32d03L/uxj9wJgSUOmByznjIjckuPdioF6KZO70CdAGO9HiJhTMtwErM2KumLtrnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760668452; c=relaxed/simple;
	bh=994P03rJ9bDXeonnhtv3w/T3UpjWJKGVQMrGcfDisaA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUXSUfTA38mBtdKihYKhgqIosQutTmbMfNntYFQYQ2UbZrosf+WMvnh9iRhlWqWNOzpBlItSMhvB2jgcAacby6Eg23C5Z2/Q3q0z9cLKPbuKwwRJhVMn9n5+a5A38QBSjrGe4lyHm2RSWiHxX+hk4lFkuMa6vp3kZXz2QvT3/io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b=mRX+oCNb; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=s.l-h@gmx.de header.b="mRX+oCNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1760668436; x=1761273236; i=s.l-h@gmx.de;
	bh=04SgkB0hDueLjD0+gc2mpn+8aDSdXgwuYvfYpcVq+Ts=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mRX+oCNbXiBfPOHtPq08WkqzRw28DfcTwUuzt3xNGI6nW4rWzukxncHjz2tovKnw
	 Ys9milYqn6AjfzhNN30yWfI0EpX8eacMcmlO0uEz7rlwStfXO5i/OQ2kGrQ5O8caq
	 u6WLnmNI8KLUiJ7CdNS1fUns3KjUfXNSg6/63KSgKoGfrUTnQGqWh4mhkJyWXqEES
	 tYJD6dK9WAcRTAdRes+Zkax2f8lJj0yeGq2Ah0+bMjkWXZGgCYwvzHsP1yVN1CXh8
	 xqY36SPx1zZccgC6ahdhCdBcixVCdtjPW5dA7KisUsJrNiai+eMF6OsRoL/fojjzd
	 yJNHof9Up+Hgl5irMw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from mir ([94.31.111.154]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M59GG-1vAgka2dEK-000Lwr; Fri, 17
 Oct 2025 04:33:56 +0200
Date: Fri, 17 Oct 2025 04:33:54 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Inochi Amaoto <inochiama@gmail.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>, Chen Wang
 <unicorn_wang@outlook.com>, Bjorn Helgaas <bhelgaas@google.com>, Sasha
 Levin <sashal@kernel.org>, Kenneth Crudup <kenny@panix.com>, Genes Lists
 <lists@sapience.com>, Jens Axboe <axboe@kernel.dk>, Todd Brandt
 <todd.e.brandt@intel.com>
Subject: Re: [PATCH 6.17 068/563] PCI/MSI: Add startup/shutdown for per
 device domains
Message-ID: <20251017043308.147d1a98@mir>
In-Reply-To: <o7hrpbeszf564cznyns3zorrofz4kkffugbmvwwub5arh34vki@dgrqpuasd7ks>
References: <20251013144413.753811471@linuxfoundation.org>
	<20251013211648.GA864848@bhelgaas>
	<20251016030711.57e92e97@mir>
	<o7hrpbeszf564cznyns3zorrofz4kkffugbmvwwub5arh34vki@dgrqpuasd7ks>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:04fG8OgH/mVDL++F33CSRLZRo9drn1Sp5uf2q7z+gqGq0WPFg8d
 2z7mPEHVBBC/Wt66b3t6bsJ6CuF9826AUfbkSBjBxsvlRkBdOeygXW26wg6XNcD+1wrsXcf
 xrvsDZPTR2wXYabzSfKwEQF5vJQWf5p4jZxyFnDtBZqGKndgreU2xl14Gjy9qU4dQ+v+usL
 GIMd4W9LHwmluY/MoQabQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OHSrTqI7wpE=;HNIhbAmq6EMovKLOKrTCSKg69eK
 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
 XV5CKK3E2AMJeWCPq6RqUCPPYs=

Hi

On 2025-10-16, Inochi Amaoto wrote:
> On Thu, Oct 16, 2025 at 03:07:11AM +0200, Stefan Lippers-Hollmann wrote:
[...]
> > > We have open regression reports about this, so I don't think we
> > > should backport it yet:
> > >=20
> > >   https://lore.kernel.org/r/af5f1790-c3b3-4f43-97d5-759d43e09c7b@pan=
ix.com
> >=20
> > I've received a similar report for v6.17.3-rc1/ v6.17.3 (v6.17.2 was=
=20
> > fine) on a Lenovo 82FG/ Ideapad 5-15ITL05 (i5-1135G7 and Xe graphics),=
=20
> > failing to (UEFI-) boot already within the initramfs (Debian/ unstable=
,=20
> > initramfs-tools).
> >=20
> > Backing out (only) the changes to drivers/pci/msi/irqdomain.c and=20
> > include/linux/msi.h from patch-6.17.3 fixes the regression again.
[...]
> This is caused by the vmd driver, as vmd driver rely on the assumption
> that pci domain template does not set irq_startup()/irq_shutdown.
>=20
> I think this may needs the following patch:
> https://lore.kernel.org/all/20251014014607.612586-1-inochiama@gmail.com

I got confirmation that this patch indeed fixes the problem, thanks a=20
lot!

Regards
	Stefan Lippers-Hollmann
