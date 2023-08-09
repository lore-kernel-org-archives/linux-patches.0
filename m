Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0783A24513
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 19:33:23 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso163340a12.1
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 12:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691609603; x=1692214403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xVlfa4BbN5B52yKwFRQSAnAaB7SvfP0B/VYlu3C5ok=;
        b=cW5wg48VUfqEZChf2iHsXRd8YC1OkN/z7sHCpCj29Q9ipmaKoiq3k8NGe3vP+/MRHF
         PqOI7n6+pACsDV6ZgjuBd8gjegEahfx9S4nbScpuVNvzxiI8TcQOJBJC8flryUApSWKq
         fZCSNUJBmZVYFo7xFvMQjb3YijXk6f9iGBsPpHNLCpsAVPIRjjS5PGowtL+dZ/hFeSj0
         epsWdhsecybANey6K3HrECWOlO2O1DkroZijAFP7l2mtzPby3cXyWpszJFrXBSF1TmN9
         2yeUNeJsjLjQ4WAhXPm1ZvzT/oQK5wElxtjkkSSrnF4MV4rRUGtjvAMfUA3dsgENC5bt
         AjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691609603; x=1692214403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0xVlfa4BbN5B52yKwFRQSAnAaB7SvfP0B/VYlu3C5ok=;
        b=bAVn8fLvoRcLgIV7vbQHQsS74jb9chlyM6aSvGHj0wMDNCLzcnTG0/NmQFT45s3sUD
         kbSD2gJBd/q6gLcc9tzs6+MReRlPlzQqXwdh1vXhxhLTwt0ZFveX0/vOEF2cNpnRZs5e
         aTZ3noTZPisq2lBJ7/UQC8DnrdTGDPn63Q4lUsMvyL0JQWul/iWPvHiZ9QF0p9QNLKZ4
         344A0z/a01vaTTolu1dnQUdQ2JciEZp23R5plgvUWUuiXXeBIWrKYGKl9uLcPVOCniTt
         qdLTiyny5X0hHmAwWhVpLEqKsAZ7XVmy/ADfgnPXfFU83S6IJoE7DjqKg4e1d7kTyXko
         507g==
X-Gm-Message-State: AOJu0Yy66Hz98jrwwo0RbcW9zATBxx22PhwakGeuOWBhUJv1Gq1nlixd
	b26bBmKw8RDvx627XM6X4vEEuesbJFZeTA==
X-Google-Smtp-Source: AGHT+IFCdtHHamFefuaCh4YzSuKB1mBkcLLamyxGektlJ61aV3HY05FFvFoTNIXzg6njdKJSBSNsKg==
X-Received: by 2002:a17:90a:fa7:b0:269:14eb:653a with SMTP id 36-20020a17090a0fa700b0026914eb653amr250920pjz.4.1691609603068;
        Wed, 09 Aug 2023 12:33:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 25-20020a17090a199900b002636e5c224asm1956681pji.56.2023.08.09.12.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 12:33:22 -0700 (PDT)
Message-ID: <cf831d49-ebdc-d132-9b8e-189e9688a9f2@gmail.com>
Date: Wed, 9 Aug 2023 12:33:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 11/92] firmware: arm_scmi: Fix chan_free cleanup on
 SMC
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Jim Quinlan <james.quinlan@broadcom.com>
Cc: patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
 Cristian Marussi <cristian.marussi@arm.com>,
 Sudeep Holla <sudeep.holla@arm.com>, Sasha Levin <sashal@kernel.org>
References: <20230809103633.485906560@linuxfoundation.org>
 <20230809103633.950016368@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230809103633.950016368@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 03:40, Greg Kroah-Hartman wrote:
> From: Cristian Marussi <cristian.marussi@arm.com>
> 
> [ Upstream commit d1ff11d7ad8704f8d615f6446041c221b2d2ec4d ]
> 
> SCMI transport based on SMC can optionally use an additional IRQ to
> signal message completion. The associated interrupt handler is currently
> allocated using devres but on shutdown the core SCMI stack will call
> .chan_free() well before any managed cleanup is invoked by devres.
> As a consequence, the arrival of a late reply to an in-flight pending
> transaction could still trigger the interrupt handler well after the
> SCMI core has cleaned up the channels, with unpleasant results.
> 
> Inhibit further message processing on the IRQ path by explicitly freeing
> the IRQ inside .chan_free() callback itself.
> 
> Fixes: dd820ee21d5e ("firmware: arm_scmi: Augment SMC/HVC to allow optional interrupt")
> Reported-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
> Link: https://lore.kernel.org/r/20230719173533.2739319-1-cristian.marussi@arm.com
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/firmware/arm_scmi/smc.c | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/firmware/arm_scmi/smc.c b/drivers/firmware/arm_scmi/smc.c
> index 4effecc3bb463..f529004f1922e 100644
> --- a/drivers/firmware/arm_scmi/smc.c
> +++ b/drivers/firmware/arm_scmi/smc.c
> @@ -21,6 +21,7 @@
>   /**
>    * struct scmi_smc - Structure representing a SCMI smc transport
>    *
> + * @irq: An optional IRQ for completion
>    * @cinfo: SCMI channel info
>    * @shmem: Transmit/Receive shared memory area
>    * @shmem_lock: Lock to protect access to Tx/Rx shared memory area
> @@ -30,6 +31,7 @@
>    */
>   
>   struct scmi_smc {
> +	int irq;

For this backport to apply as-is and not define a duplicate "int irq" 
field we need to take in f716cbd33f038af87824c30e165b3b70e4c6be1e 
("firmware: arm_scmi: Make smc transport use common completions") which 
did remove the "int irq" from struct scmi_smc.

Alternatively, we can just omit this hunk adding the "int irq" member 
from the back port.

This is a 5.15 stable kernel problem only because 
f716cbd33f038af87824c30e165b3b70e4c6be1e is in v5.18 and newer.
-- 
Florian

