Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D8CED8
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 11:38:33 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so1597589pjb.1
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 04:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=czltG6L2KkzB298LugAHRvgCtEThwrsgoIBIYbL/lmc=;
        b=mW1t99Tzzl//v4S6OsIZ7O7aaZ27kcJSkc7NEWIWcO0Uoau39paOP9AC0VwPLHYRb5
         tpKKIw0Q9Nmgbw5YNVW6j3mXEoZ1v5iq1Bgy5gkuHL1FHL1Uv4VUqKmo8MMRyXLJ2s2l
         IYYWiiVAlhU9OPfjBfqRdaZgckD4p8CCtXeyKrG7KbHCtgElYH3AhBxRn1JZkLD5jWyt
         09iHSLgBekvpDrV/9nzTh0Fgf6N80F5g/WSS0Hy7JV+G/sjBma9yPQWpmegzyzShyB/D
         vg/aJ4mrOHhf4C64FGNVB5IXt59uRqACzfB15PihqDViFiC+8VikE3d7Ay7JTtA6YXKU
         r3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=czltG6L2KkzB298LugAHRvgCtEThwrsgoIBIYbL/lmc=;
        b=D57yJah7uRXsqG2gpgEc69s03/IQUuX8NCE/+CvKwCEdgAMcWbxTP8lx2KvImFHxT5
         nkUdiJ2CXgP8jp+mhyk+Rs1JoHOrOK5b96jcJnDo5EO+67t22U7JWVSEaje8ZGgCeTY4
         U+UBDNEO4MZKduiq31tqIVgJSTPxtgaJ6LX4UvXO5TCI6uaXAI8Ri1p7v7mZCnCIjxjf
         q1EahTQkUTIHpEVjxEeY0L5VzZk5pkt2v28BMJBhE1+QXTfqL82pzSUHYJjzCqVlaHBf
         Va/Xv7KlJLgDgKTzfxwii1xNwRa30VvmzhxIRSxTEvHgmlmMG0OoM/m+bf5Qj5cVbVre
         A8VA==
X-Gm-Message-State: AOAM533LceFCbpqsiipirQHUn0D6nkp4A4gPDKM4PsQnYxGnHMVZaHjD
	lF8DRS5gxe0r7qXqIN2qRH13Rg==
X-Google-Smtp-Source: ABdhPJxPAhtfomWeKdsxGXDr3c7zmgNdpnPo++Q7ZHAGZztXONhhmeU6M+A+FPJddomQbcFHtuZPTg==
X-Received: by 2002:a17:903:22ce:b0:158:f809:3116 with SMTP id y14-20020a17090322ce00b00158f8093116mr10472507plg.159.1650368312542;
        Tue, 19 Apr 2022 04:38:32 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l15-20020a62be0f000000b005059cc9cc34sm16311856pff.92.2022.04.19.04.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 04:38:32 -0700 (PDT)
Message-ID: <77dd9800-041f-edee-4ab2-911dc311466b@kernel.dk>
Date: Tue, 19 Apr 2022 05:38:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] Drop Documentation/ide/
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20220419011021.15527-1-rdunlap@infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220419011021.15527-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/22 7:10 PM, Randy Dunlap wrote:
> Drop all Documentation/ide/ since IDE support was deleted by
> Christoph Hellwig <hch@lst.de>, Jun 16 2021.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

