Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09404290FD
	for <patches@lists.linux.dev>; Wed, 17 May 2023 02:49:49 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-64ab2a37812so9938751b3a.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 19:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684291789; x=1686883789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5Hu/pfh6heq83uqkqoHwx78gypqIXAEufcYmbKjLXk=;
        b=DqUCKOkTV5NTLs9/3LrcKWL0q4sjkAZSk1eCnfxnr9yZG7ZUQp4D4q8wC9N5qG9gGk
         xwhIYWlu93bS+7jvaocupczzqsNp62qS/1UCLcMxHtixd16yQvutnplJzdAV9P6n4jVt
         3FmY80JW2FnGt6stjHlIj2+UqU7Oz+lVJ7obnlIfzDPISXB3UdePOZJkx0F00VAnTTLS
         Rv2UYLFZ1xTBFjk2TG9mza0092KEiH1pn/NT7jyddLGAgXMF+ZztIULbzysRNvMJDKGL
         BhPtbSR3zuXuxQDSzvvRbG3H5UVIL2Zs+27HIZs28rXU9rTpCGFqHH5kZduwUkcxBOSZ
         P7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684291789; x=1686883789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5Hu/pfh6heq83uqkqoHwx78gypqIXAEufcYmbKjLXk=;
        b=BdBD9Ad2qRMTM7YicnEbljgJs7B9zp7QbcBCUw8GEYcHlB3/cuIjB7D4SFrL3co/Jx
         0ocAMau6Picgjy8c+sOUFBSP2NrE6swZVWFWDHVPDvNk3qIuglymCNJQ5sgH0hrTuUri
         Q2oZTZaI+EGmZoAGZ/XYyXDDzM5mwlg8q8Y1fb0L7XR0ADGlhbxOwXRtlHR0eYQJfKpi
         rMIMXk+RByMTabXEtO6F/dGi0/Ha2BknVl9EmJLB/wUpiydLOcSvf9kxLBCXO6IlMZ3p
         KvjbLBYiEwH2VKpoNv88B+qkt89TZ8AKIUgxEnB6VccF5Fn8cJtv007crQa3ICQslpGb
         dO2w==
X-Gm-Message-State: AC+VfDyUj7vT/Gmf0kVtIetqxOR65aPgVE3AComX+6F+zkaOK6iaXVN6
	06Q6+lTQRQGa+HTKswxSLM0=
X-Google-Smtp-Source: ACHHUZ6wrbUWipYAF7ePukEX17pMnZjyX/PPIDzXkmrRP0Avx8utruS8ChESKc4/EcfW+bKDkMYdrA==
X-Received: by 2002:a17:902:f612:b0:1a2:749:5f1a with SMTP id n18-20020a170902f61200b001a207495f1amr926119plg.26.1684291789466;
        Tue, 16 May 2023 19:49:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g26-20020aa7819a000000b0063799398eaesm13991553pfi.51.2023.05.16.19.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 19:49:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 19:49:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
Message-ID: <b2f06ad9-f298-4b97-9a5a-b40243910f7c@roeck-us.net>
References: <20230515161736.775969473@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>

On Mon, May 15, 2023 at 06:24:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.180 release.
> There are 381 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
