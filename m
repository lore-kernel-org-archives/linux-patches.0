Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793260396;
	b=fx65RSKWwKYbv3gtQWWhU8pBgpfs/R78FrpC6q1u9MFS/z6OKk/aNWQ7V50AJjFaRzM1
	 m8RBCxjIXf6o9mopwrF9awWwLHCVt/tSmC7f7cQ/sCLwULfsit+upl8e9mpIodK+dpF5q
	 kgg2ihsFlxhlkgWYoVGvhE+ikgrN87sM+QZgonYWiUHqkwGHjI7ov0QNdkffWHIgj5mqM
	 It1ImKxNpDIRDnk1XKBFBjm3TALB6T+hecUREsri7dVccSbpk7M/h4PHK0G/oz3V6LtX9
	 CJRHYyWla51H/Hh2PTbouvVdMJUrgYPQrgxKSJyYjM7gLEPNXxkPlVqzPqpmmkTfbDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793260396;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=HLaNqeXsgQkgy476yZjSOF9KDXj2H///MC1KpwxDrCE=;
	b=Cn7+CH5bfnqhnvLBj3XS21wcB4wFaHEEaM0ZEzXFxG+clRKRhUyF4Zq3ZC4Zy8Lu2UiJ
	 XynD6yE79HH0qZZT8f/wf7vB3VEAFRrf9+9GqbR7I6SBMlLqP8skzTzbU+X9XwDKk8uuB
	 RvkH+TQAqRBJQGV2hNiqob0GlRXnNssMM5ySI0W8gpAqfNAjcJhVEFOZtCuHgjCfKfPf9
	 nYFnJGkh4b2ssIpuv3MyeIoR9XDFmd70gKLN++PpFnAFxihs4ikosMqeq1PLWSdi68LPd
	 L051VffJG1p1oEsrP54JFFgmYU20N1B7z0w64CV20dxx5Ic1RDVwCP4qpzqjxrVE5Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SKpv0GkM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04160606A31C;
	Thu, 29 Oct 2026 07:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SKpv0GkM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615BB1F031E2;
	Thu, 29 Oct 2026 07:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793260395;
	bh=HLaNqeXsgQkgy476yZjSOF9KDXj2H///MC1KpwxDrCE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SKpv0GkMvN/pFxz9F2tolSA4RRnEeS54oasNONDI1eQ1OdMu8g5FqrmsAZQQlnnWV
	 P3kkKHG6eJfh4qOPDpGlLsP1V3bpe86tO/M//MA31vF4rtyWFCCRLBQ8loZ4a+md6V
	 I+K25CC/9RP6tDTnm2xRbl57eYF6VFClRpwG62QFyN4r6+k5/sG9Py7J/jbM/IiNwi
	 /kI1zUTjGDSJGswa7Yj2/EGvHua1BTKvyZfd89wgZelPckAt5iSt+PTisdqJPAr9fA
	 isDczWkMzkqslKyB+Bw6xn2Tp4dXoIt0lOe0uLs1hacPJFZweSRE5JZ1mE+FxPWJPC
	 9l1QC750TccCQ==
Message-ID: <9eb403db-31da-4b6e-a2b5-69f311c05d00@kernel.org>
Date: Thu, 29 Oct 2026 08:53:12 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 14/38] io_uring/poll: avoid retry wakeup loss when
 dropping ownership
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Juanlu Herrero <juanlu@fastmail.com>,
 Anand Natarajan <anand@meta.com>, Jens Axboe <axboe@kernel.dk>
