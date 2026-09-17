Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56B72D7D47
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671400; cv=none; b=W3eK5mNx14W196W/nPZI8NAkDDmDPdrXc8IuBfgrD9qDAokWmR6M1tRUJcuIpj6EPIlTURvw7kJO0AE/wdgaUhmQkzcVvnl+SkgMgnkqbR0tJyteOU+hGtkuWNr1Hlj+O7ZW8E5X125nRqv57j6iyMc5kGgW+7KYWyjtBO3BzM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671400; c=relaxed/simple;
	bh=+yachkDqEvQAiGt5k6YG+uN4h05LsFAbms5v2hp+GiE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=UBdjxnFJUjrDIAGnRWQ17GMxEPw9YbnoYYsZUPGioRxbK2vCgzTjbbxDhahVWDaIYD/T4xjnVpWjCL3muEyDRL60ijy6pNqNUflnLGw3CJqqkrG/l9VPgwAeXFz27gfdca1iILU6hFbXxh2tkoIvGjBK1Ra559hf6izzAR4Hz54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=max06.net; spf=pass smtp.mailfrom=max06.net; dkim=pass (2048-bit key) header.d=max06.net header.i=@max06.net header.b=dF1gRP12; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Zl+MjQK5; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=max06.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=max06.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=max06.net header.i=@max06.net header.b="dF1gRP12";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Zl+MjQK5"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id EE1A21D000C2;
	Thu, 17 Sep 2026 14:56:37 -0400 (EDT)
Received: from phl-imap-09 ([10.202.2.99])
  by phl-compute-03.internal (MEProxy); Thu, 17 Sep 2026 14:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=max06.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789671397;
	 x=1789757797; bh=EdJ8bmXVQpzlXzBcluUqZxbOqlsNo95tMQtAw++mfLw=; b=
	dF1gRP12OLea3M57VySE09JerIMUIT6qjpDyEjUt2eo2epu3WSK8pJH9NgFzRRq7
	jZNXNKkAqD9t07kkIDReK3v1AjbGaSQ1+FiuUp+Krkqqb6MPz+78FGc93ZRY9Tkb
	/6WnSSD0S/N6NSjs8IegMR+smdhOAhe007GzE16lWzx1qArE/eN5dlFgPDlRYZuq
	gX4/i3xz4ik9Dm63y9CFdfkvJJUjh/mCseTIn4iRYeLBcCOv9UOAq7p89HPgKgwC
	9UKgUYkVis+FL66HtUr56KhAt3PHJ80jtAAJBuhu+pixOo2NUHyoY54I9LmlrIax
	+hzoOMvtxNtuyfw9uQzx5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789671397; x=
	1789757797; bh=EdJ8bmXVQpzlXzBcluUqZxbOqlsNo95tMQtAw++mfLw=; b=Z
	l+MjQK5/4nrX/RXcda4dTEgFtIZftaG1CE+9y4gn4113aX3xDKwOWSofOJy0+w4T
	C/FVI5+Cx5sEz82XrDWV4LZGKe8ZFCElPoK40cCfUzGL2wnFadwB97S3XnfxpVHi
	CGGO3sD3n/k7D5QgFKG9ZygMG3U27t/PCrVC993cIX8XB3vdKHec45yMGSz94eFt
	TrsFQxS/ZT7s1sfyxkqAty2ESbmHMyGETugEp1WrCTtv070z5EdIUktRf4Odtl5v
	xoRJoApHkoTtZzQKRbSO6xZzPcY1rYGXUZRxAKOiHdcaQ+YCLWtJNhAozuYS/qLU
	fTBzLVpic04JBcTB+SxWg==
X-ME-Sender: <xms:5TesamIFLnIWP4r4hIgaD5ZToWsMcGTQD80emFkhTFrxY3hgR9gUag>
    <xme:5Tesao8qVcSFCk-LjexvmSmy1eSXHqD_WsgtxOSk2qhgTau0HWGvDB6J8UhvOoOcm
    LsLxbbwg7fBAU1TXo-q_NvUDnON_vlHDOjflVVTXtQTC0pls5d5c3Pv>
