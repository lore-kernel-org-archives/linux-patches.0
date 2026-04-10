Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C773B38B4
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 21:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775856057; cv=pass; b=RmfMkz+z0/4bHGdy0jHmmdoB7Y9U8sg2jSHwMuUI3Z7Cy3LUG52yHPbDOZtSN0R04G6pjSvanMXcCunUshQ59dUi1VF198zTIfXYcIoWetO9Zlh7EbDlgx6rLlU2Vav0ml4PDZTjHYuqsuE5i/nq5109/WT+Df4mhc7cNuwluEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775856057; c=relaxed/simple;
	bh=Ss3l4fQSrxu+4aX5Y3uEpQN7nCCMUS3AsDLwQiEMG/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ovw/dN8S8p1Fo36oe3uNp6k6ghbsFUuYQJtiynWu+6FEtlqxkRetzcXKVhWCgdKAu4iwc9AHk6hErF9rce+PM2dO4fRN6zDs/CorXlwDG73n2ucjOd/EW3YXulLiCtyMz/lecoVm9bf8cp7NuiCv53EHLbU4LpRsNeg0lHLZASw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VlH7qGfw; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VlH7qGfw"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b9bff57cb62so384659966b.2
        for <patches@lists.linux.dev>; Fri, 10 Apr 2026 14:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775856055; cv=none;
        d=google.com; s=arc-20240605;
        b=I6dg/AUqyM+DP84FoLOEnsAqyDtVx8QpN5eIAiSBXj1WZIed16iWoOFzrxJYZjMGcK
         +xUSmTGP868BPWW7NmO1yLK74HFXBo0E6ojU5tC/RRoCjht5F2fX+Sh/cTXZ3yuH84G+
         8hIxUs3sfFhjwQHmUcMJaXNw26TDYBheEYkRvI7ibwvyg6ZtFuXM2CaYjzQxSb46AiYF
         7wLegwb/FUQHFeDMmrczGtyQtuL0BI4RufLG6dosBhd3NMnNGLxf03Gy1motxZKSs1Ag
         L+a+nG8LiAeYnoh+50aurtaubVGo53lxQhULlxQ2kmm9zrqsBdBWD9tDjFHgJe1ISx8B
         gjaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WhaJJ8eoOLYXc/7WgoEtcKV9TdCM7BV5ydK19zk2ja8=;
        fh=Sd1Tc/kcVApEDyK40f0rrLOZdUMrwjHeK1v59xStr0c=;
        b=A68AH+NjAXD6A8tHIb7BHKZF+itEGjOzuOUBvfGXOxF8rtDdbkhE7hfdT/NnzpNV3e
         Q3wQ1wGbrtSz4hLvtHH7m/qq3Mbha03Xqk0LEvawZAM3z80dEcOYOpAKzeNLdcgKKOgz
         hH6Prnesk9/tA5qfVZxFHUP408vbnh2UlTygXBa0fIw8zJ5WWp659KcxSzHHuO2BGEl4
         7yWzjvLjumKuLkEqBElLkfrPDp5OBPalr/ffaC12ZDVxdjuJr/TVWmhC0ahJXVXIeU1v
         TMyFT4QBRjQMFgOsq55n6sI4w1TJ2+2P02YJAV9fXJAL8hqkru+NTeDv0DO+/LhHfvNL
         qrrg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775856055; x=1776460855; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WhaJJ8eoOLYXc/7WgoEtcKV9TdCM7BV5ydK19zk2ja8=;
        b=VlH7qGfwQy8TbMMQqixENzS51cByxcoHE3j64OjuNhTpyKEmvMmrVY1I4c5V+3LKxY
         ksH8NjXdT/iBocKRXlm8yGARasAzg4N9IiMLSHaKGmpb0ulVIUOEknr8svA6iNAvEVyX
         GukLsHwsma7zv5ZUB91KLsMWmIG3UxmH1Nw5elyncxcf3o1cdo+/0Mhb5ynFGS6guT5B
         Q8ddHi6PsmdSjcl9/piZXJXEfvpV8SFQVgF/SwNeX+28xiUQKt5niTBRkPmoWv5MWPzM
         giM8hydgMgiXWmpP52gxqjsVHBQhScB/aVfQfs/A91hUt+yKiDodQ4XDeL9+HnMde9Q3
         D3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775856055; x=1776460855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WhaJJ8eoOLYXc/7WgoEtcKV9TdCM7BV5ydK19zk2ja8=;
        b=XHts9GTBdBOoEtkFyHMExt7NM28qqRIeTetPutw38oOH46NCxWAjriLQL0ZrXtJkOF
         HnVxtcj6ohW6Kuh4yBg2jWoQQdh82zYmaHkJ0cdrKYp/kyQjP8XCcThZkP2JwXQcZYdY
         CjEvnaxbCxRUAI85h6wF/H6aetPvOVJ4hNkLiRNj4fx7Trflut9lRSFMpWndIdL++TiF
         GxrRRbss2AlWD50qN/WEUWUMWXNj8nzbgq5dvifH0Kg6NEAD1vfKc/p3C4ET9byc5uVW
         e2YJq/nVG0jPQP+qr5CjQ9cD7uCeaCJK8cnLnvDUJGlM2GaJ96zlLQnGtQVX1lJboBwB
         i/lg==
