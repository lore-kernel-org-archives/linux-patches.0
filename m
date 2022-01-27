Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3800B2C9E
	for <patches@lists.linux.dev>; Thu, 27 Jan 2022 22:46:25 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id 133so3677305pgb.0
        for <patches@lists.linux.dev>; Thu, 27 Jan 2022 14:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/11zwmji6aqM+TcjzSqvFbPLSRncjG/b2Hrb4dKpUQI=;
        b=15IS/YZrVUUtEdVs3hk6GBcxlhbNtFSUbCWiXBLRAG9j/myRWYjG6yigkfRVywh7iu
         PIQUVgcRx5cgkYisLMWwiPqd8Vgb5b1DEaM3PrdqjIGm1EDWrxHpyGvIPuHMpQQJinV/
         DH1G5nnlJdBjr8+pzNxeRe8KUeolgf/blmIzn7LscLj3clxMoZgBtcWkzbOxElSiBrNd
         /JlRCUrBp73K9Oy2Xcki4ltKN7Y/apRN7tiGimHJht6b9d/BBb2IIu8BwPCHfVXHOvTt
         NoQUI689U/3K7Lf6PolammEtrD3FNX9H17dPA427gUkJxi+ivw0Wwo4JJNfFhaLBtaYa
         uyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/11zwmji6aqM+TcjzSqvFbPLSRncjG/b2Hrb4dKpUQI=;
        b=CXKBuf1h2nbxHSswmug72wlxd8BrXUtrSAkBxkMVt9ejkRYQlF+lXkXIlO+OlHJacM
         gOQM7K5HTrnVY4ARmiDde0oVT5X95mNQ4B3wf+eChtLEdo11zxU6GjEik/4ucq4L8DOo
         WJUYZeI6AyeJFnqsMWX0UYPxUy+R2Wvfw9dLd4Eie61ndGnuqdskEF1kmwohvs2ZrjiP
         SK3N965pjdI9dFlZENa6s+a+ebZrRbKYAKZCqV0U+xpn0B1dQ4VBsxnYjzDqE2xYBYL0
         a5jnWQhP8fnfP/Pnuq+NgtYc11Z8GHZUryNTJ6mEuz/CMqJ6jGg80oSv2M8jEGZzq+vH
         DLmg==
X-Gm-Message-State: AOAM530qMfAEeBpw61cNmLMa0F8bSgDkJxgrimPeQ1oyzqloJ1PS/DEg
	3d7I7eTmfJG+tYBMWDoSGIHQhJOkxU3arNyw/ITHOQ==
X-Google-Smtp-Source: ABdhPJzaGVV9a6xmMmBvhXo3f8rFaIdDjDQ85ZmsKBIALsl3fi+U5V+UBW+LxWY3JCS14UjcCTeyY9ImHKM2F4MKCds=
X-Received: by 2002:a63:4717:: with SMTP id u23mr4483852pga.74.1643323584813;
 Thu, 27 Jan 2022 14:46:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220127212911.127741-1-ben.widawsky@intel.com> <20220127212911.127741-2-ben.widawsky@intel.com>
In-Reply-To: <20220127212911.127741-2-ben.widawsky@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Jan 2022 14:46:14 -0800
Message-ID: <CAPcyv4hEB2BBcNUeRs4m-p5BwkLNd3cHWjFFYVWaZaLOtE_DOQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] cxl/acpi: Store interleave granularity absolutely
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 27, 2022 at 1:29 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> This matches the usages everywhere else in the driver and matches the
> existing kernel documentation defined for CXL decoders.
>
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> ---
>  drivers/cxl/acpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index f64d98bfcb3b..f99cad8350fd 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -11,7 +11,7 @@
>
>  /* Encode defined in CXL 2.0 8.2.5.12.7 HDM Decoder Control Register */
>  #define CFMWS_INTERLEAVE_WAYS(x)       (1 << (x)->interleave_ways)
> -#define CFMWS_INTERLEAVE_GRANULARITY(x)        ((x)->granularity + 8)
> +#define CFMWS_INTERLEAVE_GRANULARITY(x)        (1 << ((x)->granularity + 8))

Looks good.
