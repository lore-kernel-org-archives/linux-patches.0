Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1292C21E8;
	Wed, 22 Jul 2026 05:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784698047; cv=none; b=j1iMLkKq2BMb2DEQNdiTzdOeMAU5EGR4fM0b/nm8IP2UYXMhTTfQUVCQ+reqw2Fn31FesJ9io2h3Sm/Sv5ZdilIkv9XQlzqW+7CjT+syFNZap0kVBw45qLA7kGPAKVExQM0h72rgpii3cgz8kQXjvI+mRnHexITiCCda+cZskBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784698047; c=relaxed/simple;
	bh=3FQ7lC+nAi+rMpvJaH++PbqdU4SOCjMNaTm/mTxtwW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gWfFsjhRXx7yonAEk8kA+lT4G4e8JSWDLev2A0b6kmwKCRDaE5YIBM4GPCwm0hd2LiuR6TOKw1VQfGjX4RaqWaALvAvqfbMsJHm6Lcwu7FGrsmSdnuhxF4ibMdydX4vonCcEP5fhIV5gZLO+h7CEGjjLEq2MMD35L3Fc79FXWXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bR/gVY7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bR/gVY7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C241F000E9;
	Wed, 22 Jul 2026 05:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784698046;
	bh=bqsWK4JCvhuWE6cxo3n0oqtCrdV5meK73xo2cvq/NJ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bR/gVY7Q3IvgLnq5ERmzpQxHRv/v5gVhC0tCIHqv9hvriot8EralI2AxkU6JJZxFz
	 fuhBeDigL7bPhUApjo+rD3pTqfTM7B3Y3P2usoa3z/cUaIvvOnZ3K2/qMSpntxMPWM
	 m3oa0ztiURN/VagFE5PRShaR/lLVcrYiWmjDoge/Gz4xOSEWalEMpY+NoSRpGWX0bu
	 CVnbEQCVoO/aquP4wfPZLutLQyhNxjRl5m2isXkgp/L9tPFOuzT499Uxq4G6QE08N5
	 Hgz1WswOp2HWCCUzdWYG2pxLTX5dWDt3w1vjI8xRI/NlsQBXWFOQLIbokvsDNvKVOo
	 HcNDYSxSl3jeA==
Message-ID: <f71375d0-a863-4704-af03-a2bba5a9e85e@kernel.org>
Date: Wed, 22 Jul 2026 07:27:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0837/2077] perf libdw: Fix libdw API contract
 violations and memory leaks
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@redhat.com>,
 James Clark <james.clark@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Zecheng Li <zli94@ncsu.edu>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152612.529845867@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260721152612.529845867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21. 07. 26, 17:08, Greg Kroah-Hartman wrote:
> 7.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ian Rogers <irogers@google.com>
> 
> [ Upstream commit 9c6d535ddb794fb540c3b142ab1d7416d469c1de ]


> @@ -162,11 +181,29 @@ int libdw__addr2line(u64 addr, char **file, unsigned int *line_nr,
>   			.leaf_srcline = srcline_from_fileline(src ?: "<unknown>", lineno),
>   		};
>   
> +		if (!args.leaf_srcline) {
> +			if (file && *file) {
> +				free(*file);
> +				*file = NULL;
> +			}
> +			return 0;
> +		}
> +
>   		/* Walk from the parent down to the leaf. */
> -		cu_walk_functions_at(cudie, addr, libdw_a2l_cb, &args);
> +		if (cudie)
> +			cu_walk_functions_at(cudie, addr, libdw_a2l_cb, &args);
>   
>   		if (!args.leaf_srcline_used)
>   			free(args.leaf_srcline);
> +
> +		if (args.err) {
> +			if (file && *file) {
> +				free(*file);
> +				*file = NULL;
> +			}
> +			inline_node__clear_frames(node);

This one needs:
674dea094ef6 perf srcline: Introduce inline_node__clear_frames()

-- 
js
suse labs

