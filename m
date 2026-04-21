Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781BA3845BA
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 08:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776760965; cv=none; b=CR5NZ5fGz/5rAfb7x6aVrk4pouulX7K2CniIduAj6I0Q6j9j5lU24OTzXQqDy+p5CUsBjPFkM67BbkTxHiBXLQKBk1yBHUKjUVffnTvYQikSi2cqhLqT+uZk1mXlk9Ay8PEcBpWY0cv1KCwoh7O46koYIK0/cxojEaQrnzofWf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776760965; c=relaxed/simple;
	bh=AubcC8q7XMgE101rnN4IR0kfwdHYPJP8rHsXz6m9xwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHb6GoUeBRue1n3k9yb6pYjWSC5azrotdlzRGPMC89httxvmCR+eIR+YC8sXv5XTCrtJSWfO1NrN0n4TqS7XpuwF67v5u9hIB9+fOnUYMbMtNXqn1gm6+QeP1Mrx0a/LGbXna6m37O1w8zaGdWjLRWEcgYV3a8JHFyeMWPqedUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=KYvZ8QNw; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="KYvZ8QNw"
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B5A783F646
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 08:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1776760953;
	bh=5X2/lpQqoRbi63ooosn3ol82poijbvsxg7c3eVgEVPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=KYvZ8QNwB/7M6P8ihT/rCu6sVMKzxM461029mVR+ZW3WJSW2GeHaWwzFZDv1RDYji
	 1ueL/SOFBkR44eHC85OWqMWeKmbAh9b8bg2/0Pc8cuIH/dU+ZVjeh6lG2D8wuREX82
	 BMjM9yap/AZn+IC2C5ohlVol5zHE2n7HP9qGN8zVUGqPBCWDjzE4yD+SJX7xwQM9YV
	 odmctYUVBLKAkXFK8gdGryf+0XSIEGI742L9LoJ3vjTP8TW0PNh0CTvki15A52onWq
	 1MINsUmwjddY7+ys9C3vYBcHvOlEjUhBM/VRyKbwJf2pft1SXKm6soQvXRMTOFKW2u
	 XwfuLrwcEnTDlS79fno0Qrm8F0ac4FAeYSsuAPjOykVMBG2G1Si3/A4aB0LwRcxL0p
	 fvi2oTB5iFnNWkgoZpJArqMHATsHmJF2TcHkF03oCbFWWBmGri4rYm/i/gh+NQr0xm
	 wZj0qt6+J5SfkHu9valfwBQQrfKaCCFiO9+fF67LdEYn3hq52w40jeWMMlu5Yp0i97
	 NOPvbqxLsHelvmlBefw+sFCbOwPdjhcAvpYOzAujms4FZ9HjTkVex0qBMyE6CEPdUd
	 bmuE0ttpxs6nyRMx0LjupZ0Upi0gtn9Rj7rw/d65vqnaTz8D+NcBLmwf0NeH0RO/G4
	 UZiSxb2sE8OS7fS4rrwYRSTc=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-358e425c261so4594865a91.3
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 01:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776760952; x=1777365752;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5X2/lpQqoRbi63ooosn3ol82poijbvsxg7c3eVgEVPk=;
        b=VxA7X5AfA0m03booOLk03l3FuSoMrdRg6BieFUTyj7jxq9pgt7Whapsea0iGNhuI/I
         YA831yWxhLWCkiU9Vz3PmB+o91/ei8Jb0XalH8mlHlJVEtvFRBWe0OggcvW6h5O5k6Ae
         2ZILIwZGkSYOeMwzHxPht8rL1YQn6oseNy5tIQirX+V9YKPOI2q7Ib/ZIfO95L4+Hkw2
         gjdAz8aF6cYRXZpjBxF+UZrTn9M7gFVvnZSpmiEn+T0nwOHX+ckYLJBGYNqxonBGp1qj
         PMINwt3Akyq7U36ZQhfeyV8CEzI9OH1po3pWcilqhvGiatKwV40066+BeZxtj+mto7zv
         +6ag==
X-Gm-Message-State: AOJu0Yw25pP1Au6ASNp7yvq+8RDjWGELNPnMrQckoLw6yhmoyJn4q1Az
	g9/sD4iPoe9SwKJV95C7D1m9gxtBgS87d3AvhU0XIfMdlBy+pUFKxmlccJDZCkPS7A+be7gkhUw
	WIepAFbHjNXJySXGWgunFPJrAaWRm2EIw3YNwSjZccCZ89PmrVZqfc3cUgPPJMFi3Hv0zT/quDt
	E=
X-Gm-Gg: AeBDiev8ckNb8Pwuj7EFPjDdZm0lAo0amuea8hPkhOcXf5aUh9EzedHRNSPgWWptgGf
	gP2GY1rUWQJN6Ubj5HvIY+rlS0RKr5gSi+4nrGqi0sq6fQ1lToTfn6qQAtYXDUxT5trNDmW8w5k
	Ino1svAPHOZ3MoS89yVEhiq1V55Rpr0MvpJSR5GOJHsmj/+rvTho93WKoVkjlT9cP6TgKDGTnMA
	6vDObHYfbrAAfTwo/WobBfr9D+8k5DQaSMDDRp8XYGrdJnC+2t2qxMXSLkVvqWgcxTS+3DjyX+J
	A/1VYX9t0CEL+uzGYIfloge7+pyDeGYrVOtGMijrTTPnejcUUXF0AyypwxQA+1gAr7hvbhSHGQs
	yFtVFNbhMKKo5an5FSxFJL1NfW5IAcoPt0vHa78DDBrocTys=
