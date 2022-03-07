Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE1638C9
	for <patches@lists.linux.dev>; Mon,  7 Mar 2022 08:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646640836; x=1678176836;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HzAu/XSoEig5fPmfl1zNC0iKX8Pqh5h4XbWbRhQpAH8=;
  b=ZqLCxRjq+Dd/nBS6s/QfgZ+a8cnoeZoKAFLETxg5pQ5oM/UZF0Gl2RTE
   ZvkgpNgb7nGkbMIKekvNVPpHZduu4Q7OAzfUEvJPRW25bh8toDT1Ihzm6
   2eoA0qgDGHJbx7yBCGunu80V+jlHaDixW0lDeEU/jl1zhlENW89v9D4db
   qrg8z6qxl17EFm189rGSWykyvtygVyrUbT9FoCEYtEuSfDmlVTMe95Rjj
   sVkCVbpgW8KtrVXidU6slXDuXNIcH5a+2Q20ag5pgGrJg9+5L2t+J2blm
   WrDVfbqK2DAacTDBju3y4nKPKh8nU/SMc3ONok1KjIqBofZhQBrQuUn0K
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="254063165"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="254063165"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:13:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="512595135"
Received: from mylly.fi.intel.com (HELO [10.237.72.156]) ([10.237.72.156])
  by orsmga006.jf.intel.com with ESMTP; 07 Mar 2022 00:13:53 -0800
Message-ID: <58dc14d2-969e-256b-077c-2147827e5a86@linux.intel.com>
Date: Mon, 7 Mar 2022 10:13:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH -next] i2c: designware: Mark
 dw_i2c_plat_{suspend,resume}() as __maybe_unused
Content-Language: en-US
To: Hans de Goede <hdegoede@redhat.com>, Nathan Chancellor
 <nathan@kernel.org>, Wolfram Sang <wsa@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Jan Dabros <jsd@semihalf.com>, linux-i2c@vger.kernel.org,
 patches@lists.linux.dev
References: <20220303191713.2402461-1-nathan@kernel.org>
 <b7f8ad61-4dcd-a7cd-94f5-2a37aa57fd6a@redhat.com>
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <b7f8ad61-4dcd-a7cd-94f5-2a37aa57fd6a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/22 13:46, Hans de Goede wrote:
> Hi,
> 
> On 3/3/22 20:17, Nathan Chancellor wrote:
>> When CONFIG_PM is set but CONFIG_PM_SLEEP is not, two compiler warnings
>> appear:
>>
>>    drivers/i2c/busses/i2c-designware-platdrv.c:444:12: error: unused function 'dw_i2c_plat_suspend' [-Werror,-Wunused-function]
>>    static int dw_i2c_plat_suspend(struct device *dev)
>>               ^
>>    drivers/i2c/busses/i2c-designware-platdrv.c:465:12: error: unused function 'dw_i2c_plat_resume' [-Werror,-Wunused-function]
>>    static int dw_i2c_plat_resume(struct device *dev)
>>               ^
>>    2 errors generated.
>>
>> These functions are only used in SET_LATE_SYSTEM_SLEEP_PM_OPS(), which
>> is defined as empty when CONFIG_PM_SLEEP is not defined. Mark the
>> functions as __maybe_unused to make it clear that these functions might
>> be unused in this configuration.
>>
>> Fixes: c57813b8b288 ("i2c: designware: Lock the adapter while setting the suspended flag")
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks, patch looks good to me:
> 
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> 
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