X-ME-Proxy-Cause: dmFkZTFAveyLDB4/jUEC1CFzi0gfZzbI+GkkmlhPu2D65aKAvO1Vedfn5968PbgV4zFnFA
    Px8PtEV/kxU4/dFHOW8/ka5J44j/N3AdtHVaPwrs/wVvNV/KU2L7f0QkAcjm9mZbRYRcFc
    bui8tie+564Ate4sdP/Gb0NT2BmX5dUiMOygKgMlPrGfYccFsSgRE9vdIxjSuP/doVcZRm
    1N4pe88lWNbahB2pK8SfIWl/JvA9K60YScZWWrmgxI6CUFFhf5x3oyTcjLPbLj9dPWx8/A
    kqWC70xHNKjjDYIEm7djbGI7QUurUQvlXEamBhYJa0CL2VXi9taOLtlMRjpa2i4zoFGxo7
    uSKrJMdpO0B0MEOc73P9pw4DNuKt0XHF7A/8TdMQIxJYpAY+9bMOCGfjqQUJI517inxYwo
    RbEsI7c0CgYFlpezMO0eMj/G/CBYuHblH+pO3qn+x/Ox+Mq9F5z43n94086/mk0qcMocX5
    5BmX2UVekLnJi8XJKFhCcBKcKKKrVoQzrWbIKTM0O+966nZLt/OFFG2s+B4dcLbstK7wXE
    1l45N+lYuyufol7LmykDpyz9arM1fWVGSS490GL76xodkiXzw46cpXpnGRTHMT5uiDpPIb
    ZNs1OLkFoo4Yu+OGllc40eEHONfSHlYHysojXGAvu6RTy/V4p2KBm0jIcZBw
X-ME-Proxy: <xmx:5Tesassm9wV6ig6vNEjEGYMKxaRCDjeAYXaqI5BstPL325-_7FeckQ>
    <xmx:5TesarAj6JbYJLXzM2Yh-_Nrmp02mCNWMfRH3WntzM7cQHhSgXy5wg>
    <xmx:5TesanDosZ3iECJGxlll8hflDj2PRsgSTM9z0sI3Db58Bw47NpFCQg>
    <xmx:5Tesalpp042kWX1psfOJBlVbINk6BUTClYIcrK9YESKSpQqxnPy79w>
    <xmx:5TesarnpMdi49QSx4jiTAw5p-IofpDOb3FUQWRnvTIMOjjUX-rfXTxAF>
Feedback-ID: i81964b54:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 794B73020081; Thu, 17 Sep 2026 14:56:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: Ah_FbNH1XifB
Date: Thu, 17 Sep 2026 20:56:17 +0200
From: =?UTF-8?Q?Flo_M=C3=BCller?= <flo@max06.net>
To: "Sasha Levin" <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: "Ido Schimmel" <idosch@nvidia.com>, "David Ahern" <dsahern@kernel.org>,
 "Jakub Kicinski" <kuba@kernel.org>, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <6b4dfa7d-09c1-4717-bd4a-5bca2d984139@app.fastmail.com>
In-Reply-To: <20260831133314.4125787-211-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-211-sashal@kernel.org>
Subject: Re: [PATCH AUTOSEL 6.18-5.10] ipv6: Honor oif when choosing nexthop for
 locally generated traffic
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 09:23:59AM -0400, Sasha Levin wrote:
> From: Ido Schimmel <idosch@nvidia.com>
>
> [ Upstream commit d25e7e9d8a6c1e2afb854613e417c6aa1a28ce6f ]
[...]
> **Step 3.5 =E2=80=94 Dependencies**
> Record: Patch 2 is **standalone for classic multipath routes**
> (reproducer in commit message). For **nexthop object** multipath, patch
> 1/3 is also needed so `fib6_table_lookup()` picks the best-scoring
> nexthop before path selection is skipped. Patch 1 not in tree; patch 2
> alone does not worsen nexthop-object behavior.
[...]
> **Recommendation for v6.18.y:** Backport this commit. Ideally backport
> patch 1/3 from the same series together for complete nexthop-object
> multipath coverage; patch 2 alone is still valuable and safe for class=
ic
> multipath routes.

