Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39A654763;
	Tue,  9 Jun 2026 00:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780966345; cv=none; b=Tbp6Cn1AdbXzM7JAM6BQ5Q60SOxIvlypQIL98qtlUdW9IHQkx5P0vfVgUx++KGIlR/vDKg8Q0juNlcz6y96qvsgbVr8iHd2w6q3PV6YXLEHGaz14SYIsLwhT+BsmMsI3JuWdeRl7iOD2y5QWAX2ECKuGZc+bY9IqK5NElkMUA2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780966345; c=relaxed/simple;
	bh=z73HwLVnnq2+zeo30gLl5GrbC4oK1UqZKltRwRTcJPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anbwK0aDXctwv+EMjL6YqqvH1GcuwGP+Lyi440n8hjQqCXzdwJ7Dsk09yW9QX+OT9Ws1OB6j44i17tAu7r1XOByFfikEB8Yk3iXFs2znjOGMeuoo8asfnfIA/KujcNV43zIk9Q55Sbwx9BYxA4oN18ur3xOfVrTSBGOs3hg/k8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HASS1J5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HASS1J5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C8F1F00893;
	Tue,  9 Jun 2026 00:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780966343;
	bh=z73HwLVnnq2+zeo30gLl5GrbC4oK1UqZKltRwRTcJPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HASS1J5tHtPOjb9zAvimiAvI77xPsvMFoR3clutZ5xCCx+GKXd/gR9EsSOqemR3S4
	 DJtICHylvl61OlPN0d8Zd7TFXs8EJs+O2vlRqn6Jt5KN8aZw1PQdwqicttqQuXLBdY
	 pfiqhAcEmQaU6xDHEVov0aS6xujmWyyjMoXMsKXxQLF5F2jFgtDJESgvHZDbI/gFR6
	 0CLbjjDrwS+pHBepG6ufMX602PQrBAPskhMWCVMtUcsn29glNsb5Ypg58qniSiI4Et
	 zpRBhpG9tPzGL66zDfwLHRUGKzALCrp2zSNTBhiAmloK5mt0UEphEH3vqTFHWnPuAW
	 97ivpud/u2DTw==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	khtsai@google.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	raubcameo@gmail.com,
	andrzej.p@samsung.com,
	balbi@ti.com,
	kyungmin.park@samsung.com,
	linux-usb@vger.kernel.org,
	Jianqiang kang <jianqkang@sina.cn>
Subject: Re: [PATCH 6.6.y] usb: gadget: f_ncm: Fix net_device lifecycle with device_move
Date: Mon,  8 Jun 2026 20:51:59 -0400
Message-ID: <20260608-stable-reply-0013@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260608053636.2797024-1-jianqkang@sina.cn>
References: <20260608053636.2797024-1-jianqkang@sina.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.6.y] usb: gadget: f_ncm: Fix net_device lifecycle with device_move

I can't take this one (6.6 or 6.1) on its own. ec35c1969650 alone opens a
userspace-reachable NULL deref in eth_get_drvinfo() that is later closed
upstream by e002e92e88e1 ("usb: gadget: u_ether: Fix NULL pointer deref in
eth_get_drvinfo"), so applying this commit by itself trades a UAF for a DoS.

Please send a complete backport that also includes e002e92e88e124 (as the
follow-up patch in the same series) for both 6.6.y and 6.1.y, and I'll queue
them together.

--
Thanks,
Sasha
