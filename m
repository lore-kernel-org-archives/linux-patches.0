Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=141.84.225.229
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792427411;
	b=e4qlgbsXz0eZAxw1ZoVV1IsjAkKDMts+FOLCY9plPBv6AIwp8vvTxCCGHrpqYktZzO48
	 A0jiLWYPizPWnRQQhvu4IIL+omTYVXFQtZD0ux/h7W1DGWjU42AuKAKTrLXuhiSfCuSn7
	 r//BEgSpExTUlj+9zQQ//g0FdB5RnlqUqSU5ZNJ58yCvfB63sQ5Sn5rQDffn4LxvL4J+r
	 JdP6oxvxnsOeBaN3hugV0D4/Cn+1ghNDjgTIjq6BczLtw5f1HfT5tsyRk/TWxrilTCk6F
	 bbdR/Wz+90XSab25TkThPm93QFHAKPhuobBWJFtqRske04rwJejSQFJhbO79Tx93E7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792427411;
	h=DMARC-Filter:Received:DKIM-Signature:MIME-Version:Date:From:To:Cc:
	 Subject:In-Reply-To:References:Message-ID:X-Sender:Organization:
	 Content-Type:Content-Transfer-Encoding;
	bh=bbP6Y1YX+hAETPVaAi3loOJPV58drResJNqBABhUf4E=;
	b=ifQ23wb3t1zBxyMxneVF9hJ/ad8Trh86jFy3QHy1/FDvr/onumDWwIEKlipR7jkbFIIa
	 0WFcOYfQTaAP9MQBaKDqApGpM/aUuPzAUBs9GCW6IfWuZCKfaoo6HWIDCXAriKGAfgssn
	 4yXrsOxo0/jk97Y5oQwtgq+ViAcdyn9RU+ggqlkHtgYAwaVmL3RP4/xGn5DHppONG5HPi
	 UKnLw75S1MGGMtne1Jtakw8HT7vR7hmCaRFeq520FQKUMY4YoXUSXZUgYRS1IL9izC/Qu
	 lcXq2wg/wgLRQaM0ndmXph2wdcTIkaxXnRf6U/kyBhiAUFI1BlgskhaGQQU31HmJn+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=stwm.de;
	spf=pass smtp.mailfrom=stwm.de;
	dkim=pass header.d=stwm.de header.i=@stwm.de header.a=rsa-sha256 header.s=stwm-20170627 header.b=QZaGZvGC;
	arc=none smtp.remote-ip=141.84.225.229
Received: from email.studentenwerk.mhn.de (dresden.studentenwerk.mhn.de [141.84.225.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E757606A32D
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:30:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E757606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=stwm.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stwm.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=stwm.de header.i=@stwm.de header.a=rsa-sha256 header.s=stwm-20170627 header.b=QZaGZvGC
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
	by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4j7gxd6H1JzRhR7;
	Mon, 19 Oct 2026 18:29:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
	t=1792427397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbP6Y1YX+hAETPVaAi3loOJPV58drResJNqBABhUf4E=;
	b=QZaGZvGCo6d8tLRPBRgoiJtcphlIHU0szsY0DAr5h4xu/UiB7adIckEheOJGdEDkU34j5Z
	5zxt6qZ6m1zhsK9PIgt+z3YYcWMAc3veXuV9icV2Y929NZXdGQ4NlhXA7VB2jA6cs5LXt9
	tL8haEETKexWgmLrbnNIlA5zaDuNoX9IkOa5+lA8/5JbOWmerqdo99jWRy/EOZvjLsu0Xn
	SoqBbtF1uJ1RPrs3+5A+81uRFNeRc8+tBjzXRexqkwoPYZ586sk7Oh44Bfuf8/FF1+lQcI
	pP8UqfxxUK6EJo9tKShrkRk2/81n2D3E/a8XG/S1CfENdwjYIdAMUKWgcbHYNA==
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Mon, 19 Oct 2026 18:29:57 +0200
From: Wolfgang Walter <linux@stwm.de>
To: Bob Anderson <kernel@ametros.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Sasha Levin <sashal@kernel.org>
Subject: Re: regression 6.18.57: acpi power button vanished in machines
 running in qemu
In-Reply-To: <atUi2y2BDyrDGbpG@ametros.net>
References: <5fe757e7aa54c38df3525d313598db99@stwm.de>
 <2026101834-parchment-reps-0bee@gregkh> <atSdI7buRErdF1jZ@ametros.net>
 <2026101813-doorstop-hyphen-614c@gregkh> <atUi2y2BDyrDGbpG@ametros.net>
Message-ID: <6bf6fb6e4d8a3afbd0935142d8d4f8ec@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studierendenwerk_M=C3=BCnchen_Oberbayern?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

Hello Bob,

indeed, this fixes the problem for me und virtual machines. Thanks for 
looking into it.

Am 2026-10-18 21:49, schrieb Bob Anderson:
> On Sat, Oct 17, 2026 at 07:26:54PM +0200, Wolfgang Walter wrote:
>> since 6.18.57 there is no acpi power button any more in virtual qemu 
>> based
>> machines (as far as I can see model doesn't matter).
> 
> Cherry-picking ab06eb9204010c61e754bf4e71ee6f554584714d should fix 
> things.
> 
> thanks,
> Bob.

Regards
-- 
Wolfgang Walter
Studierendenwerk München Oberbayern
Anstalt des öffentlichen Rechts
