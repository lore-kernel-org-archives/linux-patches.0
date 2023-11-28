Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CEA1C3F
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 02:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAgn6zv0"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1fa235f8026so1737256fac.3
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 18:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701140073; x=1701744873; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXG7yYq+gzZKwaIr6oNQcjt6SGtfnc8h+m5ojKiAAHk=;
        b=HAgn6zv0zBlSOp/RWoYdHmt4Ig+8w6+D1WdloCl2F+jyT6nB1Hk+ACOWe06Qu/8hrn
         x/kQJiVUzNYiI9KVb/feG0/AUfmmLxD7+UOfN2z08cPHHxTCqamsAcmvTTU9HDffjQGa
         XNp0q3/4BrlvwzQM8Smtz08FLfzCKVRT31Qg9eHPJBlufPSdAvFCwukhCFmy7ZNXQcx3
         oD4l1P2efUgi8Aasp918mbeFCvBzGL2tubacDKINLBMaXF6mpD7VrnmhRhy2+idN9bby
         RGrUili7j2+BsIPI53EfxwugwHZ/1uhKdKJnT9bOiPS/4QS95UE8p4nc1shOGo0dMKfV
         5Pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701140073; x=1701744873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eXG7yYq+gzZKwaIr6oNQcjt6SGtfnc8h+m5ojKiAAHk=;
        b=RQYZDN4HAw8epR6tf5se2TSgDocmonXSzIxPKkJT6exm0FLcRpfx1nME5tUYHbPmwp
         bYyXT8KySsra61CpBoq8OTmbTp8kX0CyzqwUF5lBXkq/hzXQl2s6OTxnSG9BNVUJT+2d
         kss7Szz434hISDl/BT8/Gp0Od8N7H1zoYUi5yVw9UFvmhju6vWKMFOcvZ9VFTu4dfANf
         UQe4kRJq8UHMAW7scsIxxGRqelHH7Ojp9/pUsnHsbEfd1ICgegbryScunSP/CArKebae
         FX4C2q8qyS1GzA8CcpnGTV9Ecl2kqgWRFPxjPUtLT6DIrGtkcyLheaW/6hhb2aML8/Ks
         LiWQ==
X-Gm-Message-State: AOJu0YxotkCXtsGeB/U0xBxq4IdX+dtJFp63MzJNjIdp9g83ojZJ+hKl
	bzuzJvNvinRrT14/NA0aQNg=
X-Google-Smtp-Source: AGHT+IGMItql6/9OgBmgcM57vuT+mVS0uORZ/2iVRrSjWrvWmM2TDewTz3SzPWvPZhW+bDRcyjbffA==
X-Received: by 2002:a05:6870:c98b:b0:1f9:9ad0:cd3d with SMTP id hi11-20020a056870c98b00b001f99ad0cd3dmr19483078oab.4.1701140073264;
        Mon, 27 Nov 2023 18:54:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id wx20-20020a0568707e1400b001fa38903b92sm1207745oab.15.2023.11.27.18.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 18:54:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 27 Nov 2023 18:54:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.5 000/483] 6.5.13-rc4 review
Message-ID: <c4432a43-3187-46f8-b848-46dd72c7715a@roeck-us.net>
References: <20231126154413.975493975@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231126154413.975493975@linuxfoundation.org>

On Sun, Nov 26, 2023 at 03:47:04PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.13 release.
> There are 483 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
> 

For v6.5.12-484-gecc37a3a8d33:

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
