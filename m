Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3592B538F
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680112102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
	b=TzktFozUStf7HV9Q9LgiiozeS4bQxQXPh0xroSVC8J3vuUaYRVEENVcwpPG9sU6BtJWbo3
	+ejDQxOgsZ0Klemedf+OAEtWlR/kS03DSkahIPr9o16chQHyTRkdqJp7qqtiRfqmkLqyPA
	liQ/+dkuspR4XMu+5Fj7OMOEk0XgPpU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-GNrUkvMBNh-XV2OLB__t1A-1; Wed, 29 Mar 2023 13:48:20 -0400
X-MC-Unique: GNrUkvMBNh-XV2OLB__t1A-1
Received: by mail-qv1-f69.google.com with SMTP id g6-20020ad45426000000b005a33510e95aso6976358qvt.16
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 10:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=071NlgHeFtrCaWDEVWfKg1A5nT0mM7BXPXulkAT957L0zgVO2+2mCMtZEBk7GpulH+
         Hjf9mtc2gI+pEtaQzM1fhh5Z9K1UvI9KqjrUOSyDknAbc49F74v2cVw082cd2HnFbCgB
         wgIfM9ZAF9t4g7ZeJhTRB9DtgXFRC/rLam90aOZz1wR+w52JjRiBj+IfCkIwjPp7zdpo
         rndr96qnoBsTYx4rX2T1LdvKcnlnKqxBCoabMjFw2b/1SBdI5wuk0vNcZbTw9l0Y7SM9
         JURsHGyNMmMwmLSvsTo3sc1Jj3zWT60noD8J7YVssIbRVyUNl8+KcO4Vb+GHNqpElvPr
         DHKA==
X-Gm-Message-State: AO0yUKWqJGgoKlDJdLWtZk6hIOgU5HBMrl2iFqlbQfkTylB1eSSVlext
	NnrxyGofJ2j+1wULttqbmkBxPx0vVyNSivsfLtc+jBqn5VXiP5AEW23jUECXZiCNq+WjCWHdjBe
	0u2Sqx7IJf/paeTivNA==
X-Received: by 2002:a05:622a:c4:b0:3b8:6a20:675e with SMTP id p4-20020a05622a00c400b003b86a20675emr26808665qtw.29.1680112099165;
        Wed, 29 Mar 2023 10:48:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set/RuEFaBncS1XZKU6gjxIY1BwiyEPHuyqMb56XvK0jO+KAKN56Wfax/73/7/MdVMdg0ASOZWQ==
X-Received: by 2002:a05:622a:c4:b0:3b8:6a20:675e with SMTP id p4-20020a05622a00c400b003b86a20675emr26808638qtw.29.1680112098922;
        Wed, 29 Mar 2023 10:48:18 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id 66-20020a370b45000000b0071eddd3bebbsm10492274qkl.81.2023.03.29.10.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 10:48:18 -0700 (PDT)
Date: Wed, 29 Mar 2023 13:48:16 -0400
From: Adrien Thierry <athierry@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 6.1 117/224] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCR54GpXqZFNET9z@fedora>
References: <20230328142617.205414124@linuxfoundation.org>
 <20230328142622.233084877@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230328142622.233084877@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A possible regression was found with this patch [1]

[1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Best,

Adrien

