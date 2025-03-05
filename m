Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC3B252919
	for <patches@lists.linux.dev>; Wed,  5 Mar 2025 19:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741201477; cv=none; b=bINgiQwbhb64tGq+wIM+Bw0dHIZT7N1jG96qD1i/Td7LkB1fsdC3lSUZiRaskx5uU6IDGQcfwbgtMdxVv96NaVqde6OecUsR4a8DW4Z5KV3+tSsyeUT9KeP8Nu6YeNY0Tk1SJ14zzGJZJvUqOyGMvXswkOLypgRRNJZcZPfW2UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741201477; c=relaxed/simple;
	bh=qfh1wvTEekJMFX55T0b8yCRRJrvfpZkth0Am/jyMk78=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BtsYzjNtaMoWJqxRPbAxoi/6Ead2ZUYOzp1k7winAWp2GMxxA92mvAWeyaOo0tTdLHwm358mAm0xsNNdTCGB4PJsrNRoW/stN+Gr0/MXsdntsKf5AZ/ZESUQSXkGbMn0U6YFK0Ks392W1g+EtwX2oiQZLh0r7qoYckY2iMK8Ays=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=PsscIedk; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="PsscIedk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741201469; x=1741806269; i=rwarsow@gmx.de;
	bh=qfh1wvTEekJMFX55T0b8yCRRJrvfpZkth0Am/jyMk78=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=PsscIedkjgdlpwl34XrLbToSKwJPKgf0DCFY9DsZQBiKcGRQGmB1tMa+RWrEwlLu
	 XdIfPreCOAwb1XA8WMj4PobSESv55ayci6TPFXkGTZdxDS5QnZm14i/t0OoGkdyiN
	 D3OUnaLTd9wl2oyW2mOfZsLRPAtNo/gHDLDjFJuGxqE4yaOvI02XeJXUymb9+iSee
	 MjED7yisXeZKMLMQFbp7HHFCQtEl6mFkOSfS2Nf9tQVFSC02ti1qfohz60eBr1P5Y
	 3k1FhGtBcxcVp5xIGP3S+6Oa6ZQOgGxQ1Qxzyabs5uryk9i/SOf0Zev55Cn/1apX6
	 wZ1S1WPRes6Z+ZkT8A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.164]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MJE6F-1tX0g33fNj-00HxZu; Wed, 05
 Mar 2025 20:04:28 +0100
Message-ID: <891abe3f-af74-47ee-8f5f-b5d43f11d8fa@gmx.de>
Date: Wed, 5 Mar 2025 20:04:26 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250305174505.268725418@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:tNDvVouYmro8bAiidG6lpf8M40FmtwQwS6QlR7jR5Y0OkNhZrt+
 DUZIk3TEoiy538mcuKKxH7cD0SrNpGeA9lb94D8EpzRC1V0LvDSntF8DvhrHqUBODOZK6z+
 57rZeAsRHIlAapTvE7suUmwgKi4C0alwZfN9r4ErIK1zTorovAhNx6bdvVpJn4wqP78W7t3
 yrlLyXmjh+mcw+hed9vwA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:PsAhI9xQdaI=;CAykRxy4U7e8/bzivqWPzFYMJRX
 47nPoaN54BzHoAzIYE/zTXyLqNvbLLFZeX3adz8SMWvW43EnsMrvR4J5EqJs6+b21Hsim8IW7
 P6KwLHdImhPQglXsElvMz+8HJlmBEEkVyGFkiwOtM9ITzMUm50ZxaPi9WMF0MfE6nUcOgpNKV
 d/HmkxIe54O00kD1uJTYx92z0isCjuZTFY0/5jj/EFFB9yO3xdGVA/kKjthTj5wJYwxkKcCsW
 ssKsUQv84UpqbmvmaslScjEh0rruq3c9KimBEspUy0YlxxFP8ZoTA8vU78/3X8qO502hU6eNK
 1UVCsry7/jd27eX54aJgOvZb8f6m11PCxL6PnGfC7CBIGDzWaEEwYN2/ZkR2B8P6AwCEXOJo+
 e+Of0i8pUMB5P4HRq7FlfpgCGfurgXv9D8Disy9Lh9PUg61mtPKajdhQebkIO7/vLAY9beDTe
 +OUIstaSn39D6oNjF7xvW2RL8A0HEH0PE3o0fpoksi46lVUuBPs9kd0IJtWjKKMGxL92tZ71H
 XmITugWy2iSwGG7wsUf8NENRduG+MhXDM1Jt+HEc9+XFmHBFwHz3fh+gTPUuYXyOXYQI6WTsD
 RdMIbTGI9vW7+qAKJE4oOSr4QH9Z9PVKKSxJthpgX40OU2ddUtnR2+RypoyAfKIPLQcQXx3Pc
 iPbfhDToH0MKW7rlE8PIfzUu2h3wkXjyp6wJ7XQSo3Eq24QwkdI1A5YbRTKEguv6h0v3lCPLw
 p1IWxx9aDgmIYlsqEqZyzWc0aXXWgSLdZE+jpduIKHVcIz05VaPSLVAVAXF7EX+GQVxA7Agkb
 yoxf/7Vy51uQB6nYQs6zCbizeft6O5Bid+GODu90HDpaWIRWQ7RYxXVryLxdr65Y7t+HOW3qe
 QuAHuaF2AkDd1vDmkCjRLKgZt+1FN1EvxrVChS3CPUN3hes3zLNtYV9ceRrZRaVWDxmzHvZia
 SDSCeDtZ3ilL525pMJ4nSTTP5uehEZ0+UUDs2Qnxfvyn2hCyoeXLF1gKDGSH0L1hKzNQvs+iN
 IpoDVML7y+8ApOLLdMqKrzdl48wwxVNsSPeO03H8IRyxXHPAadXLk5SxOnVfUMTROVawBSMQk
 ayiHs418UMZU8HmynLNZWjd3rXv+zwgu69baFCDuD6JDuAvNSmihQfX92Fjm4GyZi6Li9PK9y
 XmmiYrCHOWQ/StJ+zUjcv5ceRoC2NsASao7MfJ33ijfa7mM7blHFB19DvXYFlUMApqBKsf28D
 96vSk5rAvspMiJO7I/qNH4zG0dYL9fwbJM83oXqFNCUntU7tHBFi7QDM8xcAppKkp+21QDAhi
 d/ZTgTwokDkOMjVhMgVCjEzHT3EGkUrkEaAWtmyPvfTviOSQp1NgVEJk8bn/th8Q7W8v69vHf
 FRsMEwpWjkCtr1x+JZmsGrN+F/d8FNPPcNJgKt2vDyXHKolCIDReihMPmQ

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


P.S.

is it necessary to have all cc'ed user informed or should I leave them off ?

