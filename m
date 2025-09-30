Received: from e234-50.smtp-out.ap-northeast-1.amazonses.com (e234-50.smtp-out.ap-northeast-1.amazonses.com [23.251.234.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34156309EEA
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246260; cv=none; b=O57EhsGg1AH8G7pcInJEcuTCO8RDwj9r3XRe/gV4TLTZ1BK17XYAWoLTf/ounTL276uo5Y0KiiK4jn8/67x+S/ewp2DwJDzx39EfYDsIUziNzmj0tAY8iyH8p+0j1kQ/1yWrRRwMwfnjEoQZ8Pxo0tPrkXyepbmyK08byMHI2oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246260; c=relaxed/simple;
	bh=OqIKf+10n+DUzbSqBSShrLfq+/aISAOJp6CxJlqTu/s=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=jjWLdhm5OSOVM+OhIeHKhA1eL8T8/2DN805dxBvYT0M9/YQAQC/R1JY6+f5Lumgh0qAC8pj9ghR68+rdRuzFSjkE2AvPUogF/xwhMbLlmDW4CJtPHCFaKXat4iORyzw/bKfbTy3oMkbSEXKCWT6G3KycCvyVmxM2CcFLiLAjVh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=H1wO/0OU; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=aLMyu2v/; arc=none smtp.client-ip=23.251.234.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="H1wO/0OU";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="aLMyu2v/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1759246255;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=OqIKf+10n+DUzbSqBSShrLfq+/aISAOJp6CxJlqTu/s=;
	b=H1wO/0OUqmz0ZJm5lAxtH71o4g+aKJy0i2iVxTktnFKlaQDhc1YMqHaLO3Yd+zRr
	3CL4snCAtKD1BrMM2gY8GxlCthXOW28EAzCl/pwtAP0yGpHLJWs1ih9ksKQSxnY/Tj2
	GMmjEbm4FlmncE4Bye+27K1Dq35uW3kOu588nKEI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1759246255;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=OqIKf+10n+DUzbSqBSShrLfq+/aISAOJp6CxJlqTu/s=;
	b=aLMyu2v/R8k2LOqQc30o/rSPcv6DdzEzPHecSqOvRNgPzuul5y4Dic0gFOtVOj6j
	qXba3aShuBrTsgp39s64EmULavGtE4XhjgeuIqLsmlREOuBLScW336aGw0nBh3QUcZw
	OwtecyrI45Gcwspsq1R5A+rH6eofpBzAivd3w3R0=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <20250922192405.116510779@linuxfoundation.org>
From: Kenta Akagi <k@mgml.me>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: patches@lists.linux.dev, martineau@kernel.org, geliang@kernel.org, 
	matttbe@kernel.org, kuba@kernel.org, sashal@kernel.org
Subject: Re: [PATCH 6.1 54/61] selftests: mptcp: connect: catch IO errors
 on listen side
Message-ID: <010601999b3f8615-c141c142-950c-4eae-8e3f-1fdd001c4568-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Sep 2025 15:30:55 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.09.30-23.251.234.50

Hi,

On 2025/09/23 4:29, Greg Kroah-Hartman wrote:
> 6.1-stable review =
patch.  If anyone has any objections, please let me know.
>=20
> ------------------
>=20
> From: "Matthieu Baerts (NGI0)" <matttbe@kernel.=
org>
>=20
> [ Upstream commit 14e22b43df25dbd4301351b882486ea38892ae4f ]
>=20
> IO errors were correctly printed to stderr, and propagated up to the
> main loop for the server side, but the returned value was ignored. As a
> consequence, the program for the listener side was no longer exiting
> with an error code in case of IO issues.
>=20
> Because of that, some =
issues might not have been seen. But very likely,
> most issues either had =
an effect on the client side, or the file
> transfer was not the expected =
one, e.g. the connection got reset before
> the end. Still, it is better to=
 fix this.
>=20
> The main consequence of this issue is the error that was =
reported by the
> selftests: the received and sent files were different, =
and the MIB
> counters were not printed. Also, when such errors happened =
during the
> 'disconnect' tests, the program tried to continue until the =
timeout.
>=20
> Now when an IO error is detected, the program exits =
directly with an
> error.
>=20
> Fixes: 05be5e273c84 ("selftests: mptcp: =
add disconnect tests")
> Cc: stable@vger.kernel.org
> Reviewed-by: Mat Martineau <martineau@kernel.org>
> Reviewed-by: Geliang Tang <geliang@kernel.org>
> Signed-off-by: Matthieu =
Baerts (NGI0) <matttbe@kernel.org>
> Link: https://patch.msgid.=
link/20250912-net-mptcp-fix-sft-connect-v1-2-d40e77cbbf02@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha =
Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman =
<gregkh@linuxfoundation.org>
> ---
>  tools/testing/selftests/net/mptcp/mpt=
cp_connect.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 =
deletions(-)
>=20
> --- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
> +++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
> @@ -1005,6 +1005,7 @@ int main_loop_s(int listensock)
>  	struct pollfd polls;
>  	socklen_t salen;
>  	int remotesock;
> +	int err =3D 0;
>  	int fd =3D 0;
> =20
>  again:
> @@ -1036,7 +1037,7 @@ again:
> =20
>  		SOCK_TEST_TCPULP(remotesock, 0);
> =20
> -		copyfd_io(fd, remotesock, 1, true);
> +		err =3D copyfd_io(fd, =
remotesock, 1, true, &winfo);

The winfo in function main_loop_s was added =
in
commit ca7ae8916043 ("selftests: mptcp: mptfo Initiator/Listener")
but not present in v6.1.y.
As a result, mptcp selftests will fail to =
compile from v6.1.154.
I'm not sure whether I should send a revert patch, a=
 patch that removes &winfo,
or ask for the prereq patch to be applied. So, =
I'm reporting it for now.

mptcp_connect.c: In function =
=E2=80=98main_loop_s=E2=80=99:
mptcp_connect.c:1040:59: error: =
=E2=80=98winfo=E2=80=99 undeclared (first use in this function)
 1040 |                 err =3D copyfd_io(fd, remotesock, 1, true, &winfo);
      |                                                           ^~~~~
mptcp_connect.c:1040:59: note: each undeclared identifier is reported only =
once for each function it appears in
mptcp_connect.c:1040:23: error: too =
many arguments to function =E2=80=98copyfd_io=E2=80=99; expected 4, have 5
 1040 |                 err =3D copyfd_io(fd, remotesock, 1, true, &winfo);
      |                       ^~~~~~~~~                          ~~~~~~
mptcp_connect.c:845:12: note: declared here
  845 | static int =
copyfd_io(int infd, int peerfd, int outfd, bool close_peerfd)
      |            ^~~~~~~~~

Thanks,
Akagi

>  	} else {
>  		perror("accept");
>  		return 1;
> @@ -1045,10 +1046,10 @@ again:
>  	if (cfg_input)
>  		close(fd);
> =20
> -	if (--cfg_repeat > 0)
> +	if (!err && --cfg_repeat > 0)
>  		goto again;
> =20
> -	return 0;
> +	return err;
>  }
> =20
>  static void init_rng(void)
>=20
>=20
>=20
>=20

