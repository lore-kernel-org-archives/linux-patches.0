Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207194;
	b=vDDc7BrJ1uEFW2lPGqOmvWjuxGxhUPG90jdcvnLOtB4EkmYh+cyY9QCQYqzLKu9XseWW
	 wQXlvttNfv0bxtoQLdDIqOpbDBQlQOA77T75sABOtqPmv5Yjvv46n9Fkb+zHqMPwIolzA
	 m8VBCIjmAvMby+7M5LO8p+y6W0GsLXjDTK2hT5Yfpuenor05WDJ1G9jqMFN8PRSD5/tqS
	 7GctfDzXXMcwlL0mUYu8MLeGfiw3qah3m5t4pTjMdsCx7f0fVoJFHMirxyS9xu0IiRPUM
	 V5W75BhI/4Tmf2opG3T1ClW8+8dsCrt+rpoQBxNpZflc95VlkbO3DgeMslGQebd9Xhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=L74D0DDjr6qWcUhuctNEfte9ljzjjSG9KJneW2JFBgo=;
	b=OBg8gD1kqXMxK5bP6hhpcXC3AgbZm/upGYhZY6CXdNTWVPU5ZMkkxR0TOes3Pm5uBuLQ
	 yFcce9QQGoEFdKIequLXd56O1a3/Eo3rSbPQlsHqYsypXr7JBH/XiPqapixHjnpecg+ZB
	 vJI3V24RlOP6Gs0bBYIUSBy0Liyx+hHkC+opxPlODAEQxEIXHrp4SxjElFdYMzofsHq40
	 f3pTiSg8w6+g3G/Pl5X5OX1vOSizWIRkeyhMfmGgugVpCbrPSdTsdm5GbMEi17/Rc5LGc
	 XBqml9j79/qIsPTgwjC++eiDiDEcFCZyD7AyxsZ0NCtEhnT1UyMHpTVHcBfXHZb2iFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVXmMFAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC12606A6E7;
	Fri, 20 Nov 2026 20:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVXmMFAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A6B1F000C4;
	Fri, 20 Nov 2026 20:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795207193;
	bh=L74D0DDjr6qWcUhuctNEfte9ljzjjSG9KJneW2JFBgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVXmMFAce2VQJx/RYIPcvSKGFUDL0p5vKetl9/pJCe4+RFjJ3qAeJa7A8Q9D0Lc4J
	 FEj1m0vIL+8aYPdmRr5Yq/yZRBOreCe9/Acx/krA0mhCoZ0KIEJSCjLtJWyvJxhOiA
	 r0mzIXHGz531nIE6u4Hm+N2UyCs+kTykUS/e+NBMDlEENWkJU875qDUNTGkD0mXevu
	 hK30N2qmZi9WRuLmoG+NfZiJz6SWmSmaTEslyx774itGZ5qDovydn6FkSxWf91e4r/
	 8ZI94wPPD5RMiWe0p0e+PJumLpWIC0JwMCkrVrieEwont+RQVLznob+d92iMkHjaq5
	 FB6QqVGQFU5wg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Travis Howard <thoward@lafayetteinstrument.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1515/1756] tg3: Add Datto SIRIS 5 1U Server to restart AER quirk table
Date: Fri, 20 Nov 2026 15:39:09 -0500
Message-ID: <2026-11-20-1-daily-reply-0020@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5066c2c3-653a-4865-bef8-e031504e04cd@oracle.com>
References: <5066c2c3-653a-4865-bef8-e031504e04cd@oracle.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Could we drop this patch? The original AER quirk was superseded;
> adding it to the replacement table changes its meaning I think.

Dropped from all trees, thanks.

-- 
Thanks,
Sasha
