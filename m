Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A574C8DB
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 13:45:06 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-41958410e5cso374401cf.0
        for <patches@lists.linux.dev>; Fri, 29 Sep 2023 06:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695995106; x=1696599906; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkcij4M4qFmfPBJh0ZXRR+rqodBxc/HEVEHdtcfIjHY=;
        b=RBWN8ppe6XOZcsqNw5p5yphnuyV9C0rS+DPy1yJ+3mzvMPyBw0m0N5c9pzpki6exmL
         bq6nLrL0w21g0vtdcOI1szUOla8aK2Z1V/IGbcVpJ2+Gxu6dB3kiQplC9sWhfAJE+HCP
         oZxLSzgqTQMJNqOCeYBYDr/NXNoXXMgMxYlNYiJXf2XoAle0YRTIqjVuMZV9gGxs6T0E
         9iHt0HRfYt2djy9qZV8vK6RDLF3xkOHfZkEyiTahwm0Jb6hvfIP5fs1YI6MvlQBytBDf
         SuUotklkSOjnIDhO31V3VaIKCOBc1iRz2GT38Bi7BjGoOIxBpv+o3rSnqQ/I9Yjl1CNv
         cwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695995106; x=1696599906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkcij4M4qFmfPBJh0ZXRR+rqodBxc/HEVEHdtcfIjHY=;
        b=q2mqnWAontB+j36iRrfj5uYn7oP5k57beEpGYMBQKWdFFxl/WlGM616xjcDcZPfrWN
         coH/1n2E4WkXzx9NhWGgJDgF3aRekx9JWREO/yAQ56xgtuL2u2yv5aMrd+5m8a65DFip
         nl/jvVGspFPUg5eXJPIe/I4a85jozzF0ugCqFw6xq2jNMH7JSGo0hHlnXYiP4/zyxoMU
         NKeDZbZd+HDZHrHQEizYxPoCsQ1rIuV7DMuD635FIMjwqq1N1oz8VF2Cn3WtDvL3B3vw
         H1emm5Lk81HzXeRIsRKMI+/1DSILoivNo189ydkA7yuWtJhLuwq5duzHAV2BCkkMHwC5
         iR2w==
X-Gm-Message-State: AOJu0YzK3Bgs5tZ6MahHe0rc5Szas3c/zmboEmM1mhNfypGEkGf8f1jV
	dZopGrIshzKuJCO1rX5aDZYTaVS29pb8l0MP5LSuwQ==
X-Google-Smtp-Source: AGHT+IGqb7C2qGPVFGGU6qDXPjDw5ijpk93eWWclX0RnNuF3jfCQccabAV91wG1NS0ht9vqWAX+tBaD/0xVtgS9Gg0E=
X-Received: by 2002:a05:622a:46:b0:40f:d1f4:aa58 with SMTP id
 y6-20020a05622a004600b0040fd1f4aa58mr1209455qtw.8.1695995105901; Fri, 29 Sep
 2023 06:45:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230829234426.64421-1-tony.luck@intel.com> <20230928191350.205703-1-tony.luck@intel.com>
 <20230928191350.205703-5-tony.luck@intel.com>
In-Reply-To: <20230928191350.205703-5-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 29 Sep 2023 15:44:54 +0200
Message-ID: <CALPaoCgN2PBQymAXK_f1ggs_JwyARBuWruP-sPA1QKJMxvv9ow@mail.gmail.com>
Subject: Re: [PATCH v6 4/8] x86/resctrl: Split the rdt_domain and
 rdt_hw_domain structures
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Sep 28, 2023 at 9:14=E2=80=AFPM Tony Luck <tony.luck@intel.com> wro=
te:
>  /**
> - * struct rdt_hw_domain - Arch private attributes of a set of CPUs that =
share
> - *                       a resource
> + * struct rdt_hw_ctrl_domain - Arch private attributes of a set of CPUs =
that share
> + *                       a resource for a control function

wrapped line not quite aligned anymore

>   * @d_resctrl: Properties exposed to the resctrl file system
>   * @ctrl_val:  array of cache or mem ctrl values (indexed by CLOSID)
> + *
> + * Members of this structure are accessed via helpers that provide abstr=
action.
> + */
> +struct rdt_hw_ctrl_domain {
> +       struct rdt_ctrl_domain          d_resctrl;
> +       u32                             *ctrl_val;
> +};
> +
> +/**
> + * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs t=
hat share
> + *                       a resource for a monitor function

wrapped line not quite aligned anymore


> --
> 2.41.0
>

Reviewed-by: Peter Newman <peternewman@google.com>
