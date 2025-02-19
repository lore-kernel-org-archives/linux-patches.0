Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D491F61C
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739986006; cv=none; b=mEwNvKiOaEJBe+5pMfHeEBG6PCZ/CB13PDL7cCJAv/heqidYPNg4cIJuUsUexV0SWMqjFqVAhHU8EvA2y+5MZUL4PErJOH0cQFH9LQ3aYRhq2sBHgfKWEgKC+oOXM/gQOlPI2eXl4Z5bUZARLDdaNisEua4AHxN/BbiebpDn+fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739986006; c=relaxed/simple;
	bh=1XiBNuJTzHPL/MRXYAuMZnQavCaHYjRJito6i20Mj+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gUA/JTfk3OfCYc0i5w2rD6QcfaYfBpnt2Dh+SL7KrrWqXlqBRhPOvIXC4MbQyBDw0IN8kFwW44NS2Wz/LwGQRq+3jofMm2AQ6t1JjhQfPIgD/Pr2tIj6EToG8wvb8PuzukkzcoJGv8uEuEj6iCPT7ejPRFoCpITb+QQwoYXxKYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=criticallink.com; spf=pass smtp.mailfrom=criticallink.com; dkim=pass (2048-bit key) header.d=criticallink.com header.i=@criticallink.com header.b=ATBp6aQW; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=criticallink.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=criticallink.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=criticallink.com header.i=@criticallink.com header.b="ATBp6aQW"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5462ea9691cso77647e87.2
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 09:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=criticallink.com; s=google; t=1739986001; x=1740590801; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kezi20k2gpXEVyhfLjkzYhktG7Nl+uo5vkpb6jywdqw=;
        b=ATBp6aQWspvEx+nGTXyv/TQrDxURX4nm4vyWGVCCUtX3fMU16117eEe7c67ocnf5lk
         Vfngz0iCC5QxplqRRsNs9j5e/5SUOpBeGLKbwpb0nmMmLDUW1PF4imP4Sq0Ht1kTsBEf
         hC8wdCo3426Pz1Jj+1BYZqkITHQTjCbC90KLi0E/07GKFcaAN5KRr+wj9yt1luiv1pLw
         o9Lz6EBGUfmj5jlCS91Y4pNP8c6gligEitVW1EXsmuGTIpGTPYq2BJaC40ORkuL72ks4
         GYLBAwfmMKMxMzAZBqfzeFVwcu0VJ3Tdhs1op0rSVigkGVZXaDUKn7nZLJtwzC/NGvN0
         qKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739986001; x=1740590801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kezi20k2gpXEVyhfLjkzYhktG7Nl+uo5vkpb6jywdqw=;
        b=c7u+62dpArH+JmCW8snKJ2ciR6NG5IkTY6vnQgpTS58JfaMES+D0wp9caIU9HIz64P
         STAKQrdf8v42Qu/LF79Zcd79cKid8ZOVZmPmjSSlNnF83PP1gGW2gK6thq4Yf+b5hwr5
         gw5UOGPm6mlawMJcGJk9g292TAixqs90gCHJJCWLi4BCSj2ez4FKkvwXrEhURLtJinUG
         BwFmKrh615Nu4TyTebeqMw4UA8DjM8ZOdSQWdn6G4ssy35Nqt412vzEvSCF/lF4JVEmL
         wlJl0cOML+S6vXK4sip/wafGTeMqbQgf5kbo7wNqb8PGi9E8OeD9W7vhfGmrBf9W0MxM
         SMeQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1dp10HcXsy0dmsoMuJPIJHCo06i/K/MfzsHcl8omJehVdbGQUO/xKvLCdCpz87excUSqzKZEx@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3COFnRUfeuugX9aJnw5EG6xB6o4eM1RgJuijs3W84F3Cdl6ol
	dPZDVFXxBnrxfP/V8p35/hU95LwhENlHG3QpnVn2ugDa73GvpaFzs/wnJwwJjlwJKZpzE7dvyr/
	NsxwIRReE+juLwlMrdC6R7fGhRCJE8ySaAOWazxTkiuuXYvEqBA==
X-Gm-Gg: ASbGncstL5Lqgd4RhgfLHVPMJRgTWUOhEUUq33xqWFFX41OBsTnnP2nQ6PT8Sew3wSj
	4r+/LFd/Epm6DiOzlRb4UsXPr81DOeWnQ7O254DCsg5uO8on1PX5kPNIU0MuhrW6gBXAmuzY=
