Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C91A3AD535
	for <patches@lists.linux.dev>; Thu,  2 Apr 2026 11:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775127731; cv=none; b=jjwcVAi5cnTgFnod42T67rSC7Sxf/H/DDqUU06QHjPMEoMuhFV5b1BllQPwWZ2ZiZDvX7gBsWG29nC3tJCgO7Zp8ZwP0TOOum2Fr4grdnkDX01Pe9ngsoZPA58hpvmLhgDEgwP8VXqbILEq4SiwSnha+0c/izGbjOPhZCLarmRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775127731; c=relaxed/simple;
	bh=g1PUzPDOerdwNyKi6ER2gbfLx+t48czd+Z5hXY6tY4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4FjIItMXyqKTHrC2knkpj3YsQ+N0t7xAvgoxeY/bJr0sUlZ0SZ4dWOvRoifZtku1d1KOEyAOXgLko5/hYOu5eAPwiCJvnXqfTXz2gwm6KrjQhNxDeGKWNwZI2AG9w+IK03EAyyvQVqCiFnlBopJ4yccYeCL/3kniKiipzwmVlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NaE/SqFV; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NaE/SqFV"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486ff3a0fc1so6703755e9.2
        for <patches@lists.linux.dev>; Thu, 02 Apr 2026 04:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775127728; x=1775732528; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tf3op5lKH+OvN0zw8qp3z/h5oZygSPqopKpCD8089zY=;
        b=NaE/SqFVWl/t5J9gpo713WFzhWaSn+KPcyTSqsgQRXwfAdfndgVQIEzOnfuxmC/9/W
         SA1+BYkZRlrU/Myw87Wb1PIhqx8aE4fZNdubqqW9+yttKD4SNQFBLqYW40TksjyOfmlo
         9KAlBVtpOPZ4P+8M1U+49g/3Vr2Bxol2GxhETyB6rjj3WdlA8ccnWI0z3ca/CO+4eVLH
         AbIF/Y4Rf/LQbtue1f/geL9dY6O+IDSyKeCfRGX4PvmPW9CfiRQaHcuiKvlgUlvoDfkS
         pHcDzTBUiYDwhsuGtSDvQxNfjxMpvA+qdel+bAd7KqlNwvCBUkRIMe++nFH70VRdE8OO
         s5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775127728; x=1775732528;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tf3op5lKH+OvN0zw8qp3z/h5oZygSPqopKpCD8089zY=;
        b=NHCVgovUNyybYq/dwfbXA+8n3ZRX9uwh7S08G+Z6N+vuoMYOm6GaNshqSuUf9IJ/bF
         XaNcogyXKXRWD2lKSRpYDEPfTDgvNKcI2Pxl2N1J4TXlpI5u1En7KhrQ1IadJaweh0d1
         yzD3FCEvTstZw3gxqrQjBRzJDPrbQh0waM60/HKy8UMr8VVh2B3WEGGYv0QNA5SYbL6s
         gowMXESp/kxINj2vk/QBCa3uxu0ehtKbnfcH4YPc+S0Aswnqzij1uQHwuM4ui2hHHDLZ
         cXlHBx+Ixq47DbnOKMK5b7k1BAlwWBn8rK1F98c+Yee32i5fuINU2rl2x/tQUqcKKXcG
         Q+lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjQGlqTnrNKCPCJ2D74sxEYvX9kGz0Ng2t/uckHIhqydFdSBWcAczqD0JetZvu/ZVWBOy4pZph@lists.linux.dev
X-Gm-Message-State: AOJu0YxWhfzr+an4843/ldyhKf1k35d0ciK4TSkVsV9NpclyIUSvy1QQ
	H8VGQjbTfArACNnwY7lrDFTy+qD/FDzeJm9/OSKkF09AM5qhz4vi+Dma
X-Gm-Gg: ATEYQzxYm7CjxvPLqBXxB9AChDnGmzKWO9HGDbubPxySdY3Nn4447lYmx42VM5RUmxu
	OucIAme00u0IHF78K3nDywfQCcNsMPjVeQQMQhWnUh2m2YbDME5H0avb6ftb2FLFxngRTFgVajj
	NoDiyjM37qWw4jEafr0rvVX+KT+bzUW743xxR8KH3ucWD8Pn/TdhzbQ1EL3hRIZrPuM4/zzOqiV
	po5CsiIvLmtNzP2cEX0GGDdHj1OAv1YLoSU4Oj382vmL8Brd24VV5nhLDLYWlwmSy28whRtIW1g
	g2F9wuWGR/lBSFYDsQuQQYb+r/3tOMpP90Wo99e3DqeHbE6OXmgia1qZ6o0FiPNEgI0eH+42Spb
	Y2i+kUywHvlGJnQStS2/7HhL1aKP0qy7IqADM0uGj+ScfWWoLErsDJTlPLsx2BhLGtl1dC57rAH
	nsURBJ4Y3qiyY/8hCDGg0mqto6X9oIiyMlgQkdjbt1d+xCweC9iD0R4mHKlKEGFin3yGZu457mA
	dfFCC9BcFRn2roVRfrm6c93BPh1usPmiE7cm1Lq+kF6BTWOhpeoLy2vxEbrxpgFJUjYA2lFHG9B
	nNSU+kDjcynAfRIzhPYDIi45y9eggQN1CGgICGax+6k=
X-Received: by 2002:a05:600c:c107:b0:485:445a:87d1 with SMTP id 5b1f17b1804b1-4888b6f7f5emr34209405e9.8.1775127727616;
        Thu, 02 Apr 2026 04:02:07 -0700 (PDT)
