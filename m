Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B11D18C01;
	Mon, 15 Jan 2024 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVGSiG+S"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6dec4b7b680so2828939a34.3;
        Mon, 15 Jan 2024 09:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705338187; x=1705942987; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fgUZQcmOYmK00Ogyq1MRr9eNSSyjdevfo9jMdY5qKc=;
        b=XVGSiG+SyDfWv4gvlQMRT+ZrMldGIE96MeOdWflDC44PnF2fkuTyEoS1iLyaMhLQqO
         bVjq6SXcDp6xBdi6DKMzp6kthvHhbV4SJtz4lrN51Ls92+VZn+nRFiODOngEqrVOmcPy
         cp8LnlAXWe87qMlgd3uxFl2kg5OQx5HLCKiRQAZfgyohRVXA+molm+gFXcNDm8FqKqf9
         /SMVDI+r9Paqkb6X1h2vPM5kz52wqQ9mSCKkm/s4vEqsA7ZRGWv+39BKdl06dXyDKzCj
         PnRBHKfcqi3JSVhxI5+UyiTACdEane8z57wH0HlFt/zXizpjd7IC8sp/SZxCCMqJSKBc
         H7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705338187; x=1705942987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fgUZQcmOYmK00Ogyq1MRr9eNSSyjdevfo9jMdY5qKc=;
        b=ntR8Eu0VLAs30PK3g+sCaKwyMhkTwOXDjScmVjGCBAexfG0Nf/4lK0XVcrnk7iuxgT
         LFDjTPNdtpUrrMr9EIXxAGjPBSms57CEFHKQLklsoZfa0getMO0ou41ChFtWnhEWAhWJ
         HAiTEUarpgLXBW7MpqLTr60xRSGvZzm1DjhsC3DrpdaE8gMrjAxfS0QK5LYhuvsrLN9D
         QJfQgFrZMz3vuSQsQGzTqhFBgWPN5U2JNfv/xNX2Vvj/7DQXifnojdWaWkjNJ/W1oJMR
         2BZIDA2oqKlv434lIiaYhT6uUYuPqBNuhZ2mvfpY5ZotQKR0PoW8ZNACsT1EwkEaofLP
         4zBw==
X-Gm-Message-State: AOJu0Yx3xWyc3TWyJsuZno6CXrNhcn9KduMTLWHiMnwawSro3LcavPgp
	t9L5Ujj230FdycxtZyvsSwbJuO2i16kDhno0YWE=
X-Google-Smtp-Source: AGHT+IFmx4SZyITP3d+ZK651GFMqNPBuYso6fpXg81BJnj4lbZuuy4vSQXVTwX0qy3cGNCgd17/hwjkyHjrdVGb8NJ0=
X-Received: by 2002:a05:6871:8798:b0:205:c4d3:ef8d with SMTP id
 td24-20020a056871879800b00205c4d3ef8dmr8820687oab.104.1705338187418; Mon, 15
 Jan 2024 09:03:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240110-amdgpu-display-enum-enum-conversion-v1-1-953ae94fe15e@kernel.org>
In-Reply-To: <20240110-amdgpu-display-enum-enum-conversion-v1-1-953ae94fe15e@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 15 Jan 2024 12:02:55 -0500
Message-ID: <CADnq5_OH_YtGww2HUG5vypVmYgR6t-0Hup=apmUwQx+tQszeLg@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Avoid enum conversion warning
To: Nathan Chancellor <nathan@kernel.org>
Cc: harry.wentland@amd.com, sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com, 
	alexander.deucher@amd.com, llvm@lists.linux.dev, arnd@arndb.de, 
	dri-devel@lists.freedesktop.org, Xinhui.Pan@amd.com, patches@lists.linux.dev, 
	amd-gfx@lists.freedesktop.org, christian.koenig@amd.com, 
	peichen.huang@amd.com, cruise.hung@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

On Wed, Jan 10, 2024 at 3:56=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Clang warns (or errors with CONFIG_WERROR=3Dy) when performing arithmetic
> with different enumerated types, which is usually a bug:
>
>     drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_dpia_=
bw.c:548:24: error: arithmetic between different enumeration types ('const =
enum dc_link_rate' and 'const enum dc_lane_count') [-Werror,-Wenum-enum-con=
version]
>       548 |                         link_cap->link_rate * link_cap->lane_=
count * LINK_RATE_REF_FREQ_IN_KHZ * 8;
>           |                         ~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~=
~~~~~
>     1 error generated.
>
> In this case, there is not a problem because the enumerated types are
> basically treated as '#define' values. Add an explicit cast to an
> integral type to silence the warning.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1976
> Fixes: 5f3bce13266e ("drm/amd/display: Request usb4 bw for mst streams")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c | 5 +++-=
-
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_b=
w.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
> index 4ef1a6a1d129..dd0d2b206462 100644
> --- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
> +++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
> @@ -544,8 +544,9 @@ int link_dp_dpia_get_dp_overhead_in_dp_tunneling(stru=
ct dc_link *link)
>                  */
>                 const struct dc_link_settings *link_cap =3D
>                         dc_link_get_link_cap(link);
> -               uint32_t link_bw_in_kbps =3D
> -                       link_cap->link_rate * link_cap->lane_count * LINK=
_RATE_REF_FREQ_IN_KHZ * 8;
> +               uint32_t link_bw_in_kbps =3D (uint32_t)link_cap->link_rat=
e *
> +                                          (uint32_t)link_cap->lane_count=
 *
> +                                          LINK_RATE_REF_FREQ_IN_KHZ * 8;
>                 link_mst_overhead =3D (link_bw_in_kbps / 64) + ((link_bw_=
in_kbps % 64) ? 1 : 0);
>         }
>
>
> ---
> base-commit: 6e7a29f011ac03a765f53844f7c3f04cdd421715
> change-id: 20240110-amdgpu-display-enum-enum-conversion-e2451adbf4a7
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
