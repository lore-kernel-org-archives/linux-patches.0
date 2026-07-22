Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67C03033E3;
	Wed, 22 Jul 2026 05:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784697948; cv=none; b=ZV4eGQnHYQOjeME0k4vlrlNjiosCn0k1VzaBrEqAM+Vk3wwfTQ0jSLbqwLwDnq/ibKkBYmjEhv151+JWsLTUSWwJmuuraLFxCLNgOdU4ybWS0P1dQyFrGcnDfVLXh9dYFp1ggKMU2/uGdZyHxOsrQcrkn1OmMyJLG3V+fYgauho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784697948; c=relaxed/simple;
	bh=J86q65CdsLcXNptGSNgmSlKsxcY/3gb+MNfXzmfFtro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHl8ND7QukaooQHb6Er71i2aLwNbTbCOtIQ3MvcuuZQnrN9Bb8ASvD2JZkCy6D1zz3S4+nBN7oQv1/0Oj3o+AaWN6IWbjddnpVsh3vAdlUV6lSGUIwWTLbqJa7E0BnhQyORn8zoyFzyvGXvvFX3wWUZDtu+UXHgBBSzVJRj1Hdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjLxEvAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjLxEvAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1948F1F00A3A;
	Wed, 22 Jul 2026 05:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784697946;
	bh=6ToBPMmW6Ht7ni8Y4VWzcOobkzwmcQp323M62S7eUpc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JjLxEvAk4Vm+N2ID5eMnhsqAGzi0d2mj7Z94R/IiujoMGFgRwPM5RLFz65iy/tqu4
	 6qW6TT8GvKjwp1dxHhsYSpErU5D55PqpflueAfTbSOgJm5i3tROkt88m1LDDyzQmzA
	 QWFxWHjRKOCLONHj1JwtH8xkQbecEjyaoBtCIaCnVOOCmV9j6BxAxR5d0A1S9Efq6r
	 zEP8lqjcoQeAv1uJmyLCWFSJWoFSHdI+zH099wKUVvDhMtTTiaftD09DyfSR2vsDrT
	 V/0lhl9Iot2nl8OQxe5PcUdHV4NwpoQ3jDmuCSLiLoLdBIbvIcyj2tfuJ2OpznC9ob
	 npecYmqM68KSg==
Message-ID: <37827f3f-a0e6-4841-b54e-5784d5a8a705@kernel.org>
Date: Wed, 22 Jul 2026 07:25:43 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0931/2077] perf sched: Replace BUG_ON on invalid CPU
 with graceful skip
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Ian Rogers <irogers@google.com>,
 Arnaldo Carvalho de Melo <acme@redhat.com>, Sasha Levin <sashal@kernel.org>,
 sashiko-bot@kernel.org
References: <20260721152552.646164743@linuxfoundation.org>
 <20260721152614.777381844@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20260721152614.777381844@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21. 07. 26, 17:10, Greg Kroah-Hartman wrote:
> 7.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> [ Upstream commit 1e2c83f732deb329ebce23e26cbc482f4c4bf194 ]
> 
> latency_switch_event(), latency_runtime_event(), and map_switch_event()
> use BUG_ON(cpu >= MAX_CPUS || cpu < 0) to validate the sample CPU.
> When PERF_SAMPLE_CPU is absent from the sample type,
> evsel__parse_sample() initializes sample->cpu to (u32)-1.  Casting
> this to int yields -1, which triggers the BUG_ON and aborts perf sched.
> 
> The central CPU validation in perf_session__deliver_event() intentionally
> preserves the (u32)-1 sentinel for downstream tools like perf script
> and perf inject, so leaf callbacks must handle it themselves.
> 
> Replace the three BUG_ON calls with graceful skips using pr_warning(),
> matching the existing pattern in process_sched_switch_event() and
> process_sched_runtime_event() earlier in the same file.  Include the
> file offset for cross-referencing with perf report -D.
> 
> Reported-by: sashiko-bot@kernel.org # Running on a local machine
> Reviewed-by: Ian Rogers <irogers@google.com>
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Stable-dep-of: 8cbca8a480e1 ("perf sched: Fix NULL dereference in latency_runtime_event")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   tools/perf/builtin-sched.c | 22 +++++++++++++++++++---
>   1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index c6a96d0dd77d94..adff5d40a15c95 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -1147,7 +1147,12 @@ static int latency_switch_event(struct perf_sched *sched,
>   	int cpu = sample->cpu, err = -1;
>   	s64 delta;
>   
> -	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
> +	/* perf.data is untrusted input — CPU may be absent or corrupted */
> +	if (cpu >= MAX_CPUS || cpu < 0) {
> +		pr_warning("WARNING: at offset %#" PRIx64 ": out-of-bound sample CPU %d, skipping sample\n",
> +			   sample->file_offset, cpu);

This needs:
7a490187f22b perf sample: Add file_offset field to struct perf_sample

-- 
js
suse labs

