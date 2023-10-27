Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641CE38BCE
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0vQcRo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7697C433C9
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 16:27:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0vQcRo/"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Fri, 27 Oct 2023 17:27:52 +0100
Resent-Message-ID: <ZTvlCGpxrl86yJBb@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 27 Oct 2023 17:05:19 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=AbkU=GJ=gmail.com=groeck7@kernel.org>)
	id 1qwPKn-00FfSB-I1
	for broonie@sirena.co.uk; Fri, 27 Oct 2023 17:05:19 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by ams.source.kernel.org (Postfix) with ESMTP id 94C64B82668
	for <broonie@sirena.co.uk>; Fri, 27 Oct 2023 16:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 0BDFBC433C7; Fri, 27 Oct 2023 16:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82777C433C9
	for <broonie@kernel.org>; Fri, 27 Oct 2023 16:04:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 82777C433C9
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-579de633419so17198647b3.3
        for <broonie@kernel.org>; Fri, 27 Oct 2023 09:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698422695; x=1699027495; darn=kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=cy9iUp3v6OB4PWeR1/SVWTKFReI9Zajknegp0GS6Lpc=;
        b=g0vQcRo/p90SdnbU5CYrdvVQ+M/ONO6KkFJUo0GLB4JUZJZZgfBifVdbGiSihNanBD
         2QzfKbTA8ZBLlKYh75X26cC0n5hYJzpjqFCcE5db9xgYQDOHhJ/oviwsujBltAEZBp9F
         VPDjJI34gC4I8g6W7HTz0XY0v1IOKYowFMFNjVxTWlNdhlwt2E5UeiJmkuWCIT1/SvPZ
         qv7XyNCfMF63cgZMbOsVVP3wMV8pIaE1sUAMv1CE/neFcPq4N8Y8Eh1u72zc7HsD3rqr
         /cgvF0V5xKTMQLPaDAQoNxTtmnwE2mx3UlIUAbZHybtWrHYaiDtjbp5QshkV+Ija2cK4
         LIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698422695; x=1699027495;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cy9iUp3v6OB4PWeR1/SVWTKFReI9Zajknegp0GS6Lpc=;
        b=DL9ht8+4cp1Z8CJLeQrRKPx5whYmE3QXza95kJgk8OC5I1McWgFjNKWW/uGE5gxD2p
         tPZxUzLbUZUaI7/+rfceOOtzc7u01c0vuqr1j++T924ck6j8wyjspNPCTS+363noZJmi
         B/MsZ4+XW4OXzBMbOgT57JG9L2yAiLLtyi5oKqqQ6+q4X52l72sM2NxwsZiLm2Hcs1wg
         ZNzqsWvQ8BCbc84si6L117AguODxDm8c4HxzwJBZh/LsruiNV3wvF531s7+jMEq/xyyL
         SHmIknr1BXImwK10MMl5wjFl/VTSvB7FUNNjvBGeSBvPFF6O1KByjIjvYkSIOIb01CdC
         tULg==
X-Gm-Message-State: AOJu0YwhgPqtuA+z8wyUPAC+o4P6nFDA2+m6U3ovoE14Ph4sngp15Yet
	i1MI+FgOG2m0adICZ0gvXwI=
X-Google-Smtp-Source: AGHT+IG6R1h698jomRitOYOvER494TrCgf357KB++LKns3L48YxeH5ukAEpFGkjhKE3utqYMlGPHgA==
X-Received: by 2002:a81:c60a:0:b0:5a7:fb11:90f8 with SMTP id l10-20020a81c60a000000b005a7fb1190f8mr2858067ywi.16.1698422695469;
        Fri, 27 Oct 2023 09:04:55 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m137-20020a0dca8f000000b005a23a62a25csm801418ywd.9.2023.10.27.09.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 09:04:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <aae1861e-be1b-2f12-51e0-48c1a0cc603f@roeck-us.net>
Date: Fri, 27 Oct 2023 09:04:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Naresh Solanki <naresh.solanki@9elements.com>,
 Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
 Jean Delvare <jdelvare@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-hwmon@vger.kernel.org
References: <20231027152830.1269895-1-naresh.solanki@9elements.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20231027152830.1269895-1-naresh.solanki@9elements.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=AbkU=GJ=gmail.com=groeck7@kernel.org
Subject: Re: [PATCH v6 1/2] regulator (max5970): Add hwmon support
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: DCZxW50P8ZxP

On 10/27/23 08:28, Naresh Solanki wrote:
> Utilize the integrated 10-bit ADC in Max5970/Max5978 to enable voltage
> and current monitoring. This feature is seamlessly integrated through
> the hwmon subsystem.
> 
> Signed-off-by: Naresh Solanki <naresh.solanki@9elements.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

