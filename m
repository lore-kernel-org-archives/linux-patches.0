Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF527E0ED;
	Fri, 14 Feb 2025 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739550920; cv=none; b=UQcjV8yInp6EGD7LebStWX6OqcZ5gf5HWsiA+33ktmF7skmgwSFwPR21m6Llev0HAa7GZ3/w06NfIXFyJPOOVvxde/WguytxnJfhDFEuRFxlS71lItCRnP43hE8NS76rCHFxnf907PLNEO/mwJ7nM0IFIPpk7tYnIjD5/QmOC6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739550920; c=relaxed/simple;
	bh=hqQvw7IUAAQaitAWF3Lh4LPDIwsMNdmzFrfpxP8jcz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CdYGNCcDgk6eX+7GhDbTgIIFJqjAOqx4A0hhtuc52CYAo+8PVuEtyRmasKU7zYgLIpZzcJEaBvCFVWigSqfTNjBLBRWk/HwlxBCTx1nL+4agYsGQJkKHO3J3RZQRkx1rx2NgM9e8Uh7SsVrvJr4BHkb2XRzHspjTfCkzOsJZi2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F6XcYKjQ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F6XcYKjQ"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fa8c788c74so481126a91.2;
        Fri, 14 Feb 2025 08:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739550918; x=1740155718; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBW9iWXTPjCNPPFKZqtUELqSmwKsFRdC2nvcBo4TH2E=;
        b=F6XcYKjQwYbrcx5GAdq1nptOohOf8kkuC2UuCp6AZtXP0qH23aGvDsNJmRCyfi4vO7
         HZzGdBMjCqn4h6oQ6N1EhgFePT/xsXRrvbxXbyx3pT67+Ly0UuInJnnORkxRKBQd8a4w
         +8cFtrKWF4PcuA+7qb+qIbd9nRjKVYX9o0KWuQj5Ag2pNY4ydQjxoZ9PFgRkvKLagiAr
         TgyApzML3hSPVcd0Q5Ixj7uPWaPuJKSa0y6eRr1msthjZjLPV+3IdexUM7p/4Zq52yIQ
         qPiMz6WELFATdMnQ7kd55dq+5OvDaan0GNDlV9ykphyPXPmDVtKmbxVK4yRY6SOoGS9M
         6OQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739550918; x=1740155718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GBW9iWXTPjCNPPFKZqtUELqSmwKsFRdC2nvcBo4TH2E=;
        b=pSZjMNsIyKlzeHB3oVJItgBb6ZCnBRgb4O4iUpbSO6R+mJ+OHFgDMgK5784l8WhZ55
         2TnSV2qAoWR+JLCXB12z3029GWO1YdqGhUwOUoPXZPbM7CsAOHNWAOBSHAMv7iAVLddk
         LfGuHG7uAoBjmQX6++okRQfRTBUlgWjRhCrXYs5iXFynH8m160ucprQAJtEaXA412s6n
         G/YrMsLaeQHuLqs57675iBc14h5RKD8a1kjQPbQMe83U2aZceoBp0iHzyZy87vCeqYxi
         n5OZY+reHyD91jXWkf3c8Vb/noYzEnWNhcdaGNy0rsINM4TZGo+GosmHITXEPoyLi/yC
         /kwA==
X-Forwarded-Encrypted: i=1; AJvYcCUNwhJliXNTk2PRxvAYoZb3zlg+yvHmD9sidNuW3oAhlvtORs5stqWzSNxNnqpIpeHt5XKB4Zpnow==@lists.linux.dev, AJvYcCW6UKTes1ALAczm0zrSBGIdUVwfWvAFnOFU253kytmgs72+aoOzeokJozUPtba7Nc227BkT@lists.linux.dev
X-Gm-Message-State: AOJu0YwPsLwTSNHp4fgshzdhOprElN5gQuWvzNK8ne628Mra15QzN+TQ
	CJqM2ZbHexSdu16ZIYmvwh5QITa6HpEDFsToMbXOMtZy968vjd9cWqUIGVrq7anKwpMppLwLrzz
	3AVS2fHgS2uy9nJWX1Tz8SdK3Y6g=
