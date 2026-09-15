Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152253CF1E1;
	Tue, 15 Sep 2026 02:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437823; cv=none; b=Cck1ofk/H+fG7I0IKX7x/hjx8nV3ZgVCljjZXUDExdAAmA2gQMmfZOO/B2Bc384rGiJBR+/8Naa3mf0hb/Za1WuEiZ6qZuApayFgufNCnoCuKld0ZvBN9oNffHHCDOMYuuEWKD+uEIt/cxFs3Zm5zp8nL1VLLm+wnd/AnrbJVno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437823; c=relaxed/simple;
	bh=8K0PN0ZkAqLfx1mZCsb0Vi1gzMqnVfYQ+WOAf5zCBFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1XHIIZLeCAyCWJjGQT+8SusDKeZxRwZWYe80zA78qgxnIV24h7ljuAb23TQeZoULvw7d0sA4I/1gzyDeYTGV3Em5qgiksHfNGyf23c5gIa/+5PnR/mE5VYWCPmJCKUMe/OUoBsxC2Pw8qMkd4U00HBthcr/BkivOu1gqw/d6Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBD4jLFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBD4jLFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C9D1F0089A;
	Tue, 15 Sep 2026 02:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437822;
	bh=eyKJJNm6fkd+sD32UCaMAOk8bYp1i6k4SgGq2ch9Gr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBD4jLFmg1oiqPwy1AWJh0KT/2j1Y9Eqk0SpL1NVV3KiIfKAXdnBPHQp6vHUEX7fX
	 +iAKHeiFy1r4yFzbfT5WzAxQpJjQaAlUXRGbpm1qIsJk7gmsrGJaRjPDiwFJR2q3X0
	 LIlPbiMDcqpF8ixTlFeCZPgwymRY4wvPu8p8QaJRqsE/zknEv+dYHZZ7v/1Uk5RAbu
	 pU3jhtLCxkh3aySaP5u2BvtQ+OvnPsOrhoJg4aq7qcui+A7QcZDsInNHDTyXcFAPcb
	 tOAS5NDnoxhzzns7fgfzM3389EZZyKVr1nwn72orKiWTWhd0U7tOE/RUsWk2eNQx8w
	 xGDC9sfOVDmbQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	linux-wireless@vger.kernel.org,
	Junjie Cao <junjie.cao@intel.com>
Subject: Re: [PATCH 7.2 0862/1815] wifi: mt76: mt7921: validate CLC firmware records
Date: Mon, 14 Sep 2026 22:03:19 -0400
Message-ID: <daily-reply-0003-re-mt7921-clc-followup@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914054209.635949-1-junjie.cao@intel.com>
References: <20260914054209.635949-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please queue it with 9417c5818a01 for 7.2, 6.18, 6.12, 6.6 and 6.1.

Queued both for 7.2, 6.18, 6.12, 6.6 and 6.1, thanks.

-- 
Thanks,
Sasha
