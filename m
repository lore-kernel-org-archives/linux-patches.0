Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E55DA96;
	Fri, 10 Mar 2023 19:08:53 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id g18so6428246ljl.3;
        Fri, 10 Mar 2023 11:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678475331;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5aAsGyVx7NR5HR+xvNYcoRf6KVgVqRWKFB6FO2GAIJA=;
        b=Vtz7Nmt9yoM4cZJAd4Ac/Lz5W1ayYre4GZ4trac1YWMbDvMTha4GS/2mEqQi1XKwaa
         l4h8yDZu0Va957lrgp1DW9AxkF3IW27YWn9SlWst8zTIcF5Vqb3ndk39YlLZCJ3EaRfb
         QkoxjljEs+EHQOrmdJ1GEdz8AX9fg8FV9eIUJt4GeJS9sP3Eu+sm2D7wHYc14eqgq6EN
         /zfCa135Kj9lLWH8CkgLhdA3lv4/ey5CdOcAEw4q6y4Sc3UVgLehZh453fpGBdtg0QvU
         jG1oka/PXnsDYABLF6Mdmm3grLtFB6UbZt+7LST4mcGtZl/nOL00LnLskwDfWmzYIlVQ
         RKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678475331;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aAsGyVx7NR5HR+xvNYcoRf6KVgVqRWKFB6FO2GAIJA=;
        b=GFuGFVbEFPrvhHDxGdvbrCtr/ixEfeHaHzwEgRDH7SOrm1sXP9AvWCdcXHMc8pEfmZ
         qz+oMs23zGVeOrnPgMPOH1mOCTYwqcdHYsU7okaYKA888P4IGR64zSIL7Cw84JEljHcV
         nZt4wDknr4mQXFbgEh1xSct/7ZBOAXr8VXszDNjyZBBuCQHR2Ls7+FwrR8MstUOlFwp1
         91tMWzjR98Eln+7LL/HTThhtoXaTWXE18okv7eCBhWviAUyxsatXFZ1wq1knkGwMi9IY
         oF881k9HQmIhcAAl1PRmQqPda/Z0zuT26dpZjOWxxU8o1gqjgB2VxCzcM+BRwdqeOZs/
         b7Pg==
X-Gm-Message-State: AO0yUKXbEe8+4Bg92Sqje5YKqKHC35QimivMTF+t8w2QF4SzGgbT/UUv
	9vBOIQtJvvjhBcOGU0HWZO8=
X-Google-Smtp-Source: AK7set9/3pAcpnd/tpmly8oKdr2X6da4QN4Rphc1UEr7Lsx9gJSNMfzLIyA8p2JVtxUv6qcGSzCLZQ==
X-Received: by 2002:a2e:720c:0:b0:293:4ba1:a78b with SMTP id n12-20020a2e720c000000b002934ba1a78bmr8007295ljc.25.1678475331101;
        Fri, 10 Mar 2023 11:08:51 -0800 (PST)
Received: from ?IPV6:2a00:1370:8180:6b00:a1a8:4887:1af4:637a? ([2a00:1370:8180:6b00:a1a8:4887:1af4:637a])
        by smtp.gmail.com with ESMTPSA id bf37-20020a2eaa25000000b002946be8475esm95843ljb.135.2023.03.10.11.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 11:08:50 -0800 (PST)
Message-ID: <660ef0b7-fb09-5a72-57b1-3b57ddee924e@gmail.com>
Date: Fri, 10 Mar 2023 22:08:49 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] staging: r8188eu: delete driver
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-staging@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Hans de Goede <hdegoede@redhat.com>, Martin Kaiser <martin@kaiser.cx>,
 Larry Finger <Larry.Finger@lwfinger.net>,
 Phillip Potter <phil@philpotter.co.uk>
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
From: Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20230308131934.380395-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

Greg Kroah-Hartman <gregkh@linuxfoundation.org> says:
> Now that the same hardware that the r8188eu driver supported is
> supported by the real wireless driver rtl8xxxu, the r8188eu driver can
> be deleted.
> 
> Also the rtl8xxxu driver supports way more devices, and is a fraction of
> the overall size, making this a much better overall solution.
> 
> Thanks to the r8188eu developers and maintainers and reviewers over the
> years, your work allowed Linux users to use their hardware before the
> real driver was implemented properly.
> 
> Reported-by: Hans de Goede <hdegoede@redhat.com>
> Cc: Martin Kaiser <martin@kaiser.cx>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Phillip Potter <phil@philpotter.co.uk>
> Cc: Pavel Skripkin <paskripkin@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

I guess, I am late to the party, but if it matters

Acked-by: Pavel Skripkin <paskripkin@gmail.com>




With regards,
Pavel Skripkin
