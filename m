Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6661F8191;
	Thu, 24 Oct 2024 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729790336; cv=none; b=eLnfRRAG1cqr1A0q1xl0vUDSioBZk/+OYBf4xh5A2x9YvJ2VBhEhkfd40qXT6HyRxQg5GzWYqDWz/rpNYxdHNN80JDWOcH5ZNbogjb6p7ABuHftFKLnOAGRJ7cdbz3qniS/CRCIYAZeTOgSlmcCsueFtMFQ8EdDJIACR0XcDhzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729790336; c=relaxed/simple;
	bh=CwW7xf5pVxswj8CHaH7OyHsgU59O8BXxIvlim+vHjF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2crF3romaYhWalRr0/tL3VoEjk7WsA3IpyrYVDohw2LUusnWlmatiFK86zZYpclV+zuT1Td/ztAfL2ahfqVwbBR3vPmxatq8ISZ3m8z/vxtLBkNWD6If6tRzf1wcXni/uK4G05nEMp0aFFH5Q8HXsDwu6V/W6TDAsFVFRRhUX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h02TUfiW; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h02TUfiW"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20ca1b6a80aso11433315ad.2;
        Thu, 24 Oct 2024 10:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729790334; x=1730395134; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=MUnL715/3LxfsngyI3qhOjpz6/8IYCMLAIoj+2ZIeFg=;
        b=h02TUfiWZPfW3hxU2lN8rbIhpVlYTZpAB9d6IJO1QJo8RNKmQYZe5y2BbrjaPbICE/
         VAO3srMeOVbKN6M9mVoIOeZsjrCuTj0EH2Xyy3gf25I7SAr+/1wrMI7TyXil3wO7y5hA
         RxRlS0kxOxtksDCpOmNK4cSw/g/Kd0t48/agppmWzQYNbTYdc4wob/GaVqYDh5GAp1pa
         P9tduj7CLbMJR5S5lWCbR2YPrNMwDwDejYziexTuDl/bU4r8ObN3Vbai3E6IBqPP5wK0
         M5+cYmqNhooXkwtL+g4yJ9pDG4sbGxweY+Yc1Qb0r89lFFNFJZp69rNiRPBky/JbS3BW
         XvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729790334; x=1730395134;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUnL715/3LxfsngyI3qhOjpz6/8IYCMLAIoj+2ZIeFg=;
        b=UiVqWrjGdSQW8h1+Rm0RgnM4QjF8Qm3KhNTqR1oYQlj6iuPdPYRQFeelaVg76828f8
         /mt5M1ZpCoaoDQusDcHTU20C7gwZINnMKZYctjkueVu3T70VLMzgY6olbPd0NhWOAQi1
         vEwx1WQ9zlqmborVdq6A0wNmU3h+jEquFJDG3QpM3GeNoLdI8Fi6nQkZQNcJE0WiHWtc
         PHK6guXaDIkJDGso9xt2QT+rqtU/+Inov1GQvEwpUP48VMSkL3o5q5SaXlon8ayuu4xy
         sAXmzEsZNIqL+2NtKf2tckb1lWxx7iQhMb9TZXh5grfaRonq7DwQ/E9jza5B5OXz5ziY
         Vh6w==
X-Forwarded-Encrypted: i=1; AJvYcCW8YVqYySubXbyZQkh6ZIghlTfc2dE0rcbAJ/Ott2WAMXB2fsVZjiN/xae5lGAbPz28k5Y=@lists.linux.dev, AJvYcCWmCiMXKwX3nZ08Wl55clkuz+oxH37WRi6Auc/tMJp2vUowxpavrg3Il6VLvpFehaaMZNZlgxlMNQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8hItg+slw55RuoNx3e4wD4BvwQh88/TF7mNqVdEmEBdOCCbqu
	d3BsPUrIvveK9H1WQrtY2VHymYOZVheNf4mdMUU03z5deonGcWVa
X-Google-Smtp-Source: AGHT+IEKCAZFjKxo/Nyr/QfETLSbnXhkrol1AjduntpjOaMi5BDqrJIxxdVcVIotS2EHx7dz+GdLtg==
X-Received: by 2002:a17:902:da8a:b0:205:8275:768 with SMTP id d9443c01a7336-20fa9e6990amr87460475ad.21.1729790333794;
        Thu, 24 Oct 2024 10:18:53 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f12ea2csm74665655ad.62.2024.10.24.10.18.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 10:18:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <68e35542-d360-4a37-9ff1-16fe76594b6f@roeck-us.net>
Date: Thu, 24 Oct 2024 10:18:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "MAINTAINERS: Remove some entries due to various
 compliance requirements."
To: Ivan Epifanov <isage.dna@gmail.com>
Cc: andriy.shevchenko@intel.com, aospan@netup.ru, conor.dooley@microchip.com,
 ddrokosov@sberdevices.ru, dmaengine@vger.kernel.org, dushistov@mail.ru,
 fancer.lancer@gmail.com, geert@linux-m68k.org, gregkh@linuxfoundation.org,
 hoan@os.amperecomputing.com, ink@jurassic.park.msu.ru, jeffbai@aosc.io,
 kexybiscuit@aosc.io, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fpga@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-iio@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-renesas-soc@vger.kernel.org, linux-spi@vger.kernel.org,
 manivannan.sadhasivam@linaro.org, mattst88@gmail.com,
 netdev@vger.kernel.org, nikita@trvn.ru, ntb@lists.linux.dev,
 patches@lists.linux.dev, richard.henderson@linaro.org, s.shtylyov@omp.ru,
 serjk@netup.ru, shc_work@mail.ru, torvalds@linux-foundation.org,
 torvic9@mailbox.org, tsbogend@alpha.franken.de, v.georgiev@metrotek.ru,
 wangyuli@uniontech.com, wsa+renesas@sang-engineering.com, xeb@mail.ru
References: <61a622bd-7597-45e2-96d9-9cba02fba407@roeck-us.net>
 <20241024171301.241949-1-isage.dna@gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20241024171301.241949-1-isage.dna@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 10:13, Ivan Epifanov wrote:
>> I really don't want to get involved, but this misinformation really goes too far.
> 
> Then don't.
> 
>> https://en.wikipedia.org/wiki/Finland_in_World_War_II
> 
>> provides context. And it does sound familiar. Turns out the Finnish defended
>> themselves against invasion from the Soviet Union. Sounds familiar ? Guess it's
>> the same as those alleged Nazis in Ukraine nowadays.
> 
> Especially if you can't read beyond few pararaphs.
> 

Yes, everyone should do that, and I did.

Guenter

