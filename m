Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018862;
	b=5rHP8gsgAx1V6MSusomnKp1RFL07k0GOttj4itjcimRcm70mefr7IPqOubkMd6kFclWB
	 1TTT8KGul0HwSgcvZcEJtK3ZW3GFufdJ8YjIhzFOI+2Hot0aVt/339PuC9O6qEG6VECH5
	 JEbUgb2xaDgsAtYWRFrBSq/cDohbDPr5LjeWXERWMlQYNQa6BJbc1+krTRbcCFVabDjQV
	 gNv/KwONEg/jYPHs9vbexNzrku8QJ671KNVM26z5Ue5lDSoAPIAmlWWE5xZ90JcKzYQ+V
	 jicAY26kdx7W9iML2oHBK7xVtlokOn7AFiqMXPHjB6kERPx7l3Yceo/oETMEY3NbZug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e0sNOPdsmpLWmh78gPWNNCkfpToB+LRtkE8Yz/9I1SU=;
	b=VvBx64H4JCjcXlHQW48b08GLAyVb2twdbKLm8oYsnDnLayaqLql7g3GC9W9M796V3luX
	 TwOHP8eNRc+P7WqIuvheXgfYsjWc8hKN+mJUsmk6Vw70mgm0PKJZwtVvA0XrHrdmKslKu
	 I+kvo4/habpQPUCaWpWLP5i9QxlefOk79CEu/efc8hQ8CvEfC1+IfCcEc7cPmbf1pw6uF
	 LNXUbPzm7y5Ji8qxwcPKgDVEEwJDHoaR9zv3Vc2D4KNIzxj8gPIEPtrLMdvijWAhwVPGK
	 Vg3he/4JiE+DQUiTFfHs00bjMTcfCDV3FVEckQRlfqddDDgPWHsKjzWNvdbyawHSZ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1PNm5NJ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E30606A325;
	Wed, 18 Nov 2026 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PNm5NJ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85F21F000C4;
	Wed, 18 Nov 2026 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018862;
	bh=e0sNOPdsmpLWmh78gPWNNCkfpToB+LRtkE8Yz/9I1SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1PNm5NJ/Ho+VOw3qcgzGkjLo0EhF9OngDQb1GA4pfM5gjhHTP5SM5h8JL/wjvgRTS
	 W2IxPeqqIUOznNFsK/6+LjpKORVOKm8e9xNGHhrTRc1YCjIgUeBhyAUYLUxrkliGng
	 OIgUFt/AGVN0ymjgJSvzViemhynRmGmNVH1ESf9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1389/2651] rcuref: Fix the rcuread_is_dead reference in rcuref_read() kernel-doc
Date: Wed, 18 Nov 2026 15:43:49 +0100
Message-ID: <20261118150338.022386695@linuxfoundation.org>
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



