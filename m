Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D9F20E2
	for <patches@lists.linux.dev>; Mon,  1 May 2023 12:08:59 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3f178da21afso14383885e9.1
        for <patches@lists.linux.dev>; Mon, 01 May 2023 05:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682942938; x=1685534938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vUdzf3IvEdsxulw0zrmzJtlZgtzcorWmwsr5oTBgspM=;
        b=yqgRWU3yM9bRw+uA0Y9/HD9qijSv2+UeJZvq2k02CwctK0NGULzDsHbDN2u7d+niop
         fCSv60Fh0cNlH+EfXfbe78rXGb/KYAu+tsx92E9NikV0hgnuCeVpYdbWiOKMdAKEKQko
         i6jNWeMa6lm6/KQg2mZje9mZZqPcagqsINJQ3QBmK9IHJwZi6zuT0ZttriADi1fnhBn+
         ifaVnQXOMCF9iAm8cMYCfna8LsZ0uAw5McQr7C7jcEBr1JTTmCiUSMZJu/DiGcEZ3gLj
         DDBDqeN/xYmEH285DjzyDeAGbNdh6srvuvXakQCjeZOoXi7n5TNa5lSkjPpGwp5P6AVm
         ocYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682942938; x=1685534938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vUdzf3IvEdsxulw0zrmzJtlZgtzcorWmwsr5oTBgspM=;
        b=UPpDmw+REnfFO0UxW9ihfaopeEWZWgeyq8G+fQENeDrZsE0Vn7jf/u+Y/k78Dyh24v
         If4YtBOcV2wrEsBpIveH6P2ShvgWqlZ3cGjPikTaaKY96kxNsoZU6fX5DDdDgD6Z5DWJ
         pNUUo/8bGD/HmQsM22IPy7V14g0YFpJGC01h6DT+Q7jmzIE+9skygrG7+Tqb3+AA4Nck
         kHAwMb5kus0rsfFj9bR3cyuLIjzinyiWwehXSx+aLBZOn3Xnt0J1hzNrBz7VvQjhmdiS
         A4N5O/addRU6aCuDv/EmKGU320svEMnhpXjyWwWr/mbJAMSH97W0eK5EKOjs+p6c9bCi
         ED9w==
X-Gm-Message-State: AC+VfDw0dnMsoOo7vzvumJlWq/Yo5gGjoLSuGLSfIAXbS+jX4JapjdRA
	VgZn1Ur0h5WyPWUQuh1VXyWzeg==
X-Google-Smtp-Source: ACHHUZ54tiiVMytDtdZbk+O+s1aS7DXww0a8qsgFqay4XxReSxz3IOKsL6LnMUBSO1RrgEU3WOXjCQ==
X-Received: by 2002:a7b:c8c3:0:b0:3f1:6f53:7207 with SMTP id f3-20020a7bc8c3000000b003f16f537207mr9467082wml.17.1682942937646;
        Mon, 01 May 2023 05:08:57 -0700 (PDT)
Received: from ?IPV6:2a05:6e02:1041:c10:492d:9712:4f67:3b93? ([2a05:6e02:1041:c10:492d:9712:4f67:3b93])
        by smtp.googlemail.com with ESMTPSA id d9-20020a5d6dc9000000b00304adbeeabbsm11417548wrz.99.2023.05.01.05.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:08:57 -0700 (PDT)
Message-ID: <db038749-253b-cafc-2346-d684c81461be@linaro.org>
Date: Mon, 1 May 2023 14:08:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] soc/rockchip: dtpm: use C99 array init syntax
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org
Cc: patches@lists.linux.dev, Heiko Stuebner <heiko@sntech.de>,
 linux-rockchip@lists.infradead.org
References: <20230501024950.31518-1-rdunlap@infradead.org>
From: Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <20230501024950.31518-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01/05/2023 04:49, Randy Dunlap wrote:
> Eliminate sparse warnings in soc/rockchip/dtpm.c:
> 
> drivers/soc/rockchip/dtpm.c:15:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:17:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:20:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:23:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:26:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:29:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:32:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:35:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:38:12: sparse: warning: obsolete array initializer, use C99 syntax
> drivers/soc/rockchip/dtpm.c:41:12: sparse: warning: obsolete array initializer, use C99 syntax
> 
> Fixes: b9d6c47a2be8 ("rockchip/soc/drivers: Add DTPM description for rk3399")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: linux-rockchip@lists.infradead.org

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

