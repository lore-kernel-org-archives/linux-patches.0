Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8814C64
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 16:19:59 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id m18so1971438iln.2
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 08:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+/79zT62eGCeTFbWWbHZL6SBnBvWoPl0VA/4YXAtBMc=;
        b=EVyPHg71f/yKSKB5OafAD95khw/bL23Oai7yCp7FNOGc6yGMy9g/mtIxHqykPafOL+
         d0AKdIuCQObsBeKfN+W1N/bIeNQaxT4ceDo3TDDJNAWOBjbC6sf40Mps7OE9hG+eFb06
         pRCjaWXKh7xkOO/WME/B1pyeGdogCSRl11VUcQzcY1LeDJbeasJ+DjFHU1f6UpXIiAC3
         ortf0WQLBTvkhrrWZ9s9YwnEy7E/bXa8TAsm/0jXtBIsWQbWA+R6fOY2RXI/YBGvaUXq
         +sVoYDGu93tvS5ToP59tRnaARrFzptUgPm541oLl3zmP3WgFBvg43DJx5rK8pTJ1F1nS
         ZhSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/79zT62eGCeTFbWWbHZL6SBnBvWoPl0VA/4YXAtBMc=;
        b=JtcIKzf1g1HEePYNhuVR23y/q1S+/CD990HGbPqRtkFpOdaOASOpS19BoRJkdS6P10
         3AKzaIkRh9BvNwNwRUY1FqZwtcwT8SokvYmVZCmnyFKqM0oLByD1oFwZsEcJK/92VciX
         vur05MCHovc02JW5m5folnXLusYOgRFlLY3DOmj7oZ07ixS6bNNhbauMRbaHIHpLAHYO
         SuvdRt6wqTOmzVsP6r9rbZTM60ZIql3yYMvPIsoSiv/hggcKbtCqI12LZ9QvWE6z8SJ1
         7A8Qeol79mfdNE0ofEleSUFFdDFsj3Fr06DheD18gd6euO/t9gSWg8dXK7rREPNX9auW
         smLQ==
X-Gm-Message-State: AO0yUKUXxHaSisap+u4bWPOiD/6C/w70GQRuCf4j3UQjpFFA/lUfLfyt
	2v3bw3/i7J++TAqJwARyfBI=
X-Google-Smtp-Source: AK7set9zvHNw4dzbMz9oI64UVgh/6agPhRRFT2OvDtuxnoiGrvqZa9PP/Jt4a91atpU+n49M8cENeA==
X-Received: by 2002:a92:c242:0:b0:315:5131:f8c5 with SMTP id k2-20020a92c242000000b003155131f8c5mr5886053ilo.31.1676996398693;
        Tue, 21 Feb 2023 08:19:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k9-20020a056e02156900b00316e39f1285sm222265ilu.82.2023.02.21.08.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:19:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Feb 2023 08:19:56 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/53] 4.14.306-rc1 review
Message-ID: <20230221161956.GA1588041@roeck-us.net>
References: <20230220133548.158615609@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>

On Mon, Feb 20, 2023 at 02:35:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.306 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
