Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AF223D2
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 07:47:20 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1bdca7cc28dso32495665ad.1
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 00:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693295240; x=1693900040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjk+FpfUelxVelibnKbEkl69qBJN6BFpdKQWHtxAsVE=;
        b=g40ObASf0pgcyiV9W8yW2e0ImFv5tHz8ftNt59C8NfJptPg77pYhoWEpEMYR8HI2Rb
         Bpk3owu+9nUt1xD2kFRFdRT5yugyPE0v9DrwDsQxmz1IVYcqry9M+qlPirMav5rKr//B
         cHeqxLX/U2ASSFP8E2N1XEgKmxFo476P5fWESL5uo2M7xm3tLJOgmmR2fWU9ZYCze0o7
         o/Gjk2FiFKLs5ygkQDD91pnwuA1aqcAlvIrrI/DhPzUg+q87DPTyTGiYTidDc8VY1T7U
         694cjnroUQWaxseFLzXd6i0sOIpH8vjLvt8YY5cmyGOwojnKq3PBO7MCgc7O9NlbEK8a
         cVVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693295240; x=1693900040;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wjk+FpfUelxVelibnKbEkl69qBJN6BFpdKQWHtxAsVE=;
        b=ajiDvxoY6pNcxFRcSK7kcMp/DaCSsu+c7Fr1QK6QXh5lwQg9hGdPdsQk1HCbMuXkUC
         92UUvHsEHMNjlCD1fBF19poVo3SubEfY71mrAJM9Kf0jWPVptFwxU/JY2vqG8jAV/5Re
         Q2MVCDKai/FAGso00q26DLo77TIF3Rvcyu0sMFbJjoh0yLTilQTsUcMZ78Qa5AMC+erd
         Uk3DW8GExE7GqqXalm9N2L/D+6w/PTOfFwCCY7z/uKJYfVMqxdYAYtadEXaFOKK10KbD
         W9U8SPU485f7muxlqKdYqiaUPYHcHLQYAL+r5z3YYDbV5lagS9c7DkUt8eH43V1dR2yP
         GdeA==
X-Gm-Message-State: AOJu0Ywtq1YFwvoo1etKMzWu4ui1zXHDd4xO2I6pFWQRwjVaG/mqi2Ha
	sA8Yjrxa83Xp1xEaczZZqJg=
X-Google-Smtp-Source: AGHT+IGw54N/EbGI0oaZtyO8Gk5wcuxmUksLmpq7UNV2yDhMyCl7lrE7QumeCWn0XaSEDyQz3depfg==
X-Received: by 2002:a17:90a:ca14:b0:268:15f5:9191 with SMTP id x20-20020a17090aca1400b0026815f59191mr25533177pjt.36.1693295240008;
        Tue, 29 Aug 2023 00:47:20 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:18:efec::75b])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090332c900b001b03f208323sm8642247plr.64.2023.08.29.00.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 00:47:19 -0700 (PDT)
Message-ID: <836d554b-64a2-cc16-a361-29ce5cdd07e7@gmail.com>
Date: Tue, 29 Aug 2023 15:47:09 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2 10/15] x86: hyperv: Add mshv_handler irq handler and
 setup function
To: Nuno Das Neves <nunodasneves@linux.microsoft.com>,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org
Cc: patches@lists.linux.dev, mikelley@microsoft.com, kys@microsoft.com,
 wei.liu@kernel.org, haiyangz@microsoft.com, decui@microsoft.com,
 apais@linux.microsoft.com, Tianyu.Lan@microsoft.com,
 ssengar@linux.microsoft.com, mukeshrathor@microsoft.com,
 stanislav.kinsburskiy@gmail.com, jinankjain@linux.microsoft.com,
 vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, will@kernel.org,
 catalin.marinas@arm.com
References: <1692309711-5573-1-git-send-email-nunodasneves@linux.microsoft.com>
 <1692309711-5573-11-git-send-email-nunodasneves@linux.microsoft.com>
From: Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1692309711-5573-11-git-send-email-nunodasneves@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/2023 6:01 AM, Nuno Das Neves wrote:
> This will handle SYNIC interrupts such as intercepts, doorbells, and
> scheduling messages intended for the mshv driver.
> 
> Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
> ---
>   arch/x86/kernel/cpu/mshyperv.c | 9 +++++++++
>   drivers/hv/hv_common.c         | 5 +++++
>   include/asm-generic/mshyperv.h | 2 ++
>   3 files changed, 16 insertions(+)

Reviewed-by: Tianyu Lan <tiala@microsoft.com>

