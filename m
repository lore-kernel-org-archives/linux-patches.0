Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C7A7B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 01:03:51 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1a68d61579bso40390135ad.1
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 18:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384631; x=1684976631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uU63uYraJHI8toeOh6onSgWIkE13niAeeyHZ610UQo0=;
        b=stAJvkIEj7Td7QdUJIew8hYIOegUMfhFUqQ4pG7xO0mDcKx6wNKUj3n2RekU6nQqpq
         1EolTCuSYmPx33Ra4kegm4XRIHoH6P/Rddg4y5xvWwaBZox3sk1X8PFeZG3qvp77i/Cp
         VjN/g+P7iO0jc1QGDfEB1v5CMwEp6ULvqGOZENF5pAvihMGnC61GTsMAVw1gBuuYvBi3
         pDvBLb0mDu2X+Nfvdj0gLvNP3ORt2WGm8ehazj1EBcS10VKtpOM4aIFrD01hxgjuIFFo
         3rRGuS/02ZavHu0sn0oBWmXw6zy3+yOx6kWKQRfP0lyvawjqZwXVo43oHf238YXOroCR
         +aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384631; x=1684976631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uU63uYraJHI8toeOh6onSgWIkE13niAeeyHZ610UQo0=;
        b=fD0ClaFZBSBZSero/jPTdmyoTAb/VsmprW75hKZnJwNSVytBrh49Qr1+2lT9SNW6ig
         TZpHnQlCEzv+TXkkFryktlB8lp5yLdnp0PxGZTjkaR0luPMgzhmCJkdjwO+8J1480nC+
         gBdYIr5ywFvb1TXNT513nu92FdCMHp/gCCYDwG71pOlnNEvw1rMlOm5IlmMJ69QGGlSC
         aW//xwBqC4ByaMGUfczUTms9xvKevJm2Whq6t4wl47ie7Bvejy5UoibwubjNwtrs02El
         U+73y4WgwVaHmxQx6l/rcWHQGZ09xiU7C2XKtdUVRT/ACeLX8v+607bDLYrDACxc5RuC
         F+2A==
X-Gm-Message-State: AAQBX9dQURZ9Ypgzq0ZDV0ozGkssLu7mI2dgAeFPe+L0pGWKFi7X7JrT
	0rFo1ZXHlDc8ds7+pr5cmRg=
X-Google-Smtp-Source: AKy350YVGjlhBK4YxhTx5cYbwFRcDuLywoWA8lN+VCcTrFCWoLBzGoKl1ZDsyvqYz7qt5GxVk3mqyA==
X-Received: by 2002:a17:902:dad0:b0:1a9:433e:41e7 with SMTP id q16-20020a170902dad000b001a9433e41e7mr15921845plx.43.1682384631156;
        Mon, 24 Apr 2023 18:03:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c2-20020a170902d90200b001a6dc4a98f9sm7093837plz.195.2023.04.24.18.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:03:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 24 Apr 2023 18:03:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/28] 4.14.314-rc1 review
Message-ID: <9621c9a1-ddb8-4478-91b6-4d77a923d778@roeck-us.net>
References: <20230424131121.331252806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:18:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.314 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
