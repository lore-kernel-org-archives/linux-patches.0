Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E738C5C2
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 18:09:59 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id 20so13668337oix.5
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 10:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=6Y717KJbIRjmj+t9kJAIvgBCc3UIFcYLwVTbZ9RsBPk=;
        b=XwcIdw9ldMHQ4ayiqMbANGBH3Ycpl/ADyKalw8WJRsox/7OgE4QrKcKc8mlpGGmZoA
         dbwJnZEDuVUxTw07bumv6cXJks3KX3Aa6f3EaPhlrMTN1rhyS1Q9QKYqP86Qt/gmE/Z4
         RTODsASPYD51aEVqcsdFl3hs9g5fNjKrWpFzZsPxLpN0sqq7sy+LzKWDsUzY24pxrIEO
         R69UNBna63ls2/KXD7bTM9zNdQKqMAvfxfrcPGTxeVwyHX11VVLpR/enCawt/Dogh2Nl
         l8/5PkHxPdQRRPsfeb0zAa1VOXn7j7ZtLosQabO/vHs6T2+eGD9GCF1Z/KvjSiWTJN5l
         EMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Y717KJbIRjmj+t9kJAIvgBCc3UIFcYLwVTbZ9RsBPk=;
        b=pyMlDy8xcZ9YrzupDlKw012pP8/M711mUFGqLpvkkQKbLfoKO+fjhFgVOPFpggU204
         3MuEd/QM234tfzkm0f0e4tD7UnXQ9gMe8VVQfjt90azAW6wNA0lXC+qTgJRPAW9rS3jI
         qtPdoaR6QeHP2Zw2V7UqKZsOrCvU4gpkM5Qf6GBhHpC5IYJX/ldfOEPlOdA4ptA5iHeE
         yEv/H5+vf8GsszFuqoitdxPWSbjt5GgXlohNnUO4Jwm9OYTwAZXrlXNxrjZFaTKeWXG1
         YSfgi4CvRV/HqdBmJzW6mwWf4RcBWZ1XVjpPfrbPmzzX2Lk5G+BzxqaNRWFOnvp9Mq/U
         zg3w==
X-Gm-Message-State: AO0yUKXLFbbekkZmK226lyPmo7ICgYnmDql3H6ifNlQCGLvkzhtFnf/1
	WuMp22gsDBN94Gx5rpcqELA=
X-Google-Smtp-Source: AK7set/Ipu5a6wQXpVlF4OsXb8/OusLhF5tQD1rtSUbjH7bFzZF2ZxmmKiZVGnoNT26vDqW2b3u40w==
X-Received: by 2002:aca:2b09:0:b0:378:3c87:5092 with SMTP id i9-20020aca2b09000000b003783c875092mr1501490oik.5.1676398198584;
        Tue, 14 Feb 2023 10:09:58 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p125-20020acad883000000b003436fa2c23bsm6463808oig.7.2023.02.14.10.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 10:09:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c210524a-368d-4249-93f5-6d7ed2a5a173@roeck-us.net>
Date: Tue, 14 Feb 2023 10:09:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
 <05984672-d897-6050-3e8b-3e7984c81bd9@roeck-us.net>
 <1cd10087-87fe-048e-c9ed-0a5d32c50764@roeck-us.net>
 <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/23 09:54, Linus Torvalds wrote:
> On Tue, Feb 14, 2023 at 9:51 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Reverting the nvmem patches fixed this problem.
> 
> But upstream is fine?
> 

Yes, this was a bad backport. One of the nvmem patches was missing
from the backport. However, a fix for that missing patch was backported,
causing a double device registration and all kinds of interesting
problems.

Guenter

