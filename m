Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028364;
	b=ioV0wDIuTyJaMUvzAH68eg0oqLVSPe3CtU1PNuZosOdEL+e0G7vWnOjCmR5MO0FnCX6P
	 hJUem/mpj8mIo+xj3ZeD5r45EjX62OBXQu65hO1XtYEp47SVXngFfMGv18Pk5lAbdLFHO
	 NfQN3ed5gqgP9Upot4WyiA/Fm/LbmXd59EuH/4xV/cq45+ZCM+wPJvYFt6a2ut5rfce6b
	 2TqfwXkGqrI+Ps684DVV2pV++l0psxmK40A6BYJa5eWslEyPoPwwuEWbfjaN+behG6ABq
	 EODsJ9l3uPsYz8RsNYJ9g0Rczh0REocfHebQ7C+a+SY1ZvpkSt7r8+NTC5JHHJLpajg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FRSyc4Fso5A2yk4BjxJB3sf9S/Kx++0m409xUcRT43I=;
	b=tpp4d1ZMlhnLSCJDATA55xk4wtYaRR1MG587hEeicarSasN6dRvKNv5tyqueLGR92vqM
	 t4Sv/c0idwhgqmtnrMebF2Pnsxg5Wff9P0o1cOWiHirFa/jc4GJcJf1/tlHDQmzmGgjCg
	 Vvq/ZWInWXhEQj5G+OqYf9k85NltClV80fowmCakRORXvUgvxXwHu8MfdFR48tx03/7qG
	 b33rsnjftEEYgdV09FBeNypIuOwPeAg/ouk/0elkGhi7EvDvF9drSECayYDrdOLm0jBu7
	 XHocoGqjcXxGuwXNxhEIXv17QOIcos18p4YWk2um1WCWK2RlK7cbOAgwBhW5IOfGlow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8Y24LZf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD49B606A31C;
	Wed, 18 Nov 2026 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8Y24LZf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6561F000C4;
	Wed, 18 Nov 2026 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028364;
	bh=FRSyc4Fso5A2yk4BjxJB3sf9S/Kx++0m409xUcRT43I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8Y24LZf7P/dgtfMIwKUL6etKXp9Q6N15BBxO3JPg/CdB3K632FJygLilNdPYPn1H
	 Wr0Qbk36B8qXMk8WMTaCS/bD5/WACQGyrNhxAZmgb7E53uUzQeJu2pp5QNNdD3Ooaf
	 h+rUf61rIAJVMx4YqU1bZ8YzAY5xtBgr9BqY8Kts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2118/2151] apparmor: advertise that sctp is being mediated
Date: Wed, 18 Nov 2026 16:04:13 +0100
Message-ID: <20261118150238.846772052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 35b8ab3f36ac0fcd8fc910da0bed889b6c75c426 ]

Enable the test harness to detect that the kernel should be properly
mediating sctp.

Fixes: 7a82f9a06459f ("apparmor: fix check SCTP bind, and connect permission checks")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index 6376a86f82e17..e8b60f1b6810f 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -23,6 +23,7 @@
 struct aa_sfs_entry aa_sfs_entry_network[] = {
 	AA_SFS_FILE_STRING("af_mask",	AA_SFS_AF_MASK),
 	AA_SFS_FILE_BOOLEAN("tcp-fast-open",		1),
+	AA_SFS_FILE_BOOLEAN("sctp",		1),
 	{ }
 };
 
-- 
2.53.0



