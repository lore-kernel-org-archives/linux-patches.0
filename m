Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039018;
	b=YrF0EnJptaGrAtEOsnWMsxl5BKYizhAqMzXH29qqlESAINjVjDJlVH0WkHhnNMob1YA/
	 S02Nu80UBaXEAiQpxpBavi8QHBLf+oVbmS9dvXlmD074Qonf3GHB/lzyk9vKJnk2kJegP
	 Pz/0sqtd2KoJ2eB+TOJq2m/nJxvTj5yMFgRdPezXHHRtodYr/teHwGWKO1ITSiPMErEcN
	 P6lKejL2pmuUpevtan+AbWquwZUUB2UEAqRxnNKl1GleEhpLCJq5OukNtZ03uaNilwpEn
	 tJWcW+H7toJq1+0b3QgpOA0ByDJEL1wmRP2eHxOb5qI5yaT71oitSVmrj0uKQ2HVkuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eOrE0eq5wsrtPOv2Khu2bJNUKKJ3WtCFx8OAsSJidn0=;
	b=F1eXKJeyAO39BubmXrNFrtkFg3xqBObeZ37J1CScB0GiioWKYl27pVyCjYWdnbsEefYF
	 VgT40fGaOjZYWmDFhFRsLFE04+INor0Elc0ghFDvxt1z9Bga9WSo8Ewzzoo1zTFpPutxt
	 vtB6lX6je2cs2XKv7b/Jd6DMwofcYlxAF4iAA+JdO+dsisG8xW0BTRYOkC4lc2mQ0zxaH
	 WhgHmVdJmslMb9sG5ptQBM9taCEXzdx9UtDaYsTgJ56J6eai3xIVXWBTMnJ/5BCy2/iCz
	 qXyg89yr+dak2btEDwX2oK4Xlv0SoSyOttTsLHNy6bcNF+TsXByqnsnwjA03hnjSOFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05nii1JH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A53606A325;
	Wed, 18 Nov 2026 21:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05nii1JH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840061F000C5;
	Wed, 18 Nov 2026 21:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039018;
	bh=eOrE0eq5wsrtPOv2Khu2bJNUKKJ3WtCFx8OAsSJidn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05nii1JHRYVFWZ6mxadNAUzZNXIka2s9sfSURpiNePZuVYbtEIIZYWGCi+fIobOHS
	 d5UUn4pegwmgE9gx1ZoQNsD0OHeA6UL2yoH+m1z0vPtnKrCVGjzr5H3lNpJ3sTOgBf
	 EKcmjx9XfAchEdKcUiF7qpdbprWniEpZ7c7OLFg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1949/3318] hwrng: virtio - Remove usage of the deprecated ida_simple_xx() API
Date: Wed, 18 Nov 2026 15:42:51 +0100
Message-ID: <20261118150420.532167761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e4db80d80cff590eb5fe0444b665cec839c34133 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 0f7bf47f5a0c ("hwrng: virtio - prevent use-after-free after a failed restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 43e84983c428b..65984504a3ca9 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -154,7 +154,7 @@ static int probe_common(struct virtio_device *vdev)
 	if (!vi)
 		return -ENOMEM;
 
-	vi->index = index = ida_simple_get(&rng_index_ida, 0, 0, GFP_KERNEL);
+	vi->index = index = ida_alloc(&rng_index_ida, GFP_KERNEL);
 	if (index < 0) {
 		err = index;
 		goto err_ida;
@@ -185,7 +185,7 @@ static int probe_common(struct virtio_device *vdev)
 	return 0;
 
 err_find:
-	ida_simple_remove(&rng_index_ida, index);
+	ida_free(&rng_index_ida, index);
 err_ida:
 	kfree(vi);
 	return err;
@@ -203,7 +203,7 @@ static void remove_common(struct virtio_device *vdev)
 		hwrng_unregister(&vi->hwrng);
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
-	ida_simple_remove(&rng_index_ida, vi->index);
+	ida_free(&rng_index_ida, vi->index);
 	kfree(vi);
 }
 
-- 
2.53.0



