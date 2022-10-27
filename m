Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDFC7B;
	Thu, 27 Oct 2022 21:00:19 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-13b103a3e5dso3932345fac.2;
        Thu, 27 Oct 2022 14:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDrH9NbSmg2MxkuWrwWx7O4eXK81KiWq00+glvya1gY=;
        b=I5rJpeCz7L3Vpb7k/Dxby7j2LLzmw0Wo5Er1Tl+UqPxpPOAXosKX+jboAIkPDYTki0
         um/Sa9+ScWmJWa9X5eKmu6SQF1FLplALqsxSQdz229GnRoAIibGdsXSmaOelagRWI3pL
         sJvmX2jMr7hy6y/O2YiYK2vQFQOpwxzUpkciJ5depcoBWWEq5/mdmTCPu9niPgPo4YzZ
         0cwMjtlB8QGR82TBH+sOKUvBpMw2LbkFGxVAslMcbbKiU+llEL2btSnkI5uvkaBCIaYm
         UuIzT5WiwjROKZ/tI1W1/qMv91q4mb6zzHx3SJ8aizZAWDMh5yoOOF+6EePAH7WJz5HU
         Lkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDrH9NbSmg2MxkuWrwWx7O4eXK81KiWq00+glvya1gY=;
        b=SxPYNCt4ht8fwpG7U1O4dajjGExpIcQCWnFaXx8UZzxEmdQ6v2zLursr0eRa12el9B
         ntNMcBt+EDSYIetDfBnzMc1anAgshraJP6LrVAm7KzjobE74HUgdvUSHyYkxdgKZl8g6
         JjrplkKIiawLAwwzmHtnk6dNVt0+BE19EQLZnwrlyRkYX/X2PoM2rAOdxPfRb3e6n/is
         HoArYdwtRQEBiJfUpzY18jsRwCWJpvhPXYn4GoeoNG7GK9PjF37C6SKP9xnMluwPBFXM
         spVZOk/QBjikJF/Xnucd51NISqerfZG6xwd1/SL/n4+96bRLYKxP0mo/hMr8kCTRXYNO
         TzsQ==
X-Gm-Message-State: ACrzQf0bHN/BQsvD6PCTKiPUWU/V7l/iPCcwdeoZrscplEPlkNC9RM7I
	72Woz4NAZBSL/R8FdWv3Jyk=
X-Google-Smtp-Source: AMsMyM7ZFPu3XMVRljKKEsD87evoffo4TxYuSL7R+ljCGk3sZMJKHHUt0o4m7FmYCkc/BmeCXd661g==
X-Received: by 2002:a05:6870:e307:b0:137:542d:7360 with SMTP id z7-20020a056870e30700b00137542d7360mr6880014oad.78.1666904418270;
        Thu, 27 Oct 2022 14:00:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 126-20020a4a0384000000b00480816a5b8csm879646ooi.18.2022.10.27.14.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:00:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 27 Oct 2022 14:00:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jean Delvare <jdelvare@suse.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Quan Nguyen <quan@os.amperecomputing.com>,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH -next] hwmon: (smpro-hwmon) Add missing break in
 smpro_is_visible()
Message-ID: <20221027210016.GA1938309@roeck-us.net>
References: <20221027195238.1789586-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027195238.1789586-1-nathan@kernel.org>

On Thu, Oct 27, 2022 at 12:52:38PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   drivers/hwmon/smpro-hwmon.c:378:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
>           default:
>           ^
>   drivers/hwmon/smpro-hwmon.c:378:2: note: insert 'break;' to avoid fall-through
>           default:
>           ^
>           break;
>   1 error generated.
> 
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing break to silence
> the warning.
> 
> Fixes: a87456864cbb ("hwmon: Add Ampere's Altra smpro-hwmon driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1751
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/hwmon/smpro-hwmon.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/hwmon/smpro-hwmon.c b/drivers/hwmon/smpro-hwmon.c
> index ee54e21c2c12..667e88b6bae5 100644
> --- a/drivers/hwmon/smpro-hwmon.c
> +++ b/drivers/hwmon/smpro-hwmon.c
> @@ -375,6 +375,7 @@ static umode_t smpro_is_visible(const void *data, enum hwmon_sensor_types type,
>  				return 0;
>  		break;
>  		}
> +		break;

The alignment of the break; statement above is also bad, and a default:
for switch (attr) is missing.

Guenter

>  	default:
>  		break;
>  	}
> 
> base-commit: 0ffb687b6508c36a17b99bdaf014b38532404182
> -- 
> 2.38.1
> 
