Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0553379C7
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 08:47:35 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id y14so12796672wrq.4
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 01:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679388454;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XtHqZkEWuTahdTsop/BgtjQDbajvxIKZBkyXXuaB/ds=;
        b=BmXRwHDNMULR3xIqdzZ2p+gUZ6VX4mh7cM1N3bYfEC2lm9hA75LBXEhmQ3p/pqpx0Q
         jqvx83a30zPxizH5IQUHyQH0bZz+1V1PgfLjoJP6p5p3o7AGt11vwJgZn5UkAWLCcePd
         AGg5MEN9Fv0K7wTnMg/jWVzahMcKQ4iEuoSkZ/EpG1+y0hsLWoEmAZCPsSxZT0xOUPrr
         juLH+FUIbYAgCNLG6OunwSr+Dd8R7XDRpkE97VlqNFbgA8x94ewFh1/+wk0Ngk+gHKUc
         Z1cWt6XOIkfhI3UaGK3gDG5FEjVCnY8f8MjLHmkuej461qdy0YEhwRKPiNimDryIQyYS
         nAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388454;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtHqZkEWuTahdTsop/BgtjQDbajvxIKZBkyXXuaB/ds=;
        b=Pc1FB8u3B2g6Rcj8/Tg1lXkhpo7zA82+I2h8kgdfYItqOCHoPY2mKTdrXZU+qSPtVn
         YRaw2nwhsbV5h/r6TdJgDnbg691m4+Z2vFrAA0qZ3PGukIOFx8ij59rMuGdVzd+1ouOO
         hBTGeRXEeGWPkcS/2Wd+VnWnZdA0r59ByhjMIscqizcXUuoHnAnLoeTfVdw7LmwcoMXU
         s4Dd7B0F9JqdYL3w1+US+YBfdSvKg/CX9DoxMLLDkyoLvlIIlOj7tCfQVn9Yf1YNGHzq
         DYst3JOobpFm4XSVBw0ONad19m9TE5M3QSSCvfa0Ndr7MwmfXYgLWMucJP8M/THnX6pb
         z+IA==
X-Gm-Message-State: AO0yUKXuzrJBGqoMdpLriKPR+7v3oVDz8jORTox5U7x2Cj77mzVeTG2f
	nnvFpkdStswYtIaNT1KeZ8w=
X-Google-Smtp-Source: AK7set8J2CvTMs3v7VYwtR9kJTgmjPkUwPYEW1kTBsVsLD7LBfou73qPtnITJr4oCdgBqdjharedpw==
X-Received: by 2002:a5d:6a08:0:b0:2d0:bba8:3901 with SMTP id m8-20020a5d6a08000000b002d0bba83901mr1744754wru.62.1679388454164;
        Tue, 21 Mar 2023 01:47:34 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id q4-20020a05600c46c400b003eb2e33f327sm1924022wmo.2.2023.03.21.01.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:47:33 -0700 (PDT)
Message-ID: <b36aa25a-7cbd-6926-1ee3-ab9b2bf76111@gmail.com>
Date: Tue, 21 Mar 2023 08:47:32 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] stress-module: stress finit_module() and
 delete_module()
Content-Language: en-US
To: Luis Chamberlain <mcgrof@kernel.org>,
 Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: patches@lists.linux.dev, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, pmladek@suse.com, david@redhat.com,
 petr.pavlu@suse.com, prarit@redhat.com, christophe.leroy@csgroup.eu,
 song@kernel.org
References: <ZBUA6E3kYh0Xuu/c@bombadil.infradead.org>
 <ZBkClVqkTp5b+gut@bombadil.infradead.org>
From: "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <ZBkClVqkTp5b+gut@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/03/2023 01:04, Luis Chamberlain wrote:
> On Fri, Mar 17, 2023 at 05:08:08PM -0700, Luis Chamberlain wrote:
>> I'm not sure yet why we don't see the module delete work, I guess
>> because it's refcnt is still not 0 and so the unload probably won't
>> help at all unless we have a loop just dedicated to that.
> 
> <insert self deprecating humor>
> The reason was because the module_name is the full path, and the system
> call wants just the module name.
> </end self deprecating humor>

Ah, that explains it.

> 
> I'll fix.
> 
>    Luis

OK, I'll wait for a v3.

Thank you,

Colin

