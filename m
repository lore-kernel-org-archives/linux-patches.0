Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902B7FBE3
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 17:55:25 +0000 (UTC)
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-63c70dc7ed2so632516d6.0
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 10:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690998924; x=1691603724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qoQ9QQBh3aNb5HAI8gb3WGWfLp4PhO0tFoxt1vgia60=;
        b=Q6P7YDb36YHTIT0J9J3mRC0xO/oM72diYAGVE7wD9ZrpTSgrRwMkpx6qVc3FNK/2Pn
         NUoLOyN5EysVLEw9KnReNoTXT1TQmvu/EeFjSPIPW4VXIHL3EQDOE7WQ3yXUa1FrC/q9
         SLdeuv1arpwmrKZHc+UXMvhgn6GtH/o6AGUfCqeO5D8DLkc9oT1MlWzSXTycAZmzBBuY
         3o5K/9EM7UZ1IoLeFl2zlLP+kQSS7ajteuX+ugpeIRpRriPMJeWFXa31Myc1VRBHmzPc
         Sd1+kJajsbenswNhz61a/cWYqHt4VZPzpbfJ9epJWbFXZ/2d8xv7i2rW2Sf190ta7Xkt
         Sc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690998924; x=1691603724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qoQ9QQBh3aNb5HAI8gb3WGWfLp4PhO0tFoxt1vgia60=;
        b=LFYJQbdcVHV8y3hiWBkTOhPwNRqcS/KxxV3raj/lHyZC5mVBY6QjnNCB3GEQB7vod2
         US8WjeVW8N32V62zlsdf1trEojSFgPKqZWVqGH6RnqJP+HnwmU8JdKlixIIMzMuqFa4L
         6/ogGUp7g1f2QejZPFPlRNsK9bQuls6cIKBg5PICkMckqt/sqixmb+9nuuh7mYLZhynz
         O2B0nqNXKMIkAYKMOLYHiet68nkBGvw05yTozzoLXiYlkLdrD5zI0xLULPRd+lWkO4x1
         5NdVRTE/VtRs813CIIkW2ACoMh1ZsagFLVQcmUm6UIk26rz3FKJIIqiAoQ5hjxesnkRr
         U0Wg==
X-Gm-Message-State: ABy/qLa3/XU28JR90o45+1X2gDDafaNvt41fiqzmgA2Zlpg9hyDdLAAp
	zD+XcSQmHiZ38GTiaM3JSfCtYB6eUNALh+9p6OdRnw==
X-Google-Smtp-Source: APBJJlFXbcDAluXzkimyBCOpTg/tYoevL512peHPLiVSwrCaU15QF3ls/Tpp4KxMI08oy/Wr6Kb//rNAL8a2uSaqlHw=
X-Received: by 2002:a05:6214:21a9:b0:63d:2369:6c41 with SMTP id
 t9-20020a05621421a900b0063d23696c41mr20837155qvc.55.1690998924158; Wed, 02
 Aug 2023 10:55:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230802-fix-dsp_cmx_send-cfi-failure-v1-1-2f2e79b0178d@kernel.org>
In-Reply-To: <20230802-fix-dsp_cmx_send-cfi-failure-v1-1-2f2e79b0178d@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 2 Aug 2023 10:54:47 -0700
Message-ID: <CABCJKud-ve+6v5h1QeDwUm4q7XzuhMorDTwAGmsV4h-R+0MKxg@mail.gmail.com>
Subject: Re: [PATCH] mISDN: Update parameter type of dsp_cmx_send()
To: Nathan Chancellor <nathan@kernel.org>
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, keescook@chromium.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nathan,

On Wed, Aug 2, 2023 at 10:40=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> When booting a kernel with CONFIG_MISDN_DSP=3Dy and CONFIG_CFI_CLANG=3Dy,
> there is a failure when dsp_cmx_send() is called indirectly from
> call_timer_fn():
>
>   [    0.371412] CFI failure at call_timer_fn+0x2f/0x150 (target: dsp_cmx=
_send+0x0/0x530; expected type: 0x92ada1e9)
>
> The function pointer prototype that call_timer_fn() expects is
>
>   void (*fn)(struct timer_list *)
>
> whereas dsp_cmx_send() has a parameter type of 'void *', which causes
> the control flow integrity checks to fail because the parameter types do
> not match.
>
> Change dsp_cmx_send()'s parameter type to be 'struct timer_list' to
> match the expected prototype. The argument is unused anyways, so this
> has no functional change, aside from avoiding the CFI failure.

Looks correct to me, thanks for fixing this!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
