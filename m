Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CDB4EB3B
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 06:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706510695; cv=none; b=UcYzilQm4MzJ9u5cLpQXt9JbBC1YS6QvftbP5ixQ3Z8pFQd9/XZs46I21EXbl2D38RsejIT2KFl3U/14GijDvJwCCqmy1WtMTMOxd9nxQQqhcUMRy6gXhaSqZplOa0Gaesn/RiX3GCwcmjUgxDbmfO7YE+kXcN8qohLZmJL/lxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706510695; c=relaxed/simple;
	bh=wJJf+KFUMKaPushYnI0iEsDLec20GKo1a88Dd4q4xtY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HvUmcR+vtwFJgYAwHRkuhDS26RxhaGFz7/wu+7+L6RH9iiKHW7GS/M2bsm2+DWLQT8oFJSzyqoqHd5WtOKMctcIrAsSOQsLEzwLb59KPV80ra28bBWoUUs5CU/+501tK245aYufEdrbOkIN1xS0bR2oE5WhP7F7q1YLX+XoqfFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33ae7ae1c32so781506f8f.3
        for <patches@lists.linux.dev>; Sun, 28 Jan 2024 22:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706510692; x=1707115492;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eZRDgAq7BSDnYtXGdfWlVtUHvwFxKjEHyOIslyUr4/g=;
        b=pCUrR33kDCbNUdNwGPt1IZtv8N79zRaHi1QV6/eiRteaYrClfzWx1FceGUPP7bQ5mw
         vRrYy9vSlnkllTYAiL2s35asf8kb/UqyR8LDU+lslBDh8KWzrNk8JEf1CL/fGcBpqu1W
         6l8ATjSQM3FAZF3vmNYEZX2OyzLcTd/8yf5Y0dSR6AHoxp61KuqLCb8YBes70ROyTVXA
         ZTCcm3Q9lY8nOVwPOfMgDOfCXkSNgzxFCB0PoQlO/iuCm47Iuh5RDo4+ZkrxagHG+1LA
         qLGkIHj3JUYzDR+RvaR484aT8cPHA+SchlAToUszcHk0GcI0HVBtm8WeeLa+bv8Hrg5p
         aiiA==
X-Gm-Message-State: AOJu0YwQKgC0AfUEOQhFkxhclSwnOCy7iQ2BpytFzSD8VXKHslJP3sDv
	DdSrZy3BLK5L2a+SNKwO5hREYbKZQhi+ekvO+M3FASDw0B2oOHWU
X-Google-Smtp-Source: AGHT+IE/n56O95sMjzT0zoeRu6FWBuxYMAw65pFymDFH4iXVYbIEDvM+/qZ+jXKU119w3vM1hMs4dA==
X-Received: by 2002:adf:f8c5:0:b0:33a:f4b4:8013 with SMTP id f5-20020adff8c5000000b0033af4b48013mr59277wrq.36.1706510691695;
        Sun, 28 Jan 2024 22:44:51 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id ba1-20020a0560001c0100b0033ae593e830sm4567733wrb.23.2024.01.28.22.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 22:44:51 -0800 (PST)
Message-ID: <9fc00f54-24d5-44a6-a690-d4f73c37caa1@kernel.org>
Date: Mon, 29 Jan 2024 07:44:50 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 427/641] io_uring: dont check iopoll if request
 completes
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
 Jens Axboe <axboe@kernel.dk>
References: <20240122235818.091081209@linuxfoundation.org>
 <20240122235831.353232285@linuxfoundation.org>
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20240122235831.353232285@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23. 01. 24, 0:55, Greg Kroah-Hartman wrote:
> 6.7-stable review patch.  If anyone has any objections, please let me know.

Hi,

6.7.2 fails in liburing tests (both x64 and x86-32 lib on x64 kernel):
[  115s] Tests failed (5): <fd-pass.t> <msg-ring-overflow.t> 
<pipe-bug.t> <poll-race-mshot.t> <reg-hint.t>

I cannot reproduce locally, that happens only in openSUSE build 
machinery (the errors are transient, the links might not be valid in the 
future):
https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/i586
https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/x86_64

So I cannot tell if 6.8-rc is affected.

I suspect one of the 6.7.2 uring changes:
e24bf5b47a57 io_uring: adjust defer tw counting
22eed9134509 io_uring: ensure local task_work is run on wait timeout
ba8d8a8a36b2 io_uring/rw: ensure io->bytes_done is always initialized
d413a342275d io_uring: don't check iopoll if request completes

It looks like EINVAL is received unexpectedly (see below). Any ideas?

The tests' failures:

[   53s] Running test fd-pass.t 
     msg_ring failed -22
[   53s] test failed 0 2
[   53s] msg_ring failed -22
[   53s] test failed 1 1
[   53s] msg_ring failed -22
[   53s] test failed 1 0
[   53s] io_uring_register_file_alloc_range -22
[   53s] test failed 1 ALLOC
[   53s] Test fd-pass.t failed with ret 1



[   65s] Running test msg-ring-overflow.t 
     Destination ring create failed -22
[   65s] test defer failed
[   65s] Test msg-ring-overflow.t failed with ret 1



[   75s] Running test pipe-bug.t 
     pipe-bug.c:73 io_uring_wait_cqe_timeout(&ring, &cqe, &to) == 0 failed
[   75s] Test pipe-bug.t failed with ret 1



[   76s] Running test poll-race-mshot.t 
     Bad cqe res 0
[   76s] Bad cqe res 0
[   76s] Bad cqe res 0
[   76s] Bad cqe res 0
[   76s] Bad cqe res 0
... a lot of these
[   76s] Bad cqe res 0
[   76s] Bad cqe res 0
[   76s] Bad cqe res 0
[   76s] Bad cqe res 0
[   76s] Only got 1 requests
[   76s] Test mshot failed loop 0
[   76s] Test poll-race-mshot.t failed with ret 1



[   84s] Running test reg-hint.t 
     Bad CQE res: -22
[   84s] Test reg-hint.t failed with ret 1

> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> commit 9b43ef3d52532a0175ed6654618f7db61d390d2e upstream.
> 
> IOPOLL request should never return IOU_OK, so the following iopoll
> queueing check in io_issue_sqe() after getting IOU_OK doesn't make any
> sense as would never turn true. Let's optimise on that and return a bit
> earlier. It's also much more resilient to potential bugs from
> mischieving iopoll implementations.
> 
> Cc:  <stable@vger.kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Link: https://lore.kernel.org/r/2f8690e2fa5213a2ff292fac29a7143c036cdd60.1701390926.git.asml.silence@gmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   io_uring/io_uring.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1898,7 +1898,11 @@ static int io_issue_sqe(struct io_kiocb
>   			io_req_complete_defer(req);
>   		else
>   			io_req_complete_post(req, issue_flags);
> -	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
> +
> +		return 0;
> +	}
> +
> +	if (ret != IOU_ISSUE_SKIP_COMPLETE)
>   		return ret;
>   
>   	/* If the op doesn't have a file, we're not polling for it */
> 
> 
> 

-- 
js
suse labs

