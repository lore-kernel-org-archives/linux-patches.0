Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDDF1851
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 16:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B65C385A4;
	Fri, 29 Apr 2022 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1651250165;
	bh=ipkf+ZH0ZPZLHN4KtiziSBzjvehaBnJOxAJA9ZluiQ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lrhoj4+VwPFjgaVnmorGXwTlx8a7yh9CgR4l3rolG7SL0HZPr076d24lzYgKeKjaC
	 NVzuDInFTAr0qvQEBN3Kt8UW2Zbr61FVdU6A+gjYG/fM2tzoJJmqMur6iVPGGH4jhY
	 zVl5Nstua0m+CTSMok0OEHbq7zHP61HAzz8JBHyGWpbOvo/C6xsgetf/oiasBCfku2
	 bWrdHx2zgPMAFGetnboIc54f1YFa+9GSOHP7575tDqpeUZ5l8FEGRfEuq/dNoFNT41
	 3boRKsTyWM6nZpdWvRNtP9jmB7v4IPCak1Ap9doU1/wrN2ZdhlGMA+fZKmKoMq9KKf
	 OXAsSCk+qTSWw==
Message-ID: <eb2dd599-f38a-57b2-694e-d91aaadda2b5@kernel.org>
Date: Fri, 29 Apr 2022 18:35:58 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] dt-bindings: google,cros-ec-keyb: Introduce switches
 only compatible
Content-Language: en-US
To: Doug Anderson <dianders@chromium.org>, Stephen Boyd <swboyd@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 Rob Herring <robh+dt@kernel.org>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>,
 Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>,
 "Joseph S. Barrera III" <joebar@chromium.org>
References: <20220427203026.828183-1-swboyd@chromium.org>
 <20220427203026.828183-2-swboyd@chromium.org>
 <CAD=FV=Vtnj+8FYdBSvsud9fGEbo7N1HSjXA3rH3f8FMJsuVR1A@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <CAD=FV=Vtnj+8FYdBSvsud9fGEbo7N1HSjXA3rH3f8FMJsuVR1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/04/2022 18:31, Doug Anderson wrote:
>>    - $ref: "/schemas/input/matrix-keymap.yaml#"
>>
>>  properties:
>>    compatible:
>> -    const: google,cros-ec-keyb
>> +    oneOf:
>> +      - items:
>> +          - const: google,cros-ec-keyb-switches
>> +          - const: google,cros-ec-keyb
>> +      - items:
>> +          - const: google,cros-ec-keyb
> 
> nit: if I come back and read this binding later I'm not sure it would
> be obvious which compatible I should pick. Can we give any description
> here that indicates that the first choice is for devices that _only_
> have buttons and switches (the google,cros-ec-keyb is just for
> backward compatibility) and the second choice is for devices that have
> a physical keyboard and _also_ possibly some buttons/switches?
> 
> I could also imagine people in the future being confused about whether
> it's allowed to specify matrix properties even for devices that don't
> have a matrix keyboard. It might be worth noting that it's allowed (to
> support old drivers that might still be matching against the
> google,cros-ec-keyb compatible) but not required.

+1

> 
> 
>>    google,needs-ghost-filter:
>>      description:
>> @@ -50,7 +56,7 @@ examples:
>>    - |
>>      #include <dt-bindings/input/input.h>
>>      cros-ec-keyb {
>> -        compatible = "google,cros-ec-keyb";
>> +        compatible = "google,cros-ec-keyb-switches", "google,cros-ec-keyb";
> 
> Feels like we should create a second example?

+1 as well, because it really would confuse what's the difference
between them.

Best regards,
Krzysztof
