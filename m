Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596FF17FE
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 00:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728001543; cv=none; b=nQaZQykNOk0c9KEypDPKPqzlVUSGyXkUX3upXB3mm3mow2E/YTytHs63tF3kOC+zjKhJsDR6DtpiZ8Fqibjy6C+AUthulU4UXvLVyKLHLoaxoPtZaEPxQw2gV+BlnhEZcRjooHonJClEUe+Eb3Eksre/R/c8WwcJJfGnCo2i7xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728001543; c=relaxed/simple;
	bh=779lYMg7A1shUof+Yjz9lPBh8Op5yoFdY4l7YSTdfYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b7tL5oVFAARJgnllCtJNBtH3yNXyqtgqgSidYxD4iZDJnqvNMjQiOeNGPkpjIHZCskUVys9qj0nxSsayMQKLFAs17BrEelzGeKdm1qqfVlQhC+WRbeVJBsj3IwEc55XEMUGQznPwsf1rw+wnd1BWcLYMRNODRP/mIMt1fIPbWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2JwOLKB; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2JwOLKB"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20b0b2528d8so17624235ad.2
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 17:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728001541; x=1728606341; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ECaR81O0dfOWEMlG/slJPyPVvFIWLy+OC747Xh2FARo=;
        b=e2JwOLKB4pakU7WcPBwu3I2N7hjAQ3/ZXGoawhWGboyqpgBipzeanKMdlQ5NVK+np2
         fTvijhkIla1wg/df0vkheLK+Jm8vYVt25KWOqBMA55UaIglZXN/WbzP8pRgdbOHQrrOk
         Fo9jE9fa399EO11o8J2XBEZg9mHokN7GgAABixeUIuv8B6BefP45AxUXvwSgQTedr4VL
         Lszi6qzc4PB2yc3LsVtCobkiFdfJt4o2KOtQ4HaXqph5OqxwPb4FKx6ZAj1JseDoqus/
         48OSUeA1fAZMV2ay0a8wTHK8k35QFzVujzNsS0KBUVvTXlpdy/SHg5UVJD+V2eKJ3diZ
         VE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728001541; x=1728606341;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECaR81O0dfOWEMlG/slJPyPVvFIWLy+OC747Xh2FARo=;
        b=pC4JUngthQBYl6qsd5kMDtkZJ1ZrnXJAjynSe+1MOfk2ohX5jhITf/rf1Ct5+O+mPx
         cuF4BqDc+r0v6H+ze2Mu0FTG52U4BENVTnJ6+FZ97OlOdCCmvCmdNYTuJ/etICHGf91H
         oFeilFnyNUE8BV+Atue9CUHtxAqjL1z3XLrQo5pObAzpoYM9WMvDJoOrddai/6MVf3xU
         b41C2MqSy3GDdFYmc3oO60M3vDmII1vpmvdFySEtw1cntVpcWIXIf1D0a0l7W/f38EU/
         iPG3INlp/RyPFckO+HW4Du2aZ+IsR9IxZhB7jMUP+1v/dTZ0I/9YEQnWe2GVsDAv6zIw
         aqdA==
X-Forwarded-Encrypted: i=1; AJvYcCUznSzv3VxBZLC/NYzI3zXJ9NU3SGBS41B/LxLFYX52H9kr4xMGDMR2QfTO6bmbBJV7hxx7C3Y9@lists.linux.dev
X-Gm-Message-State: AOJu0YzLyep7x4/q6w5d6dcUEAamcUEsfoPZ9aDfoMHWIHI7ksljk/xl
	XneDxjrjOjgI9iEs/UpH1T8M5P/gNkaCFWQH2HHVlK3JP2jQuvHu
X-Google-Smtp-Source: AGHT+IHXX/IAk06czL0zXYWi6NSdPKSTpkoq597FjOvEcCYS4wBfPZe7/ujoqgqQqMUNK8cj0VeJ7w==
X-Received: by 2002:a17:902:ebcd:b0:203:a030:d0a1 with SMTP id d9443c01a7336-20bff18cadfmr16665975ad.58.1728001540634;
        Thu, 03 Oct 2024 17:25:40 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beead2573sm14601105ad.6.2024.10.03.17.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2024 17:25:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3e1de608-008c-4439-acd2-647a288dcdc0@roeck-us.net>
Date: Thu, 3 Oct 2024 17:25:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/8] clk: Add KUnit tests for clks registered with
 struct clk_parent_data
To: Stephen Boyd <sboyd@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
 linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, kunit-dev@googlegroups.com,
 linux-kselftest@vger.kernel.org, devicetree@vger.kernel.org,
 Brendan Higgins <brendan.higgins@linux.dev>, David Gow
 <davidgow@google.com>, Rae Moar <rmoar@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J.Wysocki" <rafael@kernel.org>, Rob Herring <robh@kernel.org>,
 Saravana Kannan <saravanak@google.com>, Daniel Latypov
 <dlatypov@google.com>, Christian Marangi <ansuelsmth@gmail.com>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Maxime Ripard <maxime@cerno.tech>,
 Geert Uytterhoeven <geert+renesas@glider.be>
References: <20240718210513.3801024-1-sboyd@kernel.org>
 <6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net>
 <a339ec8c-38f6-425a-94d1-ad69b5ddbd88@roeck-us.net>
 <dcd8894f-1eb6-4b5c-9e6f-f6e584c601d2@roeck-us.net>
 <6f5a5b5f-71a7-4ed3-8cb3-d930bbce599b@linuxfoundation.org>
 <ba88a29c-f05e-4ca3-82d1-0a634613caee@roeck-us.net>
 <4216b852-11a2-41ae-bb01-5f9b578ee41b@roeck-us.net>
 <879831a8-2039-4cdb-bce2-aefdeb7ab25f@linuxfoundation.org>
 <da260b77-2ecb-4486-90cb-6db456d381ef@linuxfoundation.org>
 <f5f1c42d-77c0-48c7-ac52-3d4a3b5c2b47@roeck-us.net>
 <4a8abb5f501279de7907629f4dd6be24.sboyd@kernel.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <4a8abb5f501279de7907629f4dd6be24.sboyd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/24 16:46, Stephen Boyd wrote:
[ ... ]
> That DT test has been there for a few releases. Is this the first time
> those tests have been run on arm64+acpi? I didn't try after sending the
> patches and forgot that the patch was dropped.
> 

Previously I had the affected tests disabled and never tracked down the problem.
Since the problem is now spreading to additional tests, I finally tracked it down,
that is all.

> How are you running kunit tests? I installed the qemu-efi-aarch64 debian
> package to get QEMU_EFI.fd but passing that to the kunit.py run command
> with --qemu_args="-bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd" didn't
> get me beyond the point that the EFI stub boots linux. I think the
> serial console must not be working and thus the kunit wrapper waits for
> something to show up but nothing ever does. I haven't dug any further
> though, so maybe you have a working command.
> 

I run all tests during boot, not from the command line. I also use the -bios
command but don't recall any issues with the console. I specify the
console on the qemu command line; depending on the qemu machine it is either
ttyS0 or ttyAMA0. The init script then finds and selects the active console.

> Here's my command that isn't working:
> 
> ./tools/testing/kunit/kunit.py run --arch=arm64 --kunitconfig=drivers/of --qemu_args="-bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd"	
> 

I can't really see what that command is actually doing ;-).

I'll just keep the affected tests disabled on arm64 for the time being.

Thanks,
Guenter