References: <20261028165940.394092994@linuxfoundation.org>
 <20261028165940.759766255@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 xsFNBE6S54YBEACzzjLwDUbU5elY4GTg/NdotjA0jyyJtYI86wdKraekbNE0bC4zV+ryvH4j
 rrcDwGs6tFVrAHvdHeIdI07s1iIx5R/ndcHwt4fvI8CL5PzPmn5J+h0WERR5rFprRh6axhOk
 rSD5CwQl19fm4AJCS6A9GJtOoiLpWn2/IbogPc71jQVrupZYYx51rAaHZ0D2KYK/uhfc6neJ
 i0WqPlbtIlIrpvWxckucNu6ZwXjFY0f3qIRg3Vqh5QxPkojGsq9tXVFVLEkSVz6FoqCHrUTx
 wr+aw6qqQVgvT/McQtsI0S66uIkQjzPUrgAEtWUv76rM4ekqL9stHyvTGw0Fjsualwb0Gwdx
 ReTZzMgheAyoy/umIOKrSEpWouVoBt5FFSZUyjuDdlPPYyPav+hpI6ggmCTld3u2hyiHji2H
 cDpcLM2LMhlHBipu80s9anNeZhCANDhbC5E+NZmuwgzHBcan8WC7xsPXPaiZSIm7TKaVoOcL
 9tE5aN3jQmIlrT7ZUX52Ff/hSdx/JKDP3YMNtt4B0cH6ejIjtqTd+Ge8sSttsnNM0CQUkXps
 w98jwz+Lxw/bKMr3NSnnFpUZaxwji3BC9vYyxKMAwNelBCHEgS/OAa3EJoTfuYOK6wT6nadm
 YqYjwYbZE5V/SwzMbpWu7Jwlvuwyfo5mh7w5iMfnZE+vHFwp/wARAQABzSFKaXJpIFNsYWJ5
 IDxqaXJpc2xhYnlAa2VybmVsLm9yZz7CwXcEEwEIACEFAlW3RUwCGwMFCwkIBwIGFQgJCgsC
 BBYCAwECHgECF4AACgkQvSWxBAa0cEnVTg//TQpdIAr8Tn0VAeUjdVIH9XCFw+cPSU+zMSCH
 eCZoA/N6gitEcnvHoFVVM7b3hK2HgoFUNbmYC0RdcSc80pOF5gCnACSP9XWHGWzeKCARRcQR
 4s5YD8I4VV5hqXcKo2DFAtIOVbHDW+0okOzcecdasCakUTr7s2fXz97uuoc2gIBB7bmHUGAH
 XQXHvdnCLjDjR+eJN+zrtbqZKYSfj89s/ZHn5Slug6w8qOPT1sVNGG+eWPlc5s7XYhT9z66E
 l5C0rG35JE4PhC+tl7BaE5IwjJlBMHf/cMJxNHAYoQ1hWQCKOfMDQ6bsEr++kGUCbHkrEFwD
 UVA72iLnnnlZCMevwE4hc0zVhseWhPc/KMYObU1sDGqaCesRLkE3tiE7X2cikmj/qH0CoMWe
 gjnwnQ2qVJcaPSzJ4QITvchEQ+tbuVAyvn9H+9MkdT7b7b2OaqYsUP8rn/2k1Td5zknUz7iF
 oJ0Z9wPTl6tDfF8phaMIPISYrhceVOIoL+rWfaikhBulZTIT5ihieY9nQOw6vhOfWkYvv0Dl
 o4GRnb2ybPQpfEs7WtetOsUgiUbfljTgILFw3CsPW8JESOGQc0Pv8ieznIighqPPFz9g+zSu
 Ss/rpcsqag5n9rQp/H3WW5zKUpeYcKGaPDp/vSUovMcjp8USIhzBBrmI7UWAtuedG9prjqfO
 wU0ETpLnhgEQAM+cDWLL+Wvc9cLhA2OXZ/gMmu7NbYKjfth1UyOuBd5emIO+d4RfFM02XFTI
 t4MxwhAryhsKQQcA4iQNldkbyeviYrPKWjLTjRXT5cD2lpWzr+Jx7mX7InV5JOz1Qq+P+nJW
 YIBjUKhI03ux89p58CYil24Zpyn2F5cX7U+inY8lJIBwLPBnc9Z0An/DVnUOD+0wIcYVnZAK
 DiIXODkGqTg3fhZwbbi+KAhtHPFM2fGw2VTUf62IHzV+eBSnamzPOBc1XsJYKRo3FHNeLuS8
 f4wUe7bWb9O66PPFK/RkeqNX6akkFBf9VfrZ1rTEKAyJ2uqf1EI1olYnENk4+00IBa+BavGQ
 8UW9dGW3nbPrfuOV5UUvbnsSQwj67pSdrBQqilr5N/5H9z7VCDQ0dhuJNtvDSlTf2iUFBqgk
 3smln31PUYiVPrMP0V4ja0i9qtO/TB01rTfTyXTRtqz53qO5dGsYiliJO5aUmh8swVpotgK4
 /57h3zGsaXO9PGgnnAdqeKVITaFTLY1ISg+Ptb4KoliiOjrBMmQUSJVtkUXMrCMCeuPDGHo7
 39Xc75lcHlGuM3yEB//htKjyprbLeLf1y4xPyTeeF5zg/0ztRZNKZicgEmxyUNBHHnBKHQxz
 1j+mzH0HjZZtXjGu2KLJ18G07q0fpz2ZPk2D53Ww39VNI/J9ABEBAAHCwV8EGAECAAkFAk6S
 54YCGwwACgkQvSWxBAa0cEk3tRAAgO+DFpbyIa4RlnfpcW17AfnpZi9VR5+zr496n2jH/1ld
 wRO/S+QNSA8qdABqMb9WI4BNaoANgcg0AS429Mq0taaWKkAjkkGAT7mD1Q5PiLr06Y/+Kzdr
 90eUVneqM2TUQQbK+Kh7JwmGVrRGNqQrDk+gRNvKnGwFNeTkTKtJ0P8jYd7P1gZb9Fwj9YLx
 jhn/sVIhNmEBLBoI7PL+9fbILqJPHgAwW35rpnq4f/EYTykbk1sa13Tav6btJ+4QOgbcezWI
 wZ5w/JVfEJW9JXp3BFAVzRQ5nVrrLDAJZ8Y5ioWcm99JtSIIxXxt9FJaGc1Bgsi5K/+dyTKL
 wLMJgiBzbVx8G+fCJJ9YtlNOPWhbKPlrQ8+AY52Aagi9WNhe6XfJdh5g6ptiOILm330mkR4g
 W6nEgZVyIyTq3ekOuruftWL99qpP5zi+eNrMmLRQx9iecDNgFr342R9bTDlb1TLuRb+/tJ98
 f/bIWIr0cqQmqQ33FgRhrG1+Xml6UXyJ2jExmlO8JljuOGeXYh6ZkIEyzqzffzBLXZCujlYQ
 DFXpyMNVJ2ZwPmX2mWEoYuaBU0JN7wM+/zWgOf2zRwhEuD3A2cO2PxoiIfyUEfB9SSmffaK/
 S4xXoB6wvGENZ85Hg37C7WDNdaAt6Xh2uQIly5grkgvWppkNy4ZHxE+jeNsU7tg=
