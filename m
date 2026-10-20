Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482292;
	b=OF7x2J/ei+DU/vNOlYOJ9dW5n/PGrQh0re61WMQ3nhc0TDT+MyVZcw4PGa/lXEpRnbKz
	 E4tEEz8AwJ975rQXE3HsWkRI4RUwr8DxYY7dWOh8wWaOJp0wr8kHUHVfqgg8EZEFb4Nr8
	 Os9K6d6qS35KPCkVJ4cKgdHbfrQXlm/Ef4cRyoBK8Ryeew1c+d12dhDsgSq0GmJ8w1tSf
	 GkLj+VRFHqF6lidDVMpNjwfCbJm6ViwL/icpKE75Uif/enC+8V6j4OQhVFyqKj4kyxIi9
	 U2HFY+9mrU0ZYbBkYZHGux7fO/mfToPXswxEJClWLzUV7coXdilIBK7/mPjfd/LvbwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482292;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=a2h4Z8ZzXdSSz8n/vvfe+ikwa6GSH3/gQBGbU1tp0HI=;
	b=iHNCMUTKIPRsXRegYyO/fPU7mqfPAqp+WlILLMbt9MvDbJCvqJAX+MVyGcBR30kZo+bC
	 Q1prJJXwNL1z4FSUyd+sAfsm+ylornqnfS29s2wfWwbLWma1RD4zQ7s4UfiFg/uWhAmjn
	 Rs2TmTUlbbwTinwgB1ETyQ4ndvGJXa+DRhOI9/TiR1pZJy6GH/4vkDNCcthqtdtxVC+G4
	 SbA8DhBEk9zf8TQUEcl5m4AhRUi72OdWfJEeP+ygmY9dcgw0ovPYDgEgzZ9LdXxg5b/7r
	 QhHW1hSs867W6LeO9dilsaKePZDZUmNS5ZfGd6yMt4rN1z2hkwbtd4HKZphbGQA/Ufw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EklBsvsw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FBC606A319;
	Tue, 20 Oct 2026 07:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EklBsvsw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675571F000C6;
	Tue, 20 Oct 2026 07:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792482291;
	bh=a2h4Z8ZzXdSSz8n/vvfe+ikwa6GSH3/gQBGbU1tp0HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EklBsvsw5Cl4Jq/7zKwAC+m4ZxQplkvjIh3Vc8hPfFwZiZoP3MqTTow29XDx3q43C
	 xCq1YDffdyqJyPQv3/uCC2ZZCheOkXyGanJh8Hz6ldIRpE+MkO7sLMpq7QvQITP2eH
	 Nx2QK//Jz/mrHKFyo68VPGXNK9F5BqkImuSruQhw=
Date: Tue, 20 Oct 2026 09:44:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 212/869] mptcp: move the whole rx path under msk
 socket lock protection
Message-ID: <2026102011-numbing-campsite-8856@gregkh>
References: <20261017160036.979869304@linuxfoundation.org>
 <20261017160042.490038561@linuxfoundation.org>
 <0c1f23e0-3574-4582-a271-59a6ec86ad81@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c1f23e0-3574-4582-a271-59a6ec86ad81@kernel.org>

On Mon, Oct 19, 2026 at 08:35:51PM +0200, Matthieu Baerts wrote:
> Hi Greg, Sasha,
> 
> On 17/10/2026 17:50, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> I do!
> 
> > From: Paolo Abeni <pabeni@redhat.com>
> > 
> > [ Upstream commit bc68b0efa1bf923cef1294a631d8e7416c7e06e4 ]
> 
> It looks like this commit is causing troubles when running the MPTCP
> selftests:
> 
> https://github.com/multipath-tcp/mptcp_net-next/actions/runs/39279118402#summary-118153494823
> 
> not ok 1 test: selftest_mptcp_connect # FAIL
> not ok 1 test: selftest_mptcp_connect_checksum # FAIL
> not ok 1 test: selftest_mptcp_connect_sendfile # FAIL
> 
> Is it possible to drop it, please?
> 
> I guess a few other patches are linked to that one:
> 
>  - mptcp: cleanup mem accounting
>  - mptcp: leverage skb deferral free
>  - mptcp: add eat_recv_skb helper
>  - mptcp: fix soft lockup in mptcp_recvmsg()

Thanks, I'll go drop all of these now, and push out a -rc2.

greg k-h
