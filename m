Received: from outbound-ip19a.ess.barracuda.com (outbound-ip19a.ess.barracuda.com [209.222.82.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1990E79F3
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 21:57:06 +0000 (UTC)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198]) by mx-outbound13-151.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 14 Nov 2022 21:57:05 +0000
Received: by mail-pl1-f198.google.com with SMTP id d18-20020a170902ced200b001871dab2d59so9957658plg.22
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sHhq7GAcH+SGAD2OAT/4GIJITY8Agpvr4ItX6H4dnTw=;
        b=RkaNIlr9V5SN6THND5V/unQ4uGo4Ewoz2wIKKh+ktKuyCJdNnVVPtPduHX2TXf/r3W
         OxV+lLwPYO0X+XWeGLEZ6I3mH7aPIjXo9AyxulJrwHbamWpmay+eU+B7rLJIkFYiYEve
         ZSWF624bLS8OJ48owc55yns0psiZ8lOP/YruCDfdNvvg3D8QY6oVkL1IExlvhbOlkznZ
         70h0LGGBw0M6fJwlBKvJBOWnCQ96ztSV3OtQ8cAlSDsTG8P61hJ3Vb9xDWv1jOHzZ2UN
         JGIYpXsf69ITyp1HII4ksPVOAJVtMCt1wwGkjVTLta2BW12VcOuX5HHW4NiFp/Q7g3/W
         fcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHhq7GAcH+SGAD2OAT/4GIJITY8Agpvr4ItX6H4dnTw=;
        b=RDOoAWFUlzXoNhMy7vOR6eDZB8vSUQ+DH1dGsETeyMsZrEN5GEfDHuUtFeTl4aNWrm
         wDLLs8LLDEbIfxK/3iNQEQSiTPYkkwDLA2rjBCDWqsBJkt15HxtatS1c4qfs1dtV8oaV
         39lq5tactzsf/0zL6g0jyh1rsfgAbw+VGbz0tF1gfzSoJk94WXpg5Di6pF2A1/kVetr3
         SCIC/b/Hjrt+teZ7QNArptfzzjKL8E4qwXVVU/mzAprxcdLYclm8/Oa1GdXkHTlzmeZ8
         Av1Qjo1wdrFKkObfH/wEqfDyrv0drRENnl1XO2kFdXpEhVEW8Hce4ohf/S7BMbIRxsrl
         puWQ==
X-Gm-Message-State: ANoB5pmWDuVvhiGJih/yP7hwrQi0b0QEu3Qo+NhfZTNr6fLmKwgG8qCz
	4U7DL7hKLCbOgrukrsqzYxa+w0djuf23uUyxI13tPWdyjrLt3yNplIdjtec3MMh+hDIGqd9uo6t
	jqdw6/TQ5d8nyImDmLmHXljTeFyELWGgJ0Kr6Uv2xlWVug3kxc1Mhzrm5vf/bqwGcqA==
X-Received: by 2002:a17:902:b18e:b0:187:2790:9bc2 with SMTP id s14-20020a170902b18e00b0018727909bc2mr1045578plr.61.1668460006276;
        Mon, 14 Nov 2022 13:06:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5hR1jUSh6vO+NzVXJRDYcadYdn4lJl0ydhNhJqjQVtk/DjBGaS18IFlwxJN0Asr3csyDUI7pdHlDadYCNkliw=
X-Received: by 2002:a17:902:b18e:b0:187:2790:9bc2 with SMTP id
 s14-20020a170902b18e00b0018727909bc2mr1045562plr.61.1668460006054; Mon, 14
 Nov 2022 13:06:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124442.530286937@linuxfoundation.org>
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Mon, 14 Nov 2022 16:06:34 -0500
Message-ID: <CA+pv=HMHfNO-v2jRMrzHKx7VWzg9khjPxp6pNh0DPDsnF_O55w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-SWM-External: yes
X-SWM-IntToExt-Scanning: swmout (swm-pri11-itoemail0-scan.leviathan.sladewatkins.net)
X-SWM-Sent-by: swmPRISMgateway (swm-prismgateway-pri02-mail8-scan.leviathan.sladewatkins.net)
X-SWM-Antivirus-Version: 1.1.0
X-SWM-ite-Primary-Server: swm-pri12-item.leviathan.sladewatkins.net
X-BESS-ID: 1668463025-103479-8042-10570-1
X-BESS-VER: 2019.1_20221114.2026
X-BESS-Apparent-Source-IP: 209.85.214.198
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.244151 [from 
	cloudscan8-173.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS162129 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On Mon, Nov 14, 2022 at 7:47 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.


5.10.155-rc1 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
-srw
