Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98E0757F7
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 09:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713517444; cv=none; b=ItH/9pgdM/HUOpN5QoHA55HQt/6ni3vjBN/opaT12YJKXgM6Zwn7egNtqWRtHmnm8/VdCejsQG6OyWq4oR3A0uY1hFenRZzEk0TZgUqm6+C8F7CzJjxvPDVRNLGW4HeLQ98Dm8JKbnsBe9S1XBrsvVo2eTSvDY65fU6fsZKcZXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713517444; c=relaxed/simple;
	bh=QKJ8w14BAcNcvnhnmmvDzibYqoDvnNYdIslGWyMDXgU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=O1k4qlfbQJcyNe0BgWUKuhRQHk7DZAmz/nqGCAytFzGT7qWTdUVoywQGUFMDqVOtw9C/xTil7RI03i+D1eqTjFCH38vdVsssunMXufkcrov106oA3kcywtniS/z9qjrBgjdRgz5M7PGa3HM4FB4n7U2tkq7CDJmjOl1d0jxF7Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a526d0b2349so206901066b.3
        for <patches@lists.linux.dev>; Fri, 19 Apr 2024 02:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713517441; x=1714122241;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzkLKu/6wYd7EWcuLxPk+/qlS0DbU0fekpjNF7HhE5s=;
        b=o+rdThkwrSOLB82drZbZBoecw8slOi7CbpANu00ETTlHsu/5zRGDLQ38HnG8orfGJG
         LsaMKHmtzgNbge2v9AEEtDJLwlH5ngEZohCArzC5h5xXaCPZhfNeOiFk8IeWc1NmRXSN
         sZZV5YOY7V74g21BYdBzPwMws2h8/VH/hptcYJRka7Ja39DLp8ppVYO64PKqPgzmoV21
         YbN24ga4CXPpQNptPDkrQ8C1Gbtxnh708oQoMnMJ9l7u0KCMndfWA1PFfqaODYRSx/rV
         rZmZXDJ4PMTS2hVG97wNIPB9/qfHC/kvHh24g/p+f6tx8rQxh+xPcCTnL656nK845ho9
         x8MQ==
X-Gm-Message-State: AOJu0YyYCgje6nD5eLz4P0oeYrepH/8fK6vvPHMZDoPUIKod4UUtFDWS
	Dqq1Jt56fMK5JwuuY06wqQanvqaa2If0AbzkZAur9GcOVyCFIeDg
X-Google-Smtp-Source: AGHT+IGDR1TnoIHppsTsK/HbeKue6vIzv0Y0QmEZkdKiUs7yTsyAaJ5lpEzkeWBM2maEEsr2/B+MHA==
X-Received: by 2002:a17:906:a008:b0:a55:4d24:6f9a with SMTP id p8-20020a170906a00800b00a554d246f9amr1056927ejy.6.1713517440854;
        Fri, 19 Apr 2024 02:04:00 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id b17-20020a170906491100b00a522bf06d8fsm1960789ejq.14.2024.04.19.02.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 02:04:00 -0700 (PDT)
Message-ID: <1f4367b6-7d56-4a81-a271-9a4e7089f6ef@kernel.org>
Date: Fri, 19 Apr 2024 11:03:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 117/273] e1000e: Workaround for sporadic MDI error on
 Meteor Lake systems
From: Jiri Slaby <jirislaby@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Nikolay Mushayev <nikolay.mushayev@intel.com>,
 Nir Efrati <nir.efrati@intel.com>,
 Vitaly Lifshits <vitaly.lifshits@intel.com>,
 Naama Meir <naamax.meir@linux.intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125312.934033981@linuxfoundation.org>
 <809b5785-e65f-47f4-b52b-f9d2af0a3484@kernel.org>
