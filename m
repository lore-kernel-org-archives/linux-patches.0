Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D63D38A73F
	for <patches@lists.linux.dev>; Mon,  4 May 2026 22:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777935255; cv=none; b=DRQS+lwhyA8a03ZAmls4Lyvex75TzJ+WfC4JpmNRLx5ONQnsFFDBBJbpe8Lw+UyNK005Lu1lMcnrRlh/ZvjNU2Sev6u1aouXm1ebmtr0osCNxFtEolAeCc2aEV5VJWdPEU15I57ekq8D3O8JdBQLgpROmS75l/gecXF2BAxlVZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777935255; c=relaxed/simple;
	bh=GJA5seVahYpViKnGZOh3rNiBjtA0B+KD0LRZTUEpgoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/y7zIldk7UN4SallQwCduuYQKzWitj7UQzpORODcwFFiayhSBMby3cMGwhmkD1DWpcoNj31621zfz3OmkQlFrd/yV9EiknajM7jDRjBjsD4uLpC/A1iAVSuTBpReMKGC9RqwbJqOHCBQpKAdmgcsP3vozLBfkrtMZVFZdQOpFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p2mt86Me; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p2mt86Me"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36536771300so1094415a91.1
        for <patches@lists.linux.dev>; Mon, 04 May 2026 15:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777935253; x=1778540053; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9ugfH2lM7nQgOC3+hZY16zqoQboC9qbhlDerkTWHT2Q=;
        b=p2mt86Me8c+m0wXRYSy37U/8mltYQwQ2sMDFgliyauqn7KRrgTB1sSv3EsROEKBuVB
         Z7Mbly7BajjekaIuLXFh+uq2+OUClVEhp/gau1cY6RC8NhtnIr0v7narwESfOLekAaAE
         kM/b2Hztbqg8BEH3u1JYDDKpK+dcqlBmaFoZSki/16WzftfY5RrCvtqqpWm9ZKSsEYpz
         UNy/qClXSUCthSMv2oi7ki9ZRXxE7/34fA5MD+chte5gaHI/VAahv7dUkiLVR/qn/E7U
         UE6gw8mg9OOp9AcY+SGBQUgqlrt9UPgIuTETOw+tQpLodu3CMR5brMqKClJqOgbhO0fB
         489g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777935253; x=1778540053;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ugfH2lM7nQgOC3+hZY16zqoQboC9qbhlDerkTWHT2Q=;
        b=YV1MvW+fi8yxfi03YrYlp2zfgjLxKWW+WHy9Jc8GuwhTLL4oQ12CrD8VBMbWZbsTNz
         myLDy2xIX7Rf6hYs/XfRiwJw7fhDoKAMI5GeeeLVBMA5KSlR8F3HmSbEKO8QgZmEOXH4
         ZKSm8g4M6yEesD/Y1X00a5lqGom0ja93iZT09h6d8vuiWXgxD/VaHblHUtUnkENFTAYU
         fcazWS/R6nbAStkQXURG6YO/Mmh3M2H/c+x83q+VS14HxhNfo500cgZWSVlVmnfE00tV
         1e1n53Cwkp72TGxkvnmRgntB1Zwj9iyhWpWxODCuWWn0X+mtvXxkJj7Njpkn7Ot/E5np
         ToGA==
X-Forwarded-Encrypted: i=1; AFNElJ8e2ZM1uLcumMwy5DPAI53UDSl0Yi+2ToxgnFLDE35cDnauvufnMmtV6jzyq6tQnH7w56Ix5sL3@lists.linux.dev
X-Gm-Message-State: AOJu0YxFz/t1bWiC+BVDMaCwTig/X15szN/5WVjRqZfcVJ0YWCqEYqGP
	2rstcsIXD22lqIhgAsGgYqW1nSiNWsSABWN8WvUduSYKjDn+t+s18EZrdId6tqsijQ==
