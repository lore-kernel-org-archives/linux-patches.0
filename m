Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD58442AFB2
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 16:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825882; cv=none; b=i8oM4xwWFXDR3477dfBwd1lIf500DXQbSzexvaWI3QivJf9dFxoEpIwCjJZTovYAMIaHTNhYz2lD0ivDHyJwDs3YldUO7R20SgsqB7PjjjOUeTG5YefzRbpFuscOJ7Xltssc6T/NRd4I+qxxmihp+kg80JMH+jWJrZexMabLawg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825882; c=relaxed/simple;
	bh=agnn/vVVbpuTs4r+4QvYib5M9eijg86H2mN+aWjNIgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IwOqatihli4CsbiV6J+ZNY1KF1kIxAUW26SdjtOCyqS/NfVbbk1X3p0FUqYZ7VDvxepjjUDgUN7xiIeHq7P+xTJpl8W+iUUM81pWZKfLqTNlLKCAsY/6PxcLHGMhRzSzGemlDZyFQ2JeQR8RrIUaIpGIN4s2JWgTJ8snEVTchjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=l5iEhWuq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=VjgPSq6M; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="l5iEhWuq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VjgPSq6M"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id C078EEC0315;
	Thu, 23 Jul 2026 12:57:59 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-03.internal (MEProxy); Thu, 23 Jul 2026 12:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784825879;
	 x=1784912279; bh=kg12pdmvq4RbPVfHzm9t6uJlsAgGwMISSFf/J3UeB8w=; b=
	l5iEhWuqRjSvI1F3j84riiIcHWCC7OKQh+lTDI8se/S5vmww8Ou02oTjiDwIJLhv
	ksl+ADg2XMvP2AWjIV3Zy6IkDlCn9WVjzzc4bYr0UjuPt4QGfQGPlSAvovHc98JM
	eK5o+BZy+cM72JEJK4wnZ0L97V0Eg5lS9BopBNANgkTW1Z7OegkvgSiGk86bBCvE
	9j9S1w8YqUHdTC7Yabm2fTkEQ5QPwTxXjSzxnOvfNZ4nz/6kOdf56woH5wOTPkZD
	9IXJ9U+vmxRBqJH3MjVSI0w+kEGsgylrXAtdeXfnK93GcQyxDrZcqGXUA0DaRk3Q
	CE4RorCRPdGJ5ham5TQB9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784825879; x=
	1784912279; bh=kg12pdmvq4RbPVfHzm9t6uJlsAgGwMISSFf/J3UeB8w=; b=V
	jgPSq6Mey2Phw3cAleABx67c3EMiZtdKOnLVsnM4TyyG2oyYUQNKzTbTEOkIXGhK
	ZPMkn1mz1iSmunFXB3HqT/Zvu/iI1m2Qf7CfEIRCWNhKAWT2IP6rjECIFmYI+Xi6
	1nIA2Sc5ZYX/dOkRL5mPlHElWRcEuR2oNxBp1ZwSvIiD5S7Pgh9Wu+Q3hs89KX3e
	okodWzjhQyT+crcVlU6vlUR6tJTDYMi8vY1ATHUCrduTZgy3lwNAuNtd1fzf36E8
	d7RYGZr4KSy8XxNeykoTUIjYy3MhbNwg+U3HmrOtgRTUw7sqgeaDayrSMruNO2Kn
	aR2ziPb0FxtoxzHN70Eiw==
X-ME-Sender: <xms:Fkhiat7iz-bWLu5BJCEp2XTUjX02H-yBGpHzW8416AQhejFcu5Vo9g>
    <xme:FkhiahasbBqwBS-r5wAR44jQNHqUA-gykxjTCjueXlRfQvJv_3aSDnCZbVKFKkHOD
    20OdQYEmbuVE9pZEibSO443EgJiDo0YMn_sabGBjJOf4dfqStDX3gw>
