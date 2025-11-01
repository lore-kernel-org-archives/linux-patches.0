Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339003A1B5
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 09:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761987694; cv=none; b=Gd271Aj6/IxXS1JT5PX2ndMUioHpCmpXnyhwpsRA9oosvBSGbazIdeHW0TF/ByMcXePK7smHZWLnMOfSQ8lcG6LUxWnRc35NVNML4b7pn908fwxc+uNUiYvIAkoKFaKTJPUCOIDsArdUH6+zjr6Zd491NWSd4wged/BQKAJZ+a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761987694; c=relaxed/simple;
	bh=OkmXDH+8s6o7nmZLFLfbxEPfQIoBqLBaQVRkKTvwLKQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Subject:Cc:To:
	 References:In-Reply-To; b=PYnNoaxDRjtXPH/w/N7/CJzNll9GzK+6RywSDbK+IeK98sggn9Wf4NfbcQQTl7R50OMTZDBNs0QgFvraOuddlJ2vGFouap0PhjVerd1cCrH05v/T/IZ70gkR9gCmEkEIx33DOnGQ9NWRyzlscov8ckubpUoC2mcqZ/zFJd7IJgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=GONH59AQ; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="GONH59AQ"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 88CC84E4142A;
	Sat,  1 Nov 2025 09:01:30 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 41FE36070B;
	Sat,  1 Nov 2025 09:01:30 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AA66611818085;
	Sat,  1 Nov 2025 10:01:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1761987689; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=/UrAtR9rvQYKTngRXxxUvdWSHmw552fuZKvvT/tBqRQ=;
	b=GONH59AQL9jg/3O0Ac/lBXUZSQvQkmUSwXYoEfljuoGCyNeDxW0NjhAwevfsfmP+3bUAUD
	Zm7cOWjtHnu1isTTJyHHRC7DlRdGU4YJIsMjywl5JjIYFUFMJjcCI4B+gGFZu288INfJE3
	epFERrayODOEEhFnBS/XLBD/Hbgkj9mLZeQQPxydZkL2pJhp8HCoJnbCKDqOs3dmxnQtNU
	PxYbg4naK4j7BvskbnVvb9VvRNkYEwJxseeuIl5mMX26pEGE3gu6TOVYwzCQy9ETImJMM9
	1wh6OTYkpCyrAZo/K2rpYdfhzBfts0MwVaZKbPP/TdPG4VJsEgRJs7TOht+VGA==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 01 Nov 2025 10:01:27 +0100
Message-Id: <DDX8I8XRC06M.2BIY9ACNMI9ZT@bootlin.com>
From: =?utf-8?q?Th=C3=A9o_Lebrun?= <theo.lebrun@bootlin.com>
Subject: Re: [PATCH AUTOSEL 6.17-5.4] net: macb: avoid dealing with
 endianness in macb_set_hwaddr()
Cc: =?utf-8?q?Th=C3=A9o_Lebrun?= <theo.lebrun@bootlin.com>, "Sean Anderson"
 <sean.anderson@linux.dev>, "Simon Horman" <horms@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, <nicolas.ferre@microchip.com>,
 <claudiu.beznea@tuxon.dev>
To: "Sasha Levin" <sashal@kernel.org>, <patches@lists.linux.dev>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-63-sashal@kernel.org>
In-Reply-To: <20251025160905.3857885-63-sashal@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

Hello Sasha & other stable maintainers,

On Sat Oct 25, 2025 at 5:54 PM CEST, Sasha Levin wrote:
> From: Th=C3=A9o Lebrun <theo.lebrun@bootlin.com>
>
> [ Upstream commit 70a5ce8bc94545ba0fb47b2498bfb12de2132f4d ]
>
> bp->dev->dev_addr is of type `unsigned char *`. Casting it to a u32
> pointer and dereferencing implies dealing manually with endianness,
> which is error-prone.
>
> Replace by calls to get_unaligned_le32|le16() helpers.
>
> This was found using sparse:
>    =E2=9F=A9 make C=3D2 drivers/net/ethernet/cadence/macb_main.o
>    warning: incorrect type in assignment (different base types)
>       expected unsigned int [usertype] bottom
>       got restricted __le32 [usertype]
>    warning: incorrect type in assignment (different base types)
>       expected unsigned short [usertype] top
>       got restricted __le16 [usertype]
>    ...
>
> Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
> Signed-off-by: Th=C3=A9o Lebrun <theo.lebrun@bootlin.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://patch.msgid.link/20250923-macb-fixes-v6-5-772d655cdeb6@boot=
lin.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I know about the Fixes trailer and therefore include it whenever I know
my patch is stable-worthy. Are there any trailers to mention that a
given patch isn't stable material? If not, would you consider adding it?

Thanks,

--
Th=C3=A9o Lebrun, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

