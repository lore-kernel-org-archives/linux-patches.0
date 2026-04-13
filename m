Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1603CAE76
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 15:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776093947; cv=none; b=ZPctjXkVGapvblMxxC7/jBWi9rSULXu+s2cGFNfjXF0WIRrjRgoTsrEtYCKr11OhZVpBmQ5BK7+GqD26gW6zr4eFQgxxzbtNL1unazsySoZot1B3srgeJ8HYNtZVoAwVcIBZh/HrPuPmRDZF/eOx7TjypyQLe8eAgT/WMlex+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776093947; c=relaxed/simple;
	bh=WlHTlTbf17Tb+GBGL3PvGuMhWynY5k2DWn6NxHGoMVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P6UD/jZAwQFNcb9qE4sEWXcxZtLxbvS6h/i5KY887af3aktdFxgRjl1+vGzSdYUQr86kyAkgxE2i96zZpTMKWBxUrmYYVgLPM/8dCresXsQ2Pf4kIWsDMFDMZhGcS+oZB9qSSkxioNwLOCBoAH+h0QKqREHN+8fZlVHNemw16EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6KKLJ/S; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6KKLJ/S"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso37490245e9.0
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 08:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776093945; x=1776698745; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqN2sV45OjOLBDqUsVl5Nao1bMFA+NRdxtqt3PMt3wg=;
        b=J6KKLJ/SH5IeFtOVLXFaFtd5ytkkla3mM90AwMD4V7X3X5VZorCokEBsCVXWS/chPf
         qqpWODv4Wdu5HIQH3uj0slJ13TrXzrrjhWm6OODaL6s8vz3RJAskG015eSfSzrcH13IQ
         vFnvcc5mQgMksfX8Fi+I6+hwJQyMvPswIrX+ZzdCxWUQ/cWYNbBChtx3WfuB7k24fthr
         1yvlrUBuZUTVrp9Gj0UQfeJ2DyshZvTkpcrACLKpdaGMs419SWmjVKvtEsOLDneHIpfy
         ak7oxEq1UB3PFJw8JAl104xdWK5rdZnf38sf9RIf8xElQRVHvIq2gAR+4PK/Ub9yqWbR
         geGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776093945; x=1776698745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KqN2sV45OjOLBDqUsVl5Nao1bMFA+NRdxtqt3PMt3wg=;
        b=m3N77PXtpRDedayRmMZZcTDhz6MQQ3ac3Lzt6lKpz3TInW0Um6cTbjC9ePne2uj0tn
         2NZho+tKts0NPpGSN4HZ1LG+GeRaLnTZDslxIpxoj37L7TY+PcfDi6GybLhdjbveZ5Q+
         4HPbL0RvracngDQx/nFrc+MEFlJVJXQxdlR075IFWna/EOKFkqIHmUTt1IMSrNrKrwqb
         7J8fCEaOFwfFfQ8GJuFwfJjkGLUMB9gkxjcxs9EwB+UTNW90VK8L0OkMId05o4Ex5wJ/
         VZIyiwQ7nWw5TN0J+j3BXfX7oHA6imTY2pfwJIAjeRzZlI/64YFcnNgqZqE+98gvKvXU
         gKZQ==
X-Forwarded-Encrypted: i=1; AFNElJ99g8HF7+tXiW//vk5MyRoxRn897jC5PSAW4AKMbugItZGifv+gLo2eItb5e5E7cjCe0YYZ0CSS@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9+XcKk/TKrMNqKlJyVkx2USASTpu6duXT/4n6v4URD4MBQR9t
	Mv3zIi4X3XafvY/kmmVrZ2uf/pg4MFHVs3W4mckZC+y7TDrjB1ZS+5kr
X-Gm-Gg: AeBDiesgUsDYdFBe2HLWIkJImc337cNyFv/Ur6VXV+5PvlvYHAyQJmO3ghy1WtadwPi
	2jMlKvM9YG9vZFARD52g8w/79QRmBjq+M2LxvqdNirp4vThsNWvIqln0ao1c5zTMouDQ80HAzcJ
	61TaQkgEutDYHsgBpOdqarc7/O4GS56iXr6jsJZ1f782iKg4g7YSf/Cv9JGvL+KkttjtU0/oQVV
	C8zpSp0whLMSnWgH7+P6so29a1XgMBPD30Y5GNqjuR4+/myACa1Z0yP+D6Y9jjmj+JCpxPNh9zD
	ahI29dWlT8n3ubQ66a4DTISZB0swb+R99EZH4nD0rw3FB/v85iBhLym5we8daIwf7i4FFGzXroM
	jx8c+9RGTQIELHFarv/a7k6doOKNKoehH8wn7TJCShEqc5wM2rRm1nG82TXGqKa/5mkzuhj8Ytu
	rng6gPlr3VyM639drTaI2NoryiYV+sZcz6GqR/o7c2ad/24jtw3Z3cIRGhwqhEOAqre2NYUceTP
	CCE2ShWOI4p4WP0xgn1Ysi8bWtiDg==
