Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6145CBC
	for <patches@lists.linux.dev>; Fri, 25 Nov 2022 17:19:01 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id q186so5018225oia.9
        for <patches@lists.linux.dev>; Fri, 25 Nov 2022 09:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yarLPXmHDeaH9+KUncKUuS9FlG4hBfjikKw28uiKqyk=;
        b=mQLpaCpq4PpsNMORSgcKAE18ILD/icf4FLG635gHxpfXzRf9niA7mhNA7Kx5WARmTF
         i8zwwkdrslu3WTLo8pNfNTo1acuAKDQf7S9HzGmkIJeZT8tpUPASZMNMubX0dp0BP65y
         Dawhwero9Gna8hwnli9tlrydOstXkiRxrzWRE2QEFibspXhwmvPi5iEDaDDnqcG6Dg56
         aIEbAQw5VxvhX+1fesP0323q+JLIb7JA3wXCEEpSkQJuRICAPZn/wccd61dGf1U4SNQX
         eaPF4dF2tGifcfSPeIl0u+A4l8lKgM+foqPUAjgqCeR++Z6AC61j3Li8bGffSikIP0dF
         XpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yarLPXmHDeaH9+KUncKUuS9FlG4hBfjikKw28uiKqyk=;
        b=JyS6YsRXg2KtyPTaVKa1Wh2EZ7WDlPPc/qr8X24ZbXHiutEhecKl75DestXa+DrVmr
         u+ZTG8fSdNPKz7QRKZ3F40iKsPhXGrJG6J+TPRr4Z+cuJ+pchVS0POpqGA6SXGx4pce4
         nYl7GxfTuZQrSOP0AR8puNFkS+glxiPwEdfDpiuNr2syAzgZQpXMUUsvEBwbJz7iz7p4
         cpIlNAs3sCM+OcpcCyHKX1JwOyE9CCOW34dqi3HhLPRNV2wLBjk5i+zhranYdYjA4vH7
         JZXEhz9lX8WcY9cgb+0WND5mnbLU+Iwcz/wssZGoermZ63nJmyp8q10dMdqcPgQAGsoJ
         S9mQ==
X-Gm-Message-State: ANoB5pndaTt3QRX6Gl90DoUtkcyxDAfn/QLT9eBWYZXHjAwzt12KWFaG
	b4viK8fuLqS1Dgm1cUGJHjs=
X-Google-Smtp-Source: AA0mqf4C2GRgs1nz+zpZ+jGoH8K5jBbpfsknDI6yHCRjCwfaBM17eE3OKLhYNSO83CRBLbQyzXW/TA==
X-Received: by 2002:aca:1704:0:b0:359:e535:84a2 with SMTP id j4-20020aca1704000000b00359e53584a2mr19068248oii.59.1669396741069;
        Fri, 25 Nov 2022 09:19:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c21-20020a4ae255000000b0049fd5c02d25sm1747493oot.12.2022.11.25.09.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:19:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 25 Nov 2022 09:18:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Message-ID: <20221125171859.GB1205540@roeck-us.net>
References: <20221125075804.064161337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>

On Fri, Nov 25, 2022 at 08:58:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
