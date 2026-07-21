Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22BB4582EA;
	Tue, 21 Jul 2026 21:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668091; cv=none; b=kec1Awr6zyuSfLA/WDisSLhmoUSehOlsLDhr/El//y84dI08Ia3PCRckiJzzEuN55uj6kkDtYkPNBqvatG/YV2Jzij87/mPlb+HmyRsRPw8MJd1K+UXS+KdULOMvxoB0hpQBttv3um32QroUSeWBk8Xxa0Nx0BHdSnJnyk+KTPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668091; c=relaxed/simple;
	bh=IByCI1glBVzSClIUZ4N5semrq/IQ+p9SVgtvdDN96bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqqsqpdVSj21uz1Ybai7fP55CjLbBa93j6AVka7SPo0vFGDafe115exkXnO/8ixwCItOJ3v7uWmCUWpkUv6B2yaLzF7Xn+2HT89x+IIEPxBJ5VQn4D0wx7y4u2aCH9WbXOFvKPoQH2m3Uu6G/j+/GGGXFqLujQKK7zdnWTIRIWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkcPw4gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkcPw4gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BE11F00A3A;
	Tue, 21 Jul 2026 21:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668089;
	bh=iw3Bs32tuMWAFX7ZqEs06g2Je+og4MEgrxB9NgXJH6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkcPw4guoE0u23G6Mwave34GS7Y7Sa5SEm6x8ipZoEJni3A5E4iNvNVismr8rI0VD
	 E7rAltu78CAElFQBJhDtYDlLMUg+Gz0JKLk1tw5UK3nTcDmItm+GFKnMsSzHMO/aGa
	 E0/JcDUlGL4kM3yuNGBszF46q2/uXfgCTFCL9nSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	carnil@debian.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.1 0043/1067] eventpoll: drop vestigial __ prefix from ep_remove_{file,epi}()
Date: Tue, 21 Jul 2026 17:10:44 +0200
Message-ID: <20260721152425.520515443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0feaf644f7180c4a91b6b405a881afbfd958f1cf ]

With __ep_remove() gone, the double-underscore on __ep_remove_file()
and __ep_remove_epi() no longer contrasts with a __-less parent and
just reads as noise. Rename both to ep_remove_file() and
ep_remove_epi(). No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -719,7 +719,7 @@ static void ep_free(struct eventpoll *ep
  * Called with &file->f_lock held,
  * returns with it released
  */
-static void __ep_remove_file(struct eventpoll *ep, struct epitem *epi,
+static void ep_remove_file(struct eventpoll *ep, struct epitem *epi,
 			     struct file *file)
 {
 	struct epitems_head *to_free = NULL;
@@ -743,7 +743,7 @@ static void __ep_remove_file(struct even
 	free_ephead(to_free);
 }
 
-static bool __ep_remove_epi(struct eventpoll *ep, struct epitem *epi)
+static bool ep_remove_epi(struct eventpoll *ep, struct epitem *epi)
 {
 	lockdep_assert_held(&ep->mtx);
 
@@ -789,9 +789,9 @@ static void ep_remove_safe(struct eventp
 		spin_unlock(&file->f_lock);
 		return;
 	}
-	__ep_remove_file(ep, epi, file);
+	ep_remove_file(ep, epi, file);
 
-	if (__ep_remove_epi(ep, epi))
+	if (ep_remove_epi(ep, epi))
 		WARN_ON_ONCE(ep_refcount_dec_and_test(ep));
 }
 
@@ -1013,8 +1013,8 @@ again:
 		ep_unregister_pollwait(ep, epi);
 
 		spin_lock(&file->f_lock);
-		__ep_remove_file(ep, epi, file);
-		dispose = __ep_remove_epi(ep, epi);
+		ep_remove_file(ep, epi, file);
+		dispose = ep_remove_epi(ep, epi);
 
 		mutex_unlock(&ep->mtx);
 


