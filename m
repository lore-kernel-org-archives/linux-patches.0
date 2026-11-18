Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044325;
	b=MPv9gZYc7NthVBf2v5//Sz1JShDReYZWNyeUZsuzKBH4bmNbH6r3jfi/pBNOiNUalFrG
	 qN9AxlTyccu8MzkDfdd9AxlYXhd6zYQi9hHrGAQG5QJ7nAFJLk5VNaZ19nzBGDIjwp/SM
	 deW1sIylB8eeRokbnTXVGypWTqbGSC4nX8xfbGmnZjVOhJkKrmdV0WF/8zopaf69tqs0u
	 fhzGa7KUnxuiyFLAH3na4OIYoYlLPO46u6d/nF1llHoq+/qyeJ3uOWntss8jBAOSCHJEX
	 QdMPbWzs7L8gffdLcbMGE5w9yIfNztqpJvJsI1owjCuRFpDZysT4kYeqW30r/qokuHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=io0XZNOA1ZpJRAd1a8GqqditqaU6jsdme2iu/Hb3Xy0=;
	b=PmEpmYT+iQJQWHDk0jRo+Ql0MZx1OjRjcCcujTDNRkGDi7gsa6Thzuxpj3mFtNvsJEud
	 C8gbfY/Wiek1ZcY4Y8UZ2SuRYvOlYFRllvVV7Eqgm0OP6fRRGOThDKho9UjLelZ4Sf5Y0
	 L5JyLWXqN3cxariNVrMfGZbZ0Z5nL1BTXPyxk1uZOC1/pfmAkkWs8S+EJBDWqndbBLBBD
	 Qd2VO8xJRwhEJOq/wj/kOkmWwR9IxoPMxXZ88xAUi4FkNwqFtLV4s8U4x94Nz4wXdS4ti
	 g9b9ZNNwv1fEJgVj2fTcu+gbOoSAOE4RQh9e8WSALM5vw7xhkoZetBpE1+NIbSL+u0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whiEF6di;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B174606A31C;
	Wed, 18 Nov 2026 23:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whiEF6di
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C5F1F000C4;
	Wed, 18 Nov 2026 23:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044325;
	bh=io0XZNOA1ZpJRAd1a8GqqditqaU6jsdme2iu/Hb3Xy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whiEF6diqGuapGvqaDjDqpZ51zqbJaqC8GlNrg8KrRAoAx/VcbW6Tt5IiFLzs0w3F
	 wU6JZwldeIAoqzOfPPpFH6cNImtHF8KdvX8W4qds1DDv+hcBH4j3pepbvOtKRc8gwH
	 TJaEZEipczaGbMn6e3MRIs6gEKgNHd9oczghinU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wendleder <gonsolo@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 0528/2857] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Wed, 18 Nov 2026 15:26:02 +0100
Message-ID: <20261118150220.480697515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Andreas Wendleder <gonsolo@gmail.com>

commit c6c8bc355657115664131b38c53c5ddf7d93b072 upstream.

b43_one_core_detach() frees the struct b43_wldev it is given the bus
device of. b43_bcma_remove() then reads wldev->dev again to free the bus
device, which is a read of freed memory.

b43_ssb_remove() does not have the problem: it takes a copy of wldev->dev
at the start. Do the same here.

Fixes: 96838d61102a ("b43: Fix memory leaks in b43_bus_dev_ssb_init and b43_bus_dev_bcma_init")
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
Link: https://patch.msgid.link/20261013000124.48605-1-gonsolo@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5658,6 +5658,7 @@ static void b43_bcma_remove(struct bcma_
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5672,14 +5673,14 @@ static void b43_bcma_remove(struct bcma_
 		ieee80211_unregister_hw(wl->hw);
 	}
 
-	b43_one_core_detach(wldev->dev);
+	b43_one_core_detach(dev);
 
 	/* Unregister HW RNG driver */
 	b43_rng_exit(wl);
 
 	b43_leds_unregister(wl);
 	ieee80211_free_hw(wl->hw);
-	kfree(wldev->dev);
+	kfree(dev);
 }
 
 static struct bcma_driver b43_bcma_driver = {


