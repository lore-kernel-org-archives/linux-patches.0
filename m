Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476BB6135
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 23:05:18 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id c9so9631221qkk.6
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 16:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=03xHIim8cJwL2orZIsFEEaPEGZ5A0SO9Xy6iHS5VgRo=;
        b=CLAQbMcLQlcO5FDKowqIzEN/KN92ak2XZyugeDeBWg7w2NposY2Jj0vc3RKSyaipPC
         5n+rz5aN9vrZdZcWobBxzExvlxNeAKQ+/ORw9XCHzmowsMF8FfKOBcIgL7f+sBLdAcVE
         pzG6rVKv/POhYE0VTsQSMArU1JrCgmEL0sSco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=03xHIim8cJwL2orZIsFEEaPEGZ5A0SO9Xy6iHS5VgRo=;
        b=qaMDbtfVvLZvNhz4gHPk2OviysHlhXYdCe0cclMsSysOl2cjm/TbroXezMkbHgMK0a
         r7zJzz0d4WN2SfZvGDoK4ElHUe0GJ+K6msNPxUvaQni5bWsgjfxgE+heElrp46YoUGfi
         r/Ca+wfn2BbXVyL8JwRo4ScUEBX0kvPaontAs/uO7kfRmd/amtDiiRjVcYq7AhOyo49g
         ivb8KMcRG5i6S3XvxCY47539bW8+AuyU03Wct8FpQCeP5EbL4LuEkpWlSvf2Jor5GM6d
         8+DsShW14Q29JcGeKiPBWXPL4eNUk7ZYnYsCJP5dbUi9TOl/ZoQeeUYuLLhOR9TzPAJ/
         fdGQ==
X-Gm-Message-State: ACgBeo20b5ho14swlS+h7R0G5ekpbz/RCiC2dYXrHK12JOPKSkse4Imz
	WGuq5OKOO/43cLFph95Db3l9tQls5i0Ll3k7ep7DJA==
X-Google-Smtp-Source: AA6agR5RMu+MBNHzM+xUm2TPO1Kqe1FQ42HmfdhzT9rRFEuR+Os0L/+2NDY1lvV3K+ZVgoBLveHvEHFmFHN2ebLu6kc=
X-Received: by 2002:a05:620a:4088:b0:6bc:60a5:bba9 with SMTP id
 f8-20020a05620a408800b006bc60a5bba9mr13980652qko.170.1661900717259; Tue, 30
 Aug 2022 16:05:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220830225831.2362403-1-swboyd@chromium.org> <20220830225831.2362403-3-swboyd@chromium.org>
In-Reply-To: <20220830225831.2362403-3-swboyd@chromium.org>
From: Prashant Malani <pmalani@chromium.org>
Date: Tue, 30 Aug 2022 16:05:05 -0700
Message-ID: <CACeCKae7ZCATSyHMupDynVye+CyKAqQMDU6GPKPXhf5Zibjihg@mail.gmail.com>
Subject: Re: [PATCH 2/4] platform/chrome: cros_typec_switch: Remove impossible condition
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Tzung-Bi Shih <tzungbi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 30, 2022 at 3:58 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> The type of 'index' is unsigned long long, which can't possibly be less
> than zero. Remove the impossible check.
>
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Prashant Malani <pmalani@chromium.org>