Received: from mail.gmail.com (2a01cb0889497e00981c6411e4c4d8e7.ipv6.abo.wanadoo.fr. [2a01:cb08:8949:7e00:981c:6411:e4c4:d8e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887aacb88fsm65229755e9.2.2026.04.02.04.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 04:02:06 -0700 (PDT)
Date: Thu, 2 Apr 2026 13:02:05 +0200
From: Paul Chaignon <paul.chaignon@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	stable <stable@vger.kernel.org>, patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 034/244] bpf: Fix u32/s32 bounds when ranges cross
 min/max boundary
Message-ID: <ac5MrSA8VbSNdlG_@mail.gmail.com>
References: <20260331161741.651718120@linuxfoundation.org>
 <20260331161742.960922011@linuxfoundation.org>
 <i4c753x3y67ek3r7dp774pcmaaaid3gvxcsvdssosdingre4in@od45qzitwtrf>
 <2026040115-dose-aerobics-7c6d@gregkh>
 <CAADnVQLSfDtqeLFw=DjG-dG=xD_qS7p2LHsT9jAxO5aAK0YJig@mail.gmail.com>
 <ac1LCTbV5ZnqUgG0@mail.gmail.com>
 <2026040240-friday-gurgling-7088@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026040240-friday-gurgling-7088@gregkh>

On Thu, Apr 02, 2026 at 12:46:10PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 01, 2026 at 06:42:49PM +0200, Paul Chaignon wrote:
> > On Wed, Apr 01, 2026 at 07:32:26AM -0700, Alexei Starovoitov wrote:
> > > On Wed, Apr 1, 2026 at 4:44 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Wed, Apr 01, 2026 at 02:22:58PM +0800, Shung-Hsi Yu wrote:
> > > > > Cc Eduard and Paul since they know this change better.
> > > > >
> > > > > On Tue, Mar 31, 2026 at 06:19:44PM +0200, Greg Kroah-Hartman wrote:
> > > > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > > >
> > > > > > ------------------
> > > > > >
> > > > > > From: Eduard Zingerman <eddyz87@gmail.com>
> > > > > >
> > > > > > [ Upstream commit fbc7aef517d8765e4c425d2792409bb9bf2e1f13 ]
> > > > > >
> > > > > > Same as in __reg64_deduce_bounds(), refine s32/u32 ranges
> > > > > > in __reg32_deduce_bounds() in the following situations:
> > > > > ...
> > > > >
> > > > > Hi Greg,
> > > > >
> > > > > This patch is causing the following BPF selftests to fail
> > > > >
> > > > >   #222 reg_bounds_crafted
> > > > >   #222/27 reg_bounds_crafted/(u64)[0x7fffffffffffffff; 0xffffffff00000000] (s64)<op> 0
> > > > >   #222/28 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffffffffffff; 0xffffffff00000000]
> > > > >   #222/29 reg_bounds_crafted/(u64)[0x7fffffff00000001; 0xffffffff00000000] (s64)<op> 0
> > > > >   #222/30 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffff00000001; 0xffffffff00000000]
> > > > >   #222/59 reg_bounds_crafted/(s64)[0xffffffff00000001; 0] (u64)<op> 0xffffffff00000000
> > > > >   #222/60 reg_bounds_crafted/(s64)0xffffffff00000000 (u64)<op> [0xffffffff00000001; 0]
> > > > >   #222/79 reg_bounds_crafted/(s64)[S64_MIN; 0] (u64)<op> 0
> > > > >   #222/80 reg_bounds_crafted/(s64)0 (u64)<op> [S64_MIN; 0]
> > > > >   #262 reg_bounds_rand_consts_s64_u64
> > > > >
> > > > > The failure is caused by the selftests' expectation not aligning to the
> > > > > stable 6.12 behavior. I believe the easier way out is to drop this, then
> > > > > wait for [1] to land and pick it up in stable (or I'll try to backport
> > > > > and send). That should address the root cause of what this patch is
> > > > > trying to workaround.
> > > > >
> > > > > 1: https://lore.kernel.org/bpf/d4fe45f8bd5c6a48efd2ba3b66932bf7eb5aa020.1774025082.git.paul.chaignon@gmail.com/
> > > >
> > > > Now dropped, thanks.
> > > 
> > > I suggest ignoring the selftest failures.
> > > The patch is necessary for stable and backports.
> > > It's fixing a real issue.
> > 
> > The selftest is failing because we're missing commit 1f8fe377855b
> > ("bpf: Improve bounds when s64 crosses sign boundary") in v6.12. It's
> > the s64 counterpart to the s32 patch backported here.
> > 
> > In bpf-next, we have both the s64 and the s32 patches. The s32 patch
> > also updates the reg_bounds_crafted selftest to cover the logic for
> > both the s64 and s32 patches. If we backport only the s32 patch, the
> > updated selftest fails.
> > 
> > I can send v6.12 backports for both the s32 and s64 patchsets if that
> > helps. There are a couple minor conflicts when backporting the new
> > selftests. Or we can just cherry-pick 1f8fe377855b alone.
> > 
> 
> I'll keep this dropped for now as I have no idea what 1f8fe377855b is,
> as that's not a valid git id in Linus's tree.

My bad, I meant commit 00bf8d0c6c9b ("bpf: Improve bounds when s64
crosses sign boundary").

> 
> Can you send the 2 patches needed here and I will queue them up.

Will do. Thanks!

> 
> thanks,
> 
> greg k-h
