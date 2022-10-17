Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74E033C1;
	Mon, 17 Oct 2022 16:56:31 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id l5so12768456oif.7;
        Mon, 17 Oct 2022 09:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3QLDhIRdz0sgMNmEZO3qAZB5Hcd6D723MgF6zWOXrA4=;
        b=STJ4KtOxuHBiY8sqzmqjWG/We7ki/vkSyusspW0vuRIT9tn38Y2+iqy2suZjq6CSBy
         EJWVkXcDvqJ5hiUWUjp3QKrIqROXmqHc6HoQO+SdtzACVthaU6alEcjt5fdWRupi2Ys4
         CGIizvFeSsSIK8Pe38heAtsHmhHWYHRSEKEx7JnFheyRyzmPm8rpAYWAeo9xdxXe1QrL
         YBxyNZK6Ow84BYACkEEKOyzR9S3Dlr0FUNRiV/SnWE2c0097jwgQ9TnMUEyPP6OjlBmc
         g/ZGtMPJ6XNWLiE5SfhJzAcceqkQhS9UT3Ow2ruriepg18cj/u7LMHOyylk+jn3hkw66
         eusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3QLDhIRdz0sgMNmEZO3qAZB5Hcd6D723MgF6zWOXrA4=;
        b=J3hWx9CU9+RLZbkZIIjIM5Es7s8a7e1/8aeQyNwZRyeKLW+AH2yUG3+JG5psI02bAC
         c50kexNtkAegJbnUF5qmjBuFLGaye0n8UPx6S4sLPNE3Q4fSnVzBCgKlZEE5YI+UeaPk
         uBBfOFonEqSFhLKDfHgX/3CH6gb5A169c3Q6AlWwrakS1X/jkg+eUspr1Qy5gW8kIBLR
         duUsXkJEqE083dx3LoCoCMSm+/jmgDQppM0EbC0BgXdwqMbXspBETJvDa95TVYCjaWkx
         hu4h9i3aj3viB71dQt88nTEaMHN9MAnHdiXbRGfYaZG4QqGpkPV23g6CdfiolAnXdUm7
         V2Qg==
X-Gm-Message-State: ACrzQf1i3quED0Au4LMqpMD9TXsFpIsfgiq5BX0fy0P/Xe+DPaERdTYD
	WpjZOohwqCcIweYR3zC7AHI5bI3yK4lwtJwzGrY=
X-Google-Smtp-Source: AMsMyM69y3IS/obkTemFZFId5R/zGegZMQr+gk/q70dAfdIQn3OfAaogxMNkEHflvw8+jVeL43QchVYz2RTejG33v2I=
X-Received: by 2002:a05:6808:14d2:b0:354:c733:abd3 with SMTP id
 f18-20020a05680814d200b00354c733abd3mr5586270oiw.96.1666025791038; Mon, 17
 Oct 2022 09:56:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221017162837.3698-1-nathan@kernel.org>
In-Reply-To: <20221017162837.3698-1-nathan@kernel.org>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Mon, 17 Oct 2022 12:56:19 -0400
Message-ID: <CADnq5_P5e9nWWujT4f7TG_SQkvNA=MkwZJbuA=cWnDDCBqM5+w@mail.gmail.com>
Subject: Re: [PATCH] drm/amdkfd: Fix type of reset_type parameter in
 hqd_destroy() callback
To: Nathan Chancellor <nathan@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, Kees Cook <keescook@chromium.org>, Tom Rix <trix@redhat.com>, 
	llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>, patches@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Applied.  Thanks!

Alex

On Mon, Oct 17, 2022 at 12:30 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> When booting a kernel compiled with CONFIG_CFI_CLANG on a machine with
> an RX 6700 XT, there is a CFI failure in kfd_destroy_mqd_cp():
>
>   [   12.894543] CFI failure at kfd_destroy_mqd_cp+0x2a/0x40 [amdgpu] (target: hqd_destroy_v10_3+0x0/0x260 [amdgpu]; expected type: 0x8594d794)
>
> Clang's kernel Control Flow Integrity (kCFI) makes sure that all
> indirect call targets have a type that exactly matches the function
> pointer prototype. In this case, hqd_destroy()'s third parameter,
> reset_type, should have a type of 'uint32_t' but every implementation of
> this callback has a third parameter type of 'enum kfd_preempt_type'.
>
> Update the function pointer prototype to match reality so that there is
> no more CFI violation.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1738
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>
> No Fixes tag, as I could not pin down exactly when this started. I
> suspect it is
>
> Fixes: 70539bd79500 ("drm/amd: Update MEC HQD loading code for KFD")
>
> but I did not want to add that without a second look. Feel free to add
> it during patch application if it makes sense.
>
>  drivers/gpu/drm/amd/include/kgd_kfd_interface.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/include/kgd_kfd_interface.h b/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
> index e85364dff4e0..5cb3e8634739 100644
> --- a/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
> +++ b/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
> @@ -262,8 +262,9 @@ struct kfd2kgd_calls {
>                                 uint32_t queue_id);
>
>         int (*hqd_destroy)(struct amdgpu_device *adev, void *mqd,
> -                               uint32_t reset_type, unsigned int timeout,
> -                               uint32_t pipe_id, uint32_t queue_id);
> +                               enum kfd_preempt_type reset_type,
> +                               unsigned int timeout, uint32_t pipe_id,
> +                               uint32_t queue_id);
>
>         bool (*hqd_sdma_is_occupied)(struct amdgpu_device *adev, void *mqd);
>
>
> base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
> --
> 2.38.0
>