X-Google-Smtp-Source: AGHT+IFSn1WjrEpk0+T0pG/tczzy4/xOeK+S+Yz0+rQBtSGOk4g/QyXsCji20gb3M6++A2ENSqW+LMiS6KW5PJWbtM0=
X-Received: by 2002:a05:6512:1296:b0:545:95b:a335 with SMTP id
 2adb3069b0e04-5462eedef16mr1624005e87.14.1739986000801; Wed, 19 Feb 2025
 09:26:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250219082652.891560343@linuxfoundation.org> <20250219082714.866086296@linuxfoundation.org>
In-Reply-To: <20250219082714.866086296@linuxfoundation.org>
From: Jon Cormier <jcormier@criticallink.com>
Date: Wed, 19 Feb 2025 12:26:29 -0500
X-Gm-Features: AWEUYZlxoR0yiPgplmwY2NmGsiO5VeidWdgZtI_l2ShA1DApazlZW5h2Y-FNGG8
Message-ID: <CADL8D3Yf-pQY7nPXK4n7re=BaNNZWPJdY37CkrDi4kfQFfPMqQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 557/578] drm/tidss: Clear the interrupt status for
 interrupts being disabled
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Devarsh Thakkar <devarsht@ti.com>, Aradhya Bhatia <aradhya.bhatia@linux.dev>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2025 at 4:33=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
Looks good to me
>
> ------------------
>
> From: Devarsh Thakkar <devarsht@ti.com>
>
> commit 361a2ebb5cad211732ec3c5d962de49b21895590 upstream.
>
> The driver does not touch the irqstatus register when it is disabling
> interrupts.  This might cause an interrupt to trigger for an interrupt
> that was just disabled.
>
> To fix the issue, clear the irqstatus registers right after disabling
> the interrupts.
>
> Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Disp=
lay SubSystem")
> Cc: stable@vger.kernel.org
> Reported-by: Jonathan Cormier <jcormier@criticallink.com>
> Closes: https://e2e.ti.com/support/processors-group/processors/f/processo=
rs-forum/1394222/am625-issue-about-tidss-rcu_preempt-self-detected-stall-on=
-cpu/5424479#5424479
> Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
> [Tomi: mostly rewrote the patch]
> Reviewed-by: Jonathan Cormier <jcormier@criticallink.com>
> Tested-by: Jonathan Cormier <jcormier@criticallink.com>
> Reviewed-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20241021-tidss-irq-fi=
x-v1-5-82ddaec94e4a@ideasonboard.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/tidss/tidss_dispc.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> --- a/drivers/gpu/drm/tidss/tidss_dispc.c
> +++ b/drivers/gpu/drm/tidss/tidss_dispc.c
> @@ -599,7 +599,7 @@ void dispc_k2g_set_irqenable(struct disp
>  {
>         dispc_irq_t old_mask =3D dispc_k2g_read_irqenable(dispc);
>
> -       /* clear the irqstatus for newly enabled irqs */
> +       /* clear the irqstatus for irqs that will be enabled */
>         dispc_k2g_clear_irqstatus(dispc, (mask ^ old_mask) & mask);
>
>         dispc_k2g_vp_set_irqenable(dispc, 0, mask);
> @@ -607,6 +607,9 @@ void dispc_k2g_set_irqenable(struct disp
>
>         dispc_write(dispc, DISPC_IRQENABLE_SET, (1 << 0) | (1 << 7));
>
> +       /* clear the irqstatus for irqs that were disabled */
> +       dispc_k2g_clear_irqstatus(dispc, (mask ^ old_mask) & old_mask);
> +
>         /* flush posted write */
>         dispc_k2g_read_irqenable(dispc);
>  }
> @@ -738,7 +741,7 @@ static void dispc_k3_set_irqenable(struc
>
>         old_mask =3D dispc_k3_read_irqenable(dispc);
>
> -       /* clear the irqstatus for newly enabled irqs */
> +       /* clear the irqstatus for irqs that will be enabled */
>         dispc_k3_clear_irqstatus(dispc, (old_mask ^ mask) & mask);
>
>         for (i =3D 0; i < dispc->feat->num_vps; ++i) {
> @@ -763,6 +766,9 @@ static void dispc_k3_set_irqenable(struc
>         if (main_disable)
>                 dispc_write(dispc, DISPC_IRQENABLE_CLR, main_disable);
>
> +       /* clear the irqstatus for irqs that were disabled */
> +       dispc_k3_clear_irqstatus(dispc, (old_mask ^ mask) & old_mask);
> +
>         /* Flush posted writes */
>         dispc_read(dispc, DISPC_IRQENABLE_SET);
>  }
>
>


--=20
Jonathan Cormier
Senior Software Engineer

Voice:  315.425.4045 x222

http://www.CriticalLink.com
6712 Brooklawn Parkway, Syracuse, NY 13211
