Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795073028;
	b=RkHgnW0727o33q7FzuFyL3HFskmpjuoEwD3Fbs5Bs3xD4njsFKpyEsZ0k8tVgNJ36mRA
	 7Tw/VO0Ecoo+f0c1uovR/ca9GYliff87euVODqlIAVMuqMwSyMPyWUofrZXV2Qzqks3LA
	 0Fuw5wFoyiqB6HN69S+tzkf4p0bmplqcQcaV81T5yjFs9o9lcxqjhDf+D+7edpLRnwxva
	 /0TL6j/AWfgp/8kS7pDDBeaZrB5ef8gstgCeLDGBDufKVYbsugqa6Y6NQWaZUfuAThXiM
	 PtP1glCVuVZpH1gXqPknTDSZKyG7iIf/Hggdtquib8116qHKCtuRr71zn5LdTPwJL8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795073028;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=s1E7amwr2Ec6lhWT6IJc+C+PoDVlMOHKsEuqBzS/k0s=;
	b=j9EDRm3JmlBtKg2SZQ58B1e4sq2GHF17cEzv/fgbOu+UhU/1T30m99tOI3tMqhueYwap
	 GoK1p0tnhGhBLVqNB1InEOOvfNa2EULTwu5ImXTm9rTGFAmXhEVPDQaToHtRXVVNBFzNH
	 gCh5MU4diK2HtQTD4NyzWeNDYRKklMISY39bjnZuZ5bLnE687xXxUbrna3dn/YMIfcu0A
	 62V7ejAvRbdk9CmYjUbSQM5zKjvAMrXs/FJK6CBYSXAk4FY11w3lnUvJtbjxPADQNobc3
	 OMB9yH0nLst0Agb6E8QWXnUmge1Sj8ZtS+xgRzGcuWc1Ko58BHOR/IOI+kPVsheOQLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IyNXhNy/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD5606A320;
	Thu, 19 Nov 2026 07:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IyNXhNy/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1721F000C5;
	Thu, 19 Nov 2026 07:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795073027;
	bh=s1E7amwr2Ec6lhWT6IJc+C+PoDVlMOHKsEuqBzS/k0s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IyNXhNy/v9KLUUKWji3e8YUuhdPEiIe9COxX/6VugvBqzngldqF9xxsZD7Iq75Ojv
	 9i+Ee5gIKM9t4E02yikUh/d6aWCJOt2QrWs0xaXq7BYCm9MkaC6ud/lirwWYiJGu17
	 wku6rZjZMXpRE1wRY33w52k4TLTvB/s8gMWk6UPsNbA4IYkiz4h9FLXJtf4d/UOP9h
	 A7R9Wxcn21nyLF4wIG9dCYRBL5fAHh03zC9CKs3Jufq1Qjf82HsCBvzxtbIJx479G1
	 XVaL1qDVkQPBCsM+rttWOolUBtIzufKIOIz2zgopLGeuGCEpbOsHZ9RBi0K++Aj282
	 CfChWn9F0vSqA==
Message-ID: <a646c127-dab8-481e-b9e5-d6eaa839c2c3@kernel.org>
Date: Thu, 19 Nov 2026 08:23:44 +0100
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
Subject: Re: [PATCH 7.3 0286/2651] perf trace: Enhance BTF type formatting to
 symbolise kernel function pointers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Aaron Tomlin <atomlin@atomlin.com>,
 Ian Rogers <irogers@google.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
 Sasha Levin <sashal@kernel.org>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150258.204483253@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20261118150258.204483253@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18. 11. 26, 15:25, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Aaron Tomlin <atomlin@atomlin.com>
> 
> [ Upstream commit c6dd6161815d0c10ed24ad13fdad847bec63d961 ]

...
This does not build on i386:

> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
...
> @@ -1079,33 +1135,40 @@ static size_t btf_struct_scnprintf(const struct btf_type *type, struct btf *btf,
>   }
>   
>   static size_t trace__btf_scnprintf(struct trace *trace, struct syscall_arg *arg, char *bf,
> -				   size_t size, int val, char *type)
> +				   size_t size, unsigned long val, char *type)
>   {
>   	struct syscall_arg_fmt *arg_fmt = arg->fmt;
>   
>   	if (trace->btf == NULL)
>   		return 0;
>   
> -	if (arg_fmt->type == NULL) {
> -		// Check if this is an enum and if we have the BTF type for it.
> -		syscall_arg_fmt__cache_btf_enum(arg_fmt, trace->btf, type);
> -	}
> +	if (!arg_fmt->btf_type_cached)
> +		syscall_arg_fmt__cache_btf_type(arg_fmt, trace->btf, type);
>   
>   	// Did we manage to find a BTF type for the syscall/tracepoint argument?
>   	if (arg_fmt->type == NULL)
>   		return 0;
>   
> +	if (type && strchr(type, '*')) {
> +		if (btf_is_enum(arg_fmt->type) || btf_is_func_ptr(trace->btf, arg_fmt->type))
> +			return 0;
> +	}
> +
>   	if (btf_is_enum(arg_fmt->type))
>   		return btf_enum_scnprintf(arg_fmt->type, trace->btf, bf, size, val);
>   	else if (btf_is_struct(arg_fmt->type) || btf_is_union(arg_fmt->type))
>   		return btf_struct_scnprintf(arg_fmt->type, trace->btf, bf, size, arg);
> +	else if (btf_is_func_ptr(trace->btf, arg_fmt->type)) {
> +		arg->val = val;
> +		return syscall_arg__scnprintf_ksym(bf, size, arg);

builtin-trace.c:1164:24: error: implicit declaration of function 
‘syscall_arg__scnprintf_ksym’; did you mean 
‘syscall_arg__scnprintf_buf’? [-Wimplicit-function-declaration]

> +	}
>   
>   	return 0;
>   }
>   
>   #else // HAVE_LIBBPF_SUPPORT
>   static size_t trace__btf_scnprintf(struct trace *trace __maybe_unused, struct syscall_arg *arg __maybe_unused,
> -				   char *bf __maybe_unused, size_t size __maybe_unused, int val __maybe_unused,
> +				   char *bf __maybe_unused, size_t size __maybe_unused, unsigned long val __maybe_unused,
>   				   char *type __maybe_unused)
>   {
>   	return 0;
> @@ -2529,7 +2592,8 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
>   
>   			default_scnprintf = sc->arg_fmt[arg.idx].scnprintf;
>   
> -			if (trace->force_btf || default_scnprintf == NULL || default_scnprintf == SCA_PTR) {
> +			if (trace->force_btf || default_scnprintf == NULL ||
> +			    default_scnprintf == SCA_PTR || default_scnprintf == SCA_KSYM) {


builtin-trace.c:2597:82: error: ‘SCA_KSYM’ undeclared (first use in this 
function)

>   				btf_printed = trace__btf_scnprintf(trace, &arg, bf + printed,
>   								   size - printed, val, field->type);
>   				if (btf_printed) {

-- 
js
suse labs

