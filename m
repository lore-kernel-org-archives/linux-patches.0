Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAEC7F
	for <patches@lists.linux.dev>; Tue,  3 May 2022 00:50:15 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id e15so17699355iob.3
        for <patches@lists.linux.dev>; Mon, 02 May 2022 17:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bNXNgphksGo4k32JcFbuZKqXbM115Hb6FPq1B94vQeM=;
        b=Rezn3JQ6zF/Pi8M9aA1wO0xhxWizrPKMRDsqUGbYAZg8yqFRWcJaRypJtv5uRCgFXY
         4u0tvKxQjQ0mcYDb6Pln0swgyB2V5ucmZbpaxNutSb8utdI7qglXN/vdRtWK4U83G2nr
         g6sOuiwjhlNvebxssQuFwKNY5T1P6wRvS3uIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bNXNgphksGo4k32JcFbuZKqXbM115Hb6FPq1B94vQeM=;
        b=rZorSIZFI6BfSjJtx0M1Qz+NnSNd5b0/kp68MMsoaSINXKFGbbA/sljtmn2ofKh9HH
         mb3UWW3hFomKhOPg5VYHItpvbpCjReSNPhUi9PtFcNCP0mku5c+Wdg63uHL2pyWTkYQT
         dfOyKEJOgvigPRzQhMf/pRcfB1qYlXRiPKofXVePcKZAB1QD3SACZcb2EuIyu0PDaKmU
         63abXI95F8tgEGSwt3oxa6VyzPtOGOubT8SD3Vy7Ka4XpUDPYfVEUPH+DLyTCM08yMvx
         +B1r8K1iJj6q/Pb6N++0tplTA5WubLANBrFvDwy5hQvc90AcXt1pfW8OJjPLepPLylg+
         jYrg==
X-Gm-Message-State: AOAM5305hMrhwvHVxNacqcg2SHpz31tjnQi+gnkxv7QQAcsOVpPptMzq
	duiz6uD7/3LJdgzObOm8DiRsv87oIU1JZMqXboSjEA==
X-Google-Smtp-Source: ABdhPJw3w4b9qZ7bxbY+0GUCILNFuzlVGSUn99TvdEm0g+1Qi7nOeOfG/n86dBAPua1rUpWz+FsC7/BlTV82HpJFeCo=
X-Received: by 2002:a05:6638:4905:b0:32b:5bc3:4e3 with SMTP id
 cx5-20020a056638490500b0032b5bc304e3mr4528580jab.37.1651539014154; Mon, 02
 May 2022 17:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220503004156.3559940-1-swboyd@chromium.org> <20220503004156.3559940-2-swboyd@chromium.org>
In-Reply-To: <20220503004156.3559940-2-swboyd@chromium.org>
From: Gwendal Grignou <gwendal@chromium.org>
Date: Mon, 2 May 2022 17:50:02 -0700
Message-ID: <CAPUE2usLO-sJLP64ZgBrzYBwuZf2tSvKvr9GxcVEiQk7d==OiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
To: Stephen Boyd <swboyd@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, linux-iio@vger.kernel.org, 
	Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Gwendal Grignou <gwendal@chromium.org>

Nit: you may want to add an example.

On Mon, May 2, 2022 at 5:41 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> We need to configure the sleep and idle mode of the CS pins for this
> device. Add a DT property to do this so pins are in a proper state
> during sleep (either hi-z, grounded, or pulled up to vdd).
>
> Cc: Gwendal Grignou <gwendal@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../devicetree/bindings/iio/proximity/semtech,sx9324.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> index d265eb5258c8..6cec3481c8b2 100644
> --- a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> +++ b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> @@ -126,6 +126,14 @@ properties:
>        UINT_MAX (4294967295) represents infinite. Other values
>        represent 1-1/N.
>
> +  semtech,cs-idle-sleep:
> +    description:
> +      State of CS pins during sleep mode and idle time.
> +    enum:
> +      - hz
> +      - gnd
> +      - vdd
> +
>    semtech,int-comp-resistor:
>      description:
>        Internal resistor setting for compensation.
> --
> https://chromeos.dev
>
