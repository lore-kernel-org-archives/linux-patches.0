Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF05A8462;
	Wed,  8 Mar 2023 18:22:49 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-176b90e14a9so12026870fac.9;
        Wed, 08 Mar 2023 10:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678299769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=8z6n4C9XCAy5Bw4ajsCdMIph1S7zKL5qZxtL5AjXJBo=;
        b=FQemDoLY2ZXL9MuSOsQ1LEnLoobDl7UTBOXq5NhxdYdBygo/MHA4FIyoM9OX4v0djM
         NJoWvM8SaxmFdz2Nv48yn1z2d3ITwHIRvV3efQKEQ4B/ectCd6z+caMem4x1CVw6xUHO
         6gloshNqIDzg5AE8AAepQBGk1bIMLxCFGJZDf/aFWDNhq34sJcJZpes5ea5V6QH6vuvx
         PyUZlMdfnZvxvOf2+IkU5lbMVUx4h4kYcYdNcmLyItCfxRHQP6lzViOaB4Ndhm5mkD6x
         tFd5B2kN5fjG01kbsw8jwpBK2G3JSDLDheF869pBpoEN5oR1QDG1bAGwR22MykVNW2Ve
         tEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678299769;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8z6n4C9XCAy5Bw4ajsCdMIph1S7zKL5qZxtL5AjXJBo=;
        b=B4T6FjO0snjWS1xTx5ScaD6oGTdyy7pXQDyfAdPcJ+YoZMz+zArxL6mRFb3bxg6FF0
         qQcZz0UhHlWRHC+7jJcH8Zuvz+NzhH21QqaCzKUxqKaDSYf9drKOFrxsYhIflbsnl30h
         8eaT/w+ebZwCnDXjrN6Z7G/Oqyanwrh88Xxk9GxyucKkLrRcmdaWLi/s1n4kXZR/9+k4
         +S1qCvnkqj+67FLwU1YVwoBwEKy5812hFIEr1IoPFEpGQ6r+tx7e+InSWVi9AqAv/tA/
         ebdYWHxyKenwTZLgWMapbVT/n/6zFtMFQKPwrdG48GWSkSk3dDFM3E81M+G9igLrbnur
         PsBw==
X-Gm-Message-State: AO0yUKUOkOjggemg0OjQA/QbgO/ciGKZ4MoLvC/jdUvP/rPlez8M94TK
	12pwb/S4tv/Dxs2+O7ddR3A=
X-Google-Smtp-Source: AK7set+w1q0e+Y/3UYZQjFrI2TwtL046YUtJOne6Q9BeFnre51uAeHILEQb48rkjPcwNZUbG2XqdJQ==
X-Received: by 2002:a05:6870:73cc:b0:176:4920:bf8c with SMTP id a12-20020a05687073cc00b001764920bf8cmr12070018oan.55.1678299768839;
        Wed, 08 Mar 2023 10:22:48 -0800 (PST)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id v2-20020a05687105c200b0017299192eb1sm6391758oan.25.2023.03.08.10.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 10:22:48 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <c5721099-ef49-feaa-1624-813ba2034cd2@lwfinger.net>
Date: Wed, 8 Mar 2023 12:22:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] staging: r8188eu: delete driver
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-staging@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Hans de Goede <hdegoede@redhat.com>, Martin Kaiser <martin@kaiser.cx>,
 Phillip Potter <phil@philpotter.co.uk>, Pavel Skripkin <paskripkin@gmail.com>
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230308131934.380395-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/23 07:19, Greg Kroah-Hartman wrote:
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
> Reported-by: Hans de Goede<hdegoede@redhat.com>
> Cc: Martin Kaiser<martin@kaiser.cx>
> Cc: Larry Finger<Larry.Finger@lwfinger.net>
> Cc: Phillip Potter<phil@philpotter.co.uk>
> Cc: Pavel Skripkin<paskripkin@gmail.com>
> Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>

Acked-by: Larry Finger <LarryFinger@lwfinger.net>

This staging driver satisfied a need at the time it was first added to the 
kernel, but that time is over!

Larry

