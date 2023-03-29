Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139D538F
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680111977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
	b=cNvuWGpgZkJmjBDUtxOPFCg6DkCMVb0peB/ZfT87TLkyxjsC/lUzfc6Q4aFJLs8MsFnqkt
	j6qzk7nyisq0E/CJy5lkqEWCztW/vwi80K/cvxmh7Ie8RnkbZXEGEx5J+bMFv+woo/xsw3
	XcNZNLGpXovPcG8wXxhGla64oIhWdJQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-q6gbGASUNbeypRMcw7c1gQ-1; Wed, 29 Mar 2023 13:46:16 -0400
X-MC-Unique: q6gbGASUNbeypRMcw7c1gQ-1
Received: by mail-qv1-f72.google.com with SMTP id y19-20020ad445b3000000b005a5123cb627so6925827qvu.20
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 10:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680111976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=AC76Ooeov0bGab4zjGwNzNDnEgiyIue+nlm2ySmm82dBpvDv+LS3Q6w4GBIkcHffjm
         zwEFk8+m22W/8pEv4cFTfwkX1OpYm0Hze4gCXcNTyPobBJuDcDskUnPyd0tz2z5LNkcY
         pK3Fhe7w1b8V8/dWaqqutEWB5Z00zExQAqGRCZHZ7YkItxT1uVNqmcGdV2aL7ginuiZ6
         1VOmu+hQaIdxly5ShfUB7ghHRuZXvl3bcRkiAmLRRtHItvjYFZV1NSs8TAfj4zD08abK
         FEKLgTwWcNkYHKtoWpSgDqGqj7PfKrgeQGcePL72364eiZ/60kPWFJtUUmpE3Cb8/y6l
         bGSw==
X-Gm-Message-State: AAQBX9cfdYDBCw11AZ9AC0xPZix0cieJqoZLNGoh3BhTee0WK5UohZkC
	w3n/3738oWKbkAADTmG1n+LdtweyExrpMWDo4UEeEt8OK90YEBv5IFgu6MZty2E6jO5iAmWYezK
	SMfpppLGhEmWeQ4X2vg==
X-Received: by 2002:a05:622a:188:b0:3e4:eb8f:8a7b with SMTP id s8-20020a05622a018800b003e4eb8f8a7bmr4376573qtw.29.1680111975891;
        Wed, 29 Mar 2023 10:46:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z1kJwhD5xCTJat8Q4ohGC869VT82gZmyP61KC92Wq3+k/cmmICrDwvYCiuz1nI/CkWFS+EiQ==
X-Received: by 2002:a05:622a:188:b0:3e4:eb8f:8a7b with SMTP id s8-20020a05622a018800b003e4eb8f8a7bmr4376550qtw.29.1680111975633;
        Wed, 29 Mar 2023 10:46:15 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id j68-20020a37b947000000b0074577e835f2sm18758803qkf.48.2023.03.29.10.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 10:46:15 -0700 (PDT)
Date: Wed, 29 Mar 2023 13:46:13 -0400
From: Adrien Thierry <athierry@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 5.15 082/146] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCR5Zef4oHYFkAss@fedora>
References: <20230328142602.660084725@linuxfoundation.org>
 <20230328142606.118680029@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230328142606.118680029@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A possible regression was found with this patch [1]

[1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Best,

Adrien

