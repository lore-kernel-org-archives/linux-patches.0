Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D65A210197;
	Thu, 30 May 2024 06:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717051283; cv=none; b=pExKuJqL5JDKLaVJnxLMgKk08N+CTaojFeowsaOPUWyidU05QuaOhf9kbw0iFynL6XbDPU30UUkhqsycxArPhFRTJ6ak71w7aXR7ROf11Q59IQE31dTZj6d4p1sIX3fmynsh94e869rDUXMidzK2/JmyP+mdAMCArUsDcHwz3as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717051283; c=relaxed/simple;
	bh=D4gXSqADnOk0iOGCbNIKB51H95GuHOPiUKdJBP+R1PI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CFza2RUzLhjj7fUg1RRIC3FDcXBSrTS1uyLKuLFgOvABLt7lZQe/5T1sJQWPcQMcsI2W0ytuJjJTiM52mv/LX3T2Zcf7OUgi0Agauna+6dHkdFnnAWxY6ay+ePgwWPiiiDZLS2SgFvTjzQ/yJoFPs5Jeh29aaZox0751ttZOU1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4211249fdf4so6411085e9.3;
        Wed, 29 May 2024 23:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717051280; x=1717656080;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2UinUncKMG3mfEDsS3Xt/JMMJoyLDA5LlKHUtD/VBs=;
        b=YdjKJaOGV+nZHq7KIPau2hI74o4fUbPUKeHjiQHMMwMGQ5F8K9U4oV/GNSErB85gL7
         LPpM+y0Ys83egm+jaApIhULL8gXX7nj65O7ST3J4/d7DIVw3lycq2MZZKunnO4I29pIt
         Nss0j90A8j5J68OHcYPPYHsnd6gu8c1omlSjLe043Br7JOiazxfVPrAjfkM6Dmau2+rx
         wPNCXgUHbFfOr9Qk9V3pXJaTPomwItr0niGgy/lOtbCqEU1dSoUM973gAVkqbl/rJlDR
         PIFM+8KVwHFmMJpiFGob7M2eg6g5R2vrpdmP3Xy5VAiieIDdY40FU1n+RsRTTIsstuyZ
         ZTnA==
X-Forwarded-Encrypted: i=1; AJvYcCWDkTSCPT9bbCYZT0uaGXEr3fz4Xwu7lTD/wAcdiGbTR/O3Z8h8b4WXiMX+/bslfDPcehkl0NbIlfThYyNVpiGs8NAIkfkUGZbQ/9IAPmmqt5cjkeo7gkf1H+mlqOs=
X-Gm-Message-State: AOJu0YwtB41nfz8+tbAaCPsAR9kzcqHBgyOMCohf0IBHKdQzNIE6jgw9
	KZcJ0vpoT+VJOmFwiIzMAk5DmLg5jy1rDBvDIFzjcEbjLjtNiCKW
X-Google-Smtp-Source: AGHT+IHArpXGtxZDQ1OBgqkI9aalQ8VjHT6AsZ0RHXdpUsKojMGevnqYYYdjAWulbOzH8edJo+7aLQ==
X-Received: by 2002:a05:600c:1d05:b0:421:29b4:532a with SMTP id 5b1f17b1804b1-42129b45590mr1343955e9.16.1717051280198;
        Wed, 29 May 2024 23:41:20 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3557a1c9546sm16439884f8f.82.2024.05.29.23.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 23:41:19 -0700 (PDT)
Message-ID: <0b2b4a2a-83df-4b79-a295-4da91c841587@kernel.org>
Date: Thu, 30 May 2024 08:41:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvmet-fc: Remove __counted_by from
 nvmet_fc_tgt_queue.fod[]
To: Nathan Chancellor <nathan@kernel.org>,
 James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>
Cc: Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
References: <20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-v1-1-286adbc25943@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20240529-drop-counted-by-fod-nvmet-fc-tgt-queue-v1-1-286adbc25943@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29. 05. 24, 23:42, Nathan Chancellor wrote:
>    drivers/nvme/target/fc.c:151:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct nvmet_fc_fcp_iod' is a struct type with a flexible array member.

The same as for mxser_port:

struct nvmet_fc_fcp_iod {
         struct nvmefc_tgt_fcp_req       *fcpreq;

         struct nvme_fc_cmd_iu           cmdiubuf;
         struct nvme_fc_ersp_iu          rspiubuf;
         dma_addr_t                      rspdma;
         struct scatterlist              *next_sg;
         struct scatterlist              *data_sg;
         int                             data_sg_cnt;
         u32                             offset;
         enum nvmet_fcp_datadir          io_dir;
         bool                            active;
         bool                            abort;
         bool                            aborted;
         bool                            writedataactive;
         spinlock_t                      flock;

         struct nvmet_req                req;
         struct work_struct              defer_work;

         struct nvmet_fc_tgtport         *tgtport;
         struct nvmet_fc_tgt_queue       *queue;

         struct list_head                fcp_list;       /* 
tgtport->fcp_list */
};

The error appears to be invalid.

> This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
>      151 |         struct nvmet_fc_fcp_iod         fod[] __counted_by(sqsize);
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
-- 
-- 
js
suse labs

