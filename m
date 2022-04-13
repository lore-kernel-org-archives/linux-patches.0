Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA232F23
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 21:22:15 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id j8so2995974pll.11
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 14:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4omrGBh4rMwEJEaoEHmM1XJRtehHXwGUeZy3KwoVcfc=;
        b=JHwn8yeQUIn0NLauMr393piIbTf3OTdCg4uXX41ukSp+4RGipfV9bBe8uRCqMHQlMX
         9S25rGSI3H+jBJ3AxQi2O0+xwcLfAeUPoncKPZXif+9g/IDp5dFHaydwnhjQANt1yLkX
         GyJs2zPbkf1G739gFU7CyFtLQ+Hj+1YOi7cWu3kWoOrz/uV1Z437+TvYQ0lzA9rafhT7
         uJIpadx77lSEA+Ry1z4neKG0sFKUF6fjIWOksJjovqetFl6uM2NWsDNj2hQ4DaJHC6NM
         AT+4sAQSWhMPQElg5pijJvYjZFQevAs1L2uYm7r9kasb7Oo/ecs3QY3jm2SnWWRZMTyP
         gytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4omrGBh4rMwEJEaoEHmM1XJRtehHXwGUeZy3KwoVcfc=;
        b=jMv4/mtPMBQ76Qty6WDLP/duUcCeXiOhcmLpIJulFl42vSOOCuljVCuwpsupbGuvaO
         8+O431ApkWpaWnWi00E3/ddeBIymelwVhgmPnjLKB2aca/XUyVitISRb3Ex8NTI3rfdB
         MPWK27c1tiyG8LGbAObS6sC9TPCWG8v8i+a37SuKLazBE1iATKWRuAJTTPywo8ZTK0BG
         GAQ8YryqkrLGJn1zCMPPbbylV71RYbTwoByzvyG8meeQ0Z68t7i8Jz3PLAMiaHGMZ0ML
         SyX8zP81ItZvnUFS9b/DiFzF+x5cA0CU2pfatXh0B1Zj0JHrhuIn75AmR0QeVgADiPeq
         wraQ==
X-Gm-Message-State: AOAM530nXZnMgJggfIoKQ7cYcfmCqo5x7+bSdoEZS9Pkftdy0a1h1jKJ
	W0WDjttsrRXSFis36a9Lek0w0xVuHyAexYJTRF1fQQ==
X-Google-Smtp-Source: ABdhPJzJ1KuMUw+23/AIxQgzDx5RbhtEYcoArH9fBDCciyTF6G30/td30jwZCE13hnZ4ygVGIROTwReA5Afzf8G+BBY=
X-Received: by 2002:a17:90b:1804:b0:1cb:82e3:5cd0 with SMTP id
 lw4-20020a17090b180400b001cb82e35cd0mr743163pjb.8.1649884935282; Wed, 13 Apr
 2022 14:22:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220413183720.2444089-1-ben.widawsky@intel.com> <20220413183720.2444089-2-ben.widawsky@intel.com>
In-Reply-To: <20220413183720.2444089-2-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 14:22:04 -0700
Message-ID: <CAPcyv4jJxeQ4MxG=coe+J-qsdDVZxP7f5oXSR0QkJoJ0d2tSdg@mail.gmail.com>
Subject: Re: [RFC PATCH 01/15] cxl/core: Use is_endpoint_decoder
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	patches@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 11:37 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> Save some characters and directly check decoder type rather than port
> type. There's no need to check if the port is an endpoint port since we
> already know the decoder, after alloc, has a specified type.

...a smidge more clarity:

s/we already know the decoder, after alloc,/,by this point,
cxl_endpoint_decoder_alloc()/

Otherwise, looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
