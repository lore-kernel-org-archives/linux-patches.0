Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com [209.85.167.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2C9353EE1
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 08:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770800294; cv=none; b=pjQYkneCrEUvcNf3utvrmq19J5xBxu4imlNf0GalhTURBX6ljPuVKIdCgKd8wbu6946fJbPVnuCY8Eb3onnHvvO3l+bPrJDEndslOZNEiIwSaCJ4LqPGBuaLpqy1k8MOzxHPcEnfjz8vnWT3zEnBhmpBLACXhThbWHZg9+AWvR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770800294; c=relaxed/simple;
	bh=SnjDX2BmSG9+YNiOS3gG9ljjWXS6el4ibB5xVQ1G9/Q=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=llC5MBuzZZb82O3p44kkIq5nrf8fiu1HILixImeyac1gAsvrou+pn80J25ac96Z/9IIVLHPbKulgRatgir6b4ojtOvdvjTcZqFbtbi+baem/0jtvC2jFl9z9AmZ/8yZGlzOsxyhNS2VK0K9U8mAk84sSJzIDnZcNXpVAPJQYd3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no; spf=pass smtp.mailfrom=remarkable.no; dkim=pass (2048-bit key) header.d=remarkable.no header.i=@remarkable.no header.b=TehLZu1k; arc=none smtp.client-ip=209.85.167.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=remarkable.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=remarkable.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=remarkable.no header.i=@remarkable.no header.b="TehLZu1k"
Received: by mail-lf1-f67.google.com with SMTP id 2adb3069b0e04-59e4a04f059so4650035e87.2
        for <patches@lists.linux.dev>; Wed, 11 Feb 2026 00:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=remarkable.no; s=google; t=1770800290; x=1771405090; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2nT5soxasCdecMDImdwifJowULDL/SH1hMInO+fMJhw=;
        b=TehLZu1kl5ZrTdNgpTbnQPxJh7mMCEEuQ+2K6O/GSJuNzFTbnqcEXhbS2Kdr7mJSzO
         1NGpgnADV2Oj0UJOnJwNa936bGM5TAlgsDWPBB63/iirRjw7+d7uFs5OmhrbbjJVS/wk
         1yH0LXvnpeDvwSjqWdtplIWAzh5omEsX0nue/EO/uU6q4wctlZUFM/kfIgbxnYyr3tmT
         vROb45xiKlf7GZRDXeQ9b5S/+3sJpfYZ34gwGEb7AINifYTlyIqvZpKHOpVW6m6ZCDJN
         BYbXJ6bMI6L2hcprneST2YD6v8JFzMIM60t6nRIGloPBmi+xtE5ENSjxYnUJQ8E+mm3v
         BqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770800290; x=1771405090;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2nT5soxasCdecMDImdwifJowULDL/SH1hMInO+fMJhw=;
        b=P5lEwUKFuGTCusgesnjYQbg4A8ldWV8UMnH68pvob3DSvw3BoS29WmUwXzesfGfsMh
         CJC9jq7e7fb3HvTKP/WK7qTd8GeclGUW4QVJW3FbhmqJfbfGFrJZdDPf6oYBdYdbCqiN
         XDYizKoK582/08ujMuJ8jT/7fIAPz94WzgewYme2eo+z+/DvzgjQQZfJx3+AlTH8wHT9
         wAlVKDWP/K4/2REoLzhqzrSPfmN/LM1kWpFDQoF8VOT7Ut1k7tjkIzIFp7f77pRxSyYF
         qs5acoojqkSsC3j2IflIXgwH4YBbg3HEeOiU2i90w4Us5hLiGZ0uZcNIAwvmsT3Ip2x4
         WJaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYdTF/1yfw/cpcX65GIpRhPwsGB1Ui+aQcLGwzT8BJ8SmiZdXe1UUOWLTxnSz8OmTXRLMpgXRr@lists.linux.dev
X-Gm-Message-State: AOJu0YyXtZ9SCZ3b/1XpONuR1OPDpHFpM343fhH1JK1kRpef8XtR720q
	8U2KNNVZ/adA5YXEOQEGa499rzeiDgmPiM0x79bk9bYJXZ0U5wqFOwYUxlG2ujbekQ==
X-Gm-Gg: AZuq6aJ/X0NrmbeCeGklzSZ14lDj7CV07mDrB/ObaPVAZ0bfPf2xNfz0hDoYPaqquZb
	6+I72tZBTMPpkgtlKubLPrGaDeZEel3jh1ZnILERIKADgdhzt642zBVnHcckOoCOu/5pBm9BgZx
	TUNYja82OyKHeuhFtgfKzv6sEILcimX7OnT9kSiT88EtiGGs7vgKmwAEMbiCvvR2x7p+DgnefMC
	WCXaNRrHVYot4/ftwSzy1kI3szOPshd1jANN/KrxZtXC2c/ObaE7XOiw86vW/+FMliMXzTEnXCj
	Fxug5/pwGUNcmWl7tpyYltw2HEyyeVcw16fGtD2XXroujddPeSXsh9v+UHIHIu4GwvUhFqFqknN
	FD0FqXgS4bnyelAVS+ogcxA8DiiL9WsFf51kIa1xcgVAADEkBOs2PjexqWwwiHCd9o+1i7sVO1w
	PUCVY7+elGI2d+OxXNVqRbF8nNHi3lkbzg31EeR2pJk4LwGJk55dFg1dF8nxMQNQk8L7w3jQwZw
	aSXDlHn3Nvq891PNt01ptNasu/YZ80vSB4bUu+oO9JwrbziPM3Du0ENbuI3U7bs+SPF05DJa674
	4VZs
X-Received: by 2002:a05:6512:2c09:b0:59e:5b90:d7d1 with SMTP id 2adb3069b0e04-59e5c2baca1mr685434e87.8.1770800289656;
        Wed, 11 Feb 2026 00:58:09 -0800 (PST)
Received: from ?IPV6:2001:4643:2b9c:0:64dc:7ba4:ffb0:37f7? ([2001:4643:2b9c:0:64dc:7ba4:ffb0:37f7])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f5a4f5fsm206590e87.56.2026.02.11.00.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 00:58:09 -0800 (PST)
Message-ID: <cc9bcfe1-4667-4a33-b370-1f3912f0adca@remarkable.no>
Date: Wed, 11 Feb 2026 09:58:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Johan Korsnes <johan.korsnes@remarkable.no>
Subject: Re: [PATCH 6.12 094/169] vsock/test: fix seqpacket message bounds
 test
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, "Michael S. Tsirkin" <mst@redhat.com>,
 Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20260128145334.006287341@linuxfoundation.org>
 <20260128145337.388867288@linuxfoundation.org>
 <61627e8a-6998-4138-a174-d7fd257db93e@remarkable.no>
 <aYw9N_Ido_FZzblw@sgarzare-redhat>
Content-Language: en-US
In-Reply-To: <aYw9N_Ido_FZzblw@sgarzare-redhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/02/2026 09:30, Stefano Garzarella wrote:
> On Wed, Feb 11, 2026 at 08:50:11AM +0100, Johan Korsnes wrote:
>> On 28/01/2026 16:22, Greg Kroah-Hartman wrote:
>>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Stefano Garzarella <sgarzare@redhat.com>
>>>
>>> [ Upstream commit 0a98de80136968bab7db37b16282b37f044694d3 ]
>>>
>>> The test requires the sender (client) to send all messages before waking
>>> up the receiver (server).
>>> Since virtio-vsock had a bug and did not respect the size of the TX
>>> buffer, this test worked, but now that we are going to fix the bug, the
>>> test hangs because the sender would fill the TX buffer before waking up
>>> the receiver.
>>>
>>> Set the buffer size in the sender (client) as well, as we already do for
>>> the receiver (server).
>>>
>>> Fixes: 5c338112e48a ("test/vsock: rework message bounds test")
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> Link: https://patch.msgid.link/20260121093628.9941-3-sgarzare@redhat.com
>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  tools/testing/vsock/vsock_test.c | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index 0c22ff7a8de2a..79ef11c0ab14f 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -359,6 +359,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
>>>
>>>  static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>>  {
>>> +	unsigned long long sock_buf_size;
>>>  	unsigned long curr_hash;
>>>  	size_t max_msg_size;
>>>  	int page_size;
>>> @@ -371,6 +372,16 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>>  		exit(EXIT_FAILURE);
>>>  	}
>>>
>>> +	sock_buf_size = SOCK_BUF_SIZE;
>>> +
>>> +	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
>>> +			     sock_buf_size,
>>> +			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
>>
>> Hi Greg,
>>
>> This patch causes build failure as the setsockopt_ull_check() function
>> does not seem to be defined in the 6.12 tree.
> 
> I guess just when you build vsock_test, right?
>

Correct. I should have specified that.

> BTW to fix that we should backport commit 86814d8ffd55 ("vsock/test: 
> verify socket options after setting them").
> 
> I tried to cherry-pick it on current linux-6.12.y and apply clean.
> 

I can confirm it builds fine after cherry-picking that commit.

Kind regards,
Johan

> Greg, let me know if I should send a proper patch for 6.12.
> 
> Thanks,
> Stefano
> 

