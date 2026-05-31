Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4A8248B;
	Sun, 31 May 2026 04:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780203238; cv=none; b=YwaKF15Gg2JlX9nK/8ZfPUoNui+QrIVli8j7FFjzH7YBCSW156XC438gPFHlJkj0dokVpLcO5TwxAeux4Of8vRa7QFr8JATUrDGadIU4woUuAegZKkkdcHjSrfpYyivpvLWaPj9ozvTGagfCM/DGpzF90RS58aMUW/m0hiJbRoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780203238; c=relaxed/simple;
	bh=vukg6zkEBCeRat75eY80xfwwQusH0Jtuqltfqbs47i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpzIBIIe6cPTX95jVrkugvqu3wl/laq/qNG/w3g3YIEIIBAwi7OYwQOMUUT+oCP9oIdU+dTMSGtA+EOqTx4NKfDOMS+EG3nQZq7NJu3qZs5y8cIl54wXJODJnVw9Qbj66C4tGDbHF8n/xxWq13GsFb0NX/xwqJ+TBFTglA/qrrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBZ+FgED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBZ+FgED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC5E1F00893;
	Sun, 31 May 2026 04:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780203237;
	bh=vUuUkxwwEBS0oY6KW2ODS8yD/z/8/qNRxVwCoqJAHAU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GBZ+FgED5GuCZqZfRmteD1GSo2YjdOnhX/7MNKctbfKukiPPCj9Y/xon+kOsYw0Iu
	 SQLFjL09sJmrBbBEid8YyI6u6stMLCpHiviZoYeO7hzMji2NxFemL+Iqq7A6xGX+Je
	 3KryRJF7TTj4vUbnzyD7p+TQC4jwoixVqIvC+e7HEfk71YbfEIlZuHynz3KygLoJ40
	 CzguybW3x40IbXczu0nC2YbA5JyQ6VdWNW+u13rAceFx3SpgGY6uVvehJDDKR0dN4i
	 1GCt84YRMz2rfu4q8aGI4d4KEmFaoneskE2G1J5GZ5THN7LgWHMPYieIKd0HPi3fSo
	 ZJ9mi3drHsEpw==
Message-ID: <b59b3ff3-1279-4cee-a5d2-aa4c5a7016b8@kernel.org>
Date: Sun, 31 May 2026 14:53:51 +1000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.6 113/186] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, stable@vger.kernel.org
References: <20260528194928.941004471@linuxfoundation.org>
 <20260528194931.993505304@linuxfoundation.org>
From: Matthieu Baerts <matttbe@kernel.org>
Content-Language: fr
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20260528194931.993505304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Greg, Sasha,

On 29/05/2026 05:49, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 9fce66583f06c212e95e4b76dd61d8432ffa56b6 ]
> 
> The seqcount xt_recseq is used to synchronize the replacement of
> xt_table::private in xt_replace_table() against all readers such as
> ipt_do_table()
> 
> To ensure that there is only one writer, the writing side disables
> bottom halves. The sequence counter can be acquired recursively. Only the
> first invocation modifies the sequence counter (signaling that a writer
> is in progress) while the following (recursive) writer does not modify
> the counter.
> The lack of a proper locking mechanism for the sequence counter can lead
> to live lock on PREEMPT_RT if the high prior reader preempts the
> writer. Additionally if the per-CPU lock on PREEMPT_RT is removed from
> local_bh_disable() then there is no synchronisation for the per-CPU
> sequence counter.
> 
> The affected code is "just" the legacy netfilter code which is replaced
> by "netfilter tables". That code can be disabled without sacrificing
> functionality because everything is provided by the newer
> implementation. This will only requires the usage of the "-nft" tools
> instead of the "-legacy" ones.
> The long term plan is to remove the legacy code so lets accelerate the
> progress.
> 
> Relax dependencies on iptables legacy, replace select with depends on,
> this should cause no harm to existing kernel configs and users can still
> toggle IP{6}_NF_IPTABLES_LEGACY in any case.
> Make EBTABLES_LEGACY, IPTABLES_LEGACY and ARPTABLES depend on
> NETFILTER_XTABLES_LEGACY. Hide xt_recseq and its users,
> xt_register_table() and xt_percpu_counter_alloc() behind
> NETFILTER_XTABLES_LEGACY. Let NETFILTER_XTABLES_LEGACY depend on
> !PREEMPT_RT.
> 
> This will break selftest expecing the legacy options enabled and will be
> addressed in a following patch.
It looks like this last sentence is still valid: some net selftests are
broken because the mentioned "following patch" -- commit 3c3ab65f00eb
("selftests: net: Enable legacy netfilter legacy options.") -- has not
been backported in this 6.6 version. Same for v6.1 and v5.15.

Do you mind adding it in v6.6, v6.1 and v5.15, please?

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

