Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511A01F61C
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 17:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739986067; cv=none; b=Mbm/2a0Ap9bHa7Bdn8CqxvbRHB9dM6iEVmMu7t85wf84ATTdycky5q8083U7oQAm/J00ANVWmcap5J/oC7Jb4IGhL4vByGQGYKgMeQxIP2mBUZzxwfZF5JqJBVGmHfaUC2IMZQGpcbxpJUIdxcUivNtCjJe7tp0y2fwCMXWBvBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739986067; c=relaxed/simple;
	bh=F7/KNztpiz9Tz7FrAFHcJZgfmbJ30wYqJ2aY4YVpE8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZD5ciqthLDZ98bg+QkSNPTibDctqIHIh6aTQj3kyS//FJ11FmTOP0ILIbkunHyJb8cX1/6g9e7KZaNAYlTwApSj5tJiyJ1p0JfsWHWuevBdsb0TjoJYyjQFal/s/5eFpCj0K3E3RGnLWGQjVAZKn0JYLqvYnlvzZzNB7quJbODM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=criticallink.com; spf=pass smtp.mailfrom=criticallink.com; dkim=pass (2048-bit key) header.d=criticallink.com header.i=@criticallink.com header.b=iOCIlUNx; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=criticallink.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=criticallink.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=criticallink.com header.i=@criticallink.com header.b="iOCIlUNx"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54626a71b40so70434e87.3
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 09:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=criticallink.com; s=google; t=1739986063; x=1740590863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lN7htDFfdWYBEBovB41RfScVEwCh90leE1Ry19y0hzg=;
        b=iOCIlUNxP0uW4kEOqkDVOUpmMB14mtYbZfY//D8VAeSbgNfk+AmVoX1PvcCPr05cLV
         iySuE8aT5Kaup37tWMRjhZ67YW3/nfBQZ+/CUKFMXjQOOtw7RTVI4yxa8zT7ako4Fu1W
         nwvg7LTqvL/OPQzfhCAq6cqecl5px0Xji1bZt26GifE6iKgg+UKzMZGdZv0lrCzaxAoV
         8aeZWFXylZy5b9ZkPgOE9PEshucRef9MbzP74Q+fi5O7CJO4HGDzPUTftR3ocIGWZcLm
         uzSAm3bamDljEvlNmrIyZjeKwjx1BmbrZt1wpGVr8R1il5ZQymjStU2lI4wqvCwFvmfA
         PKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739986063; x=1740590863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lN7htDFfdWYBEBovB41RfScVEwCh90leE1Ry19y0hzg=;
        b=nZ03CP/aDQ2YVf9WdSb70HWOM2/ZAYDHXVQ3fci4CA4COf4NsaIu+5FTJ1jA6h0CFI
         gz/90hTs2RlnZp685zag/Q1N+jXyoC8R11H/NLSzHjgaD6cRQTiJZJtxJe3nrcrO9fqJ
         loTeYpx7nzRXhvgpA0nXSoJQRUfTGuByvRLwqRWDaFYHRdwA9efVdYpLm4y5b80U+DTh
         jlxsBXSBt5je3WO2VgtgYSPxmnXSLYuArlRo0PRqgi/isqxW8jV+cfddSXXl5jgLISGe
         HxWxB9hsteBIlq+IOjg7QIVEjjAf/Q0ZnAg9NtOb6fQ9u2RnUyOIimTdWeckgjm/k4Ma
         af6w==
X-Forwarded-Encrypted: i=1; AJvYcCUXfLJo9df1OGNnwx1hK6PaldxlXUMN0YQ1+BapaS3PyYArLn//dDEov3/nPZgq5hoLz04IbXBB@lists.linux.dev
X-Gm-Message-State: AOJu0YzqKfHYXV8wav5Oe6x1iLhwcFNWwk4rOtILolP+RR82UrrWpoWP
	V/Mq3iG4g0LZlqIL8dNxxcR68kGEfrrY5m8yhCZXUb86qAiJWpJQSmvPGShZ+iyJ6ESW0CA5Qu0
	1frkPmAL/zXrjrY9lkrAshINqYiz4UHUBaMOlJB6JZ9pMHHUg0w==
X-Gm-Gg: ASbGncvibNu6Qohvfz/4cMTzFyStQJ7VFmjTPQpOZ+merwf7y1Ihl6GHgKhDipCxTTv
	jEChL+o+sIe8gbxeiRsi4svE6eUUXJlOT8+fg+SEU7bQs8HwNivnJ9jnc21NercZtb0SFjZo=
X-Google-Smtp-Source: AGHT+IG1mbpg1DUJZPHFFLGCFOHgr+0I1tYczB2jZkUcybESu9VB0EQyeQ6O2FbwMenyBXndXIi7ei09FKVuelV3+hE=
X-Received: by 2002:a05:6512:308f:b0:546:3052:41f3 with SMTP id
 2adb3069b0e04-546305242f4mr1849695e87.3.1739986063447; Wed, 19 Feb 2025
 09:27:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250219082652.891560343@linuxfoundation.org> <20250219082714.827798335@linuxfoundation.org>
