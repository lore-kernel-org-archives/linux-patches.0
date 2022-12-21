Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493A710F2
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 06:34:08 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id kw15so34445431ejc.10
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 22:34:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qHXdqGVAp6xwcwrdhEP2uqQblBxftTVuobuaAuqc5J4=;
        b=ApO7tzh4sKcXtaBMMH5j0kKdBS9TWhlMGslQa9igV1muzzkOSzdETSNjrJZ93QZOM7
         Etb4ssKBlHXyksRoxgGQr4PqDFsBrn2hHtbzK1h6Z30XfXN8aduOKBIrcWRdGvkAAlyW
         cvwWxEpzx9Y3fpPHh45N9Lq+IdeCXIOIMJKaHFc8fXM2+pMaNT9NTlXKRCQsEkhRGm+I
         Vr2JDczl4QK66tInyGxKrx6f7/LNvmyZJop9QnAQR46IfHM1KJpgCrRRxFsXlMb4z3Qm
         XDdaNGU+S9KlunnoewHL0dlMz8gp54KCukwMoB1IMkUXTPOQEEMydM0xVFkyuRGBBZWj
         31Eg==
X-Gm-Message-State: AFqh2kp3Jk9xIPnhcZoMAB90//YgL9KLLqmKfyO8b2ZXPzEqyRuWv4qB
	81WImpfMjofEGQjvMnSg46Y=
X-Google-Smtp-Source: AMrXdXt4KIa1qLy1tC2/3HRqqjwlebCZpmw7B+2nMiJLXSta5SN0tW51yIKwSwGM4G5nhc39kAGofg==
X-Received: by 2002:a17:906:bcd5:b0:7c0:a49a:1 with SMTP id lw21-20020a170906bcd500b007c0a49a0001mr313872ejb.71.1671604446425;
        Tue, 20 Dec 2022 22:34:06 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id b11-20020a1709064d4b00b007c500ac66b2sm6549395ejv.64.2022.12.20.22.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 22:34:05 -0800 (PST)
Message-ID: <e3b06c93-1985-a958-871a-bfd73646c38a@kernel.org>
Date: Wed, 21 Dec 2022 07:34:04 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Content-Language: en-US
To: Guenter Roeck <linux@roeck-us.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221219182943.395169070@linuxfoundation.org>
 <20221220150049.GE3748047@roeck-us.net> <Y6HQfwEnw75iajYr@kroah.com>
 <20221220161135.GA1983195@roeck-us.net>
From: Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221220161135.GA1983195@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20. 12. 22, 17:11, Guenter Roeck wrote:
> You probably didn't see any reports on mainline because I didn't report
> the issue there yet. There are so many failures in mainline that it is
> a bit difficult to keep up.

Just heads up, these are breakages in 6.1 known to me:

an io_uring 32bit test crashes the kernel:
https://lore.kernel.org/all/c80c1e3f-800b-dc49-f2f5-acc8ceb34d51@gmail.com/

Fixed in io_uring tree.


bind() of previously bound port no longer fails:
https://lore.kernel.org/all/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/

No fix available and revert close to impossible.



And most important, mremap() is broken in 6.1, so mostly everything 
fails in some random way:
https://lore.kernel.org/all/20221216163227.24648-1-vbabka@suse.cz/T/#u

Fixed in -mm.

maybe it can help...

-- 
js
suse labs

