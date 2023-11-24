Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BA72E3E1
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 22:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Fz9r82Vf"
Received: from relay3-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::223])
	by mslow1.mail.gandi.net (Postfix) with ESMTP id 05A71C61B3
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 21:53:49 +0000 (UTC)
Received: by mail.gandi.net (Postfix) with ESMTPSA id DAFC960005;
	Fri, 24 Nov 2023 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1700862822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8GWGjxo96HXmWS7PO87y6ARDdmPBxtxKcgnDG4Hw+A=;
	b=Fz9r82Vf5ZnHoHcgqJMhKABKNDPf/JCTgC8tyxotQ4x1ZwaTVwQWthPwR7qCRctLv2RaeM
	qCrvvWIF1GV9ec43x1rsZ1I7SubcJI6CRa6H6W37G7H2sMpWTmxt5l7XRy9DXP/xqwGiUo
	eXoNGQHZaO+UzU/GOZWdO8ZWQnAxvjC/MhQd0iAGh/SB1miuY0xk3zLJmw/SZmkCGTJO+z
	FZCtO/PGwTy/+jh92TPOaWWB7VKIDl0GWe8rfnP4A8dwv6DGgdgdHr4iPUCpmZQlhinTCz
	LdGmDTKb0d/jvFbI2tI7bYi9IkKOwlPiCJCYhTVUL6IOMPnsHsGFFtrlvpLJDQ==
Date: Fri, 24 Nov 2023 22:53:41 +0100
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, =?UTF-8?B?Q2zDqW1l?=
 =?UTF-8?B?bnQgTMOpZ2Vy?= <clement.leger@bootlin.com>, Lizhi Hou
 <lizhi.hou@amd.com>, Rob Herring <robh@kernel.org>, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH 6.5 369/491] of: dynamic: Add interfaces for creating
 device node dynamically
Message-ID: <20231124225341.3288322f@windsurf>
In-Reply-To: <20231124172035.663205241@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
	<20231124172035.663205241@linuxfoundation.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-GND-Sasl: thomas.petazzoni@bootlin.com

Hello,

On Fri, 24 Nov 2023 17:50:05 +0000
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 6.5-stable review patch.  If anyone has any objections, please let me kno=
w.

Isn't it quite strange to take this patch, which is clearly a feature
patch, into a stable branch?

> Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
> Link: https://lore.kernel.org/r/1692120000-46900-2-git-send-email-lizhi.h=
ou@amd.com
> Signed-off-by: Rob Herring <robh@kernel.org>
> Stable-dep-of: c9260693aa0c ("PCI: Lengthen reset delay for VideoPropulsi=
on Torrent QN16e card")

This looks very odd. I don't see how c9260693aa0c (which is the trivial
addition of a PCIe fixup) can have a dependency on this complex patch
that allows to create device nodes in the Device Tree dynamically.

Am I missing something obvious here?

Thomas
--=20
Thomas Petazzoni, co-owner and CEO, Bootlin
Embedded Linux and Kernel engineering and training
https://bootlin.com
