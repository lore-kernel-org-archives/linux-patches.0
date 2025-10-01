Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736A622B594;
	Wed,  1 Oct 2025 07:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759305382; cv=none; b=ruO6xzYV4YRptXHy1kFzmm5+YU2ukZPMkgMbKGQyOEkCE7YapDkH1lzz3wXe2jGaGJAecfSGf7bVPODaMNykLj8CUAGk6OywkhjsKvRa6LtcwLC3wm8eLhviF2k/1lkymIpbHRfabZq7vJNzWsoPrOHfdRwPMLS0rvRZmjElCas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759305382; c=relaxed/simple;
	bh=0Xbf6WiI+k8kDkwTVcaVWERAHnUbuj59jlP3WyJSKwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bA20BaYrV1TRARyLoTmHNh9PzDs5CscR58gDe3ht+vQCSLRVVphYFPcP7SLM+bgV0BbrJQzYe6XG/YBaak7FS5DJnolak5i0S09/fkSLQbiBDF8avRq4VI89bjfCfI0CaoIZ+CbijUXf1ns0tZ5YvKKFQ50iAQSn7kOEufLgpkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nmLqaY8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nmLqaY8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556D1C4CEF4;
	Wed,  1 Oct 2025 07:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759305381;
	bh=0Xbf6WiI+k8kDkwTVcaVWERAHnUbuj59jlP3WyJSKwU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nmLqaY8sDF8OOR3jb9q9JnlRBYxzl9P0+TS0qGdWeKEkbM/eoT1kFLD5Rl5HBxdNf
	 L9BdrLwWKsYD06MMWtCXzEWOS5MCIc6jsu4rCtPv7RD6TEifuOrmWfS5mbHEcTZLJT
	 h4bnDPpuvPLFmQQ7mo3B2hgnCPKH6IHHesyeAoS4/f0soht1DBIGiscDPo2ivzPiIO
	 NUKpEVZOpw+Ru3lKNeXqQoXLBNFhuwXlKkYB1I6j/mG8ZVnAaMOrwkS/h6rdcEs8AU
	 VI5CUEeqSdP89I81fGCwc3mX+UTJkCB/vLZMmWezdUe9NzJTnuGQBooui3XDqXyJuE
	 dIzR/8rF6rrSA==
Message-ID: <292570c0-4aca-4e1a-9ac6-70d377909ecf@kernel.org>
Date: Wed, 1 Oct 2025 09:56:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.1 54/61] selftests: mptcp: connect: catch IO errors on
 listen side
Content-Language: en-GB, fr-BE
To: Kenta Akagi <k@mgml.me>, gregkh@linuxfoundation.org,
 stable@vger.kernel.org
Cc: patches@lists.linux.dev, martineau@kernel.org, geliang@kernel.org,
 kuba@kernel.org, sashal@kernel.org
References: <010601999b3f8615-c141c142-950c-4eae-8e3f-1fdd001c4568-000000@ap-northeast-1.amazonses.com>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <010601999b3f8615-c141c142-950c-4eae-8e3f-1fdd001c4568-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Kenta,

On 30/09/2025 17:30, Kenta Akagi wrote:
> Hi,
> 
> On 2025/09/23 4:29, Greg Kroah-Hartman wrote:
>> 6.1-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
>>
>> [ Upstream commit 14e22b43df25dbd4301351b882486ea38892ae4f ]
>>
>> IO errors were correctly printed to stderr, and propagated up to the
>> main loop for the server side, but the returned value was ignored. As a
>> consequence, the program for the listener side was no longer exiting
>> with an error code in case of IO issues.
>>
>> Because of that, some issues might not have been seen. But very likely,
>> most issues either had an effect on the client side, or the file
>> transfer was not the expected one, e.g. the connection got reset before
>> the end. Still, it is better to fix this.
>>
>> The main consequence of this issue is the error that was reported by the
>> selftests: the received and sent files were different, and the MIB
>> counters were not printed. Also, when such errors happened during the
>> 'disconnect' tests, the program tried to continue until the timeout.
>>
>> Now when an IO error is detected, the program exits directly with an
>> error.
>>
>> Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Mat Martineau <martineau@kernel.org>
>> Reviewed-by: Geliang Tang <geliang@kernel.org>
>> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
>> Link: https://patch.msgid.link/20250912-net-mptcp-fix-sft-connect-v1-2-d40e77cbbf02@kernel.org
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  tools/testing/selftests/net/mptcp/mptcp_connect.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> --- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
>> +++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
>> @@ -1005,6 +1005,7 @@ int main_loop_s(int listensock)
>>  	struct pollfd polls;
>>  	socklen_t salen;
>>  	int remotesock;
>> +	int err = 0;
>>  	int fd = 0;
>>  
>>  again:
>> @@ -1036,7 +1037,7 @@ again:
>>  
>>  		SOCK_TEST_TCPULP(remotesock, 0);
>>  
>> -		copyfd_io(fd, remotesock, 1, true);
>> +		err = copyfd_io(fd, remotesock, 1, true, &winfo);
> 
> The winfo in function main_loop_s was added in
> commit ca7ae8916043 ("selftests: mptcp: mptfo Initiator/Listener")
> but not present in v6.1.y.
> As a result, mptcp selftests will fail to compile from v6.1.154.
> I'm not sure whether I should send a revert patch, a patch that removes &winfo,
> or ask for the prereq patch to be applied. So, I'm reporting it for now.

Thank you for reporting the error!

I think the best is a patch removing "&winfo": the goal of 14e22b43df25
("selftests: mptcp: connect: catch IO errors on listen side") is to stop
in case of errors with copyfd_io(). No need to add commit ca7ae8916043
("selftests: mptcp: mptfo Initiator/Listener") as prereq.

Do you plan to send such patch for v6.1, or do you prefer if I do it?

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

