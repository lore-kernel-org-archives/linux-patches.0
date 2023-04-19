Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701922CAB
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 09:57:57 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-2fa36231b1cso1581499f8f.2
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 02:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681898275; x=1684490275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hupHNG5IAW/zmzShc8lttgNkGPU8qe7bXT1BDjiDGH0=;
        b=gozxd3oNE0j/YGydsFJapiJzk+9Q1aDhBfoBxPSPDoQ7y7jyLCdpFWora3xRjXFapx
         T/NXIHcnHr9RtBSy4QPAiTbgphKWm0eHsyCCcgotPyIC8d5EY6nQvY3/SzmVvHpgmAyd
         9CFz5v1pLx4espbUtEulhJxIDC9Msn1ptCOkV6VG/0RKzYuSAjaQX6PVVZFcUt0Jz73E
         SrOjiOM3KgstMOkhvU9GkWG7M/UlrN4L3J65NAg1mYNdK72/FUUNXZKLJc82jzM3x7Ej
         ZFhwL8h8qaAJxDpt1KX9pzizLQcJbL21w7SpPLIaS3uYJRxYQOcoeY1bWC+DNotkcf2D
         CE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681898275; x=1684490275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hupHNG5IAW/zmzShc8lttgNkGPU8qe7bXT1BDjiDGH0=;
        b=RvcroRyMsIqBKQnrvkbyNUaJA8U/Ks9EKX2e5NPwkkb9RqqjGUspTWaLoT50F78WO5
         brbzd5o01bYVJKS6di/s3AAnHVy9ygTCUCxj0mszEB0QyfCwWOcxvHHmqrpXFjnq54TK
         p2N88qxxhq4eeOZ5lTiKP695i5AmKB7QolX/ez7ba0+foKuMST6LQtoDH2D3yMaKZOLl
         VmT8TycqYET6pOxlpOexzwdImH2jI+hVbBo0oQIUjMkcYKcrKJnJaytQionpRPHUef2+
         Ozj6IUjsrsgJ53eWtQJHEXP33B09ieY5b9DDyNnOOiMtfV3cAJrMQ8ohjVofmGnOAOmb
         x2FQ==
X-Gm-Message-State: AAQBX9fN/qgtLUlfw86vGtOUnAoAMMFE3q3+XTrxtvUwJoKfD20kzivQ
	EcsYWNaEXU/qGTxYXQRjJ1dnexVx/lJWvrFVxM6fgA==
X-Google-Smtp-Source: AKy350YZRxtrR3nRrp3HaHXWDzmawpHicPoNTqVzkpPnwGU4a0cPHCBdKS8zZ+MY18ZlDlBNm0Q40S2LocwpqaBSRZY=
X-Received: by 2002:a5d:6708:0:b0:2f9:d629:48f1 with SMTP id
 o8-20020a5d6708000000b002f9d62948f1mr4123971wru.26.1681898275594; Wed, 19 Apr
 2023 02:57:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418120313.001025904@linuxfoundation.org> <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy> <2023041948-overthrow-debtor-289d@gregkh>
 <20230419-uninstall-fragile-51c326b1adbc@wendy> <2023041918-stammer-subgroup-fbd1@gregkh>
 <20230419-unpeeled-squabble-986a9e40e4d5@wendy>
In-Reply-To: <20230419-unpeeled-squabble-986a9e40e4d5@wendy>
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Date: Wed, 19 Apr 2023 11:57:44 +0200
Message-ID: <CAHVXubgRXAzGWwyTPwUpWxjP++0Yybu=wPMRCPuaPs2mEaA86w@mail.gmail.com>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the fixmap region
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Palmer Dabbelt <palmer@rivosinc.com>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Conor,

On Wed, Apr 19, 2023 at 11:51=E2=80=AFAM Conor Dooley
<conor.dooley@microchip.com> wrote:
>
> On Wed, Apr 19, 2023 at 11:36:43AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Apr 19, 2023 at 08:55:34AM +0100, Conor Dooley wrote:
>
> > > However, this patch ("riscv: Move early dtb mapping into the fixmap
> > > region") did end up getting applied to 6.1.y and 6.2.y, despite what =
the
> > > email I got said for 6.1.y!
> >
> > That's because Sasha backported the dependent patches to get it to
> > apply.
>
> Should probably send out a notification of success then, no?
> At least, I didn't see one land in my inbox.
>
> > Let me just drop all of them, that makes it simpler and then if anyone
> > wants them applied, then they can send us an explicit set of patches.
>
> Perfect, I should be able to do that.
> Some time here might actually work in our favour, as I don't think this
> stuff has been tested yet by anyone using XIP and I had expressed some
> concerns that we would cause them issues.

Let me know how far you'd like to see it backported, I'll do it, I
already let you deal with all the backport errors, that's the least I
can do :)

Thanks!

Alex

> I already owe you one set of non-urgent backports that I have yet to
> get around to...
>
> Cheers,
> Conor.
