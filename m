Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019839;
	b=iGCgrPQvddQu4o1LN6hMxLnhCWp91LdKrT5mRwvZIWajFJVXXUHnBzSkW+nZoEOOgHnz
	 ZWeqc44WvcTbPfZyGGSioMKPumz26RznDkg2YwYoUjgdOzWesG6kKojo6ZAfqNQ0slGDO
	 5dpQ8Tc9Garsr90JKDx/xh/hm9SBl3Xj1F8GOMyL1IZKkeQAl804zeNE154ikPCue+kyi
	 /oO0C7320FHFHGrgpQErQUDMPzq2/KPWD+lYjP+5GdmbZAx+zWLJ92BaeKWvsW/A0za/A
	 cKGrh4CtyIg7eFrk+3A2f/jwDBmouiMY9FRVOaCXVqOzcsD2RKrF1X1xe256bZ4ZJpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KsVgL3JH7ePTH5hNo7qdQbMcYALfnBIq/H4OckB0mKc=;
	b=qClUzCnmQA4DZa/FkhP0Z1I/Ug9DcsiLR/BhcmbkoXTaSSFpzmt2kTQOP35lZXcLaDSX
	 N4lJMYEXtpB4GBribanZC2GlQwth9vEHTjuqbcW3bA9yVQ5xeVqmG+gw+965WLtv+GNJX
	 IErvGX9/UfP/2QUCXLGhCXwzb1HrOY7Y9JmA7U9Puqaln1zoFUy2/3J/92ky62q82boHN
	 Z+bGfiZcd28cGyFq61NuftzfP90qSHfarYf+EVckOEw5hpYhGjbyftB4AoO41xKoi8UzZ
	 4hqniJU1kSUAcacmQVRe5FJ3cFNqrRGt8OWmWA/li/W1Je5Gs0q5M3o7x/jLRiJZLUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hv1r6G/3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD10D60A260A;
	Wed, 18 Nov 2026 16:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hv1r6G/3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6591F000C7;
	Wed, 18 Nov 2026 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019839;
	bh=KsVgL3JH7ePTH5hNo7qdQbMcYALfnBIq/H4OckB0mKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hv1r6G/3g3mRcs325neIRL4vPnZBeJ2SD6v+uqiAK2deZjcco/vh5kOtqIjg8aqU0
	 L0LY3RYgHQSMe/H94qIlbl9lXPovF7I8mMiWWZveEEjfZojOJ0JmJNGEzJ/cXMm86l
	 2qLjtz8rhmLWCqnK6Kc8+IbEbWJ74KmXQsOHad2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1738/2651] bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()
Date: Wed, 18 Nov 2026 15:49:38 +0100
Message-ID: <20261118150350.149280135@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 810ccc792193909ba9bbb4246e0eb0de14dad724 ]

__cci_ace_get_port() looks up the device's "cci-control-port" node with
of_parse_phandle(), which returns the node with its reference count
raised, and only compares the pointer against the probed ports.  Neither
the match nor the no-match return releases it.

Drop the reference on both paths once the comparison is done.

Fixes: ed69bdd8fd9b ("drivers: bus: add ARM CCI support")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://lore.kernel.org/r/20260923164122.596910-1-oss.patchbox@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/arm-cci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index 076ac8e06bd01..435952602d06a 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -167,9 +167,12 @@ static int __cci_ace_get_port(struct device_node *dn, int type)
 	cci_portn = of_parse_phandle(dn, "cci-control-port", 0);
 	for (i = 0; i < nb_cci_ports; i++) {
 		ace_match = ports[i].type == type;
-		if (ace_match && cci_portn == ports[i].dn)
+		if (ace_match && cci_portn == ports[i].dn) {
+			of_node_put(cci_portn);
 			return i;
+		}
 	}
+	of_node_put(cci_portn);
 	return -ENODEV;
 }
 
-- 
2.53.0



