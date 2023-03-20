Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1416D1B;
	Mon, 20 Mar 2023 19:31:10 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id o12so51120873edb.9;
        Mon, 20 Mar 2023 12:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679340669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YGhymUT7Av6T4tSQafa+6oPxUxU1Po/EP5Zx4hiyIzk=;
        b=j9rjklNDxt1T9H4BSDdOtvbKi9dW157aq25t6svt9zrCnUXDdpbUNUXhhDMeJvLdpD
         1lRbj7UsVFv4HeXh0tE+3DMJKDq2cj2Up+he2RTamUQU0sP6z9SmAspXlqWlcsWIfGNl
         KLCfYkLlzwqMxrna/mNLlOC5yHL5XYxWYu3AIzRug35Uc2gdeSSjNfO2SGB7sT4fW3LF
         wyYiEaAb7RXzxIWCMGykh4kQOVs6fB21RO2Uyom/1p+NGiOqAtdHUS+tMqI1nDW47PNF
         Ncx3wkmMk0ul161dyCu4Xpwy2xomqWk5A84XvpjsZ9m+x5ksm8y+pGl4Td6Phu/PcIFP
         CY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679340669;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YGhymUT7Av6T4tSQafa+6oPxUxU1Po/EP5Zx4hiyIzk=;
        b=JgMwBISoY/QZ4soo0SQ3tjKwMk0ZXtMxug1MoRTr9yTXS80EPzgRq+FE1V6dPxJSaA
         j4867KQLcreIywMPUEZULvVQmTDIih9SCr+Z3zoHGiRnwys3KpghLmKSmsuWWwRKbgR5
         vMgnkIeIG+JI7UtgvdEi/4vyFoAPwR7oj+NTwSLZtgEujIJZtJUWgikHDYbW3NzRcwJT
         az90tqyXamFF/bk7nIpIa+U8iXSsdJobFdlhNU6Mh0WdZnBJ5940cC/TnMXA9AEaFmTn
         fZRkdRMdPzV1mLqID34VNiN4gY7/dbK4UzLouQkvwh2wBafic84fW2984W7ZQR6eR/mT
         fWdQ==
X-Gm-Message-State: AO0yUKVrHRZwdW9VMpsgS2+t+5XQWR23n6yvUq684lwETv/+6W2ohreS
	gj2tYZ8GFST1uCdEobJFz2E=
X-Google-Smtp-Source: AK7set9+EjCitae2DZXL+LRhp/xxIq5Qd10kjPXzYaFzMZV4KM/xIra8+4q7BiTvF75fgM7Yt/6luw==
X-Received: by 2002:a17:906:7f99:b0:931:59f:d42 with SMTP id f25-20020a1709067f9900b00931059f0d42mr185418ejr.29.1679340669025;
        Mon, 20 Mar 2023 12:31:09 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.55])
        by smtp.gmail.com with ESMTPSA id cd2-20020a170906b34200b0092c8da1e5ecsm4803191ejb.21.2023.03.20.12.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:31:08 -0700 (PDT)
Message-ID: <5428d01b-ec02-df42-3272-a4dcfea2efd9@gmail.com>
Date: Mon, 20 Mar 2023 21:31:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] staging: r8188eu: delete driver
To: Richard Weinberger <richard.weinberger@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Phillip Potter <phil@philpotter.co.uk>, linux-staging@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Hans de Goede <hdegoede@redhat.com>, Martin Kaiser <martin@kaiser.cx>,
 Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org,
 Jes.Sorensen@gmail.com
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
 <660ef0b7-fb09-5a72-57b1-3b57ddee924e@gmail.com> <ZAxZCJn7AN/yWSRh@equinox>
 <ZAxx1kYjVKFRE3kz@kroah.com>
 <CAFLxGvwKaXviF=5OTtm+pPHwdtXTX6A2e_aRTUraOsxKOL3-4A@mail.gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <CAFLxGvwKaXviF=5OTtm+pPHwdtXTX6A2e_aRTUraOsxKOL3-4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 14/03/2023 10:06, Richard Weinberger wrote:
> On Sat, Mar 11, 2023 at 1:25 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>>>> Also the rtl8xxxu driver supports way more devices, and is a fraction of
>>>>> the overall size, making this a much better overall solution.
>>>>>
>>>>> Thanks to the r8188eu developers and maintainers and reviewers over the
>>>>> years, your work allowed Linux users to use their hardware before the
>>>>> real driver was implemented properly.
> 
> Both r8188eu and rtl8188eu had support for access point mode but
> rtl8xxxu has none AFAICT.
> Is there something in the pipes to have AP mode supported?

Indeed, rtl8xxxu only supports station mode. I have been thinking about
adding support for AP mode at some point.