In-Reply-To: <20250219082714.827798335@linuxfoundation.org>
From: Jon Cormier <jcormier@criticallink.com>
Date: Wed, 19 Feb 2025 12:27:31 -0500
X-Gm-Features: AWEUYZnAcpsPmpoLeipbzFcfh4YnbuLCBX35WtDaimque7oJeRUKfINrBSQ0cGo
Message-ID: <CADL8D3Y-xe8hO30mV4obU68rK1G2FeOr_nS6VsmP349HJWMphA@mail.gmail.com>
Subject: Re: [PATCH 6.1 556/578] drm/tidss: Fix issue in irq handling causing
 irq-flood issue
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Bin Liu <b-liu@ti.com>, 
	Devarsh Thakkar <devarsht@ti.com>, Aradhya Bhatia <aradhya.bhatia@linux.dev>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2025 at 4:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.

Looks good to me
>
>
> ------------------
>
> From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
>
> commit 44b6730ab53ef04944fbaf6da0e77397531517b7 upstream.
>
> It has been observed that sometimes DSS will trigger an interrupt and
> the top level interrupt (DISPC_IRQSTATUS) is not zero, but the VP and
> VID level interrupt-statuses are zero.
>
> As the top level irqstatus is supposed to tell whether we have VP/VID
> interrupts, the thinking of the driver authors was that this particular
> case could never happen. Thus the driver only clears the DISPC_IRQSTATUS
> bits which has corresponding interrupts in VP/VID status. So when this
> issue happens, the driver will not clear DISPC_IRQSTATUS, and we get an
> interrupt flood.
>
> It is unclear why the issue happens. It could be a race issue in the
> driver, but no such race has been found. It could also be an issue with
> the HW. However a similar case can be easily triggered by manually
> writing to DISPC_IRQSTATUS_RAW. This will forcibly set a bit in the
> DISPC_IRQSTATUS and trigger an interrupt, and as the driver never clears
> the bit, we get an interrupt flood.
>
> To fix the issue, always clear DISPC_IRQSTATUS. The concern with this
> solution is that if the top level irqstatus is the one that triggers the
> interrupt, always clearing DISPC_IRQSTATUS might leave some interrupts
> unhandled if VP/VID interrupt statuses have bits set. However, testing
> shows that if any of the irqstatuses is set (i.e. even if
> DISPC_IRQSTATUS =3D=3D 0, but a VID irqstatus has a bit set), we will get=
 an
> interrupt.
>
> Co-developed-by: Bin Liu <b-liu@ti.com>
> Signed-off-by: Bin Liu <b-liu@ti.com>
> Co-developed-by: Devarsh Thakkar <devarsht@ti.com>
> Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
> Co-developed-by: Jonathan Cormier <jcormier@criticallink.com>
> Signed-off-by: Jonathan Cormier <jcormier@criticallink.com>
> Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Disp=
lay SubSystem")
> Cc: stable@vger.kernel.org
> Tested-by: Jonathan Cormier <jcormier@criticallink.com>
> Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20241021-tidss-irq-fi=
x-v1-1-82ddaec94e4a@ideasonboard.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/tidss/tidss_dispc.c |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> --- a/drivers/gpu/drm/tidss/tidss_dispc.c
> +++ b/drivers/gpu/drm/tidss/tidss_dispc.c
> @@ -679,24 +679,20 @@ static
>  void dispc_k3_clear_irqstatus(struct dispc_device *dispc, dispc_irq_t cl=
earmask)
>  {
>         unsigned int i;
> -       u32 top_clear =3D 0;
>
>         for (i =3D 0; i < dispc->feat->num_vps; ++i) {
> -               if (clearmask & DSS_IRQ_VP_MASK(i)) {
> +               if (clearmask & DSS_IRQ_VP_MASK(i))
>                         dispc_k3_vp_write_irqstatus(dispc, i, clearmask);
> -                       top_clear |=3D BIT(i);
> -               }
>         }
>         for (i =3D 0; i < dispc->feat->num_planes; ++i) {
> -               if (clearmask & DSS_IRQ_PLANE_MASK(i)) {
> +               if (clearmask & DSS_IRQ_PLANE_MASK(i))
>                         dispc_k3_vid_write_irqstatus(dispc, i, clearmask)=
;
> -                       top_clear |=3D BIT(4 + i);
> -               }
>         }
>         if (dispc->feat->subrev =3D=3D DISPC_K2G)
>                 return;
>
> -       dispc_write(dispc, DISPC_IRQSTATUS, top_clear);
> +       /* always clear the top level irqstatus */
> +       dispc_write(dispc, DISPC_IRQSTATUS, dispc_read(dispc, DISPC_IRQST=
ATUS));
>
>         /* Flush posted writes */
>         dispc_read(dispc, DISPC_IRQSTATUS);
>
>


--=20
Jonathan Cormier
Senior Software Engineer

Voice:  315.425.4045 x222

http://www.CriticalLink.com
6712 Brooklawn Parkway, Syracuse, NY 13211
