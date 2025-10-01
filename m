Received: from e234-55.smtp-out.ap-northeast-1.amazonses.com (e234-55.smtp-out.ap-northeast-1.amazonses.com [23.251.234.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAA32773C2
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759332254; cv=none; b=Qrk6NnN0xwS5ge7AWq1pg0ksEJPGK7mvvsB/IDGl0L4jdHaturiEddUzwBvUMEqYP82Qp1TbPPNS5o6igqx2eUICkxFUV64RzEtow9+Ed92sfhgOyLEUu7e8/xALCGq9XP5+dm59dsegQsF2vfRjgvOghMOqk534KQX2ZnelyNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759332254; c=relaxed/simple;
	bh=6C7qSeatUbSbIjZrcIO6xX5H86QxO7nvz3Snz3AG+I8=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=YFIvog2pIBvNGEG3SH/wXQu4FmTlD8qpPNbcOxpq8KK+Z9q83ilhFJKsgzxIgB4SSygjfHZDXsR1LmNB6OsRArqISj39d9Z6w4Dz6Nh1XNvPCniBG/JL5zsWu4moF1DbW+kNc1bhQ2kIQfB7pZkBb64SWQQdjhjctW01VmRwtrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=T94KSpaE; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=GgRd06SE; arc=none smtp.client-ip=23.251.234.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="T94KSpaE";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="GgRd06SE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1759332249;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=6C7qSeatUbSbIjZrcIO6xX5H86QxO7nvz3Snz3AG+I8=;
	b=T94KSpaEO34L7g/OlnNpYenLUItI4+85bEbV8j6Aano0tGbzLaP4Cd2BzRqK/tdH
	DEmevv7tWx2suVusOmhdP2Ior90UzTW0kQeQyhqFQLL5f+bI2El9k8fHFuNQuwa8xSg
	VQV1PhYoownYFi0S00nz1JXNJmATnEVwQ8OHpIJQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1759332249;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=6C7qSeatUbSbIjZrcIO6xX5H86QxO7nvz3Snz3AG+I8=;
	b=GgRd06SEu9MlRhFlsGnxPsb4qZXCv2P8FWC1ktAC2OcYvI7gimDAeEYabPx58Ckn
	2Vn2Pjo8ah3+JoRy7d8KTNEyC1+Cpi6V1ibkXA6gWCfENh9DI2qcokEUwa7/lZEjMPM
	7IOhhORW1nKABChMUV2dHiCtaWnkipRbOEBxpPlo=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <292570c0-4aca-4e1a-9ac6-70d377909ecf@kernel.org>
From: Kenta Akagi <k@mgml.me>
To: matttbe@kernel.org, gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: patches@lists.linux.dev, martineau@kernel.org, geliang@kernel.org, 
	kuba@kernel.org, sashal@kernel.org
Subject: Re: [PATCH 6.1 54/61] selftests: mptcp: connect: catch IO errors
 on listen side
Message-ID: <01060199a05fae4d-e68e8329-e6a2-4139-8562-6ab61e181711-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 1 Oct 2025 15:24:09 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.10.01-23.251.234.55

Hi,

On 2025/10/01 16:56, Matthieu Baerts wrote:
> Hi Kenta,
>=20
> On 30/09/2025 17:30, Kenta Akagi wrote:
>> Hi,
>>
>> On 2025/09/23 4:29, Greg Kroah-Hartman wrote:
>>> 6.1-stable review =
patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: "Matthieu Baerts (NGI0)" =
<matttbe@kernel.org>
>>>
>>> [ Upstream commit 14e22b43df25dbd4301351b88248=
6ea38892ae4f ]
>>>
>>> IO errors were correctly printed to stderr, and =
propagated up to the
>>> main loop for the server side, but the returned =
value was ignored. As a
>>> consequence, the program for the listener side =
was no longer exiting
>>> with an error code in case of IO issues.
>>>
>>> Because of that, some issues might not have been seen. But very likely,
>>> most issues either had an effect on the client side, or the file
>>> transfer was not the expected one, e.g. the connection got reset before
>>> the end. Still, it is better to fix this.
>>>
>>> The main consequence =
of this issue is the error that was reported by the
>>> selftests: the received and sent files were different, and the MIB
>>> counters were not printed. Also, when such errors happened during the
>>> 'disconnect' tests, the program tried to continue until the timeout.
>>>
>>> Now when an IO error is detected, the program exits directly with =
an
>>> error.
>>>
>>> Fixes: 05be5e273c84 ("selftests: mptcp: add =
disconnect tests")
>>> Cc: stable@vger.kernel.org
>>> Reviewed-by: Mat =
Martineau <martineau@kernel.org>
>>> Reviewed-by: Geliang Tang =
<geliang@kernel.org>
>>> Signed-off-by: Matthieu Baerts (NGI0) =
<matttbe@kernel.org>
>>> Link: https://patch.msgid.link/20250912-net-mptcp-=
fix-sft-connect-v1-2-d40e77cbbf02@kernel.org
>>> Signed-off-by: Jakub =
Kicinski <kuba@kernel.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.=
org>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>  tools/testing/selftests/net/mptcp/mptcp_connect.c |    7 =
++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> --- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
>>> +++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
>>> @@ -1005,6 +1005,7 @@ int main_loop_s(int listensock)
>>>  	struct pollfd polls;
>>>  	socklen_t salen;
>>>  	int remotesock;
>>> +	int err =3D 0;
>>>  	int fd =3D 0;
>>> =20
>>>  again:
>>> @@ -1036,7 +1037,7 @@ again:
>>> =20
>>>  		SOCK_TEST_TCPULP(remotesock=
, 0);
>>> =20
>>> -		copyfd_io(fd, remotesock, 1, true);
>>> +		err =3D copyfd_io(fd, remotesock, 1, true, &winfo);
>>
>> The winfo in function main_loop_s was added in
>> commit ca7ae8916043 =
("selftests: mptcp: mptfo Initiator/Listener")
>> but not present in v6.1.y=
.
>> As a result, mptcp selftests will fail to compile from v6.1.154.
>> I'm not sure whether I should send a revert patch, a patch that removes =
&winfo,
>> or ask for the prereq patch to be applied. So, I'm reporting it =
for now.
>=20
> Thank you for reporting the error!
>=20
> I think the best is a patch removing "&winfo": the goal of 14e22b43df25
> ("selftests: mptcp: connect: catch IO errors on listen side") is to stop
> in case of errors with copyfd_io(). No need to add commit ca7ae8916043
> ("selftests: mptcp: mptfo Initiator/Listener") as prereq.
>=20
> Do you plan to send such patch for v6.1, or do you prefer if I do it?

Thank you for checking.
I'll send PATCH for v6.1.y.


> Cheers,
> Matt
> --=20
> Sponsored by the NGI0 Core fund.
>=20
>=20