X-Gm-Gg: ASbGncvy55cKwaVbMRj9G2ByU2T4YQ7nUW6d1AgqziUTnkNbs2yBgx1aZLIveLS31/w
	JRuyoNxwQrtR9A9V1OjdjR6is8PlzFVWD98c4cqTfu6PxzV3AhcVcsNEzsP5aVx5M4YDo9shI
X-Google-Smtp-Source: AGHT+IFAg9ohgjgbuT0seCKh4CYhM69eIUuttE9yM1Ug2c4COFaR3gXGRNbaouKY5oxT95jalAAWCU/oCmaDR+/btRg=
X-Received: by 2002:a17:90b:2f85:b0:2fa:2011:c85d with SMTP id
 98e67ed59e1d1-2fc2d04fe0fmr2165699a91.7.1739550918086; Fri, 14 Feb 2025
 08:35:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241219-amdgpu-fix-enum-float-conversion-again-again-v1-1-ef2c619724b1@kernel.org>
 <CADnq5_NKWH7UC_ow825aAtF1tZXJTVOwDWaqDR8_4Y6EmPXUiA@mail.gmail.com> <20250214162813.GA3221808@ax162>
In-Reply-To: <20250214162813.GA3221808@ax162>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Fri, 14 Feb 2025 11:35:06 -0500
X-Gm-Features: AWEUYZl0Bz3gbkMM-U-AbQ0SraEE3UTPUbx05TeMQKPklIWTUPqv6fEy5wiUN_o
Message-ID: <CADnq5_M6cHLmrKevSFtzwBh4quekM6hcHnAvc+x=c-N4=Ydeqg@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Disable -Wenum-float-conversion for dml2_dpmm_dcn4.c
To: Nathan Chancellor <nathan@kernel.org>
Cc: Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Xinhui Pan <Xinhui.Pan@amd.com>, Austin Zheng <Austin.Zheng@amd.com>, 
	Dillon Varone <dillon.varone@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 11:28=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> On Thu, Dec 19, 2024 at 05:21:41PM -0500, Alex Deucher wrote:
> > On Thu, Dec 19, 2024 at 12:23=E2=80=AFPM Nathan Chancellor <nathan@kern=
el.org> wrote:
> > >
> > > Commit be4e3509314a ("drm/amd/display: DML21 Reintegration For Variou=
s
> > > Fixes") blew away commit fdedd77b0eb3 ("drm/amd/display: Reapply
> > > 2fde4fdddc1f"), which itself was a reapplication for the same reason,
> > > which results in that compiler warning returning:
> > >
> > >   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_dpmm/d=
ml2_dpmm_dcn4.c:215:58: error: arithmetic between enumeration type 'enum de=
ntist_divider_range' and floating-point type 'double' [-Werror,-Wenum-float=
-conversion]
> > >     215 |         divider =3D (unsigned int)(DFS_DIVIDER_RANGE_SCALE_=
FACTOR * (vco_freq_khz / clock_khz));
> > >         |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > > Just disable the warning for the whole file via Makefile to avoid hav=
ing
> > > to reapply the same fix every time the code syncs from wherever it is
> > > actually maintained.
> > >
> > > Fixes: be4e3509314a ("drm/amd/display: DML21 Reintegration For Variou=
s Fixes")
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > > If you would prefer reapplying the local fix, feel free to do so, but=
 I
> > > would like for it to be in the upstream source so it does not have to
> > > keep being applied.
> >
> > I've reapplied the original fix and I've confirmed that the fix will
> > be pushed to the DML tree as well this time.
>
> Did that actually end up happening? Commit 1b30456150e5
> ("drm/amd/display: DML21 Reintegration") in next-20250214 reintroduces
> this warning... I guess it may be a timing thing because the author date
> is three weeks ago or so. Should I send my "Reapply" patch or will you
> take care of it?

<sigh>  I'll reapply.  Come on guys.  Please make sure this makes it's
way into the DML code this time if it hasn't already.

Thanks,

Alex