X-Received: by 2002:a05:600c:8b6b:b0:488:be21:54b9 with SMTP id 5b1f17b1804b1-488d67ce792mr198565295e9.8.1776093944474;
        Mon, 13 Apr 2026 08:25:44 -0700 (PDT)
Received: from timur-max.localnet (20014C4E24DEE400DF3121E46476B2BD.dsl.pool.telekom.hu. [2001:4c4e:24de:e400:df31:21e4:6476:b2bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d531f1f9sm363581155e9.1.2026.04.13.08.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 08:25:44 -0700 (PDT)
From: Timur =?UTF-8?B?S3Jpc3TDs2Y=?= <timur.kristof@gmail.com>
To: Rosen Penev <rosenp@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 stable@vger.kernel.org, patches@lists.linux.dev,
 Alex Deucher <alexander.deucher@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Vegard Nossum <vegard.nossum@oracle.com>
Subject:
 Re: [PATCH 6.12 230/242] drm/amd/display: Reject modes with too high pixel
 clock on DCE6-10
Date: Mon, 13 Apr 2026 17:25:42 +0200
Message-ID: <20304292.fSG56mABFh@timur-max>
In-Reply-To: <2026041152-slogan-chariot-c87b@gregkh>
References:
 <20260408175927.064985309@linuxfoundation.org>
 <CAKxU2N-WvGmbG=Zge=C1F6a+pR3kNW6J7uExUGTOxudBDT8YqQ@mail.gmail.com>
 <2026041152-slogan-chariot-c87b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On 2026. =C3=A1prilis 11., szombat 11:49:04 k=C3=B6z=C3=A9p-eur=C3=B3pai ny=
=C3=A1ri id=C5=91 Greg Kroah-
Hartman wrote:
> On Fri, Apr 10, 2026 at 02:20:42PM -0700, Rosen Penev wrote:
> > On Fri, Apr 10, 2026 at 12:08=E2=80=AFPM Harshit Mogalapalli
> >=20
> > <harshit.m.mogalapalli@oracle.com> wrote:
> > > Hi,
> > >=20
> > > On 08/04/26 23:34, Greg Kroah-Hartman wrote:
> > > >   #include "resource.h"
> > > >=20
> > > > +#include "clk_mgr.h"
> > > >=20
> > > >   #include "include/irq_service_interface.h"
> > > >   #include "virtual/virtual_stream_encoder.h"
> > > >   #include "dce110/dce110_resource.h"
> > > >=20
> > > > @@ -843,10 +844,17 @@ static bool dce100_validate_bandwidth(
> > > >=20
> > > >   {
> > > >  =20
> > > >       int i;
> > > >       bool at_least_one_pipe =3D false;
> > > >=20
> > > > +     struct dc_stream_state *stream =3D NULL;
> > > > +     const uint32_t max_pix_clk_khz =3D
> > > > max(dc->clk_mgr->clks.max_supported_dispclk_khz, 400000);> > >=20
> > > >       for (i =3D 0; i < dc->res_pool->pipe_count; i++) {
> > > >=20
> > > > -             if (context->res_ctx.pipe_ctx[i].stream)
> > > > +             stream =3D context->res_ctx.pipe_ctx[i].stream;
> > > > +             if (stream) {
> > > >=20
> > > >                       at_least_one_pipe =3D true;
> > > >=20
> > > > +
> > > > +                     if (stream->timing.pix_clk_100hz >=3D
> > > > max_pix_clk_khz * 10) +                             return
> > > > DC_FAIL_BANDWIDTH_VALIDATE;
> > > > +             }
> > > >=20
> > > >       }
> > >=20
> > > This is a backport of commit: 118800b0797a ("drm/amd/display: Reject
> > > modes with too high pixel clock on DCE6-10").
> > >=20
> > > The backport adds return DC_FAIL_BANDWIDTH_VALIDATE, in
> > > validate_bandwidth functions that return bool;
> > >=20
> > > drivers/gpu/drm/amd/display/dc/inc/core_status.h:
> > > DC_FAIL_BANDWIDTH_VALIDATE =3D 13, /* BW and Watermark validation */
> > >=20
> > > In this branch DC_FAIL_BANDWIDTH_VALIDATE is integer 13, which conver=
ts
> > > to true, so the reject path is inverted into success.
> > >=20
> > > So I think we need to fix this. Thoughts ?
> >=20
> > Best to drop.
>=20
> I'll drop this commit now, thanks!
>=20
> greg k-h

Hi All,

If I understand correctly and the function returns bool in the old version,=
=20
then the patch could be adjusted to use:
    return false;
instead of:
   return DC_FAIL_BANDWIDTH_VALIDATE;
then it will work and fix the issue that it was supposed to fix.

Hope this helps,
Timur




