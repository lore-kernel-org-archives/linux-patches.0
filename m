Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2645028F2
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 15:27:57 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso8176665wmo.0
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 08:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678721275;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5MlqLtviOtYp6HxaLoBe4+wSDth/BbTrrWvwIZUKlwg=;
        b=QEd2dp9v6mDiG0ZlfB3umTfHAdQYxZJ8eDaGw13dPuLSU+j0UUHFP1jGTN4cya+qFF
         HU9xsqw8O3aXkj/2oXHoESKbPdNtKwSL8RQoWN3vp0BU4Q3xWY428VC2Wqo0QzdDkDK4
         CTfv2YRQf3tdFH+s7MOpjDxLCq9jE/ksXO7iKpO6C9xLmQ0yfjZA70yrgo/3dprNUqL+
         D7NmJZ9ZUCYOUxGja37dv72QXXKRYNOVrqn9y023rxeMOL9JWVjxALNJwNs6vHoYdoHQ
         7WoJijSrIpKhzczozcX1ewaHoAq9zgjffVjM8I2xkrdO9Xz1GiA9PZeSQ2dQOQWi63m0
         7qbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678721275;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5MlqLtviOtYp6HxaLoBe4+wSDth/BbTrrWvwIZUKlwg=;
        b=kQnE6m+S1r5/bQcchVPL6Wli6Q/es8GujCOV3bgt6W1Xr/xU1zkHUOTNfjGo8W2HIP
         +V9Ub88Utz+C7c2MlRLwluRDChHga3NcWYyMh+Gq56jzL/XA1OSg6T+6Dxw25YVnUyHt
         hAyl/N48dfhUIwWNzo0SNq04vGQ0TxY4vxkN18Sgl3BdkxC0sa0YLgkggikg5pdQ3W5t
         n7IhXM+gD6P39f+G4E38zQtPdL3IEQekayRiarBh7mVHb9LdaevZrwBs2LxVd0xjcxpR
         SlDoK19VjHTHcDvuGlgfgLOuwfqPhTDmA+1r2PqE4dabhlv+EzhZDGeV/tocyYDXtxKy
         XMEw==
X-Gm-Message-State: AO0yUKXngkjRm0XR+zDfe982J15D0qZDTdyGfpfOL2ec8ppRH5vxDslj
	Cckk3+WJMW/+CfDg2UC+2UY=
X-Google-Smtp-Source: AK7set9jSPgWPA4c0CSnP9h04Z4BjORE+KGXik6RLZzLIdxKfYDEybMVgA05SmzFddLLAPLg5G6mvA==
X-Received: by 2002:a05:600c:c10:b0:3eb:248f:a13e with SMTP id fm16-20020a05600c0c1000b003eb248fa13emr11542947wmb.22.1678721275178;
        Mon, 13 Mar 2023 08:27:55 -0700 (PDT)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id f26-20020a7bc8da000000b003e2096da239sm92233wml.7.2023.03.13.08.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 08:27:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Mar 2023 16:27:53 +0100
Message-Id: <CR5D0YM6E93X.S0PN49LMWT0U@vincent-arch>
Cc: <christophe.leroy@csgroup.eu>, <song@kernel.org>
Subject: Re: [PATCH] stress-module: stress finit_module() and
 delete_module()
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Luis Chamberlain" <mcgrof@kernel.org>, <colin.i.king@gmail.com>,
 <patches@lists.linux.dev>, <linux-modules@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <pmladek@suse.com>, <david@redhat.com>,
 <petr.pavlu@suse.com>, <prarit@redhat.com>
X-Mailer: aerc 0.14.0
References: <20230313103439.1235909-1-mcgrof@kernel.org>
In-Reply-To: <20230313103439.1235909-1-mcgrof@kernel.org>

Just some comments on the code that feel a little bit odd to me,=20
while I was reading the code.

> +#if defined(HAVE_LINUX_MODULE_H)
> +#include <linux/module.h>
> +#else
> +UNEXPECTED
> +#endif
> +
> +#if defined(HAVE_LIBGEN_H)
> +#include <libgen.h>
> +#endif
> +
> +#ifndef MODULE_INIT_IGNORE_MODVERSIONS
> +# define MODULE_INIT_IGNORE_MODVERSIONS 1
> +#endif
> +
> +#ifndef MODULE_INIT_IGNORE_VERMAGIC
> +# define MODULE_INIT_IGNORE_VERMAGIC 2
> +#endif
looks like that the #define has an exstra space and this differ from the ot=
hers=20
.[c,h] files?

=E2=9E=9C  stress-ng git:(master) =E2=9C=97 git grep "#define" | wc -l
2830
=E2=9E=9C  stress-ng git:(master) =E2=9C=97 git grep "# define" | wc -l
1

Cheers!

Vincent.