Hi Sasha,

we are the nexthop-object case from your dependency note, hit in
production on 6.12.y, so here is a real-world data point and a request
to carry patch 1/3 along.

(Disclaimer: Analysis below done by AI, watched and confirmed by human)

Setup: Debian 13 host, kernel 6.12.101, dual-homed to two ToR switches
over unnumbered eBGP (FRR). FRR installs the default route through a
nexthop group, which is what every FRR or Cilium dual-homed host looks
like:

  $ ip -6 route show default
  default nhid 20 proto bgp metric 20 pref medium
          nexthop via fe80::<tor-a> dev ens31f0np0 weight 1
          nexthop via fe80::<tor-b> dev ens30f0np0 weight 1
          nexthop via fe80::<tor-a> dev ens31f1np1 weight 1
          nexthop via fe80::<tor-b> dev ens30f1np1 weight 1

The kernel's own lookup ignores the oif for this route, with and
without a source address:

  $ ip -6 route get 2606:4700:4700::1111 oif ens31f1np1
  2606:4700:4700::1111 from :: via fe80::<tor-b> dev ens30f1np1 \
      proto bgp src fd00:2:1::11 metric 20 pref medium
  $ ip -6 route get 2606:4700:4700::1111 oif ens31f1np1 from 2001:db8:a:=
:1
  2606:4700:4700::1111 from 2001:db8:a::1 via fe80::<tor-b> dev ens30f1n=
p1 \
      proto bgp src fd00:2:1::11 metric 20 pref medium

Same for a socket. A test tool sends UDP on an AF_INET6/SOCK_RAW/
IPPROTO_UDP socket with IPV6_HDRINCL and SO_BINDTODEVICE=3Dens31f1np1
(root; the source address is a service address of the host, not the
interface address). The option is accepted and readable back:

  setsockopt(SO_BINDTODEVICE, "ens31f1np1") =3D 0
  getsockopt(SO_BINDTODEVICE) -> "ens31f1np1"

but the frames leave the sibling interface. tcpdump on both NICs while
3 packets are sent:

  ens31f1np1 (the bound device):  0 packets captured
  ens30f1np1:                     3 packets captured
    IP6 2001:db8:a::1.41022 > 2606:4700:4700::1111.53: ...

Impact for us: anything that pins traffic to one uplink of a dual-homed
BGP host (per-link probes, validation of switch-side policy routing)
silently takes another link. We lost a day to it before suspecting the
kernel.

From reading 6.12 route.c: with nexthop objects, fib6_table_lookup()
returns the first nexthop of the group unless the lookup is strict, so
the have_oif_match test that this patch adds to ip6_pol_route() only
becomes true for nexthop groups once 484bb9d164df ("ipv6: Select best
matching nexthop object in fib6_table_lookup()") makes the table lookup
prefer the oif-matching nexthop. Its commit message describes it as
preparation for this patch. For nexthop-object users this patch is
therefore incomplete on its own; please consider queueing both:

  484bb9d164df ipv6: Select best matching nexthop object in fib6_table_l=
ookup()
  d25e7e9d8a6c ipv6: Honor oif when choosing nexthop for locally generat=
ed traffic

  https://patch.msgid.link/20260611154605.992528-2-idosch@nvidia.com
  https://patch.msgid.link/20260611154605.992528-3-idosch@nvidia.com

Happy to test a 6.12.y tree with one or both applied on these hosts and
report back.

Thanks,
Flo
