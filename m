Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A665192D74;
	Tue, 10 Sep 2024 10:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964451; cv=none; b=CYGgcQm8kKkb9mdzvHn6G/ge+QuMbmZUsO6e3mizOGY5iE8mQO3x9qEryd9YXlEKh39rkU+IdHl0U81dbIJ2BNcAQWxYdFhRDqUofz7xJ2d3lB9Iqx1XlbhXaJc73R23igK6amsjn/kG6p4fHL1cLpMGWiXc79/4R1j2+qBY2go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964451; c=relaxed/simple;
	bh=zTqlr/QPOz5pKf1RFPMYxAuopq4c12N7cuBQ2OHORqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ejjjYhxXhf42pggNUSorJO4sxKlINmqlKq57wp0gD+AO2GMJHsvjkCz21AkuqGQQ6o6nYYoUY/9nfs6lIIfPAeLNmouYtfQQYNVl3zGAxXvnYtnpAk835XVfL7nGmkEzzpVyDCynwqCAiqiotzNvjSj94EkPwi3yqCtNXyM2Edc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=DKI7zL9b; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="DKI7zL9b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1725964432; x=1726569232; i=deller@gmx.de;
	bh=DtErsRUxKfC5cdRl92P3BngsATEbxZp7I7h/63llepU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=DKI7zL9bMXxE1K1q+F4ZAzir2LM+E9jbBJocuKdQdAFOD+I0PyLNlnFGYt3197Ih
	 8DPX65hPG9XBtjVDrVnhSs/GNRP0/emFKwHLmUFIrYMwzdhSN4Vp2o7E2ZdWdWPbF
	 aBxlefBSkxHOyOEAQNO404odmMlN9elUSL7D19XW1ZunfSb/vAD9YEAaenSD7fvsj
	 yhw+K01HW7YkQhlLizDvWecKwSMvYeQfi8+5Fe9YpAwposnFT8/vbhhV6Jq23sr79
	 0NFnOIpEuL/d1pz4uLxsTgf3x8YI1eMfjUHsWu1mmoH3cdWMBb16FmhWNHAR3IsZo
	 YAIpTl6nqWIMpuAEKw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.55] ([109.250.63.79]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MpUUw-1sDny81jbQ-00ZSoW; Tue, 10
 Sep 2024 12:33:52 +0200
Message-ID: <72b133a6-c221-4906-9184-30b4e6ee4260@gmx.de>
Date: Tue, 10 Sep 2024 12:33:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/121] 5.4.284-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, linux@roeck-us.net
References: <20240910092545.737864202@linuxfoundation.org>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:9ZvbjU5W1+bcoFuWNxlpcpLpw7hQSF5Qsam/yt62ZYJfm+fWmVf
 Mu/ZaTlK2momzJP61Jr5KObNv16MHTFIuqIcRcWHf0JFsT9c37SImHtDfROEm3if2GsQazc
 IEcehr1fkf3qDDhgIJX1QxHQ5TWa3lWOqC/Y9KP+BLgZocvuxzM93HJzMX8wER5IGXCPdye
 6JjkA0lPxkkxXOzmYUGQg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Hzn63id7MzA=;pWafmo+Q6hRRebbZFrob04SqtX7
 vRVhs4fYLxDeFDF/erp/sARK9u/JFr1uvjVX6tZN7CVJE2nmApuSmp9vaNCy63dFgrnptzGEw
 54Acvskd0GcYmJJGA0MbVlZvvIwKnuuD6WNNj5L5Jej4tbqhv6PAPXV3TuaYfdJe1EpkfHCXF
 2CJ9UgJyLePZj421eQ7vxVowIwNUAW+Xmf2cSVjaVbk+WbDmQ3HTtXl6z4K0XlEeZbKhLRBU0
 07gewTOiyDQxvnHfTwKVbf3FYxDp22v1w+8HwdZAtdE7ZjnwJYtzwCWPRSYzCxkLzFmLwOI63
 h38UV1KEAKSJ9hYT4V/4ABj6rVcLbnwy+rDsw2edOBGUPDbFCzfiCU09c9uPbOC5h0M45vOt2
 lB/3brxYxt8rSxWQCD47onUrP87KgejcZ/7U6xlnjentaTvtM4v+V4iM9cWnXlOALADMwwH+A
 S/fuN2Ur/i48xC5Uj02j8EGvVjDFrrjsn2O8n+rrKbVF4hkuNCMBnwHfsorrdhuRR4MmmO1Wh
 XL2oxf2bIEe/7L31tceHlPpT83q4nxegPE++ncz3TokE03nrp6f89RujPHGte1gGGYrLJ8Qjd
 C5GwzdDqrtrS/qb8+mRtOsc3AgJehDLzmVDkdjTjzMq581Jv3qAdE07Y8iBbrnXYqGOopL5t/
 CyGJTgvBHuw+UW2LNYtI7n5N1oWcnlfEcxlJ9MRIs4RK1jSwzx1o6TpULUYsTjqJsGmtfSv3p
 6I+k/swOqRWhxdtJooXGjB4vHsTxvu8Wk3QVDhBm46gPgnWdkU+ng0DqQiMD/9XBkFdbTZ6DL
 JWMkEFarPZhsP30OH9qUvSBg==

Hi Greg,

On 9/10/24 11:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.284 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

The upstream commit 73cb4a2d8d7e0259f94046116727084f21e4599f
("parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367")
was added in the last stable series to 5.4.283 and v4.19.321.

Since it breaks the build on parisc [1], could please you add a revert of that
patch to the current v5.4 and v4.19 series?

Thanks!
Helge
[1] https://lore.kernel.org/lkml/092aa55c-0538-41e5-8ed0-d0a96b06f32e@roeck-us.net/T/#m8657a387ec86f9a2af62380743718f72ef7619b5
