Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073173;
	b=MJlGkOA3KdDzX5ESYnjoniF+OGqBU9HrYOE0LQ5A7hsjvAPVjjtTkoFYNZJAPvgSA1O/
	 sNxf3q/00Da1XnO4ieLLi8N6OhUdEKfAm6W3UVb5BMoG4KJ49B6gPW2QlL/06t6SbEBoL
	 3tirWbXe+8kmxrGeI9A+ftbsf/ThErpjwdUN/Z935cLQho8AQXAUrEocVuKHVuET4rDp1
	 uU2RSUF5W2Z0bGwoW8vdl24XDJffFzrBjGL4Yjsobd1MpEmJRucIfW/sKYre6zmQG2Fw7
	 O1OkMUOo0+z4vCv0hGo0hVtGKxKlWHVk5/nY892ofoQM3IDLBB+pKl8ocClJfrYyV2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073173;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=e3RmIyg+sqDNJ434dD8xi+wJRQR6wg3BW/At88s145Y=;
	b=1xmNe0KjGbIYpDPadV1+2Y8UiGSC33vr/iSFTh9UPPhQUgxM4bzQPbGEjK0aHmblJzwH
	 /yM+r7otpXW9lFypjli4JGXqcBpcEKNjFmx/8pd4qXqhmkLJVJ+ZFTFjp2D9c6ZnIjGZN
	 0P9/xTD+j32AmlpWN4W0bqN+9UeeAFc5Yk+Bg5n3w8BT6ni7TWGl1llBu5vQn832MAfwf
	 wZ2Ka0MxWGr17LVOmNTH1QajJwmM95q6SJM7NUWpf004DSwpuKftDQS9OCILCLBFlSmGM
	 VXBfWlWY5uOtTtO0aun0855+/gjSLO2zDa73Ri0hTs6/dpGqC+mHBnAR9iUG9vCrSsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IoR/0XHD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B56606A320;
	Thu, 19 Nov 2026 07:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IoR/0XHD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6231F000C5;
	Thu, 19 Nov 2026 07:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795073172;
	bh=e3RmIyg+sqDNJ434dD8xi+wJRQR6wg3BW/At88s145Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IoR/0XHD7Muc0pZmCj5yguME1mrdvcu/jmgcpD7e1SHj0BRY27o4nM/sFS31SqKqJ
	 CaAm9OF6oRs6zz1LLoCfrbrqfWWylJ4qYy7I3LmUnISxR8kPzv5Dvkv2kGb+wcFvXI
	 i3xP98HrgVAMbb6ZBRgTUxyh9OMj77jIxWjAN9kU6Wv93G6I6DUr8CSgq3k/DbErz9
	 +Sc3YqGgnUbSwOnXQELuISu2sZ82pgpCu8LMJU4tdssh3FczSuzwJdiH27eIPXusPp
	 Rziln8WutVv9lpPjLc4ZIcIjCj6Ko4WwkVMo1TteiYe/FjTjqfF2L47CmLeaMQpc1P
	 8Jln52QpRAL6Q==
Message-ID: <ffb3b09b-7575-4e5a-ad98-022801346fa8@kernel.org>
Date: Thu, 19 Nov 2026 08:26:09 +0100
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
Subject: Re: [PATCH 7.3 0865/2651] perf annotate-data: Resolve type DIEs in
 the debug file they came from
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150318.997111678@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261118150318.997111678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18. 11. 26, 15:35, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> [ Upstream commit 14ca0a28de37849afdda6ffd4c9047f58d8906c2 ]

This does not build either:

> --- a/tools/perf/util/annotate-data.c
> +++ b/tools/perf/util/annotate-data.c
...
> @@ -778,12 +782,14 @@ static void global_var__collect(struct data_loc_info *dloc)
>   			if (pos->reg != -1)
>   				continue;
>   
> -			if (!dwarf_offdie(dwarf, pos->die_off, &type_die))
> +			if (!die_get_type_die(dwarf, pos->die_off, pos->die_tag,

util/annotate-data.c:785:30: error: implicit declaration of function 
‘die_get_type_die’; did you mean ‘die_get_typename’? 
[-Wimplicit-function-declaration]

> +					      pos->from_alt, &type_die))
>   				continue;
>   
>   			get_global_var_info(dloc, pos->addr, &var_name, &var_offset);
>   
> -			global_var__add(dloc, pos->addr, var_name, &type_die);
> +			global_var__add(dloc, pos->addr, var_name, &type_die,
> +					pos->from_alt);
>   		}
>   
>   		delete_var_types(var_types);



-- 
js
suse labs

