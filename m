Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A122D60A;
	Mon,  3 Jun 2024 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717394880; cv=none; b=k3feIn1AhCZFXV5LwZacR8dbgWcqY9MNg4Ab/lbM0bbM/plZJpNJOJ5HTLKWqqLSft1TGQjMwu9FAHVaI9e3zReKjc/MOudQF6oS7poVP5nSMDuochWgthRpy3foWU8iYCENTOhbRYDYGrByNR1tcVPWPQ4o7M18/cruC7H3qLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717394880; c=relaxed/simple;
	bh=0PFHYEhS00N3FhCWAGZ6Rp1hIGoUMvxsNAF1pTofkP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qH6NjKCqhmTMAVjqru3iTaeT6dMlkTnnUgMjWNEwcPWSW59Ae43oCgpT7rcW1BUjeO6jhu47RrlM6lPU0cluaLv0d+5ZBkXr9pAVoSBL84x/27S6LAJD136NyWrejgFHVrGhFvIroamw5Az5A/3MXdL3zgm4Ry5/yrbDNDT/eVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a68c5524086so139454466b.3;
        Sun, 02 Jun 2024 23:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717394877; x=1717999677;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpamzJuuJ6oiANwBbtDeDpEwVtyHNFHi2jGdgruhkZg=;
        b=Sci2mRBolQCb+EVZn56An5Knwo2raSbHugvt0JbQe7vGhbgvukWgA3XXYp3t7/83od
         Op9qO3asPdza+48TfKlsGkiVAocDoaYaf+dVjrh1g6AVp/FltbIpM83XCoR+9oyxFvhQ
         /hL3aB2EByH4fdJs0yRYHDv4FC9MjrmdsIkogWcm60hvmyV+BecW9KGre+3Ospu4HOOE
         MxhYuzjYc2lgcm56Z8xaj3QljALY3N84a5kkM6LN6W2Xx3yyr9TQWCs8VusO9Q4lukCD
         o0vQVvsAJBkbqsqaPun9QP9haKZMJjMyoK42q+n5gKpmK0s5dFj7auloyQIgy73IiwAD
         vd+A==
X-Forwarded-Encrypted: i=1; AJvYcCVx49An0Py5pj+q3g3pLjQfjq3qlqzINqlGhGVsZ0L100UFw+GHD80Hb4Nk3zJmHrGseU8cUHiQ9/2zZNm+kANVZSKBOv/dWjB6e2XEIl0Sxj3uczm5y/6t3vjihlkZQiodLDeubCszL24+TOk8ulQaVXk=
X-Gm-Message-State: AOJu0YyIHyIOGoDeLZyFg0i4ai+aOO8V7kbuQRap26YBji8VtQr2am6T
	SL+GwIYmdEHn45lKhb34dbConPjhD6zk9fqOFDe3WDq+sHao/4x0
X-Google-Smtp-Source: AGHT+IGwiafwcd/WwuoeRpCNTd9infkmEqKN4ICGHWiJH1Oh7447HFvMolSZPrNQf6v3z3dYFN5JzA==
X-Received: by 2002:a17:907:9115:b0:a68:b73d:30cf with SMTP id a640c23a62f3a-a68b73d3742mr276645566b.13.1717394877300;
        Sun, 02 Jun 2024 23:07:57 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68ed647945sm202315466b.9.2024.06.02.23.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 23:07:56 -0700 (PDT)
Message-ID: <1313c7a5-d074-4a8f-9ab9-07e4a7716fb9@kernel.org>
Date: Mon, 3 Jun 2024 08:07:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
 Bill Wendling <morbo@google.com>, Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Justin Stitt <justinstitt@google.com>, linux-serial@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, stable@vger.kernel.org
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
 <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org>
 <2024053008-sadly-skydiver-92be@gregkh>
 <09445a96-4f86-4d34-9984-4769bd6f4bc1@embeddedor.com>
 <68293959-9141-4184-a436-ea67efa9aa7c@kernel.org>
 <6170ad64-ee1c-4049-97d3-33ce26b4b715@kernel.org>
 <CAGG=3QU6kREyhAoRC+68UFX4txAKK-qK-HNvgzeqphj5-1te_g@mail.gmail.com>
 <bee7240b-d143-4613-bde4-822d9c598834@embeddedor.com>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <bee7240b-d143-4613-bde4-822d9c598834@embeddedor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30. 05. 24, 10:46, Gustavo A. R. Silva wrote:
> 
>>> So we should get rid of all those. Sooner than later.
>>>
>> Yes! Please do this.
> 
> Definitely, we are working on that already[1]. :)

FWIW undoing:
commit 7391ee16950e772076d321792d9fbf030f921345
Author: Peter Hurley <peter@hurleysoftware.com>
Date:   Sat Jun 15 09:36:07 2013 -0400

     tty: Simplify flip buffer list with 0-sized sentinel


would do the job, IMO.

thanks,
-- 
js
suse labs

