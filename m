Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76D53D0A4;
	Wed, 30 Oct 2024 13:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730295229; cv=none; b=eAoibBvZv8RRgGV865kiHBx2qn9qUmltTXHGZ1t2g7M0iV0kA96d814WL851C2Epjj7b2TdHKRCAuJQv/sEohicA9lZ88ax7kSM0GqxOz6cCLz+1hMTxFRlF3vAoT7/CwlEIpiBiLoGoGTrcNabraZ3pTFir0+4Dd+zPZRkHPU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730295229; c=relaxed/simple;
	bh=0hzVmSoIPIfT1E3L18ipoalsx/laSXZLH2Jym00CjNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTx5A0/S88qXYo58jlrVVSXYMI7yWsG9xPHMjn46FAyLaGP7tzqqbluenLviu5yKKyW/k/Djfhswug3PvZBRVmoxtHyh1yoTD18gSmLXvisDhjfRehs+OXxp0mdlY+mM0tAd6CjKBz7YOeycB/58r30tgWyXcmLAFVj4bzvm0kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=metux@gmx.de header.b=BF4AVrex; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=metux@gmx.de header.b="BF4AVrex"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1730295220; x=1730900020; i=metux@gmx.de;
	bh=0hzVmSoIPIfT1E3L18ipoalsx/laSXZLH2Jym00CjNM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BF4AVrexW929lMpaB6D/0mvscPLRsE6MkcoyQKK0k52bJZ6g/N/4a/ynMrwrTpqG
	 mIYQyfFSkXZ2P9YhmTQDbExRoyP290LiQqZ4nd1SjVK1Ko9kIzJYoptbUtAh9ylCD
	 aqQSCdEn83/xdDJdc+BFrinVnoTFmUbcdtRb66eWKjIl0t/J+okXhIT3+8uPnLTDq
	 DsMs9vba3iA0nQfbSd9y7yytsUE26yVNkTrrn/gSBII5GORpvO0RlzLmF6voxfd6X
	 xS74JfxWaWLjjrSXTt3s0cBbsg7UC7fr0hvlFqs59lxOpuLHDWT45WonTBL6ngVuD
	 RG+8GVdBhfjrLQvf1g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.1.178] ([95.114.207.188]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mlw3N-1tWMtT1gOp-00qbUt; Wed, 30
 Oct 2024 14:33:40 +0100
Message-ID: <380d9a2d-957e-43fa-a59a-fe2a0e716ec5@gmx.de>
Date: Wed, 30 Oct 2024 14:34:22 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various
 compliance requirements.
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 geert@linux-m68k.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>
Content-Language: tl
From: metux <metux@gmx.de>
In-Reply-To: <7ee74c1b5b589619a13c6318c9fbd0d6ac7c334a.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:9p0u9Hqk4fTogFMrQLZCmUdTnLNdIf/I0gHAIaimBe+wNqWZ7iZ
 ZDSuG9ICFR33/+UKoXNjVt8P9QIyDgah+wNBbOwffmUQ892anKkjs1IqOVUp2Wnp2ouB8bq
 40eMz0uM0mhrJcIh1K+md2NcwpD8gGYw3ls6j7q40XJtNSyxVvNWG+DBeWT1Us8IGnKv+5/
 TWUT7RX5LsoT/2e+0RjcQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:l8hZDc0jzcE=;99jN54kvdg6DHSR4y/gDYJyDD8S
 F/tvHSNW7q+qgFkZfPXbrGyRUEmubX9y9pIgO6QnMyHiKjCIBOxdTniz4bqQx6nDihuw+73E5
 Tvllv4J6JqFqO6eLuyaHJ7vuYOGopsutphQdZstS+aXgkpz01r1jm0uUB2NOuNUm9IzGnINlI
 d3QOptFChmTNydFXWTEtVPU5tZ6v2Zc4ix+xcx1RzyAOuNsajkhy0Bd7PROv3lW12Js3D9WTg
 0+6HX4V7wVXVeFYfBKAc5k7gapVG/ldYCXm5jnB6jJYePunmKkFssMhFZ6uIEs5VxFCBQB8fV
 lPoAaR7vjhd+WcKW2o1pp10gDhrZkKaqRlIjcRxD9DE3qz/3N6BepIeJACQAAMKV+gO/WygkO
 m0gXevynpTJi8JY/KD0UZRALutdFC/qId/lxw3ODQ5Gpx9D8vkWmpGz0K/6xqzqQi/ImFcqWE
 ev7DX+xtGtjAbMwtXz0aVRGiqCMLg7HFR+TYFF8dWGWffChki2llBHJ+QxxzCGuG3WaoM0mcG
 RNHIf1TYWPz0yZI1ZXjtvCfFjS2IKcXUsGJCUMhj3z2BttDtSAZ9271lvfC+oLA3EcH4YAlLy
 /QWQv55bB/NpPsq/9SbAi7OzOpZNuvRV8pMJ3ICJY8LgZ/Sf/TE4I9gk/j/0S3VIx7loa+5D2
 Sy8ssWzOu78N3dhEYat6xDZhRMom73l7liSNmFtR/3jUe1m5ckPtBEv/NWTIwFk0KYIgcaIf+
 csYoGFNTLLTd/sT779Ic7jiIC0JcoF7nTHJi/kubumdptAPyecDo30n4JDXkU3Pjy+l0RpbHe
 C6A9xzNuI4UpDrdh3IgRBtGQ==

On 24.10.24 17:39, James Bottomley wrote:

> The documentation Greg is looking for (which a group of Lawyers at the
> LF will verify) is that someone in the removed list doesn't actually
> work for an OFAC SDN sanctioned entity.

Aha, guilty until proven otherwise ?

Is that how things are handled in the "land of the free" ?


--mtx
