Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914A61CAA61;
	Mon, 13 Jan 2025 11:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736768931; cv=none; b=IVZaNit0SFgcz17lNpSSTp8fuEheyiNV04Z9qvzX0ZzI89XHxlav/q4ZtX7ksMGSyqzRyRiYi1kMwD918EX8XfOd6RboJeOro0lOLPaqsWd2VSe8R+UjrCODqFOu192xncnwmSjm5p5Jzit5/ABKGnv7mzbzhGm7nMrH+rWq3+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736768931; c=relaxed/simple;
	bh=utDGhzB1ePx5WwK/+vy7RmdNe9P1VCxIJTtXnUkW5dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=py3NIc0tgO/cbUoBQ9f3jBH12EAFTE8wnGDDr0e25vO0jJyRqldqBhNeCKkAU+290HyHVpzjjcPfCUIymbppDhEf2QvR3bZSdlrXUjqLbvsQnJi9ZMrguRGdXWwnauQhNscGk7lqCX31lkKpmHqM35P7hqM+m/YroEXfbVVh93E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOVAw+HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOVAw+HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ABBC4CED6;
	Mon, 13 Jan 2025 11:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736768931;
	bh=utDGhzB1ePx5WwK/+vy7RmdNe9P1VCxIJTtXnUkW5dM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rOVAw+HWkYqxqKQLs31P+TTsmdHLTcWBqx/0cBhkKkOsGmlClh5XWzEevyliAc+L9
	 yDYYOXhTjcvfUmr8c3l96/269/wh6aYbbjB5yREPlUss3Uun9kioqcYw1vGA/NiwKs
	 DMwzk/KT957lQJ1ouUTQ8tJVK2riHVVP1jsaJJ/FPI1OmAMRSiPY7Fa5w06IllIe+5
	 qsgvse4GiN/fYIxEcz1U7XofpMWV/yjBHtwff3ZwRcYrcY50pRtO3LDtw/5nKLZgiN
	 BO+JOQCFyDgZwAxao1R26wuKcVsCxiYg0batmOxyxa2/DmhONK7lv8kLzz3a+7RG9C
	 jP3o45MOmed9A==
Message-ID: <8c9a692b-aebf-425a-b267-6bcaef025cb6@kernel.org>
Date: Mon, 13 Jan 2025 12:48:42 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
To: Neal Gompa <neal@gompa.dev>, Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>,
 Masahiro Yamada <masahiroy@kernel.org>, Luis Chamberlain
 <mcgrof@kernel.org>, tech-board@groups.linuxfoundation.org,
 Steven Rostedt <rostedt@goodmis.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong"
 <djwong@kernel.org>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/01/2025 16:50, Neal Gompa wrote:
> On Sun, Jan 12, 2025 at 10:30 AM Miguel Ojeda <ojeda@kernel.org> wrote:
>>
>> Newcomers to the kernel need to learn the different tags that are
>> used in commit messages and when to apply them. Acked-by is sometimes
>> misunderstood, since the documentation did not really clarify (up to
>> the previous commit) when it should be used, especially compared to
>> Reviewed-by.
>>
>> The previous commit already clarified who the usual providers of Acked-by
>> tags are, with examples. Thus provide a clarification paragraph for
>> the comparison with Reviewed-by, and give a couple examples reusing the
>> cases given above, in the previous commit.
>>
>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>> ---
>>  Documentation/process/submitting-patches.rst | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
>> index c7a28af235f7..7b0ac7370cb1 100644
>> --- a/Documentation/process/submitting-patches.rst
>> +++ b/Documentation/process/submitting-patches.rst
>> @@ -480,6 +480,12 @@ mergers will sometimes manually convert an acker's "yep, looks good to me"
>>  into an Acked-by: (but note that it is usually better to ask for an
>>  explicit ack).
>>
>> +Acked-by: is also less formal than Reviewed-by:.  For instance, maintainers may
>> +use it to signify that they are OK with a patch landing, but they may not have
>> +reviewed it as thoroughly as if a Reviewed-by: was provided.  Similarly, a key
>> +user may not have carried out a technical review of the patch, yet they may be
>> +satisfied with the general approach, the feature or the user-facing interface.
>> +
>>  Acked-by: does not necessarily indicate acknowledgement of the entire patch.
>>  For example, if a patch affects multiple subsystems and has an Acked-by: from
>>  one subsystem maintainer then this usually indicates acknowledgement of just
>> --
>> 2.48.0
>>
> 
> This doesn't make sense as a distinction. What defines "thoroughly"?

IMO, reviewers statement of oversight. One should not give reviewed-by
tags, if one does not agree fully with the statement.

> To be honest, I think you should go the other way and become okay with
> people sending Reviewed-by tags when people have looked over a patch
> and consider it good to land.

No, that dilutes the review. There always was Ack for such cases.

Best regards,
Krzysztof

