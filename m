Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997DD39021A
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 12:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895909; cv=none; b=NC2brbp2fy6gTDV+zpQFafMePQFRQlQBG5kCVlDb7Oa/uri+wCDUYrl2QJ5CIP0TwkS4E86BiG4n8nY3XT2enfWmpwin6kgZpaKuLtQO8kY34YCPLXlke4A7H8uTWv1Kv+OGtnjLUvBCfT7LjsnZbH3BiBc2NczpGdTtRGSB1ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895909; c=relaxed/simple;
	bh=8k3OZ3tzch+36f03a1VChHCkDjDFvmykzQzVFvBJ8V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFE33dl+s5tL/JXvz1omeN81DmyhNwCGZpWdBMEZOcgbPbtMUqyYB7IDMseFHsZZp4gkWdhLri4nSNf+lCCNFXHijbKdbhuTnbPqRrbm3+PXR+aBD5jWFshrzZFwjYgBgok8ewBoBpvQ9SxsN9/bw/FVPO+rOt58RTDB2hA64ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=d/1jLJMb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aAWJbJlu; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="d/1jLJMb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aAWJbJlu"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B521F14000E2;
	Fri, 24 Jul 2026 08:25:05 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Fri, 24 Jul 2026 08:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784895905;
	 x=1784982305; bh=hWL5ERoYleP4NcUXGUmpyuGJBM1kcigKV6nTN63cPHU=; b=
	d/1jLJMbJYHMfLvuqLkQhIVZvJHVjsHBjGg33ZPAbulyP1hW5zxgL5yQh75HD/gs
	DvwCrnKOeO8XYJSlCN+Nd1pDuODTFq7uPVfEv5P07QwIbF1WhtHQdLLJRZUKaK/+
	OuBjKhz0ivMWjZOCGm7OlhsNYBRw8FvTbDse6ox2eCuDCvFw24McgYr08hFGsjoF
	BwS1OB5Lb23jhGuvlNZUa/HDUrYrL09sF45+FdjsEU/7RGSroX7feAmRdVfnw+C1
	mL01lgJI5nd9XfRkDag6n6gCLiuz2ZCDXsO3MTAsXwXGokrS3QBcDI6qOulC3vBw
	0bmelGAwN/e/T31x3J1rNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784895905; x=
	1784982305; bh=hWL5ERoYleP4NcUXGUmpyuGJBM1kcigKV6nTN63cPHU=; b=a
	AWJbJlu65zXAbmjMTBr6iL7Si4AsBzPxrmmhvPxL0u9iF2E5IpbzRdbiTDAnf48J
	8gMsiQydzkLJ0Z7VfShe1NtD6VQv/sayj0hGsNwt4dZt0ZYNadJSZvdNI55N7Rus
	wTUBKr2aJo411LvgfnmGCfcwSdVd0cMiNmY++4dnGdT9gJkVqhWHqIhcO3PyDmYY
	7miqRimPEfzPLGkU+KS0diuRTjf/WVQeqJ/X4tUAGs7Nvv/x3UOXiFL7iDJs6iGT
	Ze06LMzzFUtf7RRP41Wxk5r5d3xb2CJfzJlLi5khpys8sL7BfqRSO2JknA9cpHTY
	5Ps0pkN2Pf+5CZ/uznx0w==
X-ME-Sender: <xms:oFljaoJodcIfKnUzd-J5GCU8DpgqyEn4Zogh9aqnslA1xOmOad2b6g>
    <xme:oFljakCavTcQ6E9rzlwBgATKIEdUVQzZL0ka1akSzROtgyQWIYAWsBuikIsHPi6H4
    p8JrlAZR-4zB1cT16VtF4y_EGSe1H-W-v7AAmigU0KxQTfZR6SnsJY>
X-ME-Received: <xmr:oFljakMUZNAsE0zXg7_lzUopTdUfxLPedDm5XbRSfmdA0Wz0H12VZ11xcpU_w5wV6fzETQceiPkty3G_Oik5EzBE4ViNIN4c>
X-ME-Proxy-Cause: dmFkZTGu2LzTTV4Ys48YZ8u71+clZPfdxVNhPo3tCcEd36RjGCcDCM454dhnMasHuw5BCV
    lauh0Vl06vaeWaDYqbkCBFJXfNtIVzKq/FtPRlV68uGvlGaWZRB4I2KA6FnUxE6WV6MHjJ
    nhfwAgnjzh6OgZSe4qml+sux2mqh6pVnrlafglLYRweAcT+BH5XlL6TP4pSLGW6rG2oGiK
    fOvd0AcDwqECJ7wpTtK5abLM26dx39slz7FZd2ZRPckNI2DWpQVahqoHfPfyrs7d23Lv9j
    3iNRleBd40LGvxGC8RFJBJL+ZlJP6c3c2+wP0jpiM8S7uO+3MuwbRBQiwl2sKggng1JQtb
    QCY+E2PwKPNpOAAJODiYORjp1vRUI7dKThbw2bO8WoJ2brV/bUVLWKqcroRc0+uSlLLid5
    plFxTLQDMX5ixY3zarAIiK3YmCwbDefwn0HQ0v+U7NyCTLDlupG6YKsX8nWO+y3vYz1qv7
    UKsdW1ez03Q5RXq8xctSaEojeHLhROJj5nU8bFzWzAtYyILXOMUC1vkzXMvVkEgcS80KPG
    KLDxNGxMohpg/2RJRKbGOJ9N4uttED99m+b4EdhN6YlY3VkrWPgc8r/EDKVuZvUWaMiO+K
    8Fg3AxM4ecdVbXXhnMSzFU3gdqkTH2KZfwLt1ioI21qzUARN9U1bf7fcmd9Q
X-ME-Proxy: <xmx:oFljapW8B8CBpJyZr11yZaEQBihhNq6h2F1Dk9H0_LsalinfHRJ7vw>
    <xmx:oFljanTigEHczFiHxEz_1FcmFl8gQH29X_S1DkTAiJv3w-yytRVVyA>
    <xmx:oFljav05oMp0FO7QKmJp9SofaP6-x41L8FRP6mBEGb_WvT7wejP7vA>
    <xmx:oFljakggWB_cFmgOljNOfUQtVwbyiwkk6DJsw9Z-BSkjdxI8iLyOFQ>
    <xmx:oVljahfKPgf7csEOj-ewnN0d1gNbLhZ6O_QzR_40pmyFfgNtwjEshxET>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Jul 2026 08:25:02 -0400 (EDT)
Message-ID: <d3a54944-8d19-45e6-9793-7163fad39301@pobox.com>
Date: Fri, 24 Jul 2026 05:25:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/674] 5.10.261-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722142749.280611149@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260722142749.280611149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 7:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.261 release.
> There are 674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.261-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

With the patches that were added to the 5.10.y queue after 5.10.261-rc2,
it now builds successfully and works well on my Lenovo ThinkPad T14 Gen 1.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
