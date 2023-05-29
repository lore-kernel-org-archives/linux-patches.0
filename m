Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08D58F71
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:06:18 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-64d2a613ec4so2509713b3a.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 09:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376378; x=1687968378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q53lJcgOFRIoT/sqLBJuSrkzsCLUtjgdJNovsTwxUYI=;
        b=TSoVcNEC5KHzdSTV/COFmCiLlQoVey50m5D0ci5njG8P3y9SReGDBJFqZoPqyRr+Fd
         8Y77KcJ4EsYW8xZIRboZKdP1U/70rE0D/ygONF6JnEjTkrmAzZX+/R5uRcEEIqzrlI4g
         EYaSDLXlrep2lelBbTAU7DkrMenDx7YMXdfejPkyqmFnURpGjja0oAoHvCkou75/MwhG
         pl3AkjF4pIH0fhcOnq/WQHMrf7NC6ngLTmwk+jp2/usyWVKAwNqPnjPNEg5m1OhbZGp6
         vkecWyAcVGin3KNoXKBg98INVmoLWkXYSlJxQ5Za1SPWD5Xldiao/WVSg+QcLR8KEAiC
         +1oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376378; x=1687968378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q53lJcgOFRIoT/sqLBJuSrkzsCLUtjgdJNovsTwxUYI=;
        b=eiEa4DezAak0WVZnac48skcvaUjhWwBvo6cb7v5sB1sfS0Y/unAEVhoeO0lkzrdy2v
         WkqGor8OB834GtvklNZ1OWaX9KpPq7E7CRCdrOLwqEZkCWQTAifxLTpA+gKpzyBJzV34
         uH+1K9y1971Bd9ujST82ncnL3qf8Wv4nHl5tug2Voymocnxtmdqoiz0hlJwsO4KJmL91
         T4SwdTB5l73UAGoBbijeuFFS69YoAc4y3vq6pzc6X7PiYJFHIY7maEQTx5+cAj0AxuFE
         FNXLpHJdF0kl3e2LNC/aLmrFumRPgbeH0yJ7Xrp1vNfq6H5vgPB6joYW8ix2kKlCMho/
         C5rg==
X-Gm-Message-State: AC+VfDyWcMBKsXzXkarIcVuzh6OOCpobYV39BDIgyGCnU8SkFQC8/o/a
	d4mu8DHEaIo0ELpD0dFFk+914F6K1ig=
X-Google-Smtp-Source: ACHHUZ5zizGAthoUYgL1a63BdbwJZL2N8oio5nyEd5uwzN77OfObH0tATyO+zrhYChALeT/5a+AiqQ==
X-Received: by 2002:a17:902:7b83:b0:1ae:50cc:455 with SMTP id w3-20020a1709027b8300b001ae50cc0455mr9931389pll.39.1685376378133;
        Mon, 29 May 2023 09:06:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id iz9-20020a170902ef8900b001aaf536b1e3sm1981439plb.123.2023.05.29.09.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:06:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 09:06:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/211] 5.10.181-rc1 review
Message-ID: <ead0f6db-6400-4b5f-b3a0-9d9238524dc0@roeck-us.net>
References: <20230528190843.514829708@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>

On Sun, May 28, 2023 at 08:08:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.181 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