X-Received: by 2002:a17:90b:2ec7:b0:35f:c0d7:ac54 with SMTP id 98e67ed59e1d1-3614041aa7amr17925097a91.12.1776760952250;
        Tue, 21 Apr 2026 01:42:32 -0700 (PDT)
X-Received: by 2002:a17:90b:2ec7:b0:35f:c0d7:ac54 with SMTP id 98e67ed59e1d1-3614041aa7amr17925080a91.12.1776760951885;
        Tue, 21 Apr 2026 01:42:31 -0700 (PDT)
Received: from [192.168.192.71] ([50.47.147.90])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-362bc4f9360sm813768a91.1.2026.04.21.01.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 01:42:31 -0700 (PDT)
Message-ID: <5c718a4f-b0fe-4b80-8fdd-200871454320@canonical.com>
Date: Tue, 21 Apr 2026 01:42:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 430/491] apparmor: validate DFA start states are in
 bounds in unpack_pdb
To: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Qualys Security Advisory <qsa@qualys.com>,
 Salvatore Bonaccorso <carnil@debian.org>,
 Georgia Garcia <georgia.garcia@canonical.com>,
 Cengiz Can <cengiz.can@canonical.com>,
 Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155835.127014179@linuxfoundation.org>
 <0d3747dc57d7bfa3c53efcf4d133021ead5bef9d.camel@decadent.org.uk>
Content-Language: en-US
From: John Johansen <john.johansen@canonical.com>
Autocrypt: addr=john.johansen@canonical.com; keydata=
 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 lT9Q
Organization: Canonical
In-Reply-To: <0d3747dc57d7bfa3c53efcf4d133021ead5bef9d.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/26 03:26, Ben Hutchings wrote:
> On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
>>
>> commit 9063d7e2615f4a7ab321de6b520e23d370e58816 upstream.
>>
>> Backport for conflicts caused by
>>    ad596ea74e74 ("apparmor: group dfa policydb unpacking")
>>    - rearrange and consolidated the unpack.
>>
>>    b11e51dd7094 ("apparmor: test: make static symbols visible during kunit testing")
>>    - rename function and make it visible to kunit tests
>>
>> Start states are read from untrusted data and used as indexes into the
>> DFA state tables. The aa_dfa_next() function call in unpack_pdb() will
>> access dfa->tables[YYTD_ID_BASE][start], and if the start state exceeds
>> the number of states in the DFA, this results in an out-of-bound read.
>>
>> ==================================================================
>>   BUG: KASAN: slab-out-of-bounds in aa_dfa_next+0x2a1/0x360
>>   Read of size 4 at addr ffff88811956fb90 by task su/1097
>>   ...
>>
>> Reject policies with out-of-bounds start states during unpacking
>> to prevent the issue.
>>
>> Fixes: ad5ff3db53c6 ("AppArmor: Add ability to load extended policy")
>> Reported-by: Qualys Security Advisory <qsa@qualys.com>
>> Tested-by: Salvatore Bonaccorso <carnil@debian.org>
>> Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
>> Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
>> Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   security/apparmor/policy_unpack.c |   21 +++++++++++++++++++--
>>   1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> --- a/security/apparmor/policy_unpack.c
>> +++ b/security/apparmor/policy_unpack.c
>> @@ -841,9 +841,18 @@ static struct aa_profile *unpack_profile
>>   			error = -EPROTO;
>>   			goto fail;
>>   		}
>> -		if (!unpack_u32(e, &profile->policy.start[0], "start"))
>> +		if (!unpack_u32(e, &profile->policy.start[0], "start")) {
>>   			/* default start state */
>>   			profile->policy.start[0] = DFA_START;
>> +		} else {
>> +			size_t state_count = profile->policy.dfa->tables[YYTD_ID_BASE]->td_lolen;
>> +
>> +			if (profile->policy.start[0] >= state_count) {
>> +				info = "invalid dfa start state";
>> +				goto fail;
>> +			}
>> +		}
> [...]
> 
> Isn't this range check needed even if we use the default start state?
> unpack_table() only checks that td_tolen > 0, so we could end up with
> profile->policy.start[0] = DFA_START == 1 and
> profile->policy.dfa->tables[YYTD_ID_BASE]->td_lolen == 1.
> 
> (This is specific to the backport as the upstream version didn't put
> this check in an else-block.)
> 

Hey Ben,
I specifically chose not to make that alteration to the patches sent to
stable after reviewing the submission rules. That would be a non-backport
related change from what landed upstream and we were referencing as the
upstream patch. Instead I am sending Linus a 2nd patch that addresses
the issue by ensure the loaded dfa has at least two states. It will has
a fixes tag and will get pulled back.


