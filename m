Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE141600D
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 20:08:01 +0000 (UTC)
Received: by mail-qv1-f54.google.com with SMTP id l11so2266136qvu.13
        for <patches@lists.linux.dev>; Thu, 14 Jul 2022 13:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TKVtPZcpRdNz7o32GloPe74MZDdfyUr3cLq/c9WobfE=;
        b=S2k+4XG8mvAmC4dz+qWSvuow+4V+wWBL8uPIv+g1Lzb/eFB2Ceq0PSZdilDpDrUHEx
         t5adGgzFKgWok/XTzINGfU6RObEDIAecQUSOvZ93CJn+6Rcr6QVyJGOJkBp7K8amdfeb
         vgP3A9d4GnIQ+ewpZo7TK5Wmhn57jmejhDjrw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TKVtPZcpRdNz7o32GloPe74MZDdfyUr3cLq/c9WobfE=;
        b=gBX+H9H/wI+vQm2FxlcgDIMS9MjYJpqg8TjYZisaKDWZR7OZ8HZ47qM0S+KAhqu7eq
         PP6KSFtEw5cx32+GyZqp2wwuS/xnOtPI1lHq8oAh1G8+Ww6isUrkop0fG/J+dYC5afq+
         Dxk4P7/6hA2vhypR4+0/W9zXj1FFdBfHDsu4z7+dV96SIu/6mVtywNiBET1sf+bG++RU
         GpINZuOKiWH+VztGn2PEKaVkIpwZ8y/+W5KQkhF49XXNrEoLL8hsvv8wQeRwm7B8dPF+
         arZqRpDAvFsrXftvDyufgOlALX+nqWafXGhSJ07KuQCoUF+WgHlbkVPlAPfVCJ64djdb
         jrpA==
X-Gm-Message-State: AJIora+iZSLRCWCycNaVSQtzLEcxCjO/TK4XPq6WxxNSYjvnEjn8SSRm
	2ibJA4+c0UrdKBUbS4eAEukBg0c3T4Laqg==
X-Google-Smtp-Source: AGRyM1sezOISlxZakalWu5nzQSfAF3HwlV/f0U1jCvsWx5boHZgZjfho1J2I+r8/a9eQCFWG2tqv8Q==
X-Received: by 2002:a05:6214:2a87:b0:473:8ba7:9f76 with SMTP id jr7-20020a0562142a8700b004738ba79f76mr8997627qvb.89.1657829280668;
        Thu, 14 Jul 2022 13:08:00 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-245.dsl.bell.ca. [209.226.106.245])
        by smtp.gmail.com with ESMTPSA id z13-20020a05622a028d00b0031b18d29864sm2381158qtw.64.2022.07.14.13.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 13:08:00 -0700 (PDT)
Date: Thu, 14 Jul 2022 16:07:58 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH WIP v1 3/3] Add myself as ultimate maintainer
Message-ID: <20220714200758.hzweoskhf4kottoo@meerkat.local>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
 <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
 <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>
 <fa7a99b1-11a7-c170-05f9-3327bbf7fdfa@gnuweeb.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa7a99b1-11a7-c170-05f9-3327bbf7fdfa@gnuweeb.org>

On Fri, Jul 15, 2022 at 03:05:09AM +0700, Ammar Faizi wrote:
> On 7/15/22 3:02 AM, Ammar Faizi wrote:
> > On 7/15/22 2:52 AM, Konstantin Ryabitsev wrote:
> > > This is not a real commit. I am using it as testing grounds for
> > > b4-submit. Do not read anything into this. :)
> > > 
> > > Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
> > 
> > Shouldn't we have a "---" here?
> 
> Ah, it can apply with that too. TIL.

The actual message body is generated using git log --format=email, so b4 isn't
really doing anything crazy here. :)

Thank you for the review!

-K