X-Forwarded-Encrypted: i=1; AJvYcCWDwdfR9EnRy1hYw3ulXJ6BAwc70zuYg3Uu0Xro4rvtvA5qvQ4W9kAS3t6VZy572+L8Z5So5uCu@lists.linux.dev
X-Gm-Message-State: AOJu0YyHZaMWO/rbtcjVpavB9FCvUrQMOkzKOIkSF/npK5VzM1rnSBZv
	zNt7CABDMcLzemO8RyAyxJQ6Q0AnQ0lpZnj1fkRBfBody8qTjvVb2IUb5sV+4hdIAWP5l5krwn5
	Ovcd5pJ3E6iO7IjbOYwPLwGVTt9MzxCk=
X-Gm-Gg: AeBDieu7V6yvpbGFd2YxNssDMdP6b2gktEYefv8H5Bz1Kv8HfnB7l+XhQcjXjyRJIPX
	FmeXC7lwQR3ic5XyAyKKenxy6MOEUlIJ9+zUfnZn7lGbFNLBCrR4cMcB/suodd/CsWF1ZZWDVV9
	v/T6KjlyGAxD2Y/DQ5YnK+OLoF66tzHaLNxhYnpOZJ65ZlwE90dEwFD+zxg8D7CiKILdmhRyrcY
	ndH4M8yQYZYHy+KqJE+i9zcZ1E8DboG98AOYBnTqjetY62nBV/iI6swRK9GJ5wBa6G92OiMjUi1
	4ct+WCnlvpY/9YxJ9bpK5uARGoTIDSg+C/RKJySAoQy9Gd/y+HjAwTGoiW65WDKAnDWosO+T3Tz
	zNt2C6Q==
X-Received: by 2002:a17:907:c908:b0:b9d:3b68:954c with SMTP id
 a640c23a62f3a-b9d727aa0cbmr220907566b.24.1775856054482; Fri, 10 Apr 2026
 14:20:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408175927.064985309@linuxfoundation.org> <20260408175935.705507105@linuxfoundation.org>
 <eee63d31-f7a2-4737-b33b-cfea7f04e960@oracle.com>
