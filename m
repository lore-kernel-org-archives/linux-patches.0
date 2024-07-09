Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B719327713;
	Tue,  9 Jul 2024 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524315; cv=none; b=pxQqXXNFgyVAyVdC1mjny0Q6DrfGO6ZiGXsSa6qPTEYryvkd5tsFw+GVDahTJjhWtakNumPKHAarJj8kSsut3yDZ+IT7CioAYyqJq0uXovdq2Xu+P6mjSFUQnr102DHCQSW1dNvjG8dwJev49X9i9NQdnGKsk29HphQshYZYyz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524315; c=relaxed/simple;
	bh=3DWWkFtqYDogTiy2SLQ2Q517nIeKk3sK1cypIKDiKVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAL7kGqhClWT5Y42d+BFgdzAcYMda+dwWwJCqa4ASOy/7OTb0IWTmPxrBqksBXA8YCOJjLbWpGlFC+uH5kaiCGk6ZtFKgeX/4+8w6PQtMkuQNJUbx9mHk2SLNtu5uu2yb9VDKmAABRFUEEc3Mc2h44NyouGsqlpCbnMoFsuUwQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm04OB4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm04OB4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC13C3277B;
	Tue,  9 Jul 2024 11:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524315;
	bh=3DWWkFtqYDogTiy2SLQ2Q517nIeKk3sK1cypIKDiKVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hm04OB4tlgKYavQ6J27sVRPfhr8m4fU9rqxSqsKEE54zH2vXXgpwXXOqIY0Z9uMwq
	 DQlorURw3yKNUCX6VSAo6ydDyPTjAYN8o8CAw0Q7YTFUUqKDvpcYpbiFoNfsbV+Dy5
	 GZ8XV7vlxQTIY+LZVmJSxY+44Cct59nfXZTe+r6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Sven Peter <sven@svenpeter.dev>,
	Neal Gompa <neal@gompa.dev>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.9 143/197] Bluetooth: hci_bcm4377: Fix msgid release
Date: Tue,  9 Jul 2024 13:09:57 +0200
Message-ID: <20240709110714.486888062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

commit 897e6120566f1c108b85fefe78d1c1bddfbd5988 upstream.

We are releasing a single msgid, so the order argument to
bitmap_release_region must be zero.

Fixes: 8a06127602de ("Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards")
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_bcm4377.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/hci_bcm4377.c
+++ b/drivers/bluetooth/hci_bcm4377.c
@@ -716,7 +716,7 @@ static void bcm4377_handle_ack(struct bc
 		ring->events[msgid] = NULL;
 	}
 
-	bitmap_release_region(ring->msgids, msgid, ring->n_entries);
+	bitmap_release_region(ring->msgids, msgid, 0);
 
 unlock:
 	spin_unlock_irqrestore(&ring->lock, flags);


