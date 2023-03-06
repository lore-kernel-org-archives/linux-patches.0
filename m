Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBEE525C
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678111173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r/wVyxF7X8v5Rihnr47AJpuo/zEUiUXj51F4TpZ8Hk8=;
	b=SXUDk0tCoGZgTXqRkJRpcl/ag3KZ5kY1jcM/UjKw+7hgXWxFGBWaHsLU2OhJlFJKjPPZVV
	Z90yStPFhXst7emgw+s2JwRMcy2D/JKY8tpadtD++8yUrlFbVhWlOaNC7aZcMgYpg0qbtk
	tFFAmarGglCYj8RyJCKQlz78ALRZbhc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-2mlcyIl4OvyrEJ0azgtMvQ-1; Mon, 06 Mar 2023 08:59:32 -0500
X-MC-Unique: 2mlcyIl4OvyrEJ0azgtMvQ-1
Received: by mail-wr1-f72.google.com with SMTP id u5-20020a5d6da5000000b002cd82373455so1486164wrs.9
        for <patches@lists.linux.dev>; Mon, 06 Mar 2023 05:59:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678111171;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r/wVyxF7X8v5Rihnr47AJpuo/zEUiUXj51F4TpZ8Hk8=;
        b=d+g3ZJBvv4BzsqdN/L6pkLmyt0S37R2n3HGNhDAe9qwocf9hrB5E1AF1+1+2K7Akg1
         iuYLsN1yJOSP0Z5Qf5qkFpN6l0RADX0uuLM+K+3rXXM0LcRI0NpI2uNO//X46PE6q1iI
         CKaP8ySMD5Dj2yLOah3hR/zGRa/ol3dyeBDxYm93lzncnE/CAGI4PcPKfJhLBfCSOc8P
         nuRfeJHuk7q2UCykVTN7+6PmDfkx6Mi9PtzDlz0JcVa7iEX2IUH5+NreCkxh8blk3Qya
         KDTQ9sRgYZgdkUkEUgcBYPW1zFzDrlMSBgGeetpTzpWY8PnT88dHsjY9mNmJDvhRSi9Q
         91/g==
X-Gm-Message-State: AO0yUKUR8ANKALCjWQLqkEeLgm7+kpm+9OwzlZbz2g4RRy7mIsstC5TQ
	M0srPYs3t9yuJ+kmbH3zZBAxZm39THjdHla4lDk5ubekC7roDiPaKjTwLNYYdP/WfupdWwSlSDW
	hpcQuZubifhsneobKog==
X-Received: by 2002:a05:600c:4ecf:b0:3eb:399d:ab1a with SMTP id g15-20020a05600c4ecf00b003eb399dab1amr8875632wmq.21.1678111171447;
        Mon, 06 Mar 2023 05:59:31 -0800 (PST)
X-Google-Smtp-Source: AK7set/rppROKlCDe1OMxkgmAULnb3zDPT283NgVkX5TfaUiRMqCs34bM9FlAufSTBytifeaefB1wg==
X-Received: by 2002:a05:600c:4ecf:b0:3eb:399d:ab1a with SMTP id g15-20020a05600c4ecf00b003eb399dab1amr8875617wmq.21.1678111171096;
        Mon, 06 Mar 2023 05:59:31 -0800 (PST)
Received: from ?IPV6:2003:cb:c704:3500:b8a3:191c:eae:cc05? (p200300cbc7043500b8a3191c0eaecc05.dip0.t-ipconnect.de. [2003:cb:c704:3500:b8a3:191c:eae:cc05])
        by smtp.gmail.com with ESMTPSA id v28-20020a5d591c000000b002c6e8af1037sm9895953wrd.104.2023.03.06.05.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 05:59:30 -0800 (PST)
Message-ID: <5f8a3f21-86cb-639e-66d8-9b40a218618c@redhat.com>
Date: Mon, 6 Mar 2023 14:59:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/6] shmem: set shmem_writepage() variables early
To: Luis Chamberlain <mcgrof@kernel.org>, hughd@google.com,
 akpm@linux-foundation.org, willy@infradead.org, brauner@kernel.org
Cc: linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
 a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
 keescook@chromium.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20230302232758.888157-1-mcgrof@kernel.org>
 <20230302232758.888157-3-mcgrof@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230302232758.888157-3-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.03.23 00:27, Luis Chamberlain wrote:
> shmem_writepage() sets up variables typically used *after* a possible
> huge page split. However even if that does happen the address space
> mapping should not change, and the inode does not change either. So it
> should be safe to set that from the very beginning.
> 
> This commit makes no functional changes.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