In-Reply-To: <eee63d31-f7a2-4737-b33b-cfea7f04e960@oracle.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 10 Apr 2026 14:20:42 -0700
X-Gm-Features: AQROBzDc2Nu5LoD9cVK_3hSpGRPzX5o7HU6msz-Juo7W2QvQF2OvoWhA9GmtpqY
Message-ID: <CAKxU2N-WvGmbG=Zge=C1F6a+pR3kNW6J7uExUGTOxudBDT8YqQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 230/242] drm/amd/display: Reject modes with too high
 pixel clock on DCE6-10
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, Vegard Nossum <vegard.nossum@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 12:08=E2=80=AFPM Harshit Mogalapalli
<harshit.m.mogalapalli@oracle.com> wrote:
>
> Hi,
>
> On 08/04/26 23:34, Greg Kroah-Hartman wrote:
> >   #include "resource.h"
> > +#include "clk_mgr.h"
> >   #include "include/irq_service_interface.h"
> >   #include "virtual/virtual_stream_encoder.h"
> >   #include "dce110/dce110_resource.h"
> > @@ -843,10 +844,17 @@ static bool dce100_validate_bandwidth(
> >   {
> >       int i;
> >       bool at_least_one_pipe =3D false;
> > +     struct dc_stream_state *stream =3D NULL;
> > +     const uint32_t max_pix_clk_khz =3D max(dc->clk_mgr->clks.max_supp=
orted_dispclk_khz, 400000);
> >
> >       for (i =3D 0; i < dc->res_pool->pipe_count; i++) {
> > -             if (context->res_ctx.pipe_ctx[i].stream)
> > +             stream =3D context->res_ctx.pipe_ctx[i].stream;
> > +             if (stream) {
> >                       at_least_one_pipe =3D true;
> > +
> > +                     if (stream->timing.pix_clk_100hz >=3D max_pix_clk=
_khz * 10)
> > +                             return DC_FAIL_BANDWIDTH_VALIDATE;
> > +             }
> >       }
>
> This is a backport of commit: 118800b0797a ("drm/amd/display: Reject
> modes with too high pixel clock on DCE6-10").
>
> The backport adds return DC_FAIL_BANDWIDTH_VALIDATE, in
> validate_bandwidth functions that return bool;
>
> drivers/gpu/drm/amd/display/dc/inc/core_status.h:
> DC_FAIL_BANDWIDTH_VALIDATE =3D 13, /* BW and Watermark validation */
>
> In this branch DC_FAIL_BANDWIDTH_VALIDATE is integer 13, which converts
> to true, so the reject path is inverted into success.
>
> So I think we need to fix this. Thoughts ?
Best to drop.
>
> Maybe we need to revert this or backport commit: 4465dd0e41e8
> ("drm/amd/display: Refactor SubVP cursor limiting logic") to stable branc=
h.
>
>
> Thanks,
> Harshit
>
>
> >
> >       if (at_least_one_pipe) {
> > --- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
> > +++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
> > @@ -32,6 +32,7 @@
> >   #include "stream_encoder.h"
> >
> >   #include "resource.h"
> > +#include "clk_mgr.h"
> >   #include "include/irq_service_interface.h"
> >   #include "irq/dce80/irq_service_dce80.h"
> >   #include "dce110/dce110_timing_generator.h"
> > @@ -876,10 +877,17 @@ static bool dce80_validate_bandwidth(
> >   {
> >       int i;
> >       bool at_least_one_pipe =3D false;
> > +     struct dc_stream_state *stream =3D NULL;
> > +     const uint32_t max_pix_clk_khz =3D max(dc->clk_mgr->clks.max_supp=
orted_dispclk_khz, 400000);
> >
> >       for (i =3D 0; i < dc->res_pool->pipe_count; i++) {
> > -             if (context->res_ctx.pipe_ctx[i].stream)
> > +             stream =3D context->res_ctx.pipe_ctx[i].stream;
> > +             if (stream) {
> >                       at_least_one_pipe =3D true;
> > +
> > +                     if (stream->timing.pix_clk_100hz >=3D max_pix_clk=
_khz * 10)
> > +                             return DC_FAIL_BANDWIDTH_VALIDATE;
> > +             }
> >       }
> >
> >       if (at_least_one_pipe) {
>
