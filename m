Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212692;
	b=oOKT0we6z966040DYu8m+lPsckpsCO7ZRlKCGU8l/XDPWWyjVrVpBX9UZh8HIrsbzIF5
	 SbKeDRE1i6x+skf+3HuF/mAueC1HwFeH4hYcHiT7C4YnpJkhxjm0PIzSfmegn/nC3lLRd
	 K52yD+YlAKeTzaoKezY9HnlzTIAtceDtHRBRJAk4sv3T9Gse/jIaMP83VYr1/1kziB9an
	 XZSQQulD9+7S/90ahjrWuTUd9JnC/uCl0iQ3nkyOMYpGZTcMdIHQ4MqDhkipoD1J2HClQ
	 mpLMn2mrO7anm39tDALBeYHx8/OHD+KB8qMJF21xbfupTqIYIGNrQa4WMYxYbt9DEIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YN3YhPJKu6uHkzDrLuBB1VRLnynFVUJ7bjJR+eRgsFM=;
	b=RuQ0CsP1xJAPX3YeNkgmrPIzQExmO7AvhfAaDBPtTEZ3tw7hKCZplSGIySEKDDtPJgjG
	 7WI2Jcj6S3NiqbhmaNQr3hlQ190QHLc1OrCVOSJXA3puBKnUfVW3rxGLshbjIiAmh5a0M
	 2fCaplBEBwabnodneteoV8XUzMO9VakrN2uuMSU/LxWmkS6kJmJHBZpGKa7QYcUIvfBTB
	 CelaBFdHGWr7tw4JG93tKIbIFYPF4NLtOzLS1NTWMbCBMzXmLrSaGX1HClKL/EJWEyYRh
	 b5Pm4G2wP+kGRsYzzBw/36yMpHXmKA29q2dmmxC26eyLWVVHqLSXjrOKyobNQmftm7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+9GHZ4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415B8606A31C;
	Wed, 28 Oct 2026 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+9GHZ4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF2D1F01825;
	Wed, 28 Oct 2026 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212692;
	bh=YN3YhPJKu6uHkzDrLuBB1VRLnynFVUJ7bjJR+eRgsFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+9GHZ4ZEIV2skPOKTuGl4qHrHzMkzWo6XkVZAn0uVjSw09I9whE1nBJpYJHoUKvN
	 EmfE2EkKei11hkfaAEgBSiWPTnRom2vTNI7gK2rRk96nM2+jB6uaZGhsDrJx79Vmjs
	 Yw49CKJXTaXbPWmO2TdRCai0rU1RK1JEBJcqzipQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0241/1887] ipvs: fix missing counter decrement in lblc
Date: Wed, 28 Oct 2026 17:38:57 +0100
Message-ID: <20261028170504.715901111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit bdac17779f46817f60103baf09f0370546c3f023 ]

LBLC may delete cache entries for destinations that are
removed or overloaded and replace them with available ones.
But ip_vs_lblc_new() forgets to decrement the tbl->entries
counter after calling ip_vs_lblc_del(). This can lead to
increased shrinking of the cache with every new garbage
collection.

Fixes: 2f3d771a35fe ("ipvs: do not use dest after ip_vs_dest_put in LBLC")
Link: https://sashiko.dev/#/patchset/0bdd5abe9968ded7ca2b9cb6844ba83d94cc8d53.1787318053.git.zhilinz%40nebusec.ai
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index e2480f33a1963..9b0832f56f14e 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -205,6 +205,7 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		if (en->dest == dest)
 			return en;
 		ip_vs_lblc_del(en);
+		atomic_dec(&tbl->entries);
 	}
 	en = kmalloc(sizeof(*en), GFP_ATOMIC);
 	if (!en)
-- 
2.53.0



