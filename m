Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6CF7E
	for <patches@lists.linux.dev>; Fri, 11 Feb 2022 20:23:47 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id w11so17094365wra.4
        for <patches@lists.linux.dev>; Fri, 11 Feb 2022 12:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8izYpAp0ve1Um+PioYMF8NHyi8GfcoeiooycSXLzNlQ=;
        b=I/a5ILnFm19npYvV0MgKSrdQNRMdeM7AsECxiPFtJmArjKyJMMXwRX3yXD6yV/FEMe
         GbttCWd1S2BKgZ3Cot3Bf1rB3bhkyRAairl9L+kUP+36lUVnVA9VAe9JLK8eXr4xMA+d
         cjySH0rYpqG/UCldQPwqHDY0tob8VdzyzaOYD0X5zHeN/FkHpMahugnUadLchbNNXcjQ
         O+NngfZ5EDoFnnSqrr8TYNLgqVX9SqGCqaemmrRcf5JPmoa3AflDohnSoTGV6FPQHhEH
         AqiBvV5iALcj9R8GJ/NzIxU0c0oTImpsdCoaT2uL6T/qTxu7XHBvWZ/hZiu2ZKpcoDFR
         RKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8izYpAp0ve1Um+PioYMF8NHyi8GfcoeiooycSXLzNlQ=;
        b=iUk5at8iZcOgF7lL1Gr2p8RMll35yxk+q7mYF/vIL5BWpIvNl+RytxfUl5tuJ+5ceF
         sqAqs26WmkqNVnCy9ikXPV9tsx0Gl4NyEV1xIymuk2bAZAbJqhMpzYVHlR+k/GwR0Qz1
         4OCG9WzJ1dHUJJRlNIsPotbg2OfUznm/Uvd2877xxairI9uLCOu8j1m+o11Zoy+2XdrH
         ijUwrdw8crJlrz5M+xI2lCl0GyoB8B4A8WhbBso2PfYDutSxJoWT5Nv6o0WpeXwA9Su3
         pxtrNhrwGIEaGLZ+AKcbn6zqhThwPErD/sr86avcsFqGkImNB/FhrWufOx3f48EUg0f2
         Vn7A==
X-Gm-Message-State: AOAM531w0Lckdm3q1oFYhD10IvDcpraSfMhqUjY23d8mye4mEZ/9f8jW
	3Zm3BNspCgc3xmBrKngSw//Qf7jrykYOpm0gK4imLw==
X-Google-Smtp-Source: ABdhPJx66KThSmTSEZR8qZK1Jjh71AOqaHCEfACAY2nq31QRfSld2Jm3y2Y9sAr+4rAIRTfMAFl1q7RC0n5rTroRhNc=
X-Received: by 2002:adf:f18f:: with SMTP id h15mr2667871wro.513.1644611025895;
 Fri, 11 Feb 2022 12:23:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com> <CAPcxDJ7iHshyZdCp9ngrfFV4j2=HTvXF5naN+E+D_AvcH8n4wg@mail.gmail.com>
 <YgbEeFKdtrY+9d/x@zn.tnic>
In-Reply-To: <YgbEeFKdtrY+9d/x@zn.tnic>
From: Jue Wang <juew@google.com>
Date: Fri, 11 Feb 2022 12:23:34 -0800
Message-ID: <CAPcxDJ4Lo7EdEc-Hq3nWJtoee5AfJuVQtgCtQOUFaKbmeNP+sA@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine checks
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

My apologies, I will wait. :-)


Thanks,
-Jue

On Fri, Feb 11, 2022 at 12:18 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Feb 11, 2022 at 12:08:46PM -0800, Jue Wang wrote:
> > Tony and Borislav,
> >
> > Gently ping?
>
> From: Documentation/process/submitting-patches.rst
>
> Don't get discouraged - or impatient
> ------------------------------------
>
> After you have submitted your change, be patient and wait.  Reviewers are
> busy people and may not get to your patch right away.
>
> Once upon a time, patches used to disappear into the void without comment,
> but the development process works more smoothly than that now.  You should
> receive comments within a week or so; if that does not happen, make sure
> that you have sent your patches to the right place.  Wait for a minimum of
> one week before resubmitting or pinging reviewers - possibly longer during
> busy times like merge windows.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
