Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADDF54278;
	Mon,  9 Sep 2024 19:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725909044; cv=none; b=CCK+vWeiYklp28ffI4a0nRJfHi5HomPtYkxkruo7X1HYquGN5p6JpO2Q4PVDyv/xL2BKib6twlJN7Eh6d+96H4fMviaj2Zl7DqHb/5whgT5waC3lRGhYb8SvZlwpCDuLWhiA5Bd0eDE0WhzMgGKWTas/rzFOwp3/EieFfnkCu/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725909044; c=relaxed/simple;
	bh=oR9cwDqmVpiW55PzkayUy0i6c1cKTg9o+4ITLiEGDoQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m0KHQlY/1E4KY5rQCwYAYBE1fEgBvYsDUDtjA7WNzcdKJS3I9jgrV3NgXekh99J1Jj3yL5bcoTHTCbJ9RQj0yCaKG31axZvIMhoeh+UXCj362i4sbLMAvNDf7fyLpKeym7+JxnfsPGrYdbjGyc2raTxxHqln4mQt06QlryxjA4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlgDw1Fh; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlgDw1Fh"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5365392cfafso4467258e87.0;
        Mon, 09 Sep 2024 12:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725909041; x=1726513841; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PLAaA+GP0TBFIHxcYRpcjwhyfzRqgjOI+EgC7yPQbeg=;
        b=SlgDw1FhEtExCoESAr1buLll5VtnGKG/CfsEsdkNXTiBpQHLwxgJL3oATYOVX1+cwq
         CnqrjZlET0qUpQggaXsWFGtZbN/2aXziyYQQo9c7u3cZubEM/fnULkgLjLwixKCLVoeP
         6B8EaidUoAKTuIor4udOxESG0j1BVetQ2dKjizuaDo4ufMfTqOB5ge8r/m5CZEcNgEOr
         QoS3jSFTUn2osLo+82I8E9pVOKnU2BsMCwpavpBei4Rfc37+8DpotE0TsyqDkSLyiDUY
         O3mR+U8f6GS877rNdTEq/EdSXOfonNyGURCiVZpD3cTSoTndrHy6Q2zafeIqKwM7f4Fe
         cYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725909041; x=1726513841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PLAaA+GP0TBFIHxcYRpcjwhyfzRqgjOI+EgC7yPQbeg=;
        b=I7ikXYY8dQepHJGNRoPzc/9pTIB2Boqu1iOs+vjth5uPvDylbV11sZzSbVs1WRrrHZ
         RQSi3TzoBM+O9ApnNHPr0zmQFa3ge2NdqbxwEaTi32H2ddF7Nc78QKIqGAh4Swmxkop2
         m1LYxGOwzZr3fQSuVM9R3oJF4544geT3ygcGLymhcqAa9VpCAyq8Wx95bgowdyuh+n96
         YIRi9LfqKfppmRdVle0rfs/5ATkLflyIkUNc+SvxWYLaNsQcVxuGjU0E78KoKn2r7sP+
         cf4i5M0T0gKePxhDJGACfDaSks3OBB8vXQqH/EMaHdHIT81fxiPOLzQk1Xm+UEanmP8V
         ja5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUbiDYusbqVv7xuvh7AvhRefB+p6TtBmQBBq/N9k0ZaOp3IxUY1Gh4Gc7I5kJRLh/+cEN3jOOLgdQ==@lists.linux.dev, AJvYcCWfh+Dx3CRXpDax3GYLHUiqMA+crpUsDkRthbzNvCzD9q26jqLJs1qqZDQIKosLzNY5xpp4@lists.linux.dev
X-Gm-Message-State: AOJu0YxdMDY327rUXrMDMus4Qf2CAkdyIxaAadnLUHd4HYbHGTdFL3hu
	SXJwNpZwijxXXyxz+DBj8isdAKM/gTV6glVBijjUvIz6TY7+lmtA
X-Google-Smtp-Source: AGHT+IF41hgBa0SxOWn1cUbeQ5vTlr2BJxXvbK0+wa15NzG/X9ZZ2BMzYZ3n1zFCSCFbcTTt/f5RAA==
X-Received: by 2002:a05:6512:4018:b0:52c:df8c:72cc with SMTP id 2adb3069b0e04-536587f9a5amr8810728e87.43.1725909040414;
        Mon, 09 Sep 2024 12:10:40 -0700 (PDT)
Received: from [192.168.1.127] ([151.95.58.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d40cebsm374629966b.200.2024.09.09.12.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 12:10:40 -0700 (PDT)
Message-ID: <76068b7e-af53-4422-ad97-cf3070182ec4@gmail.com>
Date: Mon, 9 Sep 2024 21:10:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iio: bmi323: Fix array reference in
 bmi323_core_runtime_suspend()
To: Nathan Chancellor <nathan@kernel.org>,
 Jagath Jog J <jagathjog1996@gmail.com>, Jonathan Cameron <jic23@kernel.org>,
 Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-iio@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20240909-iio-bmi323-fix-array-ref-v1-1-51c220f22229@kernel.org>
Content-Language: en-US, it-IT, en-US-large
From: Denis Benato <benato.denis96@gmail.com>
In-Reply-To: <20240909-iio-bmi323-fix-array-ref-v1-1-51c220f22229@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/09/24 18:38, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR):
> 
>   drivers/iio/imu/bmi323/bmi323_core.c:133:27: error: variable 'bmi323_ext_reg_savestate' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
>     133 | static const unsigned int bmi323_ext_reg_savestate[] = {
>         |                           ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> bmi323_ext_reg_savestate is only used within sizeof() through
> ARRAY_SIZE(), so it is not unused, but it will not be emitted in the
> final binary because sizeof() is evaluated only at compile time.
> bmi323_ext_reg_savestate should have been used in the second parameter
> in the call to bmi323_read_ext_reg() in the second for loop in
> bmi323_core_runtime_suspend().
> 
> Fixes: 16531118ba63 ("iio: bmi323: peripheral in lowest power state on suspend")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/iio/imu/bmi323/bmi323_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/imu/bmi323/bmi323_core.c b/drivers/iio/imu/bmi323/bmi323_core.c
> index 671401ce80dcf947b7b64ea3af112d2a42ca5501..64dbce23ce17bcdd11c0d4c454dbeb9de17ef56c 100644
> --- a/drivers/iio/imu/bmi323/bmi323_core.c
> +++ b/drivers/iio/imu/bmi323/bmi323_core.c
> @@ -2199,7 +2199,7 @@ static int bmi323_core_runtime_suspend(struct device *dev)
>  	}
>  
>  	for (unsigned int i = 0; i < ARRAY_SIZE(bmi323_ext_reg_savestate); i++) {
> -		ret = bmi323_read_ext_reg(data, bmi323_reg_savestate[i],
> +		ret = bmi323_read_ext_reg(data, bmi323_ext_reg_savestate[i],
>  					  &savestate->reg_settings[i]);
>  		if (ret) {
>  			dev_err(data->dev,
> 
> ---
> base-commit: 5ba0cb92584ba5e107c97001e09013c1da0772a8
> change-id: 20240909-iio-bmi323-fix-array-ref-a0672a8213f0
> 
> Best regards,
Hello Nathan,

Thank you kindly for spotting and fixing it.

Regrettably while integrating suggestions I received I also changed the patch semantic and due to my hardware not having the irq pin connected to the cpu this went unnoticed.

Best regards,
Denis Benato
