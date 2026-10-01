Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F52043B3CC
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 05:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790832556; cv=none; b=EtAPcrEP/T+xhabUPHcxp5g0U4Hgh4ygr9BdhybUuPjV5tvhH81hKGdbB3cqt4/b/uY2fNkirgKEDwliYL9xOTW11ij4ZMTsXnOd3sqHeHK/GUSThFpJadtjhc9zKP0xptY01pk71siC+viXw7/Ts76LJjP3nOgHjlhLHyHnMgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790832556; c=relaxed/simple;
	bh=w/ZOXy+TEhEgZ1n/n2Ri3BayA5eQ8iQykEwzlL4HNag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aX+rjtJi5ldR4JblIVi2EtZSMieHlEUvzRJH69DAlixvTkgUR6G9shSj/qQ4iRsBMAo8h/7wBCy17u/g3+prPOwfpXpl4jkUzxaJwSeBriNHZQtQfO32oQGYt0S0Np9irz2a2529K0Kduf93AELcRXewTWPHXVGEycDRzXwvV8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nSbODIxS; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nSbODIxS"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af929e59dso1641564f8f.3
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 22:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790832553; x=1791437353; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f7De1psM/c0Th/SkbusqTwWz8XUB0UL58xuHCpdo1fQ=;
        b=nSbODIxSX3HdSd51rhXp7crGhuz/p6T+wPIxjY5h8E+20ZUitRuUH5jBaBvok+EDqo
         PyPJYupTBJKX7eYYe4uaLzNVEirQYfuTbpwxtj6ruxBtbcaH4CA77k4xEKTruu360CNR
         6a164S7QcLdKAyjaAFPjJmMFNoMCrX+shhHxCK8r7t51tILMExB7U5V2Hoq+no/LdALL
         mxpb+ooSWmtDNQIc78YYvdkmpKP0fSEU2UdrA/AYeRsmcutbBU7aXQ2ZZSeSn0GqeUgy
         FZrHS+F+7ltUbilvYVdSbS+7dKOWbVcyJziJL2vQksWB44bzyoLPO9Vy62jjtYXhP12d
         J7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790832553; x=1791437353;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f7De1psM/c0Th/SkbusqTwWz8XUB0UL58xuHCpdo1fQ=;
        b=U52haHEWYV0UbSHC2TAGbIsBIao6pghB5vZ9kY1cKsVsJR/F5N+oxC7BzFZpBYJ/SN
         jTvpM98u/gMmUs69/TtQE3KqNPMA66Uii338gUk3lVKlVi7wjkPPT/m0z35gP4s/FqWL
         UdaMVcNiECoezBR/o3Dsuh/HwA4xeVbFh5TO8sFa2GAF5XKG0GOG6J4/KCisRm5JytVI
         nFNRot24eS8nvG50CIYhHj2ed8mL+UaG2csIIYqG6I5M1SnoiO01JAmFuegKa3xLCQTU
         oZfUrs3VuMvb8uDoWqIDH0wszG5g1IfHXMs6BqSrF80DvVkNfOPr95Tq3gSYOY1mpYqO
         +TIg==
X-Forwarded-Encrypted: i=1; AKwUvBzmt7mOH9H9aDhRa2WAf8OvtwUoD71/H+VWe6K3kiHTfJ7yBft+WhhbNDE4+vbXbnx/R65aun8H@lists.linux.dev
X-Gm-Message-State: AFq9FYJZSP49nbxTq0xhP1+GV3Rf4iAdrJ4znpnzhEV90gR0dF2k6zV1
	rancxbWlTjzzAgMheS9P7mXgJgrmBHE0q0TNwB5HBxFPf1TGPCES4XsI
X-Gm-Gg: AYBFou3H8tELSq4UMbAWGwE5JFurnHJwG4ZalUeagcmZuM6lo+00FDeG71yM4VHt+sG
	HuTgrBmVWVcWb05S8fRmJo7+z0Bba6/hySaGip4iz/P1A/R1Ys/jq+4Pr3WgdYVNMtWpJXGteWw
	eDVXBRNuonMu6yWuOI5DQX1HmnFuVfv20ixvytf7y0GWTXTGTsERzg2ibG5txqxN2cYSSwCmXds
	7LLgGASgBkbJhm+hBnpVu8hNvgAlME6SlDPTMyDiaKeq01P48a9xHRW6uJNs1nbWgd9rL8WTBsI
	0p+vfqgRxy17WUhYdSWp7zJ9k2fBiSYksfNa5cXTgQ70zxabFNoR806t6ezswVh+3YLq6l4o/Ak
	L2+jGEAIMOgtZPCJJ+aJ/K8iB9iwNpZVboflpL7v8QOPZfX5n720JxzZxPpsIrUqHSI+bprDYri
	SQ/v+a+DDkiTNSESlyZxxASfPkqLsYtx3P+zm/RT0ZPZVk9lyZg1GX7eOZrf2gTS/rNuh6EgWmX
	rP/mbO7G+3aOX2/8joZWzoV4eQMouQbwJMhal14POZGCpcUMVZ5CIN1IfvrJRpnMyL+CEert0zg
	8eFST1PzjrRTwyLQxr52ASghHcOmEAZQ/2WBAD/4bdWzFme+aug=
X-Received: by 2002:a05:6000:310d:b0:485:8c16:a32d with SMTP id ffacd0b85a97d-48b0250afc2mr6371735f8f.34.1790832553332;
        Wed, 30 Sep 2026 22:29:13 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-056-101.95.117.pool.telefonica.de. [95.117.56.101])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b0691c4c4sm4635535f8f.22.2026.09.30.22.29.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 22:29:12 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 436/877] macsec: inherit lower devices TSO limits when offloading
Date: Thu,  1 Oct 2026 07:27:46 +0200
Message-Id: <20261001052746.76669-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260930152424.092713670@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152424.092713670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I object to this patch as queued. The backport is missing prerequisite
f29d24a2106a ("macsec: clean up local variables in macsec_notify"), so
NETDEV_FEAT_CHANGE dereferences an uninitialized rxd.

Clang 21 reports this in an allmodconfig W=1 build:

  warning: variable 'rxd' is uninitialized when used here
           [-Wuninitialized]

In QEMU, the exact review tip f4ffa8dc360b hits a NULL-pointer oops at
macsec_notify+0x130/0x1e0. With f29d24a2106a applied before this patch,
the same test passes and the MACsec device inherits the changed TSO
limits. A three-device test covering feature changes, MTU changes,
down/up, and unregister also passes. The corrected file builds cleanly
with Clang W=1.

Please add the prerequisite before this patch.

An LLM agent assisted with the review and QEMU A/B testing.

Thanks,
Karl
