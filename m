Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF3D1922C9;
	Tue, 30 Jul 2024 23:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722382683; cv=none; b=cKvd9B1zx+2MHRUVayiEv6fWEdHS+Q9XRbJ4p8zINcekzESSxstJEDT2//51aGxm2f7DHtgXUctBEdQDqWW5SPOlxNNRIOshdc8hWe6iIjpV8ZE0VpsGRbqLN1e7jHRResDdVcnzdsfTjKmZsegxBMMQGSh3VYTbZ0/sHOOCBV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722382683; c=relaxed/simple;
	bh=pfGOhwlGmouFtMJ0LMMKY43IxW6am2yU3qWY1OWUPmA=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=SExvWRL4s87lE9bVYI+f6W99Tp4162s1PRl3yBxzR2mhqgne2/gUg+8DBuo83RKqX7RDbjDgu0lhoVn4qePC1HusLu4DhfazO1CaymDLRMzWFYOFBiQx2BeTMD4Hbf1h/C22+3D4CmCSaatTMk0GwiaOXhPU4srCvoPkhFLn510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=LK+65/V1; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="LK+65/V1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1722382657; x=1722987457; i=frank.scheiner@web.de;
	bh=pfGOhwlGmouFtMJ0LMMKY43IxW6am2yU3qWY1OWUPmA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LK+65/V1L0pD4HHTDDGP8oMAoHIrKGenItafE4PyYSGtPvbteB4+zOXt2L6qtRHi
	 BGqvxqF9HcHVkFZ1IE7ElWJcscdGp2N2GkT8446OL4zwQzfZ0gtuebVW1+o26GUXs
	 6oxBpLoqMAKwa6JCzEhPMo4MSxOEGcmiQAntvI6KiqTh1e1UUV7jUkXy/KDEuaFqG
	 KdhUIj3bT97CwVz22lorYNuDMW+i7AfweyPIKlcC2rTkDp7j+5qe954ybNo/IHgKg
	 /yvHrc3GRXoP3coaR/N1S4Fopy9xzLAz6UvCqjB9pwDFxp2YMdWKZZGdGGbqL8/F7
	 bttn9lIkLOtjl/F+0A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([79.200.213.131]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MWi9q-1sjoN63neS-00WTOJ; Wed, 31
 Jul 2024 01:37:37 +0200
Message-ID: <017486e3-2132-44a0-ade8-94647de78cef@web.de>
Date: Wed, 31 Jul 2024 01:37:34 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: skhan@linuxfoundation.org
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
References: <061886f7-c5ec-419b-8505-b57638c5cf31@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc1 review
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <061886f7-c5ec-419b-8505-b57638c5cf31@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2dTZdmSWRU/x4dv0xlpSz/d6Dbza/593i4QpMsNA+iJ/2HOu3mF
 Pd6cnDKpBXwT1zHTyiInUyjQGgaJUZGc+EivPfVMd2OLIsWzB3N8vRsUzLQhz2LUNlSErs6
 Lb2YD6GZb92lLvt2BOq6KlU+6QdKKQpt2XUTv2Ycq8c2mhe2pwr7Pp3T+FagTnWMKa5YgSu
 dDlw7TNaZXyhxES/3i1vg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1+j7zSTl8Vk=;M/4QAP+AGMFNfHB+Ko0N2nOnH5B
 BEY/TTkKCzO1a3q/vOVkPg5hXEjmj5C/fEqpF+W2RbJ+pLcw62sKCi+mVo03MGiGeLXMFWzE4
 oDyiqn1OpXEMkXcLCL1draoeC/nRs+UsBmF92Kq1M6oqqs4G1/oX2Pefn7w/8IPKTDQ/dqC6F
 elnuKRL0PpofHTR7Mo0y3pIWGm1oLGYcJ4ZTz3ttBYThEmvnu3BfgSJPDIE94nf29XUPDpuWL
 lpjhZ3ucCNWCdTO0nLr7c6dmJNN7c34YLjchSPHoOqOjpsOhXfMva6dCVQvvVUPf4ffoRza3l
 15TxQnZTx2UfdCmnvVnqsTF2lrnmxwMAGzrR9n4Yl+Rq3jCg/dv1xiFW9Z6n9YK0hSM5TCDiR
 b1KMeoLZsTqZt97tOqNlfvddcMMqx421N/hQadlKh9rE8/49WgiV/14NgMZsy0jqSjDGdeKyF
 KBBqYl0TbYmZPHg5Ibny3sSTejDw+xizqAxXaVCDQGQ0Ofocy4LCzZh1fUFiE0TQgoDdIjTp+
 UnGYoSz5nEHA40G3I0fwwJoQLYRbdjyXQFVZdQnULIuCFuq7jMPa+1YJkGmsm996KSEkfPubf
 b7FeN/ZV3hSRM/ow04QzRgxlU0HqKyfk16zfOOCtIiyR8uOq1OvV0//DPm3us290MGwb0JGmX
 OpWsxDYCmMw25VkcYsvhKhnvusDxceIBgH7GT8j+DhyahnOmU0sq/j4+kihI5QivFQg3WnmaK
 DaiyTSavg8LI9Zfu0QmxW6M1obwfM+SUdAHcOIrgPiw/invPJcPHcEusy2AiwwzMoYFcEtLP1
 jHvQfoeI/rQyDu3A3F1vWOlIQxD8I10VdjtQQLAWZt99E=

Hi,

could be the same issue as for me, see [1] for details.

[1]:
https://lore.kernel.org/stable/de6f52bb-c670-4e03-9ce1-b4ee9b981686@web.de=
/

Does applying 6259151c04d4e0085e00d2dcb471ebdd1778e72e from mainline
(adapt hunk #2 to cleanly apply) help in your case, too, or do you maybe
detected a different issue?

Cheers,
Frank
