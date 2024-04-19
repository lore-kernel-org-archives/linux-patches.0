Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85931E4BE
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 08:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713516272; cv=none; b=jKREcKAMdipmHqrmn9rleEitqceuBqzEDLrJII1m7HtXqy2vHljgeJXTZ5DssYnQv3ic3+4U+DAbYI93FlADcakKRyo+rK052rd+9oQP846hoHin5LgGlE7j3jh/cyVaiJNXxXRPp24om3Bs5sGvOre86ARf1NP1wse4ojc78/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713516272; c=relaxed/simple;
	bh=h8+Puu6efgDe0y1LusGfqqNdJwQhMRIfG+1CPt1d0k8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pEZYDH70tK74sSp7g0pScHGE2YVSZck6ysTl8SHxR4/7QfyP80MP0K2ghgvWfNqJOFUIcglwGFM5RPzE3vG9AETKZl5quWAo4O7ihj2p/ILaSpAVIuwrWANdByosJC9YB8k/VHRTFlYL9D9csUHDzVWwnwXV2uApJnmcgPqO+Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a55602507a9so208117566b.3
        for <patches@lists.linux.dev>; Fri, 19 Apr 2024 01:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713516269; x=1714121069;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+i83ciiMH2ogGaXM3brfWf4dab4xqmpucptd4jJOL/s=;
        b=Pn0x6m9u03bUPC9YdbRpKPba+bMlIt7O6WEQ6HI9NJv1bfPMR65VBMt0V2XcXSXgpT
         M74J+Q+HRa0coQJ79TxkXrNrO5Ffm6BcJ/afsvx2hhbi0vLhNXIvD9aqo8CXPmpItjm9
         izfk3e2HQ7fiYE78buM2/txnzT4tXll9vBfWAWI4xSRV2kNbcpOU/KecM2GKH3Wv61Ty
         7TSAWVm6QSeNBTJuhQ2kNuv5GiTsiqeLMs2BJUJZd4THklU9/WccZdMK6aqcm23nZ4ZV
         NhowdxdmqEle669y3WML+foGa9Qx1pV+afCEg1qWvL6NdpltbJxWi/Is28TdTvsbpRPv
         6tTQ==
X-Gm-Message-State: AOJu0Yw0nxbM/De/TDOy/ykesErtueZqV4jnwcFTplYVraO/vJRXVYkJ
	FinfDa9ZZgOGsAoc9geZ3A1ctXuM0+SsBQ99In5SKS9PBXc/jfCW
X-Google-Smtp-Source: AGHT+IE+bp2pIwzJVFxl2UKzZTDNLT8TZhXHYQyYkMXgaIYS2a+6vup27l+C3Tq8xJGt9CxpXPdieA==
X-Received: by 2002:a17:906:e02:b0:a52:6636:a29 with SMTP id l2-20020a1709060e0200b00a5266360a29mr929979eji.28.1713516268744;
        Fri, 19 Apr 2024 01:44:28 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id jg15-20020a170907970f00b00a518bcb41c1sm1899692ejc.126.2024.04.19.01.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 01:44:28 -0700 (PDT)
