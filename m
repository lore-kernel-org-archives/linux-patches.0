Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07369238159
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 02:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783132552; cv=none; b=KIV1mWmBbIRs+dV3z0L0D9h1f+1XqwGeR00oqltdgUvu8HGE3SFc6njj3+T9sI8moqmsF5NLONQO1gNMMORN6qOh3HYfbXCQbafowDOrDjyq/l15X7Aedh4Dv6vXvsHsip/qgieEz89qqpHOlynsRm1VglDKmnbGlKceg/g3aUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783132552; c=relaxed/simple;
	bh=FgKUqeB0lXHa9dP79O/zC1viwyzBYQ+jYUH5FxxbGd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P31z2pu8QqDjAIPY1rOWOIuMPH/dOGfy/ul+hvY7AgMsHTIBSaDhrJOptsOC78TlJV8Y+VQktyf5ppbh2cgPcW9AFEfqRame5p4cfRhelBQqL6jDPg0EyKYTUnN1dnt4n+/ARj9Nl1vhoU1h3mGCSzpXnJkyOOIEIXAjw1bfgyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=zcRS8stw; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="zcRS8stw"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb63dbd229so600117a34.1
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 19:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783132548; x=1783737348; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sHvJZjVQxTmWKsTA4qLP4x++RU/BtpzZqPpEeqR7dW4=;
        b=zcRS8stwPfvX2dpFOjcYn37YyQwU7xPAqHDLy3IuFRk1kf4C3f6wRGHDM7s5buzX7N
         qrcJS/RWertditUzGaGIebs4LcXFBSwcb4fCglk2HEgV5VGZ0OI7N/wHiW3mYeZV28hD
         /5vWe1L7qqOplWa/jjsJvgkKpKQWoq0e9lTR9dmDy/CVV/OhoBGjyVa5pBPiC7aKizYT
         7d/v8zdFtd3MmZPMO0zT6op1Wtf+J9AxNb9y1rOUnhw0C6ewxVvhZA7XEjb59Q6o+8A6
         38NHCjgV0g08oBRMcXQUWJetvn1xi+ZctA5aIfwxU96tX77YxPBhw99BhHljKLQ+PNQE
         Tw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783132548; x=1783737348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHvJZjVQxTmWKsTA4qLP4x++RU/BtpzZqPpEeqR7dW4=;
        b=MOE+pJie81a3C92AOo8R94bi81Xd/U6qAovSanZ1QKYcQt4n1537betlQRyOWfamKu
         Hb21rgtU2sKWenPO9+fnoNkTUh3TsAWZ35taUxWE+hjLRtTXtesCZQqmaEOhEWLG3oxz
         3TFM1PhXyj1AQ4JqaUmzL8EJPdeWGolz+lZEz2qINm4Qe32PEk3/WZUMwbmGQ7rpwTs0
         JrbTY2nhz9qL0dNAhr2BCm2evdarr+ACHTTp0qyRg8l4cOJfEbdNcLU9XQq3+uDC+5zH
         7h3igt/GU5FuzX6yJVwSTqrGshSpv1OcX1whVv7TX0Umnz3dqp3BEmqDR+QPFkAtQiHH
         qceQ==
X-Forwarded-Encrypted: i=1; AFNElJ8yhlfUAudX3ZDj+uZLMnZ0EodgBRuq+DTzk0Zi8g6YfEP6+Ym3A4ImexEiHB5KBc2GGNM9rf8p@lists.linux.dev
X-Gm-Message-State: AOJu0YyL/7ieKizvRwD4M5B2PRyyqr6p8wXarQbiFOisGUeWLrEAkdOU
	cw249af/p70+UVIgbQu+jjr3wiSPH58F0qw8UJiELwShY1fJTeok4OPmj+L3QuF+Kgc=
X-Gm-Gg: AfdE7cn3fJnnr23xOjSk0J32g71y1v4DviYaiNx5a4LhneyWcKufwtIEkICeMOw0QUm
	RIzhExpTj3Nc9r/axUs0VYFbaOA7AldpVxM9R3sU0f5WMwoXApZ6mCwm+9GUArjN8Mde3xLsZOM
	P9+OUHYlSxGXQfyLBE9jB5fSPc2Gu1rpiiNgBoZ7Y3MUTuNIvPO4N3pCvGwJLKhTL8W0Pe3/xwF
	fk51h+AF0f2TePEclQFIRti/wfuKCp+rDp/mPl4/c69Jn5p7DMVCyA33wmHrUSXx4EJ4OBgIAZ8
	l7K4RbEo7g3CnODAaq1n2O8q0Sv0S1W5mCAA8DhYyuJnh20KTBb9++4xpswfpbAwuiJvAn1UgIR
	FgsMM5RaAEk/NHQ5IEwQC0i3KlcSImEbXv7TbMGTRo+h03GoMjDBwJHZLQwVDwPdIiuiWIxxXEz
	/HpbMsRlGYGeQTEyDuJHHAmEWbNrJhGoDIC6EbmHEvYKyWSY6SYGgKznFDzylOm16kh6Ir3TE=
X-Received: by 2002:a05:6830:82e1:b0:7e6:d003:929b with SMTP id 46e09a7af769-7eb80e10000mr864304a34.1.1783132548594;
        Fri, 03 Jul 2026 19:35:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb54292d5fsm6325595a34.6.2026.07.03.19.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 19:35:47 -0700 (PDT)
Message-ID: <eeec321a-fd07-408b-9d64-c4d65ec92935@kernel.dk>
Date: Fri, 3 Jul 2026 20:35:46 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 044/108] block: invalidate cached plug timestamp
 after task switch
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Usama Arif <usama.arif@linux.dev>, stable@vger.kernel.org,
 patches@lists.linux.dev
References: <20260703123236.3139759-1-usama.arif@linux.dev>
 <2026070315-stable-reply-0015@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026070315-stable-reply-0015@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/3/26 8:05 PM, Sasha Levin wrote:
> On Thu, Jul 03, 2026 at 05:32:35AM -0700, Usama Arif wrote:
>> It looks like this patch was backported, but the preceding patch [1]
>> in the series was not bacported to the stable branches. Both this and its
>> prerequisite have the same Fixes tag.
>> Not having the prerequisite will result in a NULL derefernce.
>> Could we please add [1] to the stable branches?
> 
> Now queued the prerequisite fd38b75c4b43 ("kernel/fork: clear PF_BLOCK_TS
> in copy_process()") for 7.1.y, 6.18.y, and 6.12.y, thanks!

This is a problem. Can some light be shed on why only 1 patch of the 2
got applied? This could lead to big problems, which seems to be the
case for this one in fact.

A Depends-on could be used here, but it's pretty hard for a submitter
to do that, as the sha isn't known before it goes into the maintainers
tree.

-- 
Jens Axboe

