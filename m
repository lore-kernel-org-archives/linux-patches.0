Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9715E1EB9F7
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 16:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729529532; cv=none; b=mynn/4BIZGTGaIBINd/IH28y0PBhP/cgj5qgBcKT8UJ//DUBU0bWTESwDepXk7zZvN/f/LQuaJFlhGSbTiNyumyci3sFaTauH4M6AA9msS05T60sl0H+9/mkx96LRYDvsRa7Z/+dWvNTJ36JkhHx/KQPkB+Fs9q2C2O4GqNfa4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729529532; c=relaxed/simple;
	bh=EUJbbfo3ZAUD6jEYt7KoSrq296Z8+HF/5pZK7t+FuoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PRNiiEvZ9K1ArORMqAY96rApPPigncNDFVH6TbHpZeOCOao3mbD04kd9/7eDXpGMgooC67BeD90mv0AymRtnUAl2ecsOmvbx43oVNtPImTiqJb/G0qZKpZJcXc3WaH4qG6BQo6MMsreoYkxTRkg5kBd7t01l6hKCJBNFyTn+khU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=emD3/UXs; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="emD3/UXs"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4608dddaa35so9931cf.0
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 09:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729529529; x=1730134329; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/QsgZ/kRVrlMOQCEc1BgaY0+yz9oCMONnpajHxu5tc=;
        b=emD3/UXsuMbU/1oWuSvaW12mTBPlvEX1Q25d1uGI4qP8vpHelWLuLNMIFuGNEaDHIM
         zZ7EgHfo3CM2SmmUgrnO9UfDbE/KpjNfJyV/ciHjhebcn8ag8YctKszMLeHtv+JMJFbN
         Nbfxrtf8Ewj9Qo/i0tJzhyApfthxtMwhDO+FjLPPxtqDEZE3bkOjFEVR98qMChMtvt3F
         CeaoFvSHVEfmIDp+ups/VegCBIdzIxFuDreih9n5HW24Rf8XZyXtEZpo5I1pzZ4i7Cm8
         VA93HOQHPuTdkr98Eem/avUM70QqD01sLSV7/no7yhNmyEGf0YL+qBAYPd4U9883hOkm
         wC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729529529; x=1730134329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/QsgZ/kRVrlMOQCEc1BgaY0+yz9oCMONnpajHxu5tc=;
        b=Jtl0z196ReX6XWcffknA078X1egU925aDqzVmfUOC6Ae+kZRPWdvKoLjWN1iLm3rmJ
         g748D80wjmaPRaZniDZseMcIKYeuEOrvCKiZdauD5WxjBnulYtMS4OV9Anl2uAco0aIT
         iPgtkQYwqNU/vYXozHTtY0BftUMaM/hrzwlidBwhNyT3u7n3nhrYCDbaEKOPywloI8XG
         a3GuXbuk1pFyT4msUVBO48zHc/sjpZHIM3U5vcPyjAul0skE4f/eAWytqxEVZ36dHc0C
         jB+Nf1gCRTrsGISSUdUx0GOdZHjwNrb3VP0HI/K1ef7ENykRtC+8exNimlwP9w4jjZZI
         kLYA==
X-Forwarded-Encrypted: i=1; AJvYcCW0ljUF0d/cpcng9EnCcbyS3P56HFgQtNHfj3H6DMG9QBv2PWq94ojh+My6TfwLrS9zbDpCIeOE@lists.linux.dev
X-Gm-Message-State: AOJu0Yxvqb99BkzvWKEavADS9yvWwHkqXGKtetZVRPAgCRs/HmkvIpQl
	L0CdfrFkaMUlLU9m7RD0Xv+Ex1njlWaWgRSDejdnPncOczwE5tCujd0GX2Uuc1VthHw70e62pMn
	m5qypHIDJNcyraWqNgfbBI4ZXHYLaZre2TJ6N
X-Google-Smtp-Source: AGHT+IGaW/ZxR9IpEgTweuDCf8gX8oQpuR0fk7PkCThDqlXbRiZhW3pbNa6IePcJOgoKrKgLXRstMLz7Y4GbgtnqZ9c=
X-Received: by 2002:a05:622a:1115:b0:460:48c3:c352 with SMTP id
 d75a77b69052e-460be418992mr4914301cf.1.1729529529041; Mon, 21 Oct 2024
 09:52:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102259.324175287@linuxfoundation.org> <20241021102300.282974151@linuxfoundation.org>
 <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com> <ZxZ_uX0e1iEKZMk5@pc636>
In-Reply-To: <ZxZ_uX0e1iEKZMk5@pc636>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 21 Oct 2024 09:51:58 -0700
Message-ID: <CAJuCfpGwBixidbi1D-+6b6BrM7Ggob-1NZApo_+dny_T2qNAzw@mail.gmail.com>
Subject: Re: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Florian Westphal <fw@strlen.de>, Vlastimil Babka <vbabka@suse.cz>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 9:22=E2=80=AFAM Uladzislau Rezki <urezki@gmail.com>=
 wrote:
>
> On Mon, Oct 21, 2024 at 09:16:43AM -0700, Ben Greear wrote:
> > On 10/21/24 03:23, Greg Kroah-Hartman wrote:
> > > 6.11-stable review patch.  If anyone has any objections, please let m=
e know.
> >
> > This won't compile in my 6.11 tree (as of last week), I think it needs =
more
> > upstream patches and/or a different work-around.
> >
> > Possibly that has already been backported into 6.11 stable and I just h=
aven't
> > seen it yet.
> >
> Right. The kvfree_rcu_barrier() will appear starting from 6.12 kernel.

I have 6.11 backport for this fix which also includes
kvfree_rcu_barrier() backport. I was waiting for this fix to be merged
into Linus' tree and now I can post it. Will send it shortly.

>
> --
> Uladzislau Rezki
