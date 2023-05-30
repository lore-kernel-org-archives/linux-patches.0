Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA81E18007
	for <patches@lists.linux.dev>; Tue, 30 May 2023 11:58:26 +0000 (UTC)
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-4f4d80bac38so4698628e87.2
        for <patches@lists.linux.dev>; Tue, 30 May 2023 04:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685447904; x=1688039904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXw2bJhZ/bTyaEyxNQlJ8soVao7954SJAKnERIc09i4=;
        b=fFVYqsPO31MT6wV8kn5JgiMeVRHsxSmSxLCGSnGBJaN8nbfuPfctIAjon+xSBe9eHF
         mbhW3aPpI248NASTB7b7U4/9rO6HwoMY30pPxo6fJH1t8d3yt3hoMnD5ukajXSh/TQ8M
         gE78SaiFX3Tb50L/otSBJ/0eb+KAb7WRyS/jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685447904; x=1688039904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VXw2bJhZ/bTyaEyxNQlJ8soVao7954SJAKnERIc09i4=;
        b=NzFAhVO+FY3FVDvLvx4fu61d9ZAkBbSWp4bgT9rKhKBI3Yht0I0EDn//W9JbBdkVkf
         UoXfNxQ7HuSjyWqyCgGBCkleQsqReptfWnSPiaIgBR2vyK/c9mfG6tnKQ7G8kRPjiLD2
         jbSKBrRN3f0qExMx2DPBosvrpLVDNa8pAcTRHeAjTZWJlDe29bAm6NYAVYgDXSh+qK7U
         rf711UuGgdJRRYVmFLJd6hW07CDLearoB+07gKIMtccbHaVZJtXy2d6n6EtLeftYr4ET
         NQ9fEHBl8ErLHXfhY5uYpqZO3+nQGawBM+N16qoDXI9TTPRAr8seSIa/pDZetYwbb7+p
         YZoA==
X-Gm-Message-State: AC+VfDxLyKoaPOgwUFakcyhPWm0FsAm0hXlbpUKDUVCzIBT6iqciK9C/
	YpcyVIYR3S/Zc0sEwvapmuVsAqVdIQfUeF6uCTb5RP6F
X-Google-Smtp-Source: ACHHUZ4r8gxApILkg3lrbrvdjYfuPeCoP/JLXqwgskFEUn2f2WxfthmANGd5Q0IvKLcAeXaN2B8GWg==
X-Received: by 2002:ac2:4ac3:0:b0:4ed:d4ac:1e17 with SMTP id m3-20020ac24ac3000000b004edd4ac1e17mr545950lfp.49.1685447904530;
        Tue, 30 May 2023 04:58:24 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id d14-20020ac2544e000000b004ece331c830sm317711lfn.206.2023.05.30.04.58.23
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 04:58:24 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-4f4bdcde899so4706575e87.0
        for <patches@lists.linux.dev>; Tue, 30 May 2023 04:58:23 -0700 (PDT)
X-Received: by 2002:a17:907:3f11:b0:961:b0:3dfd with SMTP id
 hq17-20020a1709073f1100b0096100b03dfdmr2439731ejc.7.1685447467702; Tue, 30
 May 2023 04:51:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190835.386670951@linuxfoundation.org> <ZHXUGdFMIcB5HL8s@duo.ucw.cz>
In-Reply-To: <ZHXUGdFMIcB5HL8s@duo.ucw.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 30 May 2023 07:50:50 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjekYoijzNK-MCQKvrO_7m0m9nRmt3ebKcHyhR-XJimUA@mail.gmail.com>
Message-ID: <CAHk-=wjekYoijzNK-MCQKvrO_7m0m9nRmt3ebKcHyhR-XJimUA@mail.gmail.com>
Subject: Re: Wrong/strange TPM patches was Re: [PATCH 6.1 000/119] 6.1.31-rc1 review
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, l.sanfilippo@kunbus.com, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 30, 2023 at 6:46=E2=80=AFAM Pavel Machek <pavel@denx.de> wrote:
>
> > Lino Sanfilippo <l.sanfilippo@kunbus.com>
> >     tpm, tpm_tis: Avoid cache incoherency in test for interrupts
>
> Description on this one is wrong/confused.

Yes. Commit 858e8b792d06 ("tpm, tpm_tis: Avoid cache incoherency in
test for interrupts") in mainline.

The change to test_bit/set_bit may be a good one (and adding the
IRQ_TESTED case to the bit flags), but that commit wasn't it.

As you say, the enum should now enumerate bits, not bitmasks.

             Linus
