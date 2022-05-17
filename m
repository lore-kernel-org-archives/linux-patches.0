Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4127A
	for <patches@lists.linux.dev>; Tue, 17 May 2022 20:06:08 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id o22so113644ljp.8
        for <patches@lists.linux.dev>; Tue, 17 May 2022 13:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=mvbsZxesHLOG63azhAKVTp/LJfiWJZzs4O+J5BDoyUM=;
        b=ODsUmgzH2UowvsEapJxkiqWDkFIDzv3W31CBDdpz/yC6PKm7O/2B4zLG9QtCt6MAcA
         t71NTTw7Qy0Cr+tcZ6Mgq/+a5MVKWLRvjRXvUgR5FR3/7DWlBkQ262dP8Bxc2Cqeip6Y
         ZsDdwO0gMwrIjLgFAqX0GwMbWgm2N1/v/GfUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=mvbsZxesHLOG63azhAKVTp/LJfiWJZzs4O+J5BDoyUM=;
        b=qlV9FL4UtBJ82dTQ1KIkysjHdT/2yvt/+O5KwGbSfuj3Ao8B8Kp1XSezMCz0z+hWRR
         QquG9OeBRQ7Xt/+63T/cSScsXSdNoEbkeNdBW/ZaFLeUjG7oZHUJLmznRng2HP/Faq2N
         EDLDVWlXAv88xq3Nm1VNHvnvOb8b13VIak6XpRizj6/6QB8kc/e9aDOq7YdHcLPCGFMQ
         QzEBvm0OU3tTI0BDXxNVhU1fkICZAU8gmbctbcQRK+nUM+oBxwHSG/Ofxb8FZNOEK3bS
         UabXI7H1MNrQA3OaTj4EFTUS5FsV/1a13VhJVR3K+vT4aY7LBVKSsf/oG0m/4579FRWs
         SDPA==
X-Gm-Message-State: AOAM5332PtW1AxJaDdq9L6uIqdGA0YruyGJI9r+rTeeJ/76CZIRwJKRg
	NeNZ32dyVpz1i7TA8/vtsT6y4432H3Kfi1GZr8w8LA==
X-Google-Smtp-Source: ABdhPJzcqorTOfRCis7RSf9b+7pvh+4jthqZQSdCXdNt0X8KbC2Rx0G8lw6zDck9C8VRzVof3upLg55ZcriE0z1b6Bg=
X-Received: by 2002:a2e:5309:0:b0:253:af56:4fc0 with SMTP id
 h9-20020a2e5309000000b00253af564fc0mr4585825ljb.341.1652817966524; Tue, 17
 May 2022 13:06:06 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 17 May 2022 13:06:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ceb32b66-1341-d54f-a60a-5c342119c784@linaro.org>
References: <20220517193307.3034602-1-swboyd@chromium.org> <ceb32b66-1341-d54f-a60a-5c342119c784@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 17 May 2022 13:06:05 -0700
Message-ID: <CAE-0n50rUW7Lqk4CwfSUgKYEJzwjXuVohAnbj9uKA=kEkXikyw@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
To: Alex Elder <elder@linaro.org>, Andy Gross <agross@kernel.org>, 
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Alex Elder (2022-05-17 12:51:34)
> On 5/17/22 2:33 PM, Stephen Boyd wrote:
> > We don't use this carveout on trogdor boards, and having it defined in
> > the sc7180 SoC file causes an overlap message to be printed at boot.
> >
> >   OF: reserved mem: OVERLAP DETECTED!
> >   memory@86000000 (0x0000000086000000--0x000000008ec00000) overlaps with memory@8b700000 (0x000000008b700000--0x000000008b710000)
> >
> > Delete the node in the trogdor dtsi file to fix the overlap problem and
> > remove the error message.'
>
> Is the mpss_mem node (which defines 0x86000000-0x8ec00000) correct?

I think it is. Modem is working for me.

>
> You're right, we don't use that memory on Chrome OS, but I just
> wondered whether the other node might also have a problem.

What sort of problem are you thinking about?

>
> I don't actually know...  Bjorn, do you?
>
