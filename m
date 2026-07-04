Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDF1433E8C
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 11:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783164041; cv=pass; b=egs9H2wBcd6sfXe5mMz5k02noEi6tyvgJ1WFubxMWuVHv2/MGwLgjUpj/YYOpRoIQMyKGKYMriqHiS7CA6W+7y5JiTpamZuAMtGoTNOLoROyRiTmb5EMwVEXQkcD099ZVCOyFBfShET0Tp2w1hcdodRJ3jSDDnAyKhhNzwgRDM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783164041; c=relaxed/simple;
	bh=c/zm7aL5uQAOewymZPg0aiv0Tzi13gUJ/+Q8/o/Cpzk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kNmVLJ0I+ToIJMrepVZ6cOKXdPa04/COL/a7enJYRFeyakpwRVTf+me3DoaKdp0vaE2ESes8SWZUbXPm8LAa6PZ4Wwx9E1mwJyy5QZbd1R4PfBbzecB1FBwsuSOMPfO/Pz6JliHClWgglCw/h8S2bxKn8tobhb7I/qcF4dKQOgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m46AFgL4; arc=pass smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m46AFgL4"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c96c92c0980so709875a12.3
        for <patches@lists.linux.dev>; Sat, 04 Jul 2026 04:20:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783164039; cv=none;
        d=google.com; s=arc-20260327;
        b=HEd+bbQC6ciIgMVzyeZWrKqw2MiYSNsOqNGnWT1V0D/1hxvoNDorpKikRcI6wumTg2
         m/ypA2vRhuUGCT6vcSjfjnmCle6z1K0n0p8t2HYwc9rIAurKN70THCZIphgHigAhvUeZ
         WpyTuyJFFsbY9rHhxPByRwkHI+SajIySzIrEfShQcWDlwMRB+TSmt8zu5ACqN8jiycsQ
         +w5wjFfJppTx3hFc3D8zi6n+O5GoPoeapVJyJZZZMgOPG4HSHDoBiuGw4rC8e/VThCuH
         SweF+XUcv0df96XAwvgyzrFXfZXcsskt6W8Vu/w7FlWnJxiF1L54Pd3U61JCG403F7FG
         ftuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c/zm7aL5uQAOewymZPg0aiv0Tzi13gUJ/+Q8/o/Cpzk=;
        fh=mZtK+dLbnBP1IrYKehdlNtX/fHoTeKpPRK3cU67xdfw=;
        b=GijGtd7pKjcouZ8fC2vqv0bxi6yAXZswyhFkJfrFBUfQfJY379NQCFPBi3lbfJVOsu
         F5oiWyU+k6ld2slnvH1vOeMGOGL88c8az+09mA1v842JLSZAdoiPqz/ebsuJlIeFYsOB
         Up4zkPi2pX7YRbGPX/RtxBdhCwXgUQXHR9SpYgdRsYttN5HvH6bQahIdDfOV4yY9d3ld
         Uz94Qby/zt6xuI3gji7OGIweCZxIwPH00ZBX/E5GF0CotJ8uPOdU/j5jqypqXJ+h6a9b
         VUTB2HwzxomzK7zsNbVGqLcpnMDtNa/pbU8nbiUxth2eIeyABZRlWB6vYNd6Kfc/k6+W
         PYug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783164039; x=1783768839; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c/zm7aL5uQAOewymZPg0aiv0Tzi13gUJ/+Q8/o/Cpzk=;
        b=m46AFgL4PnhsVDk0HC4z8l7CObyjcU2+NKxLlNoIpwbBmYoDx2s/t6UHYmm81+Qo28
         C5vvGansNNMMXF/RA0Bwi1T42ecDgEfSXsF/jofQrFNTmZg68mY538W8QXGBWmuUeoas
         THPPDwVI4ZjOYFf04yH+6c2bvrVXOJaAyy5oDYotAdF5DUc+nsDYCL/yEXDwpLSuSGzV
         bUUeiyREF6/e4CAmexS6Gd8uM9huZ9N5PWJNiwZdw/lOulTVZ3qv1tAp5gIrieiOOyQK
         /hhtqCvgJhssqCd/nNtNs/SqD8QJxk/HKyBVqxSFISfLkMLrZ77seOG3/hAHviOK6I7V
         Q4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783164039; x=1783768839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c/zm7aL5uQAOewymZPg0aiv0Tzi13gUJ/+Q8/o/Cpzk=;
        b=GoTB1/89Mg07AWAgLOO5um+vwHrWseukXgt98JmLQKPj06hIWcScay0mptzxrk3WfT
         wPDudNP4pRPNWNL2ZaxAEFW3e3XToQZZb98ulEkYD/6fj/mpN2zaMJpvagKwBBMK3xlC
         2PVCUuVTXiRRZiqdPjVqhz4wbr1cZ+qDJVSENy3t7qkDRMJGtm073mIxHqHZR0yhTT5Z
         OSpyV69AK3/XFB5FvqszqLTeFp5OAaCgZ/+GzdKvFDWPIQpT/K9fTus1xKdf7/C5S07B
         on/R3XZWlyU0WL2Rksb5n3xs5X0G5GYRqoXPmAq8FTTlWmqetz4LgjtLtb7xt6b1F1AP
         FvGg==
