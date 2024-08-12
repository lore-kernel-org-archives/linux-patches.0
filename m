Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22746187FE1
	for <patches@lists.linux.dev>; Mon, 12 Aug 2024 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723484980; cv=none; b=jsS9DLdYjQ2G9DhrUyUTTT1wO5Pf2oFq1MlRncJjx3Kzuhpd6n3g2P5trGjd+O2hjjSuO8pYsg88oXF9mZFbvLj7e23wHTrmHtyh6llLExWNkxwlnYlDotu8RVcg0IC1ZXpshujkeJCFntjEJeV34u1Eiyz3ChikOC8+2bnDVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723484980; c=relaxed/simple;
	bh=u+oS+V/6h+7NxaHW/munhBTgt/CeDkNesLNfS4Yvo6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzQ5QPi//PrgQ4Zd24u82Bg5dlFzU8hiZtHze/fgXHNR+eaZY0kkhA4j64B469fG98u/Xyf4naUWoJ+shRvWsIZ9+Hc8iEIu5UMXRGiyv2mMuiuvwAY9ewLbE8/VIv0Ioj4rnTpmYqzHAb4JgS6XvzgkDQSc4bpUvjtsLFwG474=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RCxzbIcM; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RCxzbIcM"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ef2cb7d562so46757801fa.3
        for <patches@lists.linux.dev>; Mon, 12 Aug 2024 10:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723484977; x=1724089777; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KyV0shQA6TIAcqdzVYHe6tGzviGmCFol708Uq7iVvLw=;
        b=RCxzbIcMKkdLCFgeKtmS1wvoGH6EtomoFb1PV7Kz585n0Qlh8f62gc0+yPlDrw1WyW
         cWXObgP5SOPI1wvsS2AWw/Scp0ApXweqq37d+8Iug9mOtWytq5Bu5dGzy8iYW0dYHCGU
         +u8rybxT8ErBzsYviF9XMot1UlOt7GrCdurPsUhRs3wTzb+nx7UmCAj7PSsSgBLl8joj
         EMo7Rpk61aIh5ureRAZgOez/XAi+JxetN19tthA7NDSWN8wIYDa+NmCPLDAw6RFTPzYo
         xvYKzqA2hZsqvCwmiD35E6FjVuBlNE8AOsDOcSp5/LU3QJZGOOdI0EyMn9Ax1X/AjqYW
         z8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723484977; x=1724089777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KyV0shQA6TIAcqdzVYHe6tGzviGmCFol708Uq7iVvLw=;
        b=dsGcm+NH++OwLDEXOY7hE3UZgQBDB5BqOp4rAEd/kCMdPQUYHuchJb+Oovwn9tVdwv
         KIP23TC0toVIbdxw7rMCEquZbrKGrXeLtP5JO7n/gHwi+c9iTBULUTYtvvxpPi6S63dD
         N36BjBOF2nFSqAUBzY9CVwpEhgozm1W6lbmdJNJoQd0ZC4L6gTT1bp+32LLpD0NOvvan
         57pE1k4Prez5oZiZF5ElcXs/dbwlevcJtOZFhGbVDX6HqH4T5kl5o4LmQr3rt7KgyNwz
         CMxD9qnNjSVdp8A/I2dOCfGe2ypeT9PQpz5q6MAJTF7uhvHT9JusdAp6AHd/CTOUKfpH
         EWnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnEtCLOySMe3HzRtE0S3bTSEdAWWKnA8DngsRyWSiecJmRcF4Yj8Vd/TQ96HySDrAnatoqAhUelfsHVJrYWyHIWvpFCt1Akg==
X-Gm-Message-State: AOJu0YxLT8mZZznaarMb/ytpOFgZRkjn5loUJ4qoyB/gPWKxRDC3aWEG
	TIoUsP39zuvfSq6glprphfrW6aVEeQH/Aut/sL1tGHLGiUhDSo3O
X-Google-Smtp-Source: AGHT+IGR4j+7/rR9G6erzkDK6bRBK0zlsxOfsHgs/YAAmuIyBC3SlXqLbYUIZS7yRBl6+Cx77mstfA==
X-Received: by 2002:a2e:be8a:0:b0:2f0:2a55:8c4a with SMTP id 38308e7fff4ca-2f2b7280998mr9035951fa.49.1723484976749;
        Mon, 12 Aug 2024 10:49:36 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4290c7a255csm197681945e9.41.2024.08.12.10.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 10:49:34 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 16FAEBE2DE0; Mon, 12 Aug 2024 19:49:34 +0200 (CEST)
Date: Mon, 12 Aug 2024 19:49:34 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Akemi Yagi <toracat@elrepo.org>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Quentin Monnet <qmo@kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc1 review
Message-ID: <ZrpLLoQeag1Fe_3r@eldamar.lan>
References: <20240807150039.247123516@linuxfoundation.org>
 <ZrPafx6KUuhZZsci@eldamar.lan>
 <2024081117-delusion-halved-9e9c@gregkh>
 <ZrjS0V-tCQ1tGkRu@eldamar.lan>
 <2024081143-grouped-blah-dd52@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024081143-grouped-blah-dd52@gregkh>

Hi Greg,

On Sun, Aug 11, 2024 at 05:40:58PM +0200, Greg Kroah-Hartman wrote:
> On Sun, Aug 11, 2024 at 05:03:45PM +0200, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > On Sun, Aug 11, 2024 at 12:09:30PM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Aug 07, 2024 at 10:35:11PM +0200, Salvatore Bonaccorso wrote:
> > > > Hi Greg,
> > > > 
> > > > On Wed, Aug 07, 2024 at 04:59:39PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.1.104 release.
> > > > > There are 86 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Fri, 09 Aug 2024 15:00:24 +0000.
> > > > > Anything received after that time might be too late.
> > > > 
> > > > 6.1.103 had the regression of bpftool not building, due to a missing
> > > > backport:
> > > > 
> > > > https://lore.kernel.org/stable/v8lqgl$15bq$1@ciao.gmane.io/
> > > > 
> > > > The problem is that da5f8fd1f0d3 ("bpftool: Mount bpffs when pinmaps
> > > > path not under the bpffs") was backported to 6.1.103 but there is no
> > > > defintion of create_and_mount_bpffs_dir(). 
> > > > 
> > > > it was suggested to revert the commit completely.
> > > 
> > > Thanks for this, I'll fix it up after this release.
> > 
> > Thanks! Note today Quentin Monnet proposed another solution by
> > cherry-picking two commits:
> > 
> > https://lore.kernel.org/stable/67bfcb8a-e00e-47b2-afe2-970a60e4a173@kernel.org/
> 
> They don't apply cleanly, so I'll just add a revert...

FYI: Just realized that the breaking commit was as well queued for
older series 5.15.y, 5.10.y and 5.4.y, so that needs to be dropped
from those queues as well.

Regards,
Salvatore
