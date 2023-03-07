Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5AFBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:57:57 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id u5so14983811plq.7
        for <patches@lists.linux.dev>; Tue, 07 Mar 2023 09:57:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678211877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eLBHmJfnrJpN2/BeQiLegODr6r/XtN9ZTf564gwPeRE=;
        b=oC5FXQ6x7v/gwLqXWt3v5xH92jV3QUlPeoIrK4qT5pSujNNPoP4+TfU3Qr6nk4QepR
         m5I4MVSmVzyfYMTDdHhF+TBPvjvb4tPz1cW+VNriyaryGgw/aiR++ZaVxHKXT3SU+Mxd
         MIFKabicn8gfNAeVflDZ528VEqj28nVQJ7F5HJkJL0FnRSH+1i47IO+HlXWlYzmrkRDr
         Bj5V0YEA0rvk9FtpKKrlEjOQIQ3id25cEbXMvir76Rv5Lm5x1H8JkYqdzqWkON+0Bo7U
         jsAa+NYKDsQDLejgumZVixOvjLpwodWpGHO2CXrIShUZ43pSJC0Nv5R7M2077Uqg5NGg
         cDhg==
X-Gm-Message-State: AO0yUKUeLv4SsfWEFMiUBMpBcBvoEoebljuTkexeQy55kSetYjpOsGoz
	TlFNBo53lyj6cBIhFwlVDCXtYDewJec=
X-Google-Smtp-Source: AK7set8zre6vcOCIFYfZQQH3CBoT1NkpHzT08x8Yp1nQNyQxA0dogkh/FNr6jlGsHJZLHTfmfUpQ4Q==
X-Received: by 2002:a05:6a20:12d1:b0:cd:fc47:ddbf with SMTP id v17-20020a056a2012d100b000cdfc47ddbfmr17185915pzg.47.1678211877038;
        Tue, 07 Mar 2023 09:57:57 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id a14-20020a62e20e000000b00582f222f088sm8190079pfi.47.2023.03.07.09.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 09:57:56 -0800 (PST)
Message-ID: <680f3bd7-2af3-bdf3-5640-faf5a21a9182@acm.org>
Date: Tue, 7 Mar 2023 09:57:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 0957/1001] scsi: core: Remove the
 /proc/scsi/${proc_name} directory earlier
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
 Yi Zhang <yi.zhang@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20230307170022.094103862@linuxfoundation.org>
 <20230307170103.699105440@linuxfoundation.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230307170103.699105440@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/23 09:02, Greg Kroah-Hartman wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> commit fc663711b94468f4e1427ebe289c9f05669699c9 upstream.
> 
> Remove the /proc/scsi/${proc_name} directory earlier to fix a race
> condition between unloading and reloading kernel modules. This fixes a bug
> introduced in 2009 by commit 77c019768f06 ("[SCSI] fix /proc memory leak in
> the SCSI core").

Hi Greg,

This patch introduces a new bug and the new bug is easier to trigger 
than the bug fixed by this patch. How about waiting with applying this 
patch on any stable branch until the fix for this patch has landed upstream?

Thanks,

Bart.

