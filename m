Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233E158550
	for <patches@lists.linux.dev>; Mon, 16 Sep 2024 19:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726513918; cv=none; b=bfzT1ajsAClqRGJnuLz5lS2+mEbRSiUCwycyUB990Wyd2wnbZkbNh/kjkL4MFlzfRl3H26R+dtwGauCyhiuuQm9BUFZyMVOTCHv8ZOQNoJfsWP7XcmEuX93OPBiWVIguNyaDgVGMD85voSvLxGfUFDrUnDf5Mj3Pua7pkma32sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726513918; c=relaxed/simple;
	bh=ntZqH3KwhY+j5nLIrPx2YIHMJOlvf/n6FnAxLSeAjk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mE4KsyxPPq8fOMMQk3U1itEUU+/VbqWYJ8+AizO3Du7lbppw3tOSvTM1ZWsKZUgjEN2HUhvAPT8X6e3ayNclV+PUR/DqiQ1jvkp4BR13GeaTD9lQ3ui3OYwly+CYF/RARzxCcFSfC1fcK0mJk9qa0/qbcPZYNo5BbG8QHfaEX7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FzyM9Ong; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FzyM9Ong"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-42cde6b5094so38722475e9.3
        for <patches@lists.linux.dev>; Mon, 16 Sep 2024 12:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1726513915; x=1727118715; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QJIs3HP84IMTP+ri2+xfE5tCgMh3aa3QvScDUaw4ots=;
        b=FzyM9Ongw+wxu7X72VcHDvr7N7Npda7KWunUeTeFnfmixzYtliVNO5qKkuHAlSvTYa
         XemnHrxsl8rTravmW5ua7K5pX6Wnjy+MFEBommoB6yhqXxb/g6r0xpvrUuCx9Hc6o4sf
         2DM+35COi+G6gvUK3dHDvhcYDImdwoN+2W1qN2t+0a+iGKXMFS04/E7I8Jn44d2+yPRu
         gta67d6zx6ofs9Do75NiDzHE03pyb0HtEl/+2yI++KgcSNDLIi6aw0SM9B7v3nP9Ew4C
         +b29foNA+i+Z6xvhg4StbwEV4XYlOKcJ+mc8hr0KLn7UdSOr8iRebI6l4HEqQXWxCqoD
         TS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726513915; x=1727118715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJIs3HP84IMTP+ri2+xfE5tCgMh3aa3QvScDUaw4ots=;
        b=LOi3IExSpD2GWYU9k9bydhtQKUbaXdf4xw/2LCFVZutUF7X2bpLMnbMixnEeZXmMME
         Ow4IKKZDevnKfqzyGii0iAzYdZOHKt6Uw+xjEo1HPkprtM3yKowe0/qtUuime76iktp1
         IWcbQXyYApozbsdATzP/Mog8q5vbF7+2QJAcWXCREsm0RZrQWLRxWvARYnFUxBzGLOlM
         kdwNEbCdqUmKfqSCP7BWk5DwL0Q9RkFysYmlqjo/2yh2GRznjdRNRXg5I30QFufC58Mp
         2b/A7crc2kZC7yxQ1l2+caYIxiuDiER5dNu0llgZiSy4DISDsuISmcL7MGtEJuI+7vdw
         wpQQ==
X-Gm-Message-State: AOJu0YzKpLmKbbCn6FvwepkK7YdVYvUQQ1O66W7o/9BY1Yilh64yCZ6a
	NKWVafnAiot7qh9a2WSLnPNxZv2x0FL0OqDpJuCn3acd2fhIT/0=
X-Google-Smtp-Source: AGHT+IFdYcBW6EPk+DbILysc95+8WJFez75+bt2ej20zZKnpVDqb0UJKQNwn5Kjgw8+foBDfR8wf/g==
X-Received: by 2002:a05:600c:154d:b0:428:e866:3933 with SMTP id 5b1f17b1804b1-42cdb57c45fmr126658755e9.22.1726513914786;
        Mon, 16 Sep 2024 12:11:54 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acc3a.dip0.t-ipconnect.de. [91.42.204.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e78052e4sm7770871f8f.102.2024.09.16.12.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 12:11:54 -0700 (PDT)
Message-ID: <302bb85a-27cc-43a7-bca8-a05748a3b216@googlemail.com>
Date: Mon, 16 Sep 2024 21:11:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.10 000/121] 6.10.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240916114228.914815055@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.09.2024 um 13:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.10.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