In-Reply-To: <20261028165940.759766255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 28. 10. 26, 18:00, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Juanlu Herrero <juanlu@fastmail.com>
> 
> commit 937d38dcacd675dc0572d6c9b6743960df3128ed upstream.

Our machinery flags this is needed as a fix:
67bb1ad9a517 ("io_uring/poll: don't loop on HUP with multiple references")

> If a wakeup sets IO_POLL_RETRY_FLAG between the owning task consuming
> the existing instance of IO_POLL_RETRY_FLAG and the loop check
> of io_poll_check_events(), then we stall on processing the request
> until an unrelated wakeup comes along.
> 
> Using atomic_cmpxchg instead of atomic_sub_return to guarantee both the
> count v and poll_refs are 0 and no wake-ups are missed.
> 
> Cc: stable@vger.kernel.org
> Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
> Signed-off-by: Juanlu Herrero <juanlu@fastmail.com>
> Assisted-by: LLM
> Suggested-by: Anand Natarajan <anand@meta.com>
> Link: https://patch.msgid.link/20261013-pu-cmpxchg-v1-1-4ddc10fd8a03@fastmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   io_uring/poll.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -330,7 +330,8 @@ static int io_poll_check_events(struct i
>   		 * Release all references, retry if someone tried to restart
>   		 * task_work while we were executing it.
>   		 */
> -	} while (atomic_sub_return(v, &req->poll_refs) & IO_POLL_REF_MASK);
> +		v &= IO_POLL_REF_MASK;
> +	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
>   
>   	io_napi_add(req);
>   	return IOU_POLL_NO_ACTION;

thanks,
-- 
js
suse labs

