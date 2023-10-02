Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E990615BD
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 19:29:23 +0000 (UTC)
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-49059c3e32aso26546e0c.0
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 12:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696274963; x=1696879763; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajjlmKdebxZk7OHm+SN7lonVxoqhP21tLhFjdE+XoAg=;
        b=f0oznSblW1mc1/rFtjH4AI5CNhK0lGEBJIlsgXscThVygrHO9b7i8hVFB8zeCtHiTb
         Qeyt9teLBBjeRTdPDRNhFiLoi+94wauCEi1Qd3VXP6mIHXulPu/EryUoj+X+RRYyMC+7
         fsGx+u9FLSefaBjPVGmk/fnzAh84dkOpuom4jmpxT++FSh958z/WjVND7tUAy/TxV6jN
         5Saqp95EsPCW0D8MO1C3VEaXF+EjEOHXalb7FjED5Sv9V30O+VEXVfPePq1eIxHnLgPF
         p5iCui5WeomKPnXNAoh5K4J1snfpJWVcDPDF5n6Q67v9CWetd9VKOYegwfuxBeQ+waWd
         V1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696274963; x=1696879763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ajjlmKdebxZk7OHm+SN7lonVxoqhP21tLhFjdE+XoAg=;
        b=K8Gveybw2oX5YTseNAmgiwoxaId57zS8wQmY7t++XtnHR1yN+0QFmUk87qUbUhBMRv
         G7aTSvmuRd2PMjX1ChIq5ydODKwxh2TiU8DrgHeGzHbo1ipiTDTUha+HZKcqr6lUFMDr
         MxlTyw6mPxVJUimLC/fCjbgN4dKwsZ/Ld/86RFjjWd8RKOQH6bToXUL9OC3zSkz/jMBr
         GiCDP82GcwTLktzH58MJqiXweTDc9ARePEXxvWM+RFcnD/Fo/6Z4pqZY8CRBMo6KCCJB
         eQiBl3x7gjm8TGJYh08P3lGQaJzI6jQA7BiAwSEkW81vYME2A/J0ZnBPMkp5Nuvys/HW
         qQ6Q==
X-Gm-Message-State: AOJu0Yyw+kODzYp4GzoSvCLMUC4d+mo8D6d5XJGCzVdMEkPMW4O6OJjN
	IhRAYWb/g6COVcGbYLIgr24zAMYJCmBeZF80Ugs=
X-Google-Smtp-Source: AGHT+IE49qL31bZrwQMJ0Xfes4Ezx8noj0Ajc/E7xZWoRNGoaK3gWcipOZQfm9J+6RsfmrXvjcIxKo9Ikw11UYOzsZY=
X-Received: by 2002:a05:6122:60c:b0:49b:9510:1f94 with SMTP id
 u12-20020a056122060c00b0049b95101f94mr5413861vkp.1.1696274962518; Mon, 02 Oct
 2023 12:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1696010501-24584-10-git-send-email-nunodasneves@linux.microsoft.com>
In-Reply-To: <1696010501-24584-10-git-send-email-nunodasneves@linux.microsoft.com>
From: Alex Ionescu <aionescu@gmail.com>
Date: Mon, 2 Oct 2023 15:29:11 -0400
Message-ID: <CAJ-90N+A-wS-Uwrs_2WVL86Uo3qzQ1czxm-u9vDj3UuOwjhLdQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/15] Drivers: hv: Introduce hv_output_arg_exists in hv_common.c
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	patches@lists.linux.dev, mikelley@microsoft.com, kys@microsoft.com, 
	wei.liu@kernel.org, gregkh@linuxfoundation.org, haiyangz@microsoft.com, 
	decui@microsoft.com, apais@linux.microsoft.com, Tianyu.Lan@microsoft.com, 
	ssengar@linux.microsoft.com, mukeshrathor@microsoft.com, 
	stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com, 
	vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org, 
	catalin.marinas@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nuno,

Is it possible to simply change to always allocating the output page?
For example, the output page could be needed in scenarios where Linux
is not running as the root partition, since certain hypercalls that a
guest can make will still require one (I realize that's not the case
_today_, but I don't believe this optimization buys much).

Best regards,
Alex Ionescu

Best regards,
Alex Ionescu


On Fri, Sep 29, 2023 at 2:02=E2=80=AFPM Nuno Das Neves
<nunodasneves@linux.microsoft.com> wrote:
>
> This is a more flexible approach for determining whether to allocate the
> output page.
>
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
> Acked-by: Wei Liu <wei.liu@kernel.org>
> ---
>  drivers/hv/hv_common.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index 39077841d518..3f6f23e4c579 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -58,6 +58,14 @@ EXPORT_SYMBOL_GPL(hyperv_pcpu_input_arg);
>  void * __percpu *hyperv_pcpu_output_arg;
>  EXPORT_SYMBOL_GPL(hyperv_pcpu_output_arg);
>
> +/*
> + * Determine whether output arg is needed
> + */
> +static inline bool hv_output_arg_exists(void)
> +{
> +       return hv_root_partition ? true : false;
> +}
> +
>  static void hv_kmsg_dump_unregister(void);
>
>  static struct ctl_table_header *hv_ctl_table_hdr;
> @@ -342,10 +350,12 @@ int __init hv_common_init(void)
>         hyperv_pcpu_input_arg =3D alloc_percpu(void  *);
>         BUG_ON(!hyperv_pcpu_input_arg);
>
> -       /* Allocate the per-CPU state for output arg for root */
> -       if (hv_root_partition) {
> +       if (hv_output_arg_exists()) {
>                 hyperv_pcpu_output_arg =3D alloc_percpu(void *);
>                 BUG_ON(!hyperv_pcpu_output_arg);
> +       }
> +
> +       if (hv_root_partition) {
>                 hv_synic_eventring_tail =3D alloc_percpu(u8 *);
>                 BUG_ON(hv_synic_eventring_tail =3D=3D NULL);
>         }
> @@ -375,7 +385,7 @@ int hv_common_cpu_init(unsigned int cpu)
>         u8 **synic_eventring_tail;
>         u64 msr_vp_index;
>         gfp_t flags;
> -       int pgcount =3D hv_root_partition ? 2 : 1;
> +       int pgcount =3D hv_output_arg_exists() ? 2 : 1;
>         void *mem;
>         int ret;
>
> @@ -393,9 +403,12 @@ int hv_common_cpu_init(unsigned int cpu)
>                 if (!mem)
>                         return -ENOMEM;
>
> -               if (hv_root_partition) {
> +               if (hv_output_arg_exists()) {
>                         outputarg =3D (void **)this_cpu_ptr(hyperv_pcpu_o=
utput_arg);
>                         *outputarg =3D (char *)mem + HV_HYP_PAGE_SIZE;
> +               }
> +
> +               if (hv_root_partition) {
>                         synic_eventring_tail =3D (u8 **)this_cpu_ptr(hv_s=
ynic_eventring_tail);
>                         *synic_eventring_tail =3D kcalloc(HV_SYNIC_SINT_C=
OUNT, sizeof(u8),
>                                                         flags);
> --
> 2.25.1
>
>
