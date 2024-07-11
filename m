Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564F116DECB
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720722257; cv=none; b=eSufylC9jwAL83QWnZNSnUXjhoIH1lUBnd+olLAMk+u3BjC3N05S6oHTUV1Q18ClSmC0KOJ/Xd24v9b8/PicCb2fUSgK2pvrPJ/+4SATB14+CUI5T8bP4hwr1He+gSvLOnRls7PBVX3xTFL+UwjkGqbqP5IZ5pX2AHUGJ6ufg6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720722257; c=relaxed/simple;
	bh=4yc6TTybyvbq7r+wQzEg9hfuNL618Dtw76lL5URUVIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCv5Hs1DCVrBcwI+T2YT2+r55k8FZ9GrnTRLwca5NYYcvnoYDx/sqidwNeJ8KgSrm+4FYWgSwdI1yfADhZTuP0TUqCt913xA3CY8vPCgcubOITz/yYuj7j2Wts47lon7XBkDIxEGvm4D6qN3nYa7sCqdVFOF/iaYpyzhdcFO5fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EO/FSteY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EO/FSteY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720722255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Cm66rg1XZxCCsZjKT6Mp2kABO5AQZLpHZVrfTgemS9w=;
	b=EO/FSteY3Gv+khjeE7XJ1/IADxhe3Tn0S2MdducIWVEUIaM+PzGJWj6AlZtVt7j5YWcsqe
	kCmVCFgWV7KP/UeNbblZrdaFDgOwQs7/+BDIpBiI/CniCvOb3nqpZn8S9UzGRj4dRGCF1C
	VxU02dqyUYqLdaZhNJnY+0KLPLnpbFc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-uWLKLKsCMEiHKLuGlKeGDw-1; Thu, 11 Jul 2024 14:24:11 -0400
X-MC-Unique: uWLKLKsCMEiHKLuGlKeGDw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-70af28c2665so1262714b3a.0
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 11:24:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720722250; x=1721327050;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cm66rg1XZxCCsZjKT6Mp2kABO5AQZLpHZVrfTgemS9w=;
        b=MqgLh3maxpyFhyHIPtVL54Wv9LMSQlCjNPQ811P0fUyfaxyTKJWi08jnApebyOcys/
         VCpuTswCqkN49+NrizIUpzbJHbKoslcGjpwaTV2bQg9FCjPIS/VUYVy3jv4nTspoLS+n
         g8eiPLSGRyWa2L6sjGt6OlqXy8ntnh026WFp3WOUMjm+1kyPM11mSs5jqC7tOOaQrAW2
         F+TVNxN1lvpS1GU8DefRrkownQU8QBoXNFBUILlNzfR8vauPtlfzusJJ7ewXvSLfUnR5
         oDkECwFVIcyyvnegE5DpMpto7TGFa5ccYCGSnu7mHTH5m52vGeWmU2k4gUDIEpTf+Pos
         2I+A==
X-Forwarded-Encrypted: i=1; AJvYcCVxzMfxKoAf711xBpspyqSTPBA4NW58CMmxZgj58Wmn8ph7dwmYnjeRReB3P3tp3hTgJKWIVFtyD9teOxfqw0+hX2RO5sokmQ==
X-Gm-Message-State: AOJu0YwdiSqyRI12wTJ+5Pt12Yd/IM6UsfknGmqTZdLTv/RKfzTdObev
	mEbkyz9kF3ZN1JceADriLPaYfE7PLx9wPAo63DcaLNYdFoRVa893kXWptq2SCDFhhgeCAazkTCE
	LMDJSexi1getRmNn/2Fba8hLTWl9RClkV5dZJQixESpDwfvkoqBPdy3o=
X-Received: by 2002:a05:6a20:4328:b0:1c0:ebca:963d with SMTP id adf61e73a8af0-1c3becb2121mr586154637.4.1720722250570;
        Thu, 11 Jul 2024 11:24:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4jCYKJblZyB+FBweYmfvmonb9H5CH5xNShBFvfLtVj6t3jF8KoVnfT8+Sq9FycQr3reRt/w==
X-Received: by 2002:a05:6a20:4328:b0:1c0:ebca:963d with SMTP id adf61e73a8af0-1c3becb2121mr586130637.4.1720722250166;
        Thu, 11 Jul 2024 11:24:10 -0700 (PDT)
Received: from [10.35.209.243] ([208.115.86.68])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b439b70b4sm6003781b3a.185.2024.07.11.11.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 11:24:09 -0700 (PDT)
Message-ID: <8586b19c-2e14-4164-888f-8c3b86f3f963@redhat.com>
Date: Thu, 11 Jul 2024 20:24:07 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 1/4] mm: add MAP_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de,
 linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
 Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
 Christian Brauner <brauner@kernel.org>,
 David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
References: <Zo8q7ePlOearG481@zx2c4.com> <Zo9gXAlF-82_EYX1@zx2c4.com>
 <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
 <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
 <ZpAR0CgLc28gEkV3@zx2c4.com> <ZpATx21F_01SBRnO@zx2c4.com>
 <98798483-dfcd-451e-94bb-57d830bf68d8@redhat.com>
 <54b6de32-f127-4928-9f4a-acb8653e5c81@redhat.com>
 <ZpAcWvij59AzUD9u@zx2c4.com> <ZpAc118_U7p3u2gZ@zx2c4.com>
 <ZpAfigBHfHdVeyNO@zx2c4.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZpAfigBHfHdVeyNO@zx2c4.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.07.24 20:08, Jason A. Donenfeld wrote:
> On Thu, Jul 11, 2024 at 07:56:39PM +0200, Jason A. Donenfeld wrote:
>> On Thu, Jul 11, 2024 at 07:54:34PM +0200, Jason A. Donenfeld wrote:
>>> On Thu, Jul 11, 2024 at 07:27:27PM +0200, David Hildenbrand wrote:
>>>>> PG_owner_priv_1 maps to PG_swapcache? :)
>>>>
>>>> Maybe the combination !swapbacked && swapcache could be used to indicate
>>>> such folios. (we will never set swapbacked)
>>>>
>>>> But likely we have to be a bit careful here. We don't want
>>>> folio_test_swapcache() to return for folios that ... are not in the
>>>> swapcache.
>>>
>>> I was thinking that too, but I'm afraid it's going to be another
>>> whack-a-mole nightmare. Even for things like task_mmu in procfs that
>>> show stats, that's going to be wonky.
>>>
>>> Any other flags we can overload that aren't going to be already used in
>>> our case?
>>
>> PG_error / folio_set_error seems unused in the non-IO case.
> 

Note that Willy is about to remove PG_error IIRC.

> And PG_large_rmappable seems to only be used for hugetlb branches.

It should be set for THP/large folios.

-- 
Cheers,

David / dhildenb

