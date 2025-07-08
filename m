Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CF42E5B0B
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992509; cv=none; b=snj/G4V9BSrZ9dOuQDqOPbI7JYbSVRN/5VD29P9eBDuSHCM9ceMrKHW8k3XjtfUZkXM1XckY6ClwgYMDVZWUiAcPWgAyXBAjauTjSwZPkKahUArrzNTf7wcLMer5isbuMxExB8KWBsQJXfwi1lnqoTQnIDQbwhhJbFHF/A1iwqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992509; c=relaxed/simple;
	bh=FoE92rz5YymWiE0i90IBqdQH69KV5QkK5fCNH1NZknE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jdXOpJcRBbZrpnDF8qgsw3gf8EbZEQ1dMh3QA7AKPVJ3M0mdKnNyAFriQjlUsxjul6Bm7SV4ZMOcTQwqcxs8dLAf/cBfHCkdkrB3C4F/yChiv7OwdD6QbX6uJVGa+ZiDeuJhIY2TAL3pziWA9upEDLnqeowjeVwAgToSHaWAfvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=KorGKSnD; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="KorGKSnD"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso8198558a12.0
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 09:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1751992506; x=1752597306; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=R1mZto5rJhSBOshiMGcFEAzHOJW3dEN/btMQDuM5FVk=;
        b=KorGKSnDxqkdJbUEKatE/KSjjVi5vLG2UuD/zadG4e0Et44XLpsHjwGc0O4HB2E6B+
         68rs7ozVHG97ivEZO5UsQ86Ls/lQZCkBlPg7tLW4aGK4WWzM37rNWmX8VfAkhrFasnS+
         BkhuC+xRBRfJpm/5nV07kY9gb4ohQC04AFdHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751992506; x=1752597306;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1mZto5rJhSBOshiMGcFEAzHOJW3dEN/btMQDuM5FVk=;
        b=aIf/wz+uNXZWLLbO9lRdFPMHmN9YUjeNiHigVcYkbkm/qJ/A1WgR1jrRwhVEgH+czW
         0gqJnyXQt5rfezbCZgSWm2nLuuvGvCoCy6/gWu8lBB6t38ajVW2iZEuqt8WC4mXVhFkW
         rK4HHzLcoUd4CC86K9gUsS0x0Mp3c2AAKxhxc/dsFMFBSqX9/bmlFxufYwocxQTCxTPH
         /iS66m6FngxFElVDbwIZkk0ZFawolMquOkqPWyBt2Qcp5VxpNAC2R5YboeiV3+82hfC0
         2Xkc+vBa9YnosCPhKqhS3rIU2RFX0ZAvkFDndKdPHH3SWx8DrPnWvHJ3zu88GlTD8hbH
         QzoQ==
X-Gm-Message-State: AOJu0Yy0Alvi+kRlCj1x7uZM3bPhfT6HYPTmfCJvIA/l64qMu+CRSABY
	Uv4WZ/2eLL19kny4XkUj2f50Tr2kWjBzzkiWlzCZdEq8PaKB28CnlXL8sAijjoJ1c34=
X-Gm-Gg: ASbGnctT5mWq5hqY/ZazpUEoxNVrcK2rwpl9N0sUvc/B5O317JVwmg9pqvmzKSdWiKr
	Y+HTkXd4OXS61y+HLkr4+k6xT08HxqEOg5IhUf9dS/35hOFv7D9B+jHG67Y8i35mynDHuBezhnn
	GNgy9lm4KgdO795bMf9qx2BFyAnABWrs2x3hrzzd0un+BhGbbxPjEPJ+Q2js33gWI0o4YkGKL+R
	O06QcwSxO60p4seMGnK1l1PSZWfGHZNDuGviJ8ItwMHtQuWXvkch7qxTifluR9jfXdKYYgLRdm1
	ezbAKjscfYAfb5toWkRPmhRPUol6WKAUWGOBBGJ2Ruy0fCOWKX4x2cG08KL2QZREkQROOmWIP+4
	=
X-Google-Smtp-Source: AGHT+IGMo8kBO2GHo5TMS6dyW7CYtreMJgYPnUJDJTLyUDkcfCr6zUd8/vK93tQQG2iW5lSmSxcBoA==
X-Received: by 2002:a17:906:f9d0:b0:ad4:d00f:b4ca with SMTP id a640c23a62f3a-ae6b021aecemr344108566b.50.1751992505550;
        Tue, 08 Jul 2025 09:35:05 -0700 (PDT)
Received: from [192.168.50.23] ([188.89.134.172])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b288aesm934502466b.140.2025.07.08.09.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 09:35:05 -0700 (PDT)
Message-ID: <46161d11-2560-4044-8ed5-bb50206f9da2@citrix.com>
Date: Tue, 8 Jul 2025 17:35:04 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 81/81] x86/process: Move the buffer clearing before
 MONITOR
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Borislav Petkov (AMD)" <bp@alien8.de>
References: <20250708162224.795155912@linuxfoundation.org>
 <20250708162227.496631045@linuxfoundation.org>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20250708162227.496631045@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/07/2025 5:24 pm, Greg Kroah-Hartman wrote:
> @@ -895,13 +900,17 @@ static __cpuidle void mwait_idle(void)
>  		}
>  
>  		__monitor((void *)&current_thread_info()->flags, 0, 0);
> -		if (!need_resched())
> -			__sti_mwait(0, 0);
> -		else
> +		if (need_resched()) {
>  			raw_local_irq_enable();
> +			goto out;
> +		}
> +
> +		__sti_mwait(0, 0);

Erm, this doesn't look correct.

The raw_local_irq_enable() needs to remain after __sti_mwait().

~Andrew
