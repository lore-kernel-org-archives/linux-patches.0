Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6309B408D9
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 19:06:32 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-970028cfb6cso373654766b.1
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 12:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686337590; x=1688929590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+ONXQdK4a1fSmqiExKhyWkPlcAP+HPrxGCh1eVdlew=;
        b=bpVzgn61as+4qL7auUj1HnOlDIjFqVWvh06qWK1SNbkokfl8Jvevh4dXxWIpmO3Cve
         F8HR50CZTBrTlHKF5v9bALzAtK3QBrNcboEq8uj+pCM1DFEVif1d0ETW2on62nlMCbKT
         vmb94A6gkFwvIAQAJgDpfttdblDsobazCdipE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686337590; x=1688929590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+ONXQdK4a1fSmqiExKhyWkPlcAP+HPrxGCh1eVdlew=;
        b=bvvdFvkJp/aEhusm1j76CjhVif1L1PSzHs142AJjroFRzkd1avA1o/HdC6w7SPrkjH
         bdS3srL9JtXR1Ne4dlcxBlUN1SYwb0wRxnA8gBpwPPIhlXDhv6h/VF5cYT7dF6lQHbqO
         qz6Q1rWCOroALOOs9JfKjJ1+5Xjs+m/I68cTH1QBq8uA8EP2LlrdCia9LxSsXc6JLgAu
         M7UsyUdmq4iOKnucSpINblJUcOhiBNA5lRjfEeYwyapUOTTGw8u/zYf0X1d67e8Y5EvW
         jL+gFDlgxuQWn28iNGtOM++nfBeDatpcQqHm0KB1D5iml74BxHwxecVsxxe6RFtlCGbw
         WjPA==
X-Gm-Message-State: AC+VfDwUGW4YhrQVslnkOd1CbG22jwHym8WvWozk19Cd4GGkD55aeMOZ
	0PVnTwB0pEUKPChI53ft/mZn+qLcblwpENJASaO9ftDI
X-Google-Smtp-Source: ACHHUZ5oq/KvkrUjNr9NEjJP51qeNSn1yMPun/s+4UGlPrjBXrvrIEVwa1sBzRGH0BdpODbthkjCiA==
X-Received: by 2002:a17:907:d2a:b0:97d:cda7:f0c4 with SMTP id gn42-20020a1709070d2a00b0097dcda7f0c4mr75636ejc.61.1686337590427;
        Fri, 09 Jun 2023 12:06:30 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id lv16-20020a170906bc9000b00965a52d2bf6sm1618034ejb.88.2023.06.09.12.06.30
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 12:06:30 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-970028cfb6cso373652566b.1
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 12:06:30 -0700 (PDT)
X-Received: by 2002:a17:907:26c1:b0:978:930e:2279 with SMTP id
 bp1-20020a17090726c100b00978930e2279mr2489992ejc.52.1686337589586; Fri, 09
 Jun 2023 12:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607200903.652580797@linuxfoundation.org> <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>
 <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>
In-Reply-To: <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Jun 2023 12:06:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=whA=HsyDFtgQnWMZP-08ddhMh1a88OZHCXf8N-iP6hFQw@mail.gmail.com>
Message-ID: <CAHk-=whA=HsyDFtgQnWMZP-08ddhMh1a88OZHCXf8N-iP6hFQw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, Thomas Gleixner <tglx@linutronix.de>, Ido Schimmel <idosch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 9, 2023 at 11:42=E2=80=AFAM Guenter Roeck <linux@roeck-us.net> =
wrote:
>
> I managed to revise my bisect script sufficiently enough to get reliable
> results. It looks like the culprit is commit 503e554782c9 (" debugobject:
> Ensure pool refill (again)"); see bisect log below. Bisect on four
> different systems all have the same result. After reverting this patch,
> I do not see the problem anymore (again, confirmed on four different
> systems).

Does this happen on mainline too? It's commit 0af462f19e63 in the upstream =
tree.

It was in 6.4-rc1, and I see a clean result from you at least for
-rc2, so for some reason it sounds like upstream is ok. But I don't
really see why that would be the case...

                  Linus
