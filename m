Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F2E657;
	Wed,  8 Mar 2023 20:33:47 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id p26so10556231wmc.4;
        Wed, 08 Mar 2023 12:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678307626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V0PHdmmNJusG1epclYYmQTbwEIZkKSzfpFAnnbOVxlE=;
        b=TtKOv1V1408AuF6vuwpZW+5EVawzPS6WnKGiHr0wVcJgvgDHDr5ajirvjs+VWAnwe+
         GCpAUXbvT3ooT+CzEoIbT6N+FobLF0B58By4KQCaGvW7mj9Au+Jy1UiT/+Lju75AU+3O
         l0NhQR6ownk8BvgolOKoC9isVmK/bQX5DT5DEDvlMxcCrZwOb1fhP1ckt7RShSO05+Ly
         lupVNHp55CwRIq3FCFYpfQ17ZNi5KyYW/DpLXDyb6etnXe032YMOTSAENYDoAF0v0GBb
         h5wMIvM394arqjAL0aE+mGNk6oWWAdK9Xy3dcxAYGAsMG9snoixqXOZWDEdC22YZ2yZ8
         59mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678307626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0PHdmmNJusG1epclYYmQTbwEIZkKSzfpFAnnbOVxlE=;
        b=GjVYdwnX+8Dv97YcqYRaEhjV1WbNQPfFlAox+F8eIvWunburoI5utCKHCDNAva4Jyd
         mus7cYOnCd6QTewNMDgPGOc3rjD0yBdg0+PPXXvs2pF68YWpVUjQM8ntMjMWWALkilPx
         qlROxvhzBAOl1jNyjm6Q9SJBSftzKT4D48D7E0RWrq9MzekzRNysJx9qISBr+OoSrkKC
         VU08KL5J8MzkaLVbPtGnJRamOE6lI0ziV528pB1aqj3blI8U6I7Z3R/DO6UtjbpPU+W9
         92QyrRuyubhQtfRWbhj+eyoQapL4aSNvca3ice3+sCIRfwJvtGMUiXt9BypyoGhtcR0r
         LhpA==
X-Gm-Message-State: AO0yUKXYGlUEV6pPLDTWcFgYvkQKmXgcaTPAp9xkLap43AcWiw/ZIkAr
	UtHl0qc0xkrWbfUAXm4eNyM=
X-Google-Smtp-Source: AK7set9mrwvbQ2AGOynSLhzAtgvFkMELvmNU5TzXvABg6Hplqti24OdZXB3ofyF0E5kns3kzi3NV3A==
X-Received: by 2002:a05:600c:3b07:b0:3eb:2e2a:be82 with SMTP id m7-20020a05600c3b0700b003eb2e2abe82mr16380951wms.2.1678307625757;
        Wed, 08 Mar 2023 12:33:45 -0800 (PST)
Received: from [192.168.0.103] (p57935146.dip0.t-ipconnect.de. [87.147.81.70])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c4f8500b003e2096da239sm512795wmq.7.2023.03.08.12.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 12:33:45 -0800 (PST)
Message-ID: <9578ec97-bca8-6335-4f84-9b6fa6c59522@gmail.com>
Date: Wed, 8 Mar 2023 21:33:43 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] staging: r8188eu: delete driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-staging@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Hans de Goede <hdegoede@redhat.com>, Martin Kaiser <martin@kaiser.cx>,
 Larry Finger <Larry.Finger@lwfinger.net>,
 Phillip Potter <phil@philpotter.co.uk>, Pavel Skripkin <paskripkin@gmail.com>
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
Content-Language: en-US
From: Philipp Hortmann <philipp.g.hortmann@gmail.com>
In-Reply-To: <20230308131934.380395-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/23 14:19, Greg Kroah-Hartman wrote:
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


New driver rtl8xxxu is working fine for me.
r8188eu is gone.

Thanks for your support.

Tested-by: Philipp Hortmann <philipp.g.hortmann@gmail.com> # Edimax N150
