Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F027C
	for <patches@lists.linux.dev>; Mon, 28 Mar 2022 15:09:37 +0000 (UTC)
Received: by mail-oi1-f177.google.com with SMTP id 12so15873456oix.12
        for <patches@lists.linux.dev>; Mon, 28 Mar 2022 08:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hR1jRa2phyLv14hWOxaM9+j9CCvuPKpyIhWccqDJKiU=;
        b=q1gM3zTfmWHCf8RU3HwJ+H7QV2DOiLw1oZW8RtIgSzfBccBwuCoDKBY7C7NT6lfK2D
         rqokHdDdmod7qFO37x1EXvmQjBwhfOcvlfZd1pscXE7tzOBmgW5htBMVaGGaHJCxIeeC
         1CBkoqNPJChehR1D3sC156ACkHB1/fnVlgTZb0LGlJyAvY1aGUJDbYFtGzRa/Qdz/wNB
         RiThumDOlZVctTz9UQwkWw/6Pv2sAbTbVk/4vG9ZeL1Xqx++EAlDP2BmHNnNemH3C9QK
         1o6cDTpzG8xvoNJx15+jEpUtPtzy7IJpJVfguwKrR20wYhJ06ZC5QPYMtgijyjbtVhVv
         MrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hR1jRa2phyLv14hWOxaM9+j9CCvuPKpyIhWccqDJKiU=;
        b=BPmB+9PRrvZYPRMdsCsnTf+tfbnwciPKWAH4/j/g+5NgdnprSNxrNJnY/TlGPzjZh4
         G4G3AMdiSZLQ9ldmBVPWr9YXT3rdTavu3rjmYVuZjBDoVIQKlO7cf4QUldOrvO9ex/Lw
         wMGkmRB0/oER0tP0ehlgEP+h5sMoZZeaLrSFUXhnMrTWO29LX+mgxkP4HyWrqZe8LVco
         rxAbEeR2Ag108SusVfGdCXGct10lXCiLvn7qmupHn4kSzHZACn5KRzhSpyymWMS3sNmr
         s9HZQ50D2zP5B0ehWYJXcgQ2Q2FzS8PHej0/m4YSMms9XpNCHh3754D2Au3y0YBQJ/Wp
         RTIw==
X-Gm-Message-State: AOAM530euW/GwQMEj87jB4tpWpACLtYchssreODSut4OmLgVHVyBtQVi
	TqRRlxS96WtrKoLlu4em3c3eYZQzlRxkjS2YKBQ=
X-Google-Smtp-Source: ABdhPJxXs81P8Av3G60zCVlTmece1KGzOmPai54eYxv81AImIsCyKHUBwW5lMB+xR1oBt7wsD0hEkM4fezshtDOT7GI=
X-Received: by 2002:a05:6808:df1:b0:2ec:b193:ad6c with SMTP id
 g49-20020a0568080df100b002ecb193ad6cmr15958905oic.200.1648480174953; Mon, 28
 Mar 2022 08:09:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220326233726.14712-1-rdunlap@infradead.org>
In-Reply-To: <20220326233726.14712-1-rdunlap@infradead.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 28 Mar 2022 11:09:23 -0400
Message-ID: <CADnq5_Oed23CBfdsnOaacSZem=Kk8okJa06YHJHUkmTMp13ufw@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: DCN3.1: don't mark as kernel-doc
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Maling list - DRI developers <dri-devel@lists.freedesktop.org>, "Pan, Xinhui" <Xinhui.Pan@amd.com>, 
	Leo Li <sunpeng.li@amd.com>, Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, patches@lists.linux.dev, 
	amd-gfx list <amd-gfx@lists.freedesktop.org>, 
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

Alex

On Sat, Mar 26, 2022 at 7:37 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> There is no need for this one static function to be marked as
> kernel-doc notation.
>
> Avoid this doc build warning:
>
> warning: This comment starts with '/**', but isn't a kernel-doc comment. =
Refer Documentation/doc-guide/kernel-doc.rst
>  * Enable CRTC
>
> Fixes: 110d3968fe95 ("drm/amd/display: Add DCN3.1 OPTC")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
> Cc: amd-gfx@lists.freedesktop.org
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Leo Li <sunpeng.li@amd.com>
> Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
> ---
>  drivers/gpu/drm/amd/display/dc/dcn31/dcn31_optc.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- linux-next-20220325.orig/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_o=
ptc.c
> +++ linux-next-20220325/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_optc.c
> @@ -91,8 +91,7 @@ static void optc31_set_odm_combine(struc
>         optc1->opp_count =3D opp_cnt;
>  }
>
> -/**
> - * Enable CRTC
> +/*
>   * Enable CRTC - call ASIC Control Object to enable Timing generator.
>   */
>  static bool optc31_enable_crtc(struct timing_generator *optc)
