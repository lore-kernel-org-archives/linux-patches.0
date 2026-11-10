Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794310576;
	b=5lnLpMtotxVGIr/78ZGtxTlI8SZ43Qt6fqmi23hTMY+HQa1P6hWkV6bWqWRQhLl6v6x6
	 MoXhkqtRga1K9jj7XGmXKYgk0fI/Et6ftosFRQoCRnOurZCkKorPtE7JRLdO33Ki6nzAz
	 WIhosk11L1ly5lpJ6bgKBcs5t4DUIb09Od8Rqvd66BP2b25UFKk+UcYKg2ZnhtRjxYgxY
	 B2Va8RZeH05f9Umm/wZX4VxOv13x9ZD9bJ5vABT8Lb9JJiInexmqATCqDY/PafnJBaB+j
	 j9zTYglifCW7T5TX6Isv0n+5jtE7kaTlx0dkjSYF/0wjSiM13jGd1QHnaRdooBujhMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794310576;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=KARVFzaA2emNcbaNE7Zlfo9u+xQFHA5uL67hKotT2QY=;
	b=HdoThk2Gb9lPOhUSttigPH86h+dl8R84/jSJk+P9rPskTIrehJOnIm/xRHIUjuHy5h7I
	 bmdSarc117p21Dt1ufx58KwWMnqwGJ/Sq7zsX8whdeyB5/+m+h/vN53gsj2AkkstlSZRz
	 5emiQ8zXrilJcVJDCVGDfsxtZDcgBZjd0RGGnZdLxaiu1CkJT68sxz3Ly4srANXULommN
	 RREw6ccWs5UGEmmM+p9/1EmrgBZNRjjygghAkqaciVmZKblzOXXtSVPiSJ+xWDxeC4kPw
	 kjWE7l1bMoDb5y8QJwERczeaGxV1Vmb2hz0I6YNGHZi6XMXcJJp0sDA0k/wVmNtV0Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=LsP5JWv0;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF504606A32E
	for <patches@lists.linux.dev>; Tue, 10 Nov 2026 11:36:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF504606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=LsP5JWv0
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4b7252a32c8so20190185e9.0
        for <patches@lists.linux.dev>; Tue, 10 Nov 2026 03:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1794310574; x=1794915374; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KARVFzaA2emNcbaNE7Zlfo9u+xQFHA5uL67hKotT2QY=;
        b=LsP5JWv0xszRBeY4ogvu3ZN5He2wqi1aNcOKkkv4ijtN+9rruAsQIP5pMcAOrvivwn
         ojNNvfsy0cSIwf3Djj+1hun2I4sRQXRefCnDPnr8JkwPmrjl5jMpY4EipB2ZY08zUA7m
         iiTR0SxGunYoABuZfseXEcz0G3qUdbgjcUr3g8fkJyzTu4k/cxgypk6xePOtL/c4laHe
         UGHAFMxUM4q1pXSk5FUkc2w3nTqNOzdM5WvjiPmtw9JbwsD3VxOMvAfEOdEM1JP+QNZW
         6NaE4z+R5WnJhl31hjOt+1suq10mZ9EllvgxiL6H5V4d8slFZlpf4Afqqbzff0cXqDb+
         rx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794310574; x=1794915374;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KARVFzaA2emNcbaNE7Zlfo9u+xQFHA5uL67hKotT2QY=;
        b=v8Kwkff30APbXIZk5w5BgZRUGjvmh4jpz/Pv06ves/SrhUVeYqbw9G5e0wTEyMR6wk
         ZkPi8cx1AYe02i+Y5aQzGexdb9m4RCjm0Mk1X4WVx3lnDvN0CuaxDuwzvVKoTIXsIAQW
         MtQq5MInKzbC8cbE4h+A74HTSThHtja0GSWKw5m14UslSa9pRrcdXWF/eWEJxkDVhfh7
         WKfDkwuX/GAGG6Ed+5+eWCjrHQWRjSuEJYTmQvZ4+jSrdBy88cd3Bjujpm6czabsX1I8
         vWTgaZmnNoyFZvcBj8iDX6tbqXeFEsQZu36aGFq+NDYEN9MydCE/zM7bIvwX8jc9ua7B
         qIoQ==
X-Forwarded-Encrypted: i=1; AL+hErF+N9Z0LK7QrIp2gR+rM8zhOtEN9eaBYa/H+gmEM6TuExqtAxbbzs4lET8CXlbxlZ51Vrw+t6RI@lists.linux.dev
X-Gm-Message-State: APuU4Z94Stf9SVa/JsoP2Trg7X3mhtMpnUJdnwZ8i5wQJtS0aNKu8gqt
	1+pnC3IIxdkeEeGUlOAiQOZv0TfW3PwiknTWxyU6/gZL20Lj3nWZeaug+wvIfyynaII=
