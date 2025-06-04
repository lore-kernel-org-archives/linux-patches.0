Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA47679F2
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 08:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749027263; cv=none; b=qAAMN7Mwt964hShWvBLQcqK6+cBlKyfaKE7XaYrSAXv2oh8VPRyAVFw/xwtMXEjxdA1cc5gn8twbTGODCPMOFm83FQyTksRDdlL9v0a7gM2jL66gr4QXWzFTJInwEck6o4wu0jFe39XU+ScbdHdb7W5ma24AYAzsUFsuKNvdagI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749027263; c=relaxed/simple;
	bh=g0ppivEkoM1bf4Myn91O2YnyqHNJElL0LhGMOzqDmBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GDaRLwGlbDtHFWA33FsN/jCYe76Hn1qKiX1QKQqAyXt/g3+f78douoMmHb8iwIKlsMSHh0HNxhut9VIRu/8iqk8YHgqRD9sCmhMJ05gclvKykks+F2KyJ+CHz+73crp1Bx6Orl11pmeqjW9O+CrJD0oJjQK6FJUfeVLhTWLOW4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JaGoW6QC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JaGoW6QC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749027260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AvsoGpn4vrP9au9LXRzA3/0BBfANYNVTOadYG+jd6TY=;
	b=JaGoW6QC9bU4UgBE8vXPP4V7vXnfJy+XEWyf1d7JrW6BE8lh/0kHRTtQzwzi5vhs19b/yD
	Tgwn8XocsM3zFzsApXBKmTqSiLw91BxnpCouAHD8ZTrmxZw//3BOl8S2QNNPfNMjVLoZR6
	3H6NM/vlcoMkIzJ15lehYVx/pMoMavs=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-bdaUDtp1MPuaEOIIAQDARQ-1; Wed, 04 Jun 2025 04:54:19 -0400
X-MC-Unique: bdaUDtp1MPuaEOIIAQDARQ-1
X-Mimecast-MFC-AGG-ID: bdaUDtp1MPuaEOIIAQDARQ_1749027259
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e7dabc0305dso8911436276.2
        for <patches@lists.linux.dev>; Wed, 04 Jun 2025 01:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749027259; x=1749632059;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AvsoGpn4vrP9au9LXRzA3/0BBfANYNVTOadYG+jd6TY=;
        b=FUor0p5GYkcj6kCYSFuTkgU97HxCbG51V9zJYiNSgCFtCmYyhYY1pLrNirQs6dHEn+
         kn1F2VhpsP2mrMJ1jBU/CRsqg9anO2BW7WDsAyE7j0rwmD4zwO29MyU8Omk1ovieXOQv
         m9SLFbPWwB7AFBH2Rj5G4amQ9DuxP00O/u1yElfiSX8VWVv4os+dVtZRTTRPqrjQPRtU
         hp2E5ZLd/z5MzazFVIJTTEJga0KM9EXuMiRwa+e2ojfqA8yp9q9a/T4/Ac2oOX1Xln4c
         vsWNCv9RS0ZxWIj1HysRHj4k84vWcd56Z9Vd3C3W7jbMgHJYs1JXDMbZUmzXMCPEaXXg
         4Frw==
X-Forwarded-Encrypted: i=1; AJvYcCUW0vhaF+zFxwTO1wSDXMB7+zyuHcBYssJz0xxK7in/07ZKv5n4irwr6X9qeI9SRW5SggLwnkCn@lists.linux.dev
X-Gm-Message-State: AOJu0YyvsCEloukxP2pUJsi7b4NPry5JUARBFf/3Oh+0NSYOMBzNoFwv
	X2llM6MelufqeZUaIgEFMz06cbRn5lAu6V2Q9E0U9hCDxpf8dd40Wh8Gx8zlJi8AyowBqsnyEag
	cRhffVPfygaoajW2Lz4P5H47MulxAj8fIbFZSTFRB6vlCPXzk0FZ2ZjMCaJczJPkWqTw4p5nhr2
	f4YgkThBysvDpoCHt3tcXdVGRiuj8Leg8kxg==
X-Gm-Gg: ASbGncuL/xjBB9MZ0sYXuUCmlItwBBDw3duXokCD6E6yb9C14ZzwLxJT9e7cEFFwONU
	7CIJ8QpibUQiTZ8W0w0yaU41H49ZfDYFnDQleFEZd3J2+6deqcoODBswuXPlu+Xb+FrCi
X-Received: by 2002:a05:6902:2d06:b0:e7d:d002:da94 with SMTP id 3f1490d57ef6-e8179c0191dmr2531831276.20.1749027258988;
        Wed, 04 Jun 2025 01:54:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2C121V7OjYlteSOkifolsWZy/x2Ol1f4a1SiVTnu+7fvufC/08o+ydl4x6iDTlhXDzxen3FpEn318g2cKE4M=
X-Received: by 2002:a05:6902:2d06:b0:e7d:d002:da94 with SMTP id
 3f1490d57ef6-e8179c0191dmr2531819276.20.1749027258689; Wed, 04 Jun 2025
 01:54:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134340.906731340@linuxfoundation.org> <20250602134341.897528821@linuxfoundation.org>
 <CAGxU2F7fRUn1H_-CF5SJJ1DZDEt3xfm+er0kqa_XS9nn6uJi0g@mail.gmail.com> <2025060443-morse-reentry-9573@gregkh>
In-Reply-To: <2025060443-morse-reentry-9573@gregkh>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 4 Jun 2025 10:54:07 +0200
X-Gm-Features: AX0GCFuyEeJEQ6h8-T5G-nE_57PXCHmHGBprnsW2EwdMbKXOArs7EAI3zPnaWyU
Message-ID: <CAGxU2F60xQoWT3JBHQfGAgjPSJAMwVpynbiLXnbZw72Q2QqJ2Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 024/444] vhost_task: fix vhost_task_create() documentation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	"Michael S. Tsirkin" <mst@redhat.com>, Sasha Levin <sashal@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UxDf66DD5CFEU9j_uaof_ei3LBpjkIZF2WQwUgXH-o4_1749027259
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Jun 2025 at 10:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 03, 2025 at 02:18:12PM +0200, Stefano Garzarella wrote:
> > On Mon, 2 Jun 2025 at 16:04, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > It seems that commit cb380909ae3b ("vhost: return task creation error
> > instead of NULL") is not backported to 6.6, so we can skip this patch.
> > BTW it's just a fix in a comment, so if it's too late, it should not
> > be a big issue.
> >
> > Just for my understanding, next time should I add a Fixes tag in this
> > case, also if the patch doesn't touch code?
>
> Yes, as you did say that in the changelog, which is what triggered this
> backport, but our tools that automatically check for Fixes: tags missed
> it :(

Sorry about that, I'll keep that in mind for next times.

>
> I'll go drop this now, thanks!

Great, thanks!
Stefano

