Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7384C538F
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680112142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
	b=i0UsfHcQcfdgq6vst4WGz8RESQzl4O6TP0Mr4/NYYKRmZkjE8TLH986RrDRfd3nzVCM36S
	PmRFDTb2eyn7z3zvbCCwKwpqt678Y0RZ4LMT9GtYEpTrBYVZ0Z4Uyq9wANUYEGS/9PKrCE
	Zh1YpqbzsIlhfFt6dBgZje3Z6OldYaQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-8UfH2HD5OFSuW12Mq9cdnw-1; Wed, 29 Mar 2023 13:49:01 -0400
X-MC-Unique: 8UfH2HD5OFSuW12Mq9cdnw-1
Received: by mail-qk1-f199.google.com with SMTP id d72-20020ae9ef4b000000b007467a30076fso7677614qkg.18
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 10:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=qT3e2qR5ab/3t3/EUtrCWQ+/3Qmft4OUcy7ve+K/qR0WfhNf/WkGjdepGTNQ7o4c/t
         SlhHLyzsfaC8m/lm7ErgsTDWiphEDufQJBq0N38UOrl2PUIZUohoHKj4hZefROxHC/N9
         PlMmzdF9rWmlIvt7ZCh8MbIjcgLoN6i4DtDK22a+zQ95YRlUm27eveBv3cBccGbcBfTh
         Myz96f2ehkq37YtymTDL4NRFb2tbPlFE30+PKSlCA/MEYtjq/Bx1694cft/jQZ/72Iub
         iE7KQOudGmBo/kOUSsn8UhBWtiLMI7V4zqp0AITByPapWAcpm4mZPs2gDJEo/dWDMENW
         D1HA==
X-Gm-Message-State: AAQBX9c6qbHf5/jOHg3jVZg2/iDXN5C1TDaliq86PsR8TPPXvGMZjJKj
	XFmX7w5sEMTnxePk2HtU/jJrt5iih/syzPh0p3qWfzb/PkQlxv0z1UI2A5O56tIaWjYN3OS5NJ/
	VCaZmX1qP5VRiDDjYQg==
X-Received: by 2002:a05:6214:5299:b0:56f:796e:c3a5 with SMTP id kj25-20020a056214529900b0056f796ec3a5mr33440983qvb.4.1680112140878;
        Wed, 29 Mar 2023 10:49:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350aI2qlfzgI2jwFvg3qZMpYzAQdHa4DExATysZa4PwrH9UwHFxOYyuR61+4tFE0cJ4kmmOzrCA==
X-Received: by 2002:a05:6214:5299:b0:56f:796e:c3a5 with SMTP id kj25-20020a056214529900b0056f796ec3a5mr33440968qvb.4.1680112140666;
        Wed, 29 Mar 2023 10:49:00 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id mu10-20020a056214328a00b005dd8b9345aasm4699202qvb.66.2023.03.29.10.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 10:49:00 -0700 (PDT)
Date: Wed, 29 Mar 2023 13:48:58 -0400
From: Adrien Thierry <athierry@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 6.2 128/240] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCR6CiexABbS9AVI@fedora>
References: <20230328142619.643313678@linuxfoundation.org>
 <20230328142625.117629733@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230328142625.117629733@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A possible regression was found with this patch [1]

[1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Best,

Adrien

