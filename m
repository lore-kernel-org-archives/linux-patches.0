Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A881A31
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 02:49:29 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id 123-20020a4a0681000000b004faa9c6f6b9so2429946ooj.11
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 18:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZQ9vrog7jwNZgu5+COhRurOZBjvasf11OGREJXcEyo=;
        b=nXxI9dcxw4FCLr6MFNVsEbPm6aMw9maNM3UTrhikgJbE8snI5b/PV9RbiNWnqiTorx
         WhsNUl7sOR0eSI0BhM3/Pz41FdlYdlXcfPDuIeo19/mULpRQ5nZ53Nl38D8dMBlwdd0o
         MG5ekJIHE5DiKOOyNhzrRCM3tq9K0KGm5prFxh2G631EMp5v3zL3V2Zs7LBtnXek+PMU
         qmTAjhMNB/CzNFzbo/6enO35xUeyrJStGfnDpZFV8xft8DDs3iC3aNwSxte7wEEI6D4a
         OffVuvyUkV7nukWLHytffshM9/37TOtYJ4XOkwcI+KPhgZQD5sar4c9yROJZ/TRyHP0s
         sfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZQ9vrog7jwNZgu5+COhRurOZBjvasf11OGREJXcEyo=;
        b=tPoK6LOwnck+knjCXMe6nIGXkwMbELsaUMAcKD250UrqyB67P/tWNOj2Yjp7UtCDFe
         wuWWB/UYcTzGp8j5MUdFqu3UHD7QgCvHqHd23Nfwniav8fhJNNZPtePEID8wOnhvyyxw
         B7eFzvkMBrtNwjlRBQom3XKwbttV97BFkTmowgmgy+69rQPXHrXTobg3A7YXn3jXzt9n
         lTShT8g4B9c8mIL456aLVJg+PiZvPx15GkAcbr9Khinv1RfPzmC37zUhvFmLq/VDh0T5
         91jIzF6/4mOHqNpHC9pi3/1iAXfBxiqOloneJQL8IffxX9fukdec1+/mIg6OPje2XVxY
         Y6Uw==
X-Gm-Message-State: AFqh2kqGlppokxfVWlLlEHLRrK/GIrBSKQ5kw3Gcc1DMkltje5IYMgFC
	qJDSRQkQSpVCUe8C5iU3M78naspsOPs=
X-Google-Smtp-Source: AMrXdXtjSXuytDtnGpEG907cWjqqFD6TqwgBcWQLdNpexxhGWG5R08Si91mT/uz3nUEwFAS4282gTg==
X-Received: by 2002:a4a:1584:0:b0:4f2:88ea:54dc with SMTP id 126-20020a4a1584000000b004f288ea54dcmr18717473oon.7.1674528569167;
        Mon, 23 Jan 2023 18:49:29 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v25-20020a4ade99000000b0049ee88e86f9sm325889oou.10.2023.01.23.18.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:49:28 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 23 Jan 2023 18:49:27 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Message-ID: <20230124024927.GE1495310@roeck-us.net>
References: <20230123094918.977276664@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>

On Mon, Jan 23, 2023 at 10:52:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
