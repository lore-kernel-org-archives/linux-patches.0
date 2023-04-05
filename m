Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA19D7470
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 17:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680714400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+jGMyE/H4z0XX1rbokRrj+UlMMC2RKbOMB2U8991WxU=;
	b=gsytrA3zaQKWI+6qf3PBSvOUnP+vnIwl4te0xeaJtSZDGQfDTLA0vefCZTxyq8qG2ytsZ+
	4jngw6fo7dFaaAmdP0LEVPIHvobNQcLQCcaCxDCYrABBrMW4Goju02PrSUUJTI6SZw2wVV
	UwEzCzx8z1lvF0BA2uEzDc0UxCOizZI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-kTAfior-NZGYC3JEjV_cZA-1; Wed, 05 Apr 2023 13:06:39 -0400
X-MC-Unique: kTAfior-NZGYC3JEjV_cZA-1
Received: by mail-wr1-f72.google.com with SMTP id b14-20020a05600003ce00b002cfefd8e637so4536051wrg.15
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 10:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680714398;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+jGMyE/H4z0XX1rbokRrj+UlMMC2RKbOMB2U8991WxU=;
        b=siTO155QkDq8DB3C/dyd044UWcRXl3HP8VlKSAh2ipKYu5vcDxheCzjxRi/NJU4sQB
         YprI8S/SRSo6GBbaK/57uwshJd9XD0FOpSDjitP9Wh3nnNnc4jLS+116aOCH8lSMQVtL
         qBYDuCMW6DSllq0mBx+Z/JPP0VBlWdC5e0Rv2zJs91DEgmGsu8aeh0ZwEHPTYUb7hFQY
         68xMKA7j18il7EedwhW3W3kTEas6DdtukkggUxukw0t1O+R+yvdAMzwN1iN4Hy484rhb
         49oC1ivd/5QR5ULthWvg2VRw5NkKnfyd0V2/d5fR1TUbfW+pPDTbhk0YuDxfOrxxdfuF
         vdBg==
X-Gm-Message-State: AAQBX9erAqFyZejbReaAbqZO1rYbFPjL/uvSt3DdwG3ZlvDXJtmcXPkx
	CedCXl8xRHB0O4SXHF7aD7zQUKalJD+uTGDafdldyttUJ0H1kBu88fyhBdZowYlamKYkdY2iEsS
	2GpyxbdatNp80aZ7zKw==
X-Received: by 2002:a05:600c:3644:b0:3eb:42fa:39d5 with SMTP id y4-20020a05600c364400b003eb42fa39d5mr5247573wmq.29.1680714398419;
        Wed, 05 Apr 2023 10:06:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zc3yUUSM0QMVb09Y7+zHVijaxSRVwUv8quFIs59ptAnEOpLeN1hskZOZ5fkbJtamSWNoF0vQ==
X-Received: by 2002:a05:600c:3644:b0:3eb:42fa:39d5 with SMTP id y4-20020a05600c364400b003eb42fa39d5mr5247534wmq.29.1680714398050;
        Wed, 05 Apr 2023 10:06:38 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:d00:ca74:d9ea:11e0:dfb? (p200300cbc7030d00ca74d9ea11e00dfb.dip0.t-ipconnect.de. [2003:cb:c703:d00:ca74:d9ea:11e0:dfb])
        by smtp.gmail.com with ESMTPSA id k4-20020a5d4284000000b002cefcac0c62sm15631552wrq.9.2023.04.05.10.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 10:06:37 -0700 (PDT)
Message-ID: <d6f6f4a5-2b6d-d3d6-0806-8c41ac5dcdf0@redhat.com>
Date: Wed, 5 Apr 2023 19:06:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 2/6] module: move finished_loading()
To: Luis Chamberlain <mcgrof@kernel.org>, patches@lists.linux.dev,
 linux-modules@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
 prarit@redhat.com, torvalds@linux-foundation.org,
 gregkh@linuxfoundation.org, rafael@kernel.org
Cc: christophe.leroy@csgroup.eu, tglx@linutronix.de, peterz@infradead.org,
 song@kernel.org, rppt@kernel.org, dave@stgolabs.net, willy@infradead.org,
 vbabka@suse.cz, mhocko@suse.com, dave.hansen@linux.intel.com,
 colin.i.king@gmail.com, jim.cromie@gmail.com, catalin.marinas@arm.com,
 jbaron@akamai.com, rick.p.edgecombe@intel.com
References: <20230405022702.753323-1-mcgrof@kernel.org>
 <20230405022702.753323-3-mcgrof@kernel.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230405022702.753323-3-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.04.23 04:26, Luis Chamberlain wrote:
> This has no functional change, just moves a routine earlier
> as we'll make use of it next.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

I'd simply squash into #3, as that's short enough that the move doesn't 
add significant noise. Anyhow:

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