X-Gm-Gg: AYBFou1XUICzn/cxxznNLlX2DXsgIWppmNx338YKnO0ogQuiSJkK218VenoYGvhDwr3
	Rzp5p+yG5fyFPqYLG9rFvJzZhF8IpoLQ3VNrf7sqx3RJBgCeGBeNlemIgkWciaIztmJBXPnG2N2
	UPwNuHtVpN7aEV6h85IA1CHFE85pVmJ+GmTZrh9v8a9tTwCRquy/p5ifNhthLn9x++Wb1fQLe4W
	eAH+2cH1WcsKzG/VRyz//qB3cFBoYP2vAvutN13/EnaoAs+v604XaO/HQOpjhZ4PQsimwehxsX3
	IRVjJpgr3Y2BZCPQqo0fam4xEtI44k1Bzwdq0Mx3EBI59S2oDZ0cLvBGYrokZtD1jveY+0Ax2vF
	G0dYrb8EBNBarPNYEz59j93PULQKSIJKsnern/rhQiGG2uMLV9RnctqgMzaqKyTaK97mDUkhhyA
	mJPFRkYmWJHWmz2cKSmHxCeupEnImGIHK6sjdRBeuzTroM8cRRyX8EVjXTEAc3xYkGEjwlaQXUG
	bTtx5UjtyaRg49OcnIXS77stG9sVbnGfF2ks+wbFAAaZwfpbqlejQgY2czUhV1/RBeLEJz9fWmB
	KTgqfJfpfTV016VOvV+glxfqihu0t1lB6Q==
X-Received: by 2002:a05:600c:34c7:b0:4a2:150f:1609 with SMTP id 5b1f17b1804b1-4ba0233bd68mr41274365e9.8.1794310574048;
        Tue, 10 Nov 2026 03:36:14 -0800 (PST)
Received: from [192.168.1.3] ([37.18.141.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba020485bcsm54874055e9.11.2026.11.10.03.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 03:36:13 -0800 (PST)
Message-ID: <6d0fabcb-79eb-4a17-af3e-b58a1d1c93fa@linaro.org>
Date: Tue, 10 Nov 2026 11:36:12 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6.y] perf cs-etm: fix a compilation issue in
 cs_etm_decoder__set_tid()
To: Valentin Caron <valentin.caron@foss.st.com>, gregkh@linuxfoundation.org,
 stable@vger.kernel.org, Leo Yan <leo.yan@arm.com>
Cc: Paschalis.Mpeis@arm.com, aaupov@meta.com, acme@redhat.com,
 corbet@lwn.net, irogers@google.com, jolsa@kernel.org, leo.yan@arm.com,
 linux-doc@vger.kernel.org, mike.leach@arm.com, namhyung@kernel.org,
 patches@lists.linux.dev, robert.walker@arm.com, sashal@kernel.org,
 skhan@linuxfoundation.org, suzuki.poulose@arm.com,
 amelie.delaunay@foss.st.com
References: <20260912065621.463708027@linuxfoundation.org>
 <20261109171457.1233670-1-valentin.caron@foss.st.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20261109171457.1233670-1-valentin.caron@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 09/11/2026 17:14, Valentin Caron wrote:
> When compiling coresight tool with the command:
> make -C tools/perf CORESIGHT=1 all
> 
> The following build issue occurs:
> util/cs-etm-decoder/cs-etm-decoder.c:551:15: error: too many arguments to
> function 'cs_etm_decoder__buffer_packet'
>    551 |         ret = cs_etm_decoder__buffer_packet(etmq, packet_queue,
>        |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this by removing the parameter "etmq" from function call to match its
> declaration:
> cs_etm_decoder__buffer_packet(struct cs_etm_packet_queue *packet_queue,
> 			      const u8 trace_chan_id,
> 			      enum cs_etm_sample_type sample_type)
> 
> Fixes: 99d324594165 ("perf cs-etm: Queue context packets for frontend")
> Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
> ---
>   tools/perf/util/cs-etm-decoder/cs-etm-decoder.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
> index 277da9f767b9d..caacab8c92e26 100644
> --- a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
> +++ b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
> @@ -548,7 +548,7 @@ cs_etm_decoder__set_tid(struct cs_etm_queue *etmq,
>   				elem->context.exception_level, tid))
>   		return OCSD_RESP_FATAL_SYS_ERR;
>   
> -	ret = cs_etm_decoder__buffer_packet(etmq, packet_queue, trace_chan_id,
> +	ret = cs_etm_decoder__buffer_packet(packet_queue, trace_chan_id,
>   					    CS_ETM_CONTEXT);
>   	if (ret != OCSD_RESP_CONT && ret != OCSD_RESP_WAIT)
>   		return ret;

Reviewed-by: James Clark <james.clark@linaro.org>

I tested Coresight decoding on the 6.6.y branch in case there was some 
other non-obvious dependency missing, but this is the only fix that's 
required. Thanks!


