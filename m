Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E170122AE65
	for <patches@lists.linux.dev>; Mon, 13 Jan 2025 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736771894; cv=none; b=iboJR0UY1YY2OcPjjP2jjJuvl95uObXRQbaNeoLO2MCl+JvCRRbCQnwYolfuzTIDqsKHszLkE01Jfw2j6SPJUrzWxGXuiLuh8+1BQoWkJRtkyVRcr7Tjli6Pb7Gx+WuBeKoG0FA2NwM/Tkwyz95/QhUY/BMgVvs3uxoCwtxQuqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736771894; c=relaxed/simple;
	bh=SoyAfk6H80s16ml/wFRyRtoTVekP6uGYgQVIOJfPrA8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SYKd8qEiMGqtDAiZtxMtrB10Kw/86+LBv7lwHQGwSzKwmoTrpDgzsKfWSv3ulLoH6pZt01SqUrFM6trenf+Ntu1PftBBHOK20gdiwADmldiqbOuhDqpa3cf3MYXchscQ4vDjudlowE3eQA8jk4wAfksx0j5Knp8xW49uQNOhC3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E8tlZAGh; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8tlZAGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736771893; x=1768307893;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=SoyAfk6H80s16ml/wFRyRtoTVekP6uGYgQVIOJfPrA8=;
  b=E8tlZAGh6FkOifTEzs6NssZxVZM+kVHZ61t6PxpLZlpvP+/gpU570TPg
   a6jU0dGvzk9FzchmdRou2inVYbNKbw5VssK5agP/QtAm6gmwbYO/f/cZx
   6msagTjPLMM/rXESAoad1MWdmb4ZGnxJe2jA5yOXWYrJHwI/UFMLlaUKi
   b7rUcezUXPNsWrYfqIfdOLKtZDykOXoZdmipAcsoZo/XAddvc8MsHLtQo
   6cI8qTrKB1qFTUPbfZtz9/rPfqkdRHjqD2IE1ma5sbvbBsiqGZuup5Sv1
   2OsZsLFLyoVvT0C9pWBPBQFQD/wTUB97tzIXrbNwuMEOz9U8v/oA/tiTg
   w==;
X-CSE-ConnectionGUID: lyl7oYM+QJS9r7O2cXeScQ==
X-CSE-MsgGUID: OGYbnKJBQLa633pawfOlmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="47608310"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="47608310"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 04:38:12 -0800
X-CSE-ConnectionGUID: roRnDMGcRP2ip8o05MSGMw==
X-CSE-MsgGUID: v0pBQv8LQR2divxzr90rQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104551210"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.145])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 04:38:03 -0800
From: Jani Nikula <jani.nikula@intel.com>
To: Neal Gompa <neal@gompa.dev>, Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, Masahiro
 Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
 tech-board@groups.linuxfoundation.org, Steven Rostedt
 <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linus
 Torvalds <torvalds@linux-foundation.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference
 between Acked-by and Reviewed-by
In-Reply-To: <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
Date: Mon, 13 Jan 2025 14:38:00 +0200
Message-ID: <87ikqij3dj.fsf@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Jan 2025, Neal Gompa <neal@gompa.dev> wrote:
> On Sun, Jan 12, 2025 at 10:30=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> =
wrote:
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
>> diff --git a/Documentation/process/submitting-patches.rst b/Documentatio=
n/process/submitting-patches.rst
>> index c7a28af235f7..7b0ac7370cb1 100644
>> --- a/Documentation/process/submitting-patches.rst
>> +++ b/Documentation/process/submitting-patches.rst
>> @@ -480,6 +480,12 @@ mergers will sometimes manually convert an acker's =
"yep, looks good to me"
>>  into an Acked-by: (but note that it is usually better to ask for an
>>  explicit ack).
>>
>> +Acked-by: is also less formal than Reviewed-by:.  For instance, maintai=
ners may
>> +use it to signify that they are OK with a patch landing, but they may n=
ot have
>> +reviewed it as thoroughly as if a Reviewed-by: was provided.  Similarly=
, a key
>> +user may not have carried out a technical review of the patch, yet they=
 may be
>> +satisfied with the general approach, the feature or the user-facing int=
erface.
>> +
>>  Acked-by: does not necessarily indicate acknowledgement of the entire p=
atch.
>>  For example, if a patch affects multiple subsystems and has an Acked-by=
: from
>>  one subsystem maintainer then this usually indicates acknowledgement of=
 just
>> --
>> 2.48.0
>>
>
> This doesn't make sense as a distinction. What defines "thoroughly"?
> To be honest, I think you should go the other way and become okay with
> people sending Reviewed-by tags when people have looked over a patch
> and consider it good to land.
>
> To me, Acked-by mostly makes sense as a tag for people who *won't*
> review the code, not for those who *will*. Blending Acked-by and
> Reviewed-by just creates confusion.

As a maintainer, I mostly use Acked-by for two slightly different cases:

1) I've seen the patch. I have no objections to it being merged, I
   approve of it. I haven't done a detailed review of it. Additionally,
   I may indicate whether a detailed review (by someone else) is
   required, or whether I think the ack is sufficient for merging.

2) I'm fine with the patch to the area I maintain being merged via some
   other maintainers' repositories. I may or may not have also given my
   Reviewed-by in this case, which alone is not an approval to merge via
   other trees.

I think this pretty much aligns with the patch series.


BR,
Jani.

--=20
Jani Nikula, Intel
