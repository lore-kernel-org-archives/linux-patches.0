Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23770FC0E
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 00:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dk5iDPyT"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-db4364ecd6aso3892594276.2
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 16:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701822819; x=1702427619; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xu9oRa8BSfMv9BLhUnnloC2Q8CY9EL7xXo54kO5COc=;
        b=Dk5iDPyTTcNEDbYNNRuvJtuivzI1jkt0QWnvOP7nMP7qd6C/bOp1j/7QebK6/KZO6x
         86OU0YtqD37hXoZsE2VFLZLOlAKPDC1WNSTgfWJ0h85yobVo1SAC99mMwy82L4xJO0+l
         bvnazmlsPPWg929xkjHuzaRU8QvOTi8yj9sncLnVuM5pATVuiO7miZPoTmX1bhBwYL+f
         HFkXWzYmGFEQbvWUXfr/CwvI8CTfxbATb5Gr6WVNlx+jRh4tfI80OUyKjec9rONuwsjU
         1FKaFY4ANwJVhp7VrhGGrYlC9OMKkYw0R4Dn6cgohulmZ+J90ovexxdZmNVlcztF/s6V
         vZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701822819; x=1702427619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5xu9oRa8BSfMv9BLhUnnloC2Q8CY9EL7xXo54kO5COc=;
        b=xCDBybMnwY6bp3fOf8RjuYIg1Y3rnEeVD3e7cJcslP4azOXB5f2w+c+ZiOkbW1GCvI
         Uv6UOpBD1unK8MSdF1b+Na7eHoukHdb41J5IdaX2GiG7cYo6ZHzU/uO4D9sclFA/jTxT
         U4RDwh2bDtDDaUJ/nAATFZVEv+Kddk+in8jprzn8JwRN60T3n3dtFw6kd0GCXYoVPxrM
         3LeyPMEEUeUFMwn3nkRNYVW/gtGM6R3OK/kfWY+FJQ8EDDZujKTFC9A8p6PB0cEry0qO
         JsK3ul6zJ+fGFEJIxF/pIXF0wZK+9gLns97v1Lva67U7+vrXVMPOBwNTnLK8E+hzm+Hf
         BdOA==
X-Gm-Message-State: AOJu0YxESOMV4eMKgMLUrv3oit9HSpipbzf9HdsaSiC8Ljy8vwxbV1iC
	/iRTwfLCxweJwZlRAzVNlfzbCHcLSISvth/hoNI=
X-Google-Smtp-Source: AGHT+IHonzzibf5ZZHh+7K/UVAPqQEw4hM4dQz6l5XubBlwFnIEoIIT4on/J7koxoWBpFJgXUSsCIh4tsFdmii6I7B8=
X-Received: by 2002:a25:e613:0:b0:db7:dacf:4d6f with SMTP id
 d19-20020a25e613000000b00db7dacf4d6fmr1791ybh.107.1701822818959; Tue, 05 Dec
 2023 16:33:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031531.426872356@linuxfoundation.org> <20231205031534.517148119@linuxfoundation.org>
In-Reply-To: <20231205031534.517148119@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 6 Dec 2023 01:33:27 +0100
Message-ID: <CANiq72kuK9cFDNWszsR1jSAiQo6qV9cjduYNm+oAooGtE6mRkw@mail.gmail.com>
Subject: Re: [PATCH 6.1 051/107] auxdisplay: hd44780: move cursor home after
 clear display command
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Hugo Villeneuve <hvilleneuve@dimonoff.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	David Reaver <me@davidreaver.com>, Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 4:31=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Hugo Villeneuve <hvilleneuve@dimonoff.com>
>
> commit 35b464e32c8bccef435e415db955787ead4ab44c upstream.
>
> The DISPLAY_CLEAR command on the NewHaven NHD-0220DZW-AG5 display
> does NOT change the DDRAM address to 00h (home position) like the
> standard Hitachi HD44780 controller. As a consequence, the starting
> position of the initial string LCD_INIT_TEXT is not guaranteed to be
> at 0,0 depending on where the cursor was before the DISPLAY_CLEAR
> command.
>
> Extract of DISPLAY_CLEAR command from datasheets of:
>
>     Hitachi HD44780:
>         ... It then sets DDRAM address 0 into the address counter...
>
>     NewHaven NHD-0220DZW-AG5 datasheet:
>         ... This instruction does not change the DDRAM Address
>
> Move the cursor home after sending DISPLAY_CLEAR command to support
> non-standard LCDs.
>
> Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Tested-by: David Reaver <me@davidreaver.com>
> Link: https://lore.kernel.org/r/20230722180925.1408885-1-hugo@hugovil.com
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The commit enables more hardware to work, so it is a "feature" in
sense. It does not break the current supported hardware (as far as we
know -- David's `Tested-by` was on HD44780), but as usual, there is
always a risk with any change.

If it is OK to take commits like this into stable or somebody wanted
to use that hardware in 6.1, then I assume it is fine, but I wanted to
point it out just in case.

Thanks!

Cheers,
Miguel