X-Gm-Gg: AeBDievM9yOf1JwH6NKfanuAxiIN39IK0mrVvRDi5+by7039l/MjOAw3asuFydL2BTV
	Yci2pb24MN1kWLwx9ueXFbS/TmEoF3sfuO5/S+MNDOiCuBV+QY87UIYA/zngwR+CRHvDlIGaa8h
	a0pFJpvyL+W0VK0dN6ibLz65noyguF7+TUaLj8ap5IKVk2JeZcL8YEa3NB5+lEteKVxm7Uy03M/
	9aT4wsvoA36wm60UjIsPK1E449L2+hHTuT2B+FQceC3pUNtHGPqimsVNcmMhs4TrOyPys+FRC/6
	jWqJqLcm/MD/Z5/L7xDpXP6LDogynUrm3AeUSj4MnQHBFTiPJP/wQxW9hfZxC71XAHnZ9iVUzUW
	uALB4LyD36XxqHpFATTXqglpPL5//BN9FYPVXHtxzaJeu/wuCM++NgMGNIS7tIZYPBtdP3QxVXX
	xFnNhGPkIqvhPfypwixcDDIPwnmhXVPk5F9l8acw8POWndvAHuQEOD6WO8x9c465+qnEY7aenMq
	1pNfQ==
X-Received: by 2002:a17:90b:2e85:b0:364:a497:db8f with SMTP id 98e67ed59e1d1-365727322f8mr956720a91.9.1777935252914;
        Mon, 04 May 2026 15:54:12 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9f0b21c4bsm88242915ad.29.2026.05.04.15.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 15:54:12 -0700 (PDT)
Date: Mon, 4 May 2026 22:54:08 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev, Josh Hilke <jrhilke@google.com>
Subject: Re: [PATCH 00/11] mlx5 support for VFIO self test
Message-ID: <afkjkBq8B-4KjhS_@google.com>
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <CALzav=ci8bi3=sY+F3HJTB5sOQ_pJ8Lm+kz0CDBBWVXry5P98w@mail.gmail.com>
 <20260501164314.GA1381708@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501164314.GA1381708@nvidia.com>

On 2026-05-01 01:43 PM, Jason Gunthorpe wrote:
> On Fri, May 01, 2026 at 09:11:11AM -0700, David Matlack wrote:
> > On Thu, Apr 30, 2026 at 5:08 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > Add an mlx5 driver to VFIO self test. This is largely a remix of the
> > > existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> > > to issue RDMA WRITE operations which effectively perform memory
> > > copies using DMA. Since mlx5 has a stable programming ABI this
> > > should work on devices from CX5 to current HW. The device FW must
> > > support the QP loopback configuration.
> > 
> > > This entire series was coded by Claude Code in about 4 days.
> > 
> > Very exciting. Josh Hilke from Google is also working on using AI to
> > create a selftest driver for Intel IGB NICs so VFIO selftests can run
> > in QEMU [1]. So it's encouraging to see you were able to do it with
> > mlx5.
> > 
> > [1] https://www.qemu.org/docs/master/system/devices/igb.html
> 
> Yes! I would feed DPDK in as well in this case? Combined with the
> kernel driver it should be doable. It is much easier if you understand
> how the NIC works, of course. This worked out significantly because I
> guided it through sufficiently small steps and knew where to find all
> the quality reference material..
> 
> > >  - Make it work on a PF too (this is surprisingly hard!).
> > 
> > Can it work on CX VFs? We're interested in continuously performing
> > memory copies across a Live Update using a VF via selftests to
> > demonstrate SR-IOV preservation (when we eventually get there).
> 
> Yes, I started with VF because it is simpler.

Makes sense. I tested it out and was able to get vfio_pci_driver_test
passing with a CX7 VF.

> The PF support flow requires a bunch more complicated stuff.

Do you think it's worth supporting PFs? If anyone with a CX NIC can
enable SR-IOV and run selftests on a VF then we can keep the driver
somewhat simpler.
