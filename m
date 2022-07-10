Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292017A
	for <patches@lists.linux.dev>; Sun, 10 Jul 2022 19:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657483036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j6rPChSJrNMOV21SPMB+KCTvjBhzyRJQxoZZsHf/z/U=;
	b=JqYTq/n6DFfFn1Y/yEQaLfmen6ymLvr7C17JaWlpSxYdWlpvu5Z6czcfhk2Sz1nBsmbVyr
	S8aZGEsWceTZPcdaEKTvnQ3UzTW5APp+psyd+fzNLQvbD8O+fmb5I+0t7qdWcaGdY7yGGG
	dq1jBN6b6DACJYj7Pv790kwElCwChTc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-9SVBjQnqMaqSHO5SbJeXWg-1; Sun, 10 Jul 2022 15:57:15 -0400
X-MC-Unique: 9SVBjQnqMaqSHO5SbJeXWg-1
Received: by mail-ed1-f72.google.com with SMTP id x21-20020a05640226d500b0043abb7ac086so2907475edd.14
        for <patches@lists.linux.dev>; Sun, 10 Jul 2022 12:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j6rPChSJrNMOV21SPMB+KCTvjBhzyRJQxoZZsHf/z/U=;
        b=0iBlp90w6xJyHhemOg4pq0LURO3zfkjX4sz28R26dqBR53uFGkLnoz7KIQLxIm5QSQ
         QLW9ZKjnpIR7usHdLPU8sWb9EmFRXpzXTYvHsLEvSPIhGcuSMGMpDQsIZyialOjJT05H
         bEbEz04WECJNmlMCmipnLrzSnc8mlqszuUKrn7EF18ntmzu1bTmkPKXW6qj45JcOxBoY
         pnFOO6fATuznM9s+IIlJNr7LEecYdaED1a3ShA87ptpKCZbvJpRxL//J2XqVS0B6Mgbu
         7t+Q/6BpVth+f53I6GtF4JR9/2pWiDG89O0PpDj1OJgARmch6ytXmGhn+MJAhuLJEPbd
         OOSQ==
X-Gm-Message-State: AJIora9xeNGYv0sulPeN4O6HHGhk6KpGZAcrPaVfdu5SzIFXjBXtKdOW
	YqctlHCa36fVPLFINBnOjJTq+er/6BroWOlyh1XXAn75LR6cFY36Z+aTt3/DTsBhm5KXcmR0rHz
	DcCpZOLgy96dRukw1SA==
X-Received: by 2002:a17:907:2c5b:b0:72b:54bd:40f8 with SMTP id hf27-20020a1709072c5b00b0072b54bd40f8mr1383566ejc.137.1657483034715;
        Sun, 10 Jul 2022 12:57:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u7rNCF5/yqaZ40q8aChIrxUxRxVr6oAworIrvtHiCFKok1ELZFgoMNqZrRV8mf/Zq8cB0/Jg==
X-Received: by 2002:a17:907:2c5b:b0:72b:54bd:40f8 with SMTP id hf27-20020a1709072c5b00b0072b54bd40f8mr1383554ejc.137.1657483034578;
        Sun, 10 Jul 2022 12:57:14 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906218200b0072b14836087sm1838111eju.103.2022.07.10.12.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 12:57:13 -0700 (PDT)
Message-ID: <9ce8aa53-ed70-823f-3410-1f50d5b902c9@redhat.com>
Date: Sun, 10 Jul 2022 21:57:13 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 0/2] Two fixes for IFS
To: Tony Luck <tony.luck@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
 "Joseph, Jithu" <jithu.joseph@intel.com>, markgross@kernel.org,
 ashok.raj@intel.com, ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev
References: <c416b93b-8adc-d9a8-ef0d-594cce6d9a9d@redhat.com>
 <20220710182521.60642-1-tony.luck@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220710182521.60642-1-tony.luck@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Tony,

On 7/10/22 20:25, Tony Luck wrote:
> Hans ... if you are pushing to Linus to add "BROKEN", then could
> you include these two patches to make it fractionally less broken?

Since the driver is going to be marked as BROKEN now anyways,
I don't see much value in getting these send last minute to Linus.

At this point in the kernel cycle (rc6 will be out in a couple
of hours likely) we really should avoid churn as much as possible.

Regards,

Hans


