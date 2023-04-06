Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC86FD0
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 14:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680790493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B/VuXtyuOduGMa5ZSVvX0YV7CAkGWIAjStnAR0rgErI=;
	b=XRkonhnrmG7TAsmdnjM7H7M0ESl2FoEIqROgUHYWMR867qdfkCD+a0tSaaHzt7ufAs/0Ng
	eC3Jst0KsX4bugUg6x1k+NyabuMoS+TTljyIFQ4YhsRlgdlLl8ollh40wdD5DfV+oDlgMk
	Xp6AKHaUb47+oPJXgyF2X+bVGx4Kr+w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-soT3_CBgOhu0Vt8PF5jkZA-1; Thu, 06 Apr 2023 10:14:52 -0400
X-MC-Unique: soT3_CBgOhu0Vt8PF5jkZA-1
Received: by mail-wr1-f70.google.com with SMTP id e15-20020adfa44f000000b002d7ea9d6ef0so4911895wra.8
        for <patches@lists.linux.dev>; Thu, 06 Apr 2023 07:14:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680790491; x=1683382491;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B/VuXtyuOduGMa5ZSVvX0YV7CAkGWIAjStnAR0rgErI=;
        b=Qvds2uu9GdTV+S71iOXZnZ+QwhPy0jQbzLY90i5XRNRjXD8CcyRxIpcBp+dyUGqXcN
         4ExAV/uscEi3QdY9McYliLCtf6ad+GeTnbO7qzSIlJPERpXtgPTFRfvS5tS7cBbwb2HL
         TCuCnRlwtdejYaRo4p2mYH2YqU0bzFyiV3z83hwTADoVIPefY3PGw121Jmuu0LJYf6xZ
         0NKyrMeJjqxeacar/dj0T/UaEIEuChvTkEHgScg5/QhcUQAK7s4h6naSSZrcG+HMJyZY
         pjeXiCes3/c+y0hMd+/cbO3Dvl0osSMW4Hzm6eb1gssqr/PZKzv+dPTltP7fdH5n2OoD
         2P0Q==
X-Gm-Message-State: AAQBX9cCEJrou3kQmDrJnMtcxIbeMtZzKmhcmR2chG7wIK3UNIM4e83v
	F2PP89KYRtn17J9RoaBkDsppgSIImOExp6Q5X1pnsYElHH4nzC+/Hbl2Xqyg5bTu7JYXHoDGLaD
	iDta2w35tdxCtF62BNg==
X-Received: by 2002:a1c:cc15:0:b0:3ef:561d:255d with SMTP id h21-20020a1ccc15000000b003ef561d255dmr6768194wmb.41.1680790491517;
        Thu, 06 Apr 2023 07:14:51 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZtIq3UeLwNBpMRIQtwhyNqEaPwt8QiZdNhkpjpFMM9Z/XHAeZlxlSD5BXz8r8GJQVI3pJKwA==
X-Received: by 2002:a1c:cc15:0:b0:3ef:561d:255d with SMTP id h21-20020a1ccc15000000b003ef561d255dmr6768177wmb.41.1680790491211;
        Thu, 06 Apr 2023 07:14:51 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id n37-20020a05600c3ba500b003f0652084b8sm5300179wms.20.2023.04.06.07.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 07:14:50 -0700 (PDT)
Message-ID: <cd49c00e-1982-b7f3-5637-4a35533ac498@redhat.com>
Date: Thu, 6 Apr 2023 16:14:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 5/6] debugfs: add debugfs_create_atomic64_t for
 atomic64_t
To: David Laight <David.Laight@ACULAB.COM>,
 'Christophe Leroy' <christophe.leroy@csgroup.eu>,
 'Luis Chamberlain' <mcgrof@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "petr.pavlu@suse.com" <petr.pavlu@suse.com>,
 "prarit@redhat.com" <prarit@redhat.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "song@kernel.org" <song@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
 "dave@stgolabs.net" <dave@stgolabs.net>,
 "willy@infradead.org" <willy@infradead.org>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "mhocko@suse.com" <mhocko@suse.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "colin.i.king@gmail.com" <colin.i.king@gmail.com>,
 "jim.cromie@gmail.com" <jim.cromie@gmail.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "jbaron@akamai.com" <jbaron@akamai.com>,
 "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>
References: <20230405022702.753323-1-mcgrof@kernel.org>
 <20230405022702.753323-6-mcgrof@kernel.org>
 <CAHk-=whH+OsAY+9qLc9Hz+-W8u=dvD3NLWHemOQpZPcgZa52fA@mail.gmail.com>
 <ZC2cC+I1KTyD8UcC@bombadil.infradead.org>
 <ZC2dtI02ZIbjte2l@bombadil.infradead.org>
 <CAHk-=wiGhHk4u2RRZmJinA4Apb47pXXJPW9cOZ_2-yUqOvaC7Q@mail.gmail.com>
 <ZC2nbiarELlUVcSj@bombadil.infradead.org>
 <979c8cf9ab2d4fcba811adc0c563b8bb@AcuMS.aculab.com>
 <48f2c6f2-f776-be29-7d74-67f1b6cf5467@csgroup.eu>
 <6ba49055a1a343e8b50f808f91438e39@AcuMS.aculab.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <6ba49055a1a343e8b50f808f91438e39@AcuMS.aculab.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.04.23 15:48, David Laight wrote:
> From: Christophe Leroy
>> Sent: 06 April 2023 14:38
> ...
>> On powerpc 'long long' is 64 bits on both PPC32 and PPC64.
> 
> It probably in on x85-64 as well.
> By brain is getting frazzled.
> 
> On 64bit long long ought to be 128bit.

I might have been living under a rock, but the only requirement I am 
aware of is for long long to be at least 64bit wide.

AFAIK, that is also the case on s390x and aarch64.

-- 
Thanks,

David / dhildenb