Message-ID: <809b5785-e65f-47f4-b52b-f9d2af0a3484@kernel.org>
Date: Fri, 19 Apr 2024 10:44:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 117/273] e1000e: Workaround for sporadic MDI error on
 Meteor Lake systems
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nikolay Mushayev <nikolay.mushayev@intel.com>,
 Nir Efrati <nir.efrati@intel.com>,
 Vitaly Lifshits <vitaly.lifshits@intel.com>,
 Naama Meir <naamax.meir@linux.intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125312.934033981@linuxfoundation.org>
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
In-Reply-To: <20240408125312.934033981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08. 04. 24, 14:56, Greg Kroah-Hartman wrote:
> 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Vitaly Lifshits <vitaly.lifshits@intel.com>
> 
> commit 6dbdd4de0362c37e54e8b049781402e5a409e7d0 upstream.
> 
> On some Meteor Lake systems accessing the PHY via the MDIO interface may
> result in an MDI error. This issue happens sporadically and in most cases
> a second access to the PHY via the MDIO interface results in success.
> 
> As a workaround, introduce a retry counter which is set to 3 on Meteor
> Lake systems. The driver will only return an error if 3 consecutive PHY
> access attempts fail. The retry mechanism is disabled in specific flows,
> where MDI errors are expected.
...
> --- a/drivers/net/ethernet/intel/e1000e/phy.c
> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> @@ -107,6 +107,16 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw
>   	return e1e_wphy(hw, M88E1000_PHY_GEN_CONTROL, 0);
>   }
>   
> +void e1000e_disable_phy_retry(struct e1000_hw *hw)
> +{
> +	hw->phy.retry_enabled = false;
> +}
> +
> +void e1000e_enable_phy_retry(struct e1000_hw *hw)
> +{
> +	hw->phy.retry_enabled = true;
> +}
> +
>   /**
>    *  e1000e_read_phy_reg_mdic - Read MDI control register
>    *  @hw: pointer to the HW structure
> @@ -118,55 +128,73 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw
>    **/
>   s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data)
>   {
> +	u32 i, mdic = 0, retry_counter, retry_max;
>   	struct e1000_phy_info *phy = &hw->phy;
> -	u32 i, mdic = 0;
> +	bool success;
>   
>   	if (offset > MAX_PHY_REG_ADDRESS) {
>   		e_dbg("PHY Address %d is out of range\n", offset);
>   		return -E1000_ERR_PARAM;
>   	}
>   
> +	retry_max = phy->retry_enabled ? phy->retry_count : 0;
> +
>   	/* Set up Op-code, Phy Address, and register offset in the MDI
>   	 * Control register.  The MAC will take care of interfacing with the
>   	 * PHY to retrieve the desired data.
>   	 */
> -	mdic = ((offset << E1000_MDIC_REG_SHIFT) |
> -		(phy->addr << E1000_MDIC_PHY_SHIFT) |
> -		(E1000_MDIC_OP_READ));
> -
> -	ew32(MDIC, mdic);
> -
> -	/* Poll the ready bit to see if the MDI read completed
> -	 * Increasing the time out as testing showed failures with
> -	 * the lower time out
> -	 */
> -	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
> -		udelay(50);
> -		mdic = er32(MDIC);
> -		if (mdic & E1000_MDIC_READY)
> -			break;
> -	}
> -	if (!(mdic & E1000_MDIC_READY)) {
> -		e_dbg("MDI Read PHY Reg Address %d did not complete\n", offset);
> -		return -E1000_ERR_PHY;
> -	}
> -	if (mdic & E1000_MDIC_ERROR) {
> -		e_dbg("MDI Read PHY Reg Address %d Error\n", offset);
> -		return -E1000_ERR_PHY;
> -	}
> -	if (FIELD_GET(E1000_MDIC_REG_MASK, mdic) != offset) {
> -		e_dbg("MDI Read offset error - requested %d, returned %d\n",
> -		      offset, FIELD_GET(E1000_MDIC_REG_MASK, mdic));
> -		return -E1000_ERR_PHY;
> +	for (retry_counter = 0; retry_counter <= retry_max; retry_counter++) {
> +		success = true;
> +
> +		mdic = ((offset << E1000_MDIC_REG_SHIFT) |
> +			(phy->addr << E1000_MDIC_PHY_SHIFT) |
> +			(E1000_MDIC_OP_READ));
> +
> +		ew32(MDIC, mdic);
> +
> +		/* Poll the ready bit to see if the MDI read completed
> +		 * Increasing the time out as testing showed failures with
> +		 * the lower time out
> +		 */
> +		for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
> +			usleep_range(50, 60);

This crashes the kernel as a spinlock is held upper in the call stack in 
e1000_watchdog_task():
   spin_lock(&adapter->stats64_lock);
   e1000e_update_stats(adapter);
   -> e1000e_update_phy_stats()
      -> e1000e_read_phy_reg_mdic()
         -> usleep_range() ----> Boom.

It was reported to our bugzilla:
https://bugzilla.suse.com/show_bug.cgi?id=1223109

I believe, the mainline has the same bug.

Any ideas?

thanks,
-- 
js
suse labs