Content-Language: en-US
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <809b5785-e65f-47f4-b52b-f9d2af0a3484@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19. 04. 24, 10:44, Jiri Slaby wrote:
> On 08. 04. 24, 14:56, Greg Kroah-Hartman wrote:
>> 6.8-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Vitaly Lifshits <vitaly.lifshits@intel.com>
>>
>> commit 6dbdd4de0362c37e54e8b049781402e5a409e7d0 upstream.
>>
>> On some Meteor Lake systems accessing the PHY via the MDIO interface may
>> result in an MDI error. This issue happens sporadically and in most cases
>> a second access to the PHY via the MDIO interface results in success.
>>
>> As a workaround, introduce a retry counter which is set to 3 on Meteor
>> Lake systems. The driver will only return an error if 3 consecutive PHY
>> access attempts fail. The retry mechanism is disabled in specific flows,
>> where MDI errors are expected.
> ...
>> --- a/drivers/net/ethernet/intel/e1000e/phy.c
>> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
>> @@ -107,6 +107,16 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw
>>       return e1e_wphy(hw, M88E1000_PHY_GEN_CONTROL, 0);
>>   }
>> +void e1000e_disable_phy_retry(struct e1000_hw *hw)
>> +{
>> +    hw->phy.retry_enabled = false;
>> +}
>> +
>> +void e1000e_enable_phy_retry(struct e1000_hw *hw)
>> +{
>> +    hw->phy.retry_enabled = true;
>> +}
>> +
>>   /**
>>    *  e1000e_read_phy_reg_mdic - Read MDI control register
>>    *  @hw: pointer to the HW structure
>> @@ -118,55 +128,73 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw
>>    **/
>>   s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 
>> *data)
>>   {
>> +    u32 i, mdic = 0, retry_counter, retry_max;
>>       struct e1000_phy_info *phy = &hw->phy;
>> -    u32 i, mdic = 0;
>> +    bool success;
>>       if (offset > MAX_PHY_REG_ADDRESS) {
>>           e_dbg("PHY Address %d is out of range\n", offset);
>>           return -E1000_ERR_PARAM;
>>       }
>> +    retry_max = phy->retry_enabled ? phy->retry_count : 0;
>> +
>>       /* Set up Op-code, Phy Address, and register offset in the MDI
>>        * Control register.  The MAC will take care of interfacing with 
>> the
>>        * PHY to retrieve the desired data.
>>        */
>> -    mdic = ((offset << E1000_MDIC_REG_SHIFT) |
>> -        (phy->addr << E1000_MDIC_PHY_SHIFT) |
>> -        (E1000_MDIC_OP_READ));
>> -
>> -    ew32(MDIC, mdic);
>> -
>> -    /* Poll the ready bit to see if the MDI read completed
>> -     * Increasing the time out as testing showed failures with
>> -     * the lower time out
>> -     */
>> -    for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
>> -        udelay(50);
>> -        mdic = er32(MDIC);
>> -        if (mdic & E1000_MDIC_READY)
>> -            break;
>> -    }
>> -    if (!(mdic & E1000_MDIC_READY)) {
>> -        e_dbg("MDI Read PHY Reg Address %d did not complete\n", offset);
>> -        return -E1000_ERR_PHY;
>> -    }
>> -    if (mdic & E1000_MDIC_ERROR) {
>> -        e_dbg("MDI Read PHY Reg Address %d Error\n", offset);
>> -        return -E1000_ERR_PHY;
>> -    }
>> -    if (FIELD_GET(E1000_MDIC_REG_MASK, mdic) != offset) {
>> -        e_dbg("MDI Read offset error - requested %d, returned %d\n",
>> -              offset, FIELD_GET(E1000_MDIC_REG_MASK, mdic));
>> -        return -E1000_ERR_PHY;
>> +    for (retry_counter = 0; retry_counter <= retry_max; 
>> retry_counter++) {
>> +        success = true;
>> +
>> +        mdic = ((offset << E1000_MDIC_REG_SHIFT) |
>> +            (phy->addr << E1000_MDIC_PHY_SHIFT) |
>> +            (E1000_MDIC_OP_READ));
>> +
>> +        ew32(MDIC, mdic);
>> +
>> +        /* Poll the ready bit to see if the MDI read completed
>> +         * Increasing the time out as testing showed failures with
>> +         * the lower time out
>> +         */
>> +        for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
>> +            usleep_range(50, 60);
> 
> This crashes the kernel as a spinlock is held upper in the call stack in 
> e1000_watchdog_task():
>    spin_lock(&adapter->stats64_lock);
>    e1000e_update_stats(adapter);
>    -> e1000e_update_phy_stats()
>       -> e1000e_read_phy_reg_mdic()
>          -> usleep_range() ----> Boom.
> 
> It was reported to our bugzilla:
> https://bugzilla.suse.com/show_bug.cgi?id=1223109
> 
> I believe, the mainline has the same bug.
> 
> Any ideas?

Obviously change the usleeps back to udelays? Or maybe only when
retry_enabled is set?

> thanks,
-- 
js
suse labs

