Received: from mail-ej2-f2.google.com (mail-ej2-f2.google.com [74.125.228.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C99B39B49A
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784875986; cv=none; b=nhm1uVORQGVb/bSx+GoK9J4ae8m7A9tcaVQqMUzQzX+NF8SjXqZjWiyhfwjGROA9aHgRArLGBI6J3zeUq6uRJpGHF79sF0/kjOteTz4WrKKjzHMplAyFSpJj10hPsr+kYgQ7ECaCBnkt2INJpcfDAt+cuaLjt71tByJ9rscRJYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784875986; c=relaxed/simple;
	bh=C6g4IJ7nkIuLRBYnGLfnGuivsqdEPRmNM7+k8tmIPGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrCF6Yg42glfC5Myd1P7M6J/YPWlE9SE7NmxDSe2VVZ+wTLYmacsIw6fVvcKRnOPquJGwYOwsf4oNJOmLFyj2eusGYMOy9RYUMFo2MdRa/YOKVaRaBRkzGlcS8ABqTZ76rfPl7w8dUmeEYVv0gm3wFQ35XTzJQM4N62YEpLO/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AWPZg0uF; arc=none smtp.client-ip=74.125.228.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AWPZg0uF"
Received: by mail-ej2-f2.google.com with SMTP id a640c23a62f3a-c15f8dd6f18so6462666b.1
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 23:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784875979; x=1785480779; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WY7CdMG8toSwubevIKGiHcYEpkYHz2KmtfuPZHWqhkg=;
        b=AWPZg0uFTJ/SL8f0uyUjfEo2gOPEs5AjRm7s8hg+l+HjoHn+7nasVOBKcsSYlSs8+S
         ppl4SPCpjellFYkYIVDWfTA3NaleXJBKnyHd+TNwwm4xAeUNdwPdnLGAju89l4h+iPyF
         4dU3cXZ3RZlMBkH4qLT4/6l19k0bXRUUXIWWx56ZDxmABFMw7nwcaTo6k0pZwuCR9rvj
         RG2sDvs+pJh/kdn4bpCRhfCu/DicaRlAZMvCC5DMBuAVUc2Z76nppqwf35JxWlrViMZF
         kDi+jNrf9K+CChYiWjhFE9ekuqvIQnOnidkmZrQVh/52eZqRqRU2JJBCddjozURIp24b
         yfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784875979; x=1785480779;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WY7CdMG8toSwubevIKGiHcYEpkYHz2KmtfuPZHWqhkg=;
        b=Qb1IA9cpR9I7sM5pZCf47m/H8TC88zsflBPF3f01UyYaEUMgJW16PBR4fpY+1TDpnV
         EOXCdWlPxgUnTK0fM5skpFN4tHwFcfc3h10145rE0nRYoYYe/s9a9hPf3Lg49ArjhT5V
         Ev1LKlP9O5XwXrkdtNQIgIQNB7QFQI/6OMV7wvgbrXEZCDd+nyt3yGeS3xgqF6lwTJZr
         buulCtHkvwd6TwbJS2YFdTYDlOOOTpOsTuIYXV/T9C8RTQTumnVICdm2gawkmOztyMm3
         q8LkbqyN5s2DT7TS2PDN4tSsHDlggVZh1eZjtzeBmSjO5wvEHXrJ8wjjUopL6McXFYn8
         7/4w==
X-Forwarded-Encrypted: i=1; AHgh+RqnAP0Q1AWhssl9mYo72ZPL/U5WunuXfzl6JozLo99t8V6waGmOpIMXSxM0DbO4W0jSDqX7BLCg@lists.linux.dev
X-Gm-Message-State: AOJu0YzI1KAMJKqFoDI0g4b1m5qwchIVGX6Owu8nWd/AQxz9wGWsB6Vo
	eyWZimGCv+0lpGFZrUFKsGxkFwmn8qA/T5447jwnUXBKmkP8USxdxlFug+XGYmTbevk=
X-Gm-Gg: AR+sD11WHhKSiMDAG7C5HhhNAQ4/dsKs0GQs5GUhasd7vsx35fKGTYudqcSd1OII7Zu
	6m7SzlOp4AEp5VerWDWH3bOPE0mFQe4U6ZSpQSMyRSqM1eiXRYfztXOn++RrRuM7SpEtPnDer6u
	ztTdQHvlOOVSeK6nVZVRhAKnRE6sjhyL43mAz4gY4mxJGrCxc8C5ME7+G1K3Mg0fMdPYDvPlln8
	XY/lzPzucYQ6FIrFW/Aj2rWLL+0dVDVvMpBI5zreUo+iZsCH9OFX+u6Tg4VaM3lkV4uD7OdFFMb
	C4bEjXAJGFfMfNrK5iXQA8fsjX5C1B8RpwtoH0+FXozCSIXjiJT7rW3fDWhIB4ulXBbTikHPl5a
	682xN8dSwnKjJYHbd4RSPXr+38u6zll0nw/HQqQrjPhwWIIO/A/ba0jTNyoru6IAKJBOOQ5cE7S
	srtWVI8b6KSQwASk/mF2FYMU210lnE
X-Received: by 2002:a17:907:1c02:b0:c15:b332:260f with SMTP id a640c23a62f3a-c1c5089e82fmr290349466b.30.1784875978862;
        Thu, 23 Jul 2026 23:52:58 -0700 (PDT)
Received: from u94a (61-227-70-26.dynamic-ip.hinet.net. [61.227.70.26])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03b0eaa8sm1009011a91.8.2026.07.23.23.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 23:52:57 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:52:50 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Message-ID: <amMLUyAZFJJY73JI@u94a>
References: <20260722143258.264584003@linuxfoundation.org>
 <amHSEwZcutUhO5tL@u94a>
 <2026072304-dentist-repayment-4761@gregkh>
 <2026072416-chunk-curtain-332d@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026072416-chunk-curtain-332d@gregkh>

On Fri, Jul 24, 2026 at 08:18:39AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Jul 23, 2026 at 12:17:23PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Jul 23, 2026 at 04:37:07PM +0800, Shung-Hsi Yu wrote:
> > > On Wed, Jul 22, 2026 at 04:33:42PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.6.145 release.
> > > > There are 1226 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> > > > Anything received after that time might be too late.
> > > 
> > > BPF selftests compilation is currently broken. But with [1] applied it
> > > will build, with test_progs, test_progs-no_alu32, test_progs-cpuv4,
> > > test_maps, test_verifier in BPF selftests all passes[2] on x86_64 and
> > > aarch64.
> > > 
> > > Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
> > > 
> > > 1: https://lore.kernel.org/stable/20260723071334.39630-1-shung-hsi.yu@suse.com/
> > > 2: https://github.com/kernel-patches/linux-stable/actions/runs/29987147891
> > 
> > Ok, I'll go queue those up for 6.12.y and 6.6.y now, thanks!
> 
> As I said on the thread for those patches, they only applied to 6.12.y,
> so 6.6 will remain as-is for now :(

Hmm, I would swear that `git cherry-pick $6-12-commit` in 6.6 worked
when I tried. Maybe I got the wrong tree.

Will resend one specifically for 6.6.y, sorry for the hassle.
