Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13F8359F96
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 15:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765898184; cv=none; b=VA2wi5EpjC+jhZmZtvbu7C34cYr84HeAUN9CJk15WkCjup17deywERdnsSYWCrBzk0RKlMoDMicMc+nxNmY1cjeJdVUiKqLF80qu+I4Qupqr7ZDwIAh7Se6DMAZLj1q63wyd/4oKuy5lnajAREt1/zQqNI51CDIYlRCH4GlzWQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765898184; c=relaxed/simple;
	bh=XydU0zYPi34+6gSjQxNPZvQ3IrEKTjskKmZnjkotDnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bNGfGJEVrykUzEpp/pplV3oWAt4xeYJTpuzbZIBZpx9LHNtC6dn8z45V4J2d81IhneSvnLqP+auAOdw2czSvQugDy+NFFVTl3bzHsTUsm3mTDTrBMgP9S6+ez66Z/M686MszDgl31gbZ+3hbSU9V8DVDGaP8ksaVvCBNoWO6li0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgUxIads; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgUxIads"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c0e7f4920aeso139416a12.2
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 07:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765898181; x=1766502981; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Prk++bNPBbw7llSvdyWuyKrdatVuaHMUXvtiIeDQebI=;
        b=QgUxIads2TrBzccDXsBRGXf+sOdsHDqJTqM+wAb1+cUNhoxxNQQhwY1jZroUthNNlA
         zJEC6ioFq47n539GP0GXmWqfXgauBp0VQUitOYYUuZcoov4AHCOQ08HGIv/6NGszCjID
         d/ldOmVJfP6CFb1hX0zHtto7FYNfia4fzPwO1l7jRYI3f7EpMFq+qKQ64AI0QsIEZq39
         b4DzFzGuBQloiZBJ/Blh9iG/TZsoCT9lB1ggAwdCQZVyS05BFoSAvJLhdf++ULvGcLuW
         sVRJmez+cm9NAy+Q6hogN/8uCiIJI2JYJkB8MZQBM5MGUXWCXajcW0LjnOTzSu080QvI
         CHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765898181; x=1766502981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Prk++bNPBbw7llSvdyWuyKrdatVuaHMUXvtiIeDQebI=;
        b=J1YDYZoqyTo02MTeLNIVdQkyJKUG1yIbY83z9hi6uSf+nIXKliwldoPN18KlFUtnzQ
         IV+89mSQVTFwGldRc4TG08eKg8x32RRi2GktEa5AckPqBNy1WCTlKaXVBoCikpjRGH1G
         HeToHkFkqjMQEdz4EdURGkp7PKeNsyE7D58ARH+mnSo4eEAthrTD8ylaqqhuOOwub2/X
         WeX/B5CMSruQjsT3clI9wPcx0i1RobRQp7cnRplR8aQhutveItz0pkHsorGbSR4Kt1Hq
         iXRksp2eqGNzMjoDNpEScc48ibxcbxyHCy5p4QWljaO82DIuubjo8Kua8GbxYDaxgqlg
         Jdeg==
X-Forwarded-Encrypted: i=1; AJvYcCXvrDN1GfgIyDAX2CjElfOltaVsaI0sDZl/Lar7DDQw7/QX5e30RfoQqPSKzQvIdE14f7FtfHDg@lists.linux.dev
X-Gm-Message-State: AOJu0YxhAsA/W5OJh2ifk0zIKI/d7j7rQKKPoiX0R8fkLjeRHqL0Y6+G
	RZef3wt3pbquQXV9Sj1NYkgPe4t9GnvRmaCKDEP9inwVx4hay4p0kudpXaL3pNg0xsH/0Ikj2vN
	yJO4VCWfOUWgga7pZaQdLbcuNer3L70U=
X-Gm-Gg: AY/fxX7cQiNocrr3E2K+OYCyqqDibnoZ7FBDblpHGZFzoIHc0Mz+18ITYv/WTvgm0w4
	DuBm8Kqn4gFdhelOs3N5VerfSWlfvVX41LsiAy3Buyh1ZToFdsJoczDe1pf/TwSlC8tUYuHR/CP
	PeT9pVs3j3mfCuVKwf5rY6yU13RlphzQBDcyfDd+JRE+q9tflHErkzux6yyGrM1oEYldBWpUViN
	lumeBYXIUVX3ScLM0mwCN5Q1fLD/Kewnx00yiWRonWYiivrJNYqSZ0Rg0QyCuVCSLkCMVsq
X-Google-Smtp-Source: AGHT+IExL4bbWd8dGz3R1du6C5PQxAQFN3higbgXbHR2p3Vd8GWbSJj78l5nGqz1hyDQKAFC7gD/XLUbhsxrspplMLo=
X-Received: by 2002:a05:7022:698f:b0:119:e56b:c3f1 with SMTP id
 a92af1059eb24-11f34bd3d6cmr7088129c88.1.1765898180806; Tue, 16 Dec 2025
 07:16:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251213-dml-dcn30-avoid-clang-frame-larger-than-v1-0-dd3d74b76a17@kernel.org>
In-Reply-To: <20251213-dml-dcn30-avoid-clang-frame-larger-than-v1-0-dd3d74b76a17@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 16 Dec 2025 10:16:09 -0500
X-Gm-Features: AQt7F2o9ouuY7f1i8nUGZF2nlb34bshqvLmZP02ymrNXjm02AX6gvFlIqpRP0n0
Message-ID: <CADnq5_PLd_v9n=dHFmAdPcWY2NbbyCocOtE-9CoMX4D1H4sL+w@mail.gmail.com>
Subject: Re: [PATCH 0/2] drm/amd/display: Address -Wframe-larger-than with clang-22
To: Nathan Chancellor <nathan@kernel.org>
Cc: Austin Zheng <austin.zheng@amd.com>, Jun Lei <jun.lei@amd.com>, 
	Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <siqueira@igalia.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 13, 2025 at 6:04=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Hi all,
>
> This series addresses a new instance of -Wframe-larger-than in
> drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c with
> clang-22 (current main). This is similar to previous fixes that I have
> done in other dml folders such as:
>
>   a3fef74b1d48 ("drm/amd/display: Reduce number of arguments of dml32_Cal=
culatePrefetchSchedule()")
>   c4be0ac987f2 ("drm/amd/display: Reduce number of arguments of dml32_Cal=
culateWatermarksMALLUseAndDRAMSpeedChangeSupport()")
>
> This was done fairly mechanically, so let me know if there are any
> issues, as it has only been build tested.

I'll run the patches through CI and if they pass, I'll apply them.

Thanks!

Alex

>
> ---
> Nathan Chancellor (2):
>       drm/amd/display: Reduce number of arguments of dcn30's CalculatePre=
fetchSchedule()
>       drm/amd/display: Reduce number of arguments of dcn30's CalculateWat=
ermarksAndDRAMSpeedChangeSupport()
>
>  .../amd/display/dc/dml/dcn30/display_mode_vba_30.c | 545 ++++++---------=
------
>  1 file changed, 139 insertions(+), 406 deletions(-)
> ---
> base-commit: f24e96d69f5b9eb0f3b9c49e53c385c50729edfd
> change-id: 20251213-dml-dcn30-avoid-clang-frame-larger-than-36afd349190b
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