X-ME-Received: <xmr:FkhiaicUEzTWvsQWuReimamB4eiHM8xKlKyIwp2iVVWCn_jtNaPj-plBoP_0wbrKQYGJjawH1jX8FxPMC7Q0R8lBqrZim0KY>
X-ME-Proxy-Cause: dmFkZTGrHdAdEnK9D8QcBeUJE6Iu8s8ENkYluDvRv9lwJnC9ZCbR4uc9b7r6l2HcPCLbrk
    bmBZZbxL1s++nDgWs1tWU+dNvaJTUkpy/2SKW1wNuRgN1PGQ3zO66sJ8HkqFz/Uho0aXJw
    6gT+xrnaEWSZH3VrglNdYQwMQTsY5/92HAFrbGeb8ndg4Szh+71OKWn1+w+BltnT6DS9gi
    cl2iwUgvH+mGDH5PVUgTbV+Y67Av06FZxi63RYedTOBj8LzKgqZwoRtuCbx3AhoG3de8YH
    HJlhoYhTgu1xJnP2BkdAoxuyaPFFyB5v2mLpFqGksp/z01b1d5kT57oZzJHwGqPKFS9kBn
    bBrMHaPEo+7FB/TEMDoyqESgI5ccPtDYIhAUgRiJNrtkg6alnrT/6fGdvEvK6cKHPBjNyY
    /Xkfsjoif+EUSrmG2zVKe3eGV8I0ySnB3o8v2nHSdOyGvIRQ0bINgb6+k7WE9haYq9le6m
    qVwlBEa9S0HPe7txKM4rnU8olULDKagnSMtBjjg5W7yb9l5h3mbF0idCaRAp1TUbnOrNFE
    M7m5NkOlQDUrHzUUDqhTACIGbT/AW479JEc3oe2FO0fKKjYqC9fBxT9SXZVjnrUYO6Xke9
    /p1Dbh7t2yKCVYrV4ERwlnikyMnF3Q7fKM47OSYGpm22tb7HViafCgu6edEw
X-ME-Proxy: <xmx:Fkhiao7q2MM8YE2zyqPHf2DBtzmA1VwEFHO3nphALH3duK8dm3RHYg>
    <xmx:FkhianZV7R6vA3PpD3BFvECCTSIqxrQ3DaXMBfDmC7bfhIfpM3ldRQ>
    <xmx:FkhiaqFaYyCDqKYrVhm79M19l9AKcnWcHNgnETnt-SHuPpidvBoI7A>
    <xmx:FkhiaimKnf8v_iNnsO8RsQch87mDnUHZo47hGUgqCUcHd9PwgBaE7Q>
    <xmx:F0hiaq3PsfaggAw4xeEnMDWTcsG5XChALGGy_U4XsYeLWbPuaGnijpHM>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Jul 2026 12:57:57 -0400 (EDT)
Message-ID: <3308ea85-4ae5-4c5d-bfba-67bf7164a5d9@pobox.com>
Date: Thu, 23 Jul 2026 09:57:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in glob
 matching
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Yuan Tan <yuantan098@gmail.com>,
 Yifan Wu <yifanwucs@gmail.com>, Juefei Pu <tomapufckgml@gmail.com>,
 Zhengchuan Liang <zcliangcn@gmail.com>, Xin Liu <bird@lzu.edu.cn>,
 Huihui Huang <hhhuang@smu.edu.sg>, Ren Wei <n05ec@lzu.edu.cn>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
References: <20260721152355.667394603@linuxfoundation.org>
 <20260721152358.800887633@linuxfoundation.org>
 <1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
 <2026072339-reshuffle-blizzard-42e9@gregkh>
 <759ee068-9519-4cfa-9be5-1deb0d9fc877@pobox.com>
 <20260723114247.00a3f66d@gandalf.local.home>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260723114247.00a3f66d@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 8:42 AM, Steven Rostedt wrote:
> On Thu, 23 Jul 2026 08:32:23 -0700
> "Barry K. Nathan" <barryn@pobox.com> wrote:
> 
>> In the process of testing, troubleshooting, and eventually bisecting this,
>> I've tried rebuilding the kernel from scratch maybe 6 or 7 times now. I've
>> tried on two different build systems so far, and it seems deterministic
>> that the build succeeds without this patch and fails with it.
> 
> When you say "from scatch", do you create a new directory and build there?
> 
> Is it reproducible with a "make mrproper"? (Need to copy the .config
> elsewhere to not lose it)
> 
> As I don't see anything in this patch that would cause filp_close to be
> unresolved. Sounds like a bad object was added somewhere.

When I say "from scratch" I mean something like:

rm -rf build/linux-5.10.261-rc2
cp -al linux-5.10.261-rc2 build/
cd build/linux-5.10.261-rc2
cp ../../configs/config-5.10.257 .config
make oldconfig
make -j#

(where # is dependent on the hardware of the build system in question)

I just tried again, doing a "make mrproper" after
"cd build/linux-5.10.261-rc2", but it didn't make a difference,
the build still fails.

(By the way, I tried downloading a fresh 5.10.260 tarball off kernel.org,
extracting it, and running "diff -ruN" between the new extraction and my
existing copy of 5.10.260. The diff output was empty.)

Oh, also, this might be useless information, but if I disable
CONFIG_64BIT then the build succeeds.

Anyway, there are several different things I'm going to try. Perhaps in a
few hours I'll have a somewhat better idea of what's happening, hopefully.
-- 
-Barry K. Nathan  <barryn@pobox.com>
