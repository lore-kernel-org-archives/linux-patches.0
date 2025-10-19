Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A968354ADF
	for <patches@lists.linux.dev>; Sun, 19 Oct 2025 05:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.61.224.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760852368; cv=none; b=njYn16by1vQJWxCHdWsnfmN3TgiUkf5iiSNBmU0aC649gsQyu9ZgkL+oHDjfdToEHEohJVfq0HjOKmabNtKIGF9tuH8AQlRmC98F0xTc4mp/g0n+U8oW6HdppFE/UBTq/fLXvEYC5wBNqbE9bnq6vK/m0np0nYTzPuijaKrgSVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760852368; c=relaxed/simple;
	bh=AUetctZfU4WPwK3EmwpyMrcmmU7Sw0mh4g+oM9LzWmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=csrFdhJkNNQ3Ri5FzrO0nFpWiaN1vmnjREdJXCRAUAOnersFSh7+V3zB8SRK8NkRpwP8+3UZxZt1uM7MQxm2vnA93mVGEkUkzUHJOPM8anH33GaABZuvSMSSzUidkNU5ecrkUqPaqm5VbCfgEDo6wqaYgPYD850R42jnI5/Xbk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org; spf=pass smtp.mailfrom=cachyos.org; dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b=GuiECUSi; arc=none smtp.client-ip=202.61.224.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cachyos.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cachyos.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cachyos.org header.i=@cachyos.org header.b="GuiECUSi"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C3C00284C2A;
	Sun, 19 Oct 2025 07:29:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
	t=1760851770; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=4gGqfG3ZXsXTwpKldk/kpLeODZwHq4Vin9TjGeIck90=;
	b=GuiECUSinqYYjjnEToOQj+knVSxz06gi0AbQ3yUlftiY0bdX8IP6d9I/fATf3pPhWdZ+1V
	BlzS8O5dNr6hbhTFMMAewG7VsJSSkdEHXLVsyovIGYQor2V/+QycAszrxm535L6sXmqwcr
	cXpoUtWKBefc8T8iM3aMc81K6op65ZdT5OorO65GTpgzg2YcefofLDx54SmkiDcxIQzBvo
	Ok1IExwCrq6s7f2ZNZqhADcY5Yvd7xrkaIKFiB9gUZJhrR0lolEap1k9wsqj0HsPHlUhwe
	sDSlM3/vnMeY6GdU7NB6D/TZTD0Xmg/qSkjDJL/+6sJb920Oh39SMtAsOSc2cw==
Message-ID: <6f19c559-35b4-4cd8-8bcd-615898dd8a4d@cachyos.org>
Date: Sun, 19 Oct 2025 13:29:18 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 068/563] PCI/MSI: Add startup/shutdown for per device
 domains
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Bjorn Helgaas <helgaas@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Inochi Amaoto <inochiama@gmail.com>,
 Chen Wang <unicorn_wang@outlook.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Sasha Levin <sashal@kernel.org>, Kenneth Crudup <kenny@panix.com>,
 Genes Lists <lists@sapience.com>, Jens Axboe <axboe@kernel.dk>,
 Todd Brandt <todd.e.brandt@intel.com>
References: <20251013144413.753811471@linuxfoundation.org>
 <20251013211648.GA864848@bhelgaas> <2025101753-borough-perm-365d@gregkh>
Content-Language: en-US
From: Eric Naim <dnaim@cachyos.org>
In-Reply-To: <2025101753-borough-perm-365d@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

On 10/17/25 14:56, Greg Kroah-Hartman wrote:
> On Mon, Oct 13, 2025 at 04:16:48PM -0500, Bjorn Helgaas wrote:
>> [+cc Kenny, Gene, Jens, Todd]
>>
>> On Mon, Oct 13, 2025 at 04:38:49PM +0200, Greg Kroah-Hartman wrote:
>>> 6.17-stable review patch.  If anyone has any objections, please let me know.
>>
>> We have open regression reports about this, so I don't think we
>> should backport it yet:
>>
>>   https://lore.kernel.org/r/af5f1790-c3b3-4f43-97d5-759d43e09c7b@panix.com
> 
> It's already in a release :(
> 
> If someone will be so kind as to forward me the git id of the fix when
> it lands in Linus's tree, I will be glad to queue that up.
> 
> thanks,
> 

Hi Greg, the fix has made it into Linus's tree. The git hash is e433110eb5bf067f74d3d15c5fb252206c66ae0b

-- 
Regards,
  Eric

> greg k-h
> 

