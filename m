Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9499030BF67
	for <patches@lists.linux.dev>; Wed, 26 Nov 2025 17:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764179276; cv=none; b=HzyGxaBIaSqyZEbjkKgDoB/xytcBlar6Xmsn9mlYT2Jy4AcCt864lfHGynd82h+gCkmaXXwvfKaAqDahqICaPgKxtkYJJcEuudndoZVmBRLVUfu7jgSuM+gWziWGOuByDEmNeP2Sl5rCGwHeoLbjXj6ADaagzgrrGATN/mOVdxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764179276; c=relaxed/simple;
	bh=FJl4K/OEujc2ZzLeEya106sEqJFkkF7QO56YI6CXvNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dGDTRxK1y0kZP3wTiTuVYMgxwhJjVRojdt5oIlx0/mPw4UP9XUXsCPHtDcMfrU5kjzWBKCaR+wWzwTTgFKL7iEJbrJEw790X+pw8XkeGz7m3ZYGVv7EmnKYwE55p8AUmx4dSCRX4C7JZ1EySdTYlOvCdlQ5U20FShwTRjglWjSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aoa7lSiu; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aoa7lSiu"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dGn5C5FmRzlgqjW;
	Wed, 26 Nov 2025 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764179101; x=1766771102; bh=aY560T2fZUcicLcM/TjNKorD
	8bkvVCAZ2pJYtGV8Hs8=; b=aoa7lSiuLH9Rzm541to4Pipw1/CgGvXTSJzhEp01
	TceRBxpqNSgOtpVi8f4Lp+WR61zYzr0Y5aIo+RRt2uLBUW7OmdWTD4w9CsTavHW/
	i02kHtipz6Jk8EG4mdqHnst7h43Wk42eP9CaK0Cdrhkk6rXqQft7WbeoSUprgwAs
	6MIelLMkSCV+ElLDt5vE/M9jt6yOhMJ14YSi/Ut/rthjqA+pR00+sSl/DoLi865M
	TL/QwxtFWc53Y+q0z61zsmeKiGiWGqI3AOFXaKnuPFcUMs+di7fErrmgKUzBqfvn
	CJ+5iBEVEcaGDNasniVt3pHlrlwClG3JW/D7RmaS+gZA4A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GJMa-J9gw7Gq; Wed, 26 Nov 2025 17:45:01 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dGn524TlYzlgqjV;
	Wed, 26 Nov 2025 17:44:53 +0000 (UTC)
Message-ID: <a38bbe68-97e8-4476-a406-5c5228167e96@acm.org>
Date: Wed, 26 Nov 2025 09:44:52 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
To: Luis Chamberlain <mcgrof@kernel.org>, shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org, patches@lists.linux.dev,
 gost.dev@samsung.com, sw.prabhu6@gmail.com, kernel@pankajraghav.com,
 Chaitanya Kulkarni <kch@nvidia.com>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
 <20251126171102.3663957-2-mcgrof@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251126171102.3663957-2-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/25 9:11 AM, Luis Chamberlain wrote:
> Long ago a WAIT option for module removal was added... that was then
> removed as it was deemed not needed as folks couldn't figure out when
> these races happened. The races are actually pretty easy to trigger, it
> was just never properly documented. A simpe blkdev_open() will easily
> bump a module refcnt, and these days many thing scan do that sort of
> thing.

It would be appreciated if "thing" could be replaced with a more
specific description of what actually happens.
> The proper solution is to implement then a patient module removal
> on kmod and that has been merged now as modprobe --wait=MSEC option.
> We need a work around to open code a similar solution for users of
> old versions of kmod. An open coded solution for fstests exists
> there for over a year now. This now provides the respective blktests
> implementation.

How can it be concluded what the proper solution is without explaining
the root cause first? Please add an explanation of the root cause. I
assume that the root cause is that some references are dropped
asynchronously after module removal has been requested for the first
time?
> +_has_modprobe_patient()
> +{
> +	modprobe --help >& /dev/null || return 1
> +	modprobe --help | grep -q "\-\-wait" || return 1
> +	return 0
> +}

Please combine the above two modprobe invocations into a single
invocation and leave out the superfluous return statements, e.g. as
follows:

	modprobe --help |& grep -q -- --wait

Additionally, wouldn't has_modprobe_wait be a better name for this
function?

> +# Check whether modprobe --wait is supported and set up the patient module
> +# remover command. This is evaluated at source time, so we need to handle

remover -> removal?

> +# checks the refcount and returns 0 if we can safely remove the module. rmmod
> +# does this check for us, but we can use this to also iterate checking for this
> +# refcount before we even try to remove the module. This is useful when using
> +# debug test modules which take a while to quiesce.
> +_patient_rmmod_check_refcnt()
> +{
> +	local module=$1
> +	local refcnt=0
> +
> +	refcnt=$(cat "/sys/module/$module/refcnt" 2>/dev/null)
> +	if [[ $? -ne 0 || $refcnt -eq 0 ]]; then
> +		return 0
> +	fi
> +	return 1
> +}

The refcnt initializer can be removed safely and the return statements
can be removed too.

> +	# Check if module is built-in or not loaded
> +	if [[ ! -d "/sys/module/$module_sys" ]]; then
> +		return 0
> +	fi

Is the comment above the if-statement correct? /sys/module/${module_sys}
is also created for built-in kernel drivers that set the .owner field,
isn't it? See also the sysfs_create_link(... "module") calls in
drivers/base/.

> +	max_tries=$max_tries_max
> +
> +	while [[ "$max_tries" != "0" ]]; do
> +		if _patient_rmmod_check_refcnt "$module_sys"; then
> +			refcnt_is_zero=1
> +			break
> +		fi
> +		sleep 1
> +		((max_tries--))
> +	done

Has it been considered to use a for-loop for the above code? E.g.
something like

   for ((max_tries=max_tries_max; max_tries != 0; max_tries--)); do
     ...
   done

Thanks,

Bart.

