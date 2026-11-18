Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025686;
	b=gkv92rNmDqomUInMtdEaaoBqts/c5dOm9OYeglJ/Fe99FpirzX0iS5yjNGhWHOzqX1JB
	 3DYy9R/AJf+ZBq5JanociDMzLogz114WSiZHE0cBuhJOZcR2CKPBtHEqSCw+8mgVjk8Kq
	 0OBXCvRkwfljrt9AMm/zx45wgwm8xkm7oP7vRyOx2cqyY7pHwqP/I8IyVYH0YNhcEmLop
	 DEJ8Ptj4Oqo4JZJ7v+xjkK+MZe85mIRLmrg2p+4yoWjMdp/y0xyq6LW/w+m0tYVHEUVWu
	 CXmEInOl93cFiC9m6e8LSAn5LrgG0tx0ToRn16mMHGb4+9FCykvTP3DQTZxdZRgWZwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kJus/oaStWNwjtZLIiSsXoS1SwMAsXTdyyPjaGQl+Fs=;
	b=4PE3LHzmyMtNi0QWARmReuYR/Ek1oDIhCYvSEDgaNnQmI3gqW+ifmdnpENiw8ChlnIku
	 uwnRdSGSIzMl6y8643cmwXRDsSNQKsl6lzdC5rmcPj8sUL1VD6wsdfiHOrzL4aCnuwwXY
	 lBsk50Y+Wt7RYI3jh3S64Bh6S5GHfAJrIiMK1dg6ZXdQh7CDXRf1J5Hm4L6HjjrTyI469
	 AVhpWllXoVwNEo+66quX4mfUzCF87Igfz+fhOMa1ObDUJLdYWtns3yXIgx20cR0hFo70C
	 UxBXSOGubAu/iXidRL6NhDBcsK4DlmLG1/X9hx+/40Vs0NcuiLc5cLet7HQ6Cf/rR+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDYzWaup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A43A606A31C;
	Wed, 18 Nov 2026 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDYzWaup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1A51F000C4;
	Wed, 18 Nov 2026 18:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025685;
	bh=kJus/oaStWNwjtZLIiSsXoS1SwMAsXTdyyPjaGQl+Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDYzWaupaS/49Gzf+9Dvy/ReEcbEBhI4wPjWaBCXQ/VEaK09ix4+mRrnTvt8wWHNC
	 /S5K6lXrsIBTYopMaTWzyYJ/XEnnqXCKqqbxCi25mZfH3ncnTRFu3mue2dOYTS7OFm
	 eBSkOvIvE9qyWEj2vrac9rTNktiyP3Ovteup33fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1168/2151] rcuref: Fix the rcuread_is_dead reference in rcuref_read() kernel-doc
Date: Wed, 18 Nov 2026 15:48:23 +0100
Message-ID: <20261118150204.689899451@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 852fbf7fc857fd375d8caccbce576aefc37fb065 ]

The kernel-doc comment of rcuref_read() refers to rcuread_is_dead, which
does not exist. The name is rcuref_is_dead. Say rcuref_is_dead.

Fixes: 3efa66ce6ee1 ("rcuref: Provide rcuref_is_dead()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcuref.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcuref.h b/include/linux/rcuref.h
index 2fb2af6d98249..01fee161b67c3 100644
--- a/include/linux/rcuref.h
+++ b/include/linux/rcuref.h
@@ -34,7 +34,7 @@ static inline void rcuref_init(rcuref_t *ref, unsigned int cnt)
  * indicate that it is safe to schedule the object, protected by this reference
  * counter, for deconstruction.
  * If you want to know if the reference counter has been marked DEAD (as
- * signaled by rcuref_put()) please use rcuread_is_dead().
+ * signaled by rcuref_put()) please use rcuref_is_dead().
  */
 static inline unsigned int rcuref_read(rcuref_t *ref)
 {
-- 
2.53.0



