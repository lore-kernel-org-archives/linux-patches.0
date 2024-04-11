Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003622BD18
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 21:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712869870; cv=none; b=N4/gkfPgyLPZo9DU5vqhUZjJzynAjTDiTuWFRcSoV5rU/54CgRufzzIPlgZwudW+GvBrHKN4mecEZq3YlLbBuZzTi0atJZoCMjFiQSC2G8fTNTYNb5FJhWzERRy80dcGjgDPjGHLZi+oxH3RLzE/bp2XqB4LGVn9SHC2XVgTSF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712869870; c=relaxed/simple;
	bh=IEBJoFDSC/xhmN89SjQvJVuzGWr9gyS0EGlcaOZ8eMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSSDDrXSP66JLVNoD09/y0GbbSQefwZoqAQOXxRZW+c0237rNhy6s24Nu9+8O++BvZPEGDO/WcpjFyAm2EMqkqD6AIDWNeguVY3z7Jvko4wxwkzGfbnZr1IeAbKMjdVPNb+2JLdPdvOvHz+EpDGDCuwIvKZjcsm4hePJ5bDpPuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1or4a8x; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1or4a8x"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7c8e4c0412dso2935439f.1
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 14:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712869868; x=1713474668; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=38LeeLy9B9nLfzSgbJxSutTG0T1HzptAeGhsMkzO9sI=;
        b=R1or4a8xuQv0grgVsQke8Y1maG0bGCuUY0SPz5PMqn3Ydd4XK2/fEn3pIQ6aFcu69C
         PpH+zubPba0KBaKPDP4s0gq8yV5wj7DeeQy+xytfen6ksZFF3Jakb36rqaZfqAMLbcNW
         YkudteFWz68CYMOlrVpXJI0s/yY5h7eEU6YWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712869868; x=1713474668;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=38LeeLy9B9nLfzSgbJxSutTG0T1HzptAeGhsMkzO9sI=;
        b=E+bMxOlcn25ACUP10O5Zt3BAzuaHcFoM8GXQZlOEnA1V5bp3ZhfYvPuIkrUTyZ5uiz
         y/ikdp0jZWRnzD4EqGZqcOjQL7+WcmH0kz4FfoAEEeIzfdbWx27qqIbAOwIVGwDrDxyL
         Ljx2+wY8JkYmk+M6VO9SB2glmMGG/M4OoJ/PLV0ylTV7mMnpVf+YWw7V1Os5fTVV7Dhq
         3euNXUt9udPy79Ti/Ut+4hbZyEp/jmnBOpVkdq1RxLfAGAGeK5q7mdYEfmaUYrJoRFm+
         benl7Ahhm7UMU3EWkfPLY8FgIknZaLK8RNPq0OnjrfFUpTpROSfuG2x2KVZVQSpqkUUB
         bDew==
X-Forwarded-Encrypted: i=1; AJvYcCVbOA1wqlXmh4A3f6kaP5i6coZgPgrwRclFoiStwmERrFg7uJ00iLH6odZYSOeo0zWeSCb9j0zTIrK0A0YktwCXfzQdOu+vjw==
X-Gm-Message-State: AOJu0YzRle0KSINdcDJYhMrBgEW0JNm/I/fLIUU7+qZ64Ahxab8f1EZQ
	erSPXgqhGHz9sX8sl8Q6pHC/kFtq/KESYoP0QnUNCjeqWp2186e88SWKuYmGMK4=
X-Google-Smtp-Source: AGHT+IEvOEEya92osbmmTcRV/7dhRZrlPtPgQIc4ZlZO618j3bCXYpmIxG7Z7CY+DhVW9kJ6yy/Esw==
X-Received: by 2002:a6b:c34e:0:b0:7d6:7b7c:8257 with SMTP id t75-20020a6bc34e000000b007d67b7c8257mr1040368iof.0.1712869868075;
        Thu, 11 Apr 2024 14:11:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id bv21-20020a056638449500b0048075de1461sm598414jab.90.2024.04.11.14.11.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 14:11:07 -0700 (PDT)
Message-ID: <8254ab4d-9cb6-402e-80dd-d9ec70d77de5@linuxfoundation.org>
Date: Thu, 11 Apr 2024 15:11:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kselftest: Mark functions that unconditionally call
 exit() as __noreturn
To: Nathan Chancellor <nathan@kernel.org>, tglx@linutronix.de,
 shuah@kernel.org, Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: oleg@redhat.com, anna-maria@linutronix.de, frederic@kernel.org,
 ndesaulniers@google.com, morbo@google.com, justinstitt@google.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 John Stultz <jstultz@google.com>, Shuah Khan <skhan@linuxfoundation.org>
References: <20240411-mark-kselftest-exit-funcs-noreturn-v1-1-b027c948f586@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240411-mark-kselftest-exit-funcs-noreturn-v1-1-b027c948f586@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 12:45, Nathan Chancellor wrote:
> After commit 6d029c25b71f ("selftests/timers/posix_timers: Reimplement
> check_timer_distribution()"), clang warns:
> 
>    tools/testing/selftests/timers/../kselftest.h:398:6: warning: variable 'major' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
>      398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &major, &minor) != 2)
>          |             ^~~~~~~~~~~~
>    tools/testing/selftests/timers/../kselftest.h:401:9: note: uninitialized use occurs here
>      401 |         return major > min_major || (major == min_major && minor >= min_minor);
>          |                ^~~~~
>    tools/testing/selftests/timers/../kselftest.h:398:6: note: remove the '||' if its condition is always false
>      398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &major, &minor) != 2)
>          |             ^~~~~~~~~~~~~~~
>    tools/testing/selftests/timers/../kselftest.h:395:20: note: initialize the variable 'major' to silence this warning
>      395 |         unsigned int major, minor;
>          |                           ^
>          |                            = 0
> 
> This is a false positive because if uname() fails, ksft_exit_fail_msg()
> will be called, which unconditionally calls exit(), a noreturn function.
> However, clang does not know that ksft_exit_fail_msg() will call exit()
> at the point in the pipeline that the warning is emitted because
> inlining has not occurred, so it assumes control flow will resume
> normally after ksft_exit_fail_msg() is called.
> 
> Make it clear to clang that all of the functions that call exit()
> unconditionally in kselftest.h are noreturn transitively by marking them
> explicitly with '__attribute__((__noreturn__))', which clears up the
> warning above and any future warnings that may appear for the same
> reason.
> 
> Fixes: 6d029c25b71f ("selftests/timers/posix_timers: Reimplement check_timer_distribution()")
> Reported-by: John Stultz <jstultz@google.com>
> Closes: https://lore.kernel.org/all/20240410232637.4135564-2-jstultz@google.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> I have based this change on timers/urgent, as the commit that introduces
> this particular warning is there and it is marked for stable, even
> though this appears to be a generic kselftest issue. I think it makes
> the most sense for this change to go via timers/urgent with Shuah's ack.
> While __noreturn with a return type other than 'void' does not make much
> sense semantically, there are many places that these functions are used
> as the return value for other functions such as main(), so I did not
> change the return type of these functions from 'int' to 'void' to
> minimize the necessary changes for a backport (it is an existing issue
> anyways).
> 
> I see there is another instance of this problem that will need to be
> addressed in -next, introduced by commit f07041728422 ("selftests: add
> ksft_exit_fail_perror()").

Thank you. Assuming this is going through tip/timers/urgent

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

Usama, please send patch fixing this problem in next on top of

commit f07041728422 ("selftests: add
> ksft_exit_fail_perror()").

thanks,
-- Shuah

