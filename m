Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030F538E106
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 20:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788209876; cv=none; b=qBwkX23g+P2A8IiCSpiolsMfKG6yaP+hYyaq4gqTpdk8wCeaQqWcQV3LlT+ktE/QI6HlpTF8o+ARjvjyQ+Sig7Jvh9BjPsPSHT0HRPiL6twr6gC5KGhb24oJAZvWs5+Y0gm1XQQZHqaPY0hF00q8Sq+08XXvGx1otQUU/N30ZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788209876; c=relaxed/simple;
	bh=7XhoZc+d+Npz+Cabc3A0TtQ6BwVo5jOIjEe/ClwtPew=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TrxL7buNuE6o+xGNzW4Le+cWUwXZbB+0acP1BwdjV3LTfIkVSACE9Mff0JZd9qofc7hnGHUOpwIm65A4mbYIhNID7HmfMUXUGvzYJOTE+AEDYRA7MqJnbW9qsF7eIZDs8b3VRRfX85L+hb+ytBTrCPNzVLR8EgA7w829Izl4H0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y9GoiKu+; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9GoiKu+"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-52ff0b7c98aso28149891cf.0
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 13:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788209874; x=1788814674; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ro9e2jTWieCFdtrEqKTJDij7AqVySynjSHA79dJ5Oyo=;
        b=Y9GoiKu+guTcLdeDrEbjiz+YurBC5nS9P7mbuIeCJ+K0CWzlS214w5eV43pBKnhvU6
         SyxjAHs4dVmKyNuRVXL1779h8JUJyQ1pN+n1qVK13IE6CPWHORX4VXB1Ul4UpXXkR2Xh
         0mrUEm+Bl7OqGoX3FbyxeBankQ1pZaN5q/SMyYj7Yj8uJ+7VNYjzVdHWjOcBBGb76M6l
         K7R+7SdBbI7JEWTcIklsesVBHVOb3o/LeK9VCtZA629tOsOalrYqMQ5cV7aeD72YZHMQ
         C8EUY9ocX3HnKIgWJvRNhh232n3x4dmrZqybOzhCKOME5IS7vBUU6Im75WYmrLKU+YI8
         hKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788209874; x=1788814674;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ro9e2jTWieCFdtrEqKTJDij7AqVySynjSHA79dJ5Oyo=;
        b=IDPUVTecWZPw1+DZKoMXcAw2Bdw3WX/F3nnk2fkKtzPIMJP6Zjy+xzQM7KeOKoekC0
         /JOLmmK3XZec2JUTyiZiVEoGdztX7eTZHlX8TxMRtsmUrRimCqDFMqNWGTuyQgTBZoEA
         fOtdbKy8Fz56eUkVHMOqWT0zYUISEv2iZqNSBNlVbj3w06fpjsk9NSKdmi7BlxkxI5Bq
         BNtjaqniUSotVwCGC4pxk/6bD1jHiSt/quSNIN0ys3Wtblb08iraAMTl8LvvKRmO+7K8
         gv/XEdyVxlWo1XBIl3Uo5wvxCB9DIVgijaYIsqq5CTz1hbWmKD44X3rzurv2zE0TRG0t
         x5JA==
X-Gm-Message-State: AFuF++mZwPlDuto+G52/emEbxYe4V//YCHYJ0ww8yOiFX8b49N+sp2o6
	7koeVZ+23SRciV3AfVbFzhMH3uDhMKO2MjEGCVa9eyzloHt8qi7aCgM=
X-Gm-Gg: AR+sD13S8Cc4ms8H1eYaQv74ZyZYiSj1BfKx6SgL7kik/H8lQO8+CqDS5WVnf74uq30
	UcLRna5+zn79bwzeQ2aAQ5TIpkXLBr4Ov6sM/V5QgWUpvAWYmlXqJNqIBFZ0Eani2Zoxu8/E+Mg
	0cOh4pyVEQ/CfEWL46mEFgxzgSgWTNkifS6VRuIXw1kfZ73lUWgIZQbvUlbi9HLEp1tvAazgO3j
	RO+4Uz0ayBSYH96BYQMO416EH6hvuBH924iM40Prxo10RZj5IvJr7kFTmKvxUQ+BfC9BW7aJPFh
	qH90bVJj+PPVIG8fNs+2y1RJAn/9NEi8miOlMsGCDAMz4fLlNGcKpdJ/YN5OqMdNGWu99af7r+k
	473eU6owDLqZMD64XQ+Rm7f+gpCdq0zYt+mCN3Lq+A881Ai/tsf2ILFGZqAJPhwCrijpIpFkXn5
	X44w3gDGJ1dLNVptW0TSehPaYo0QyNsMRRItEBJueUQRirJdodbN6D1MR5eRivI07r8NsJ3d56X
	3P0gAp/j4TcxUM4V70vih3QWw==
X-Received: by 2002:a05:622a:e3ce:20b0:52f:c0b8:b619 with SMTP id d75a77b69052e-52fc0b928b5mr168125111cf.29.1788209873697;
        Mon, 31 Aug 2026 13:57:53 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90ce4515072sm91956876d6.36.2026.08.31.13.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 13:57:53 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/43] 5.10.269-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133358.571886287@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <ffd3fcee-cb98-0821-3544-4da490e546a8@gmail.com>
Date: Mon, 31 Aug 2026 16:58:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.24
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.269 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
Compiled an i386 kernel, installed and booted OK on a 32-bit EeePC.
No problems noticed.

Tested-by: Woody Suwalski <terraluna977@gmail.com>

PS. Should the 5.10.269 patch include the fix from pchelkin@ispras.ru
[PATCH 5.10] Revert "USB: serial: keyspan_pda: fix information leak" ?