X-Forwarded-Encrypted: i=1; AFNElJ8huSHJj8C9HdOfDC/vAHUvPmAA88btdhTGkWvcR+uegDOzSfSrsr8qvYPbMuuiKY5mVHIrSsji@lists.linux.dev
X-Gm-Message-State: AOJu0Yyg+KLJRTaTkjL0dWcV5VWrMqW+j4Iq8NQTBkApS+AS342VsJ0c
	METcwluzpeDuw6jeTdrkKu2wkhK1NjkMTOLi/bwwt9e5ZSR0aAtibSylcNUyiR0rUdbKGF7tdlf
	zsISMX2hrS0abYJU8af2u/0QpRxJ4uK0=
X-Gm-Gg: AfdE7cl/HYnho95ay0YiuqYsGxZkt7xHK6fjr7hPxdL3Ox1l7ibtgsKg1C+52h2lDoV
	43dIuoQs9R2+ObYZ71WAan9VJzs6DrD2j++FNvO3QFbKr/bK842fILJA1da0GmWkR0uNdjUOVxu
	KxqLY0SomYiE2ebZSkheUb3/kcUBaxQolVCQWOW2ixNqkNcJxWlAsD3KsMZ1fOTO4oKMtkrR3H0
	rW+cRSMPEgvCA3eDBqcaF6H2l8NzDDQnFX5fL6lYZULEGK0TAa8HIQVEPbS9laM3WA0fJbSFQ==
X-Received: by 2002:a05:6a20:d48c:b0:3bf:6c08:2b27 with SMTP id
 adf61e73a8af0-3c03e5818b7mr3187982637.47.1783164039478; Sat, 04 Jul 2026
 04:20:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org> <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
 <2026062933-storeroom-amusement-0b66@gregkh> <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
 <2026070446-blank-duckbill-13ec@gregkh> <CAFQ-Uc8AAEGw90BPximQm3cLzB+KiH_PXr-UZEPK9nvueMGtSg@mail.gmail.com>
 <2026070406-squander-geography-213a@gregkh>
In-Reply-To: <2026070406-squander-geography-213a@gregkh>
From: maher azz <maherazz04@gmail.com>
Date: Sat, 4 Jul 2026 12:20:27 +0100
X-Gm-Features: AVVi8CdGnaG_XVJukiNdw0eBZBNxDPUTX5VAcWV5rjI0hAjcFCCuMPd9y8VPQ2A
Message-ID: <CAFQ-Uc8CDnGUH3xhjaVBd+Dr=+b7Lfu1SUrGGh2gQ17WW+gqxQ@mail.gmail.com>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, Jakub Kicinski <kuba@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I sent it like half an hour ago the same way I'm sending you this
email, I sent it in plain text mode with the subject "CVE request for
a patched Linux kernel LPE vulnerability.",I really don't know what is
the issue..
Anyway, can you please take a look, since a CVE should've been issued
a long time ago, Ubuntu 24.04 latest kernel with latest patch is still
vulnerable and many more

On Sat, Jul 4, 2026 at 12:07=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jul 04, 2026 at 11:41:33AM +0100, maher azz wrote:
> > Hello,
> >
> > Yes, I=E2=80=99m sure I sent an e-mail one week ago to cve@kernel.org, =
and I
> > just re-sent now just in case you didn=E2=80=99t get it.
>
> Nothing came through, please fix your email system?
