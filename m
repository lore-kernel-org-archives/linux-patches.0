Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9527F746E
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 01:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717722286; cv=none; b=CIic9nRea761/qDad6QxoARTVbkKe+2qY1iHGjKsZUyWpyFrsON9vrnK3ucd1kW2SRjXvFCc2RvmcgA3RuC9MMmvYk5cKXGh1w69Honz7KynGfblKxk2wsvBH/lOmUCqZTImDXlL8qr7/GYjJnDTywRTpOcszPn5lE1qODG5TQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717722286; c=relaxed/simple;
	bh=T9vY3K0R2B9Unns/VSBomR/uyY0tXDUhf+n/JqDa3DM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LBCQ1mLRnd3J0e/Vsaw80odoYkvJZzHt3fCbju0ZtXQlMAS2dgk6uuKThHmanVNkFShYX9qWwDxoBBecghAkSOjE/HHrmWtaQ52XGKKRNEcjcMbh6Hi8CU5SNh1loTP9az461Q6U/4+b30DzZ/b6PdCm+9GOGfZTY0teAxYwTjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=ouyXKClM; arc=none smtp.client-ip=185.125.188.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="ouyXKClM"
Received: from [192.168.0.106] (unknown [123.112.65.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id B49AE3F756;
	Fri,  7 Jun 2024 01:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1717722276;
	bh=HGrLvbDkzrQv2MWxC/wYrnAWrcD9HMzV/8K0CiaPiWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=ouyXKClMqGxkkb/DqsYoioaTYwkRb0V8fMpb17lzopDOm4h4r6AR5dBQ9nECyaJGt
	 89Bj248fehcvMJl/UFY2UlfgGtm37178lNRaWMjl/gB4wHSwuUS4l5u5IAO4h9V18W
	 Zqimt0Sv9/J4ClohvhECzmkwgdPBp2Bfp5H5XolyjTj48zSfSbyKljsNtvyW0DUsku
	 uQLDqEqJMoOTy282eyR4ADhXrf3i+B7+Re1qjjlqejMblvfUw5dIGFCQFs7BuOlOY0
	 vQ6yj3zJHkT3v03P+sE6TlBZ8X89bor8OJIhZ8MH/J7Khp1jGnzRIedQeNb3uq+Nhv
	 kDZxZ39KalexQ==
Message-ID: <60a65889-130f-479d-b7de-04236316adc3@canonical.com>
Date: Fri, 7 Jun 2024 09:04:26 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 723/744] e1000e: move force SMBUS near the end of
 enable_ulp function
To: "Zhang, Rui" <rui.zhang@intel.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
 "Brandt, Todd E" <todd.e.brandt@intel.com>,
 "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
 "Keller, Jacob E" <jacob.e.keller@intel.com>,
 "horms@kernel.org" <horms@kernel.org>,
 "naamax.meir@linux.intel.com" <naamax.meir@linux.intel.com>,
 "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
 "sashal@kernel.org" <sashal@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240606131755.652268611@linuxfoundation.org>
 <3eb7ce5780ccbd08f1d1d50df333d6fc7364b2e9.camel@intel.com>
Content-Language: en-US
From: Hui Wang <hui.wang@canonical.com>
In-Reply-To: <3eb7ce5780ccbd08f1d1d50df333d6fc7364b2e9.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Please do not apply the commit to the stable kernels, there is a 
regression report on this commit.

Thanks,

Hui.

On 6/7/24 08:32, Zhang, Rui wrote:
> Add Todd.
>
> Todd found a regression caused by this commit.
> https://bugzilla.kernel.org/show_bug.cgi?id=218940
>
> I think we should make that clear first.
>
> thanks,
> rui
>
> On Thu, 2024-06-06 at 16:06 +0200, Greg Kroah-Hartman wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me
>> know.
>>
>> ------------------
>>
>> From: Hui Wang <hui.wang@canonical.com>
>>
>> [ Upstream commit bfd546a552e140b0a4c8a21527c39d6d21addb28 ]
>>
>> The commit 861e8086029e ("e1000e: move force SMBUS from enable ulp
>> function to avoid PHY loss issue") introduces a regression on
>> PCH_MTP_I219_LM18 (PCIID: 0x8086550A). Without the referred commit,
>> the
>> ethernet works well after suspend and resume, but after applying the
>> commit, the ethernet couldn't work anymore after the resume and the
>> dmesg shows that the NIC link changes to 10Mbps (1000Mbps
>> originally):
>>
>>      [   43.305084] e1000e 0000:00:1f.6 enp0s31f6: NIC Link is Up 10
>> Mbps Full Duplex, Flow Control: Rx/Tx
>>
>> Without the commit, the force SMBUS code will not be executed if
>> "return 0" or "goto out" is executed in the enable_ulp(), and in my
>> case, the "goto out" is executed since FWSM_FW_VALID is set. But
>> after
>> applying the commit, the force SMBUS code will be ran
>> unconditionally.
>>
>> Here move the force SMBUS code back to enable_ulp() and put it
>> immediately ahead of hw->phy.ops.release(hw), this could allow the
>> longest settling time as possible for interface in this function and
>> doesn't change the original code logic.
>>
>> The issue was found on a Lenovo laptop with the ethernet hw as below:
>> 00:1f.6 Ethernet controller [0200]: Intel Corporation Device
>> [8086:550a]
>> (rev 20).
>>
>> And this patch is verified (cable plug and unplug, system suspend
>> and resume) on Lenovo laptops with ethernet hw: [8086:550a],
>> [8086:550b], [8086:15bb], [8086:15be], [8086:1a1f], [8086:1a1c] and
>> [8086:0dc7].
>>
>> Fixes: 861e8086029e ("e1000e: move force SMBUS from enable ulp
>> function to avoid PHY loss issue")
>> Signed-off-by: Hui Wang <hui.wang@canonical.com>
>> Acked-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
>> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
>> Reviewed-by: Simon Horman <horms@kernel.org>
>> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> Tested-by: Zhang Rui <rui.zhang@intel.com>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Link:
>> https://lore.kernel.org/r/20240528-net-2024-05-28-intel-net-fixes-v1-1-dc8593d2bbc6@intel.com
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/net/ethernet/intel/e1000e/ich8lan.c | 22
>> +++++++++++++++++++++
>>   drivers/net/ethernet/intel/e1000e/netdev.c  | 18 -----------------
>>   2 files changed, 22 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> index 4d83c9a0c023a..d678ca0254651 100644
>> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> @@ -1225,6 +1225,28 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000_hw
>> *hw, bool to_sx)
>>          }
>>   
>>   release:
>> +       /* Switching PHY interface always returns MDI error
>> +        * so disable retry mechanism to avoid wasting time
>> +        */
>> +       e1000e_disable_phy_retry(hw);
>> +
>> +       /* Force SMBus mode in PHY */
>> +       ret_val = e1000_read_phy_reg_hv_locked(hw, CV_SMB_CTRL,
>> &phy_reg);
>> +       if (ret_val) {
>> +               e1000e_enable_phy_retry(hw);
>> +               hw->phy.ops.release(hw);
>> +               goto out;
>> +       }
>> +       phy_reg |= CV_SMB_CTRL_FORCE_SMBUS;
>> +       e1000_write_phy_reg_hv_locked(hw, CV_SMB_CTRL, phy_reg);
>> +
>> +       e1000e_enable_phy_retry(hw);
>> +
>> +       /* Force SMBus mode in MAC */
>> +       mac_reg = er32(CTRL_EXT);
>> +       mac_reg |= E1000_CTRL_EXT_FORCE_SMBUS;
>> +       ew32(CTRL_EXT, mac_reg);
>> +
>>          hw->phy.ops.release(hw);
>>   out:
>>          if (ret_val)
>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c
>> b/drivers/net/ethernet/intel/e1000e/netdev.c
>> index 3692fce201959..cc8c531ec3dff 100644
>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>> @@ -6623,7 +6623,6 @@ static int __e1000_shutdown(struct pci_dev
>> *pdev, bool runtime)
>>          struct e1000_hw *hw = &adapter->hw;
>>          u32 ctrl, ctrl_ext, rctl, status, wufc;
>>          int retval = 0;
>> -       u16 smb_ctrl;
>>   
>>          /* Runtime suspend should only enable wakeup for link changes
>> */
>>          if (runtime)
>> @@ -6697,23 +6696,6 @@ static int __e1000_shutdown(struct pci_dev
>> *pdev, bool runtime)
>>                          if (retval)
>>                                  return retval;
>>                  }
>> -
>> -               /* Force SMBUS to allow WOL */
>> -               /* Switching PHY interface always returns MDI error
>> -                * so disable retry mechanism to avoid wasting time
>> -                */
>> -               e1000e_disable_phy_retry(hw);
>> -
>> -               e1e_rphy(hw, CV_SMB_CTRL, &smb_ctrl);
>> -               smb_ctrl |= CV_SMB_CTRL_FORCE_SMBUS;
>> -               e1e_wphy(hw, CV_SMB_CTRL, smb_ctrl);
>> -
>> -               e1000e_enable_phy_retry(hw);
>> -
>> -               /* Force SMBus mode in MAC */
>> -               ctrl_ext = er32(CTRL_EXT);
>> -               ctrl_ext |= E1000_CTRL_EXT_FORCE_SMBUS;
>> -               ew32(CTRL_EXT, ctrl_ext);
>>          }
>>   
>>          /* Ensure that the appropriate bits are set in LPI_CTRL
