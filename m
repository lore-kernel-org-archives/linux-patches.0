Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7807340DFB3
	for <patches@lists.linux.dev>; Wed,  6 May 2026 01:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778032070; cv=none; b=MuI02dKSZXyU0KNg0Q1TpkewuIe5oK8HgGjI8VUXOEbYYNoZVnl7WMQ2EGxVDTYrHqpdLdzZhKRbwKNICBwxXklkDsxSudsndIrwwxnfcO7bKMGtBBP6pGY2Br/eVLwiG7slV/9+sfkUL4Dl+fH7JIw3WFzVzo1NUygLe2jJJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778032070; c=relaxed/simple;
	bh=kvdHMyUd6HY5+NQcA5vYvtKaKFSt4PICTJ5L/NBuFJ0=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=tgtsiwxCjGWhxVoq7/mgKQUMowq2Y1epFJ1VatAGOa2Qr1YgukR/1eGQWzGed1cIKLmrsNzcPB+VCrg/kwbZXJOPRTndo1MgxD2xWm5MucKafLP1tyQoKwR9KbcR9QnHsCCJQa/DLcjdPuBvaLLog51TYjozXvvntq6QM2zzpvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rRGzpZAY; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rRGzpZAY"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778032066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xNoa+/5rxK6oL7CPWgtRiawwuEPcZV3Ro2C5ThlSBKc=;
	b=rRGzpZAY17+MRtxkHu2mTdfJOa8QVdR/mblVV8XxsniSrCqgaGxdjWf3uF4zd04ZxZesRv
	z71mlxAlsQWuus65rVydG2bjHIzBrn6GBSw2soraNqbHwMjbYBNkNSyq4dVsyb9OF+agny
	qXN43FewaiDFGwkV+Tym4xETGrrgM4w=
Date: Wed, 06 May 2026 01:47:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: gang.yan@linux.dev
Message-ID: <3c8a7577bcdd2cfb50d7a90c4779c8023a6144fb@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 6.18 214/275] mptcp: sync the msk->sndbuf at accept()
 time
To: "Matthieu Baerts" <matttbe@kernel.org>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Gang Yan" <yangang@kylinos.cn>
Cc: patches@lists.linux.dev, "Paolo Abeni" <pabeni@redhat.com>,
 stable@vger.kernel.org, "MPTCP Linux" <mptcp@lists.linux.dev>
In-Reply-To: <68c8f2a7-6149-4b65-bb1b-0ab4cd4067cf@kernel.org>
References: <20260504135142.929052779@linuxfoundation.org>
 <20260504135151.022829547@linuxfoundation.org>
 <1bbeee9b-b69b-4be9-84ee-ddadda4793ef@kernel.org>
 <68c8f2a7-6149-4b65-bb1b-0ab4cd4067cf@kernel.org>
X-Migadu-Flow: FLOW_OUT

May 6, 2026 at 1:50 AM, "Matthieu Baerts" <matttbe@kernel.org mailto:matt=
tbe@kernel.org?to=3D%22Matthieu%20Baerts%22%20%3Cmatttbe%40kernel.org%3E =
> wrote:


>=20
>=20On 05/05/2026 19:16, Matthieu Baerts wrote:
>=20
>=20>=20
>=20> Hi Greg, Gang,
> >=20=20
>=20>  On 04/05/2026 15:52, Greg Kroah-Hartman wrote:
> >=20
>=20> >=20
>=20> > 6.18-stable review patch. If anyone has any objections, please le=
t me know.
> > >=20
>=20>=20=20
>=20>  Please drop this patch, it looks like it is introducing regression=
s on
> >  v6.18:
> >=20
>=20(...)
>=20
>=20>=20
>=20> @Gang: could you eventually have a look, please?
> >=20
>=20FYI, I quickly checked, and I noticed that 'subflow' is different on
> v6.18 due to the "mptcp_for_each_subflow(msk, subflow)" removed in
> 68c7c3867145 ("mptcp: fix memcg accounting for passive sockets").
>=20
>=20Moving __mptcp_propagate_sndbuf() a couple of lines above, before the
> for-loop, should fix the issue. I can eventually look at sending a patc=
h
> with the fix.
>=20
Hi=20Matt,

Thanks for the quick check and fix! Much appreciated.

Cherrs,
Gang
> Cheers,
> Matt
> --=20
>=20Sponsored by the NGI0 Core fund.
>
