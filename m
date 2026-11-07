Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061511;
	b=Yf98zb41o02RTRgm7kM0hyFeKdpDMseCSGiVK5vsqcfVia/LMzB+YzG7ChIz5hqn6EQh
	 JViW656E4dG5evxk6UNTBxLSNvh5DUciEm+2MCkHVcNTFowHy8+spr/ttBHJs1f64B3NA
	 IR87hWwBYGhWNDzWK5n4umW1vX7yd8QZ7/VBFqliqcnbl4AvPys+X4iTpuUc2T2Deb28P
	 Iz0Mi8Qm5rYahQXb1hQQe2pt3TUsNFmBi1p7eQY++KY5B/p2/L1GnoYACbr8CgdtaJOa8
	 aHLDfK1cK50rPc9FDFz6OfImKjs7VOMpLTeSJoExuKRxmWzKNpjjcQhok8EbnglbPzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNuw9bQRMzI/HjX6HG5JB9R+is9U/1f5fcbaZrfRT9k=;
	b=Ody5eMNvkuDECfA5ylOfcg1Huz1MGpOqeliZkIecGdL25LYfksxpVNl3RDcfBhLG7XWu
	 PG0Y0hAZhppsIOqLFdE1KnA4J3PVns/aLgjSAIHm7FHp7l0gHLeM0kC2kJdzHjpw6qpgT
	 mmsL5ziq8fiOTyTg9LuCoecw5zW7KL9C3M3nJaWymKizJZnrmh9nchPdiy/p8XtJmR/X4
	 8tlgvLBjnj1WocS9EOGX7gWfn6XTs5kyPTORaM/jNAjWsISb9RJKrK438jTEz/a6wR6Vx
	 OG11r3aJyFhG9SxrH55Gl6FBdyQz4RWl22VWDA1BT33c6rhMfAl9PECSvUZywdFd/rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eXz1q/r0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E21606A336;
	Sat,  7 Nov 2026 14:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXz1q/r0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19431F0089F;
	Sat,  7 Nov 2026 14:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061511;
	bh=dNuw9bQRMzI/HjX6HG5JB9R+is9U/1f5fcbaZrfRT9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXz1q/r0dxC0Izl0GBXA0I6KUmeQfzt7b40N/XNt38VHAtDh/rSwFrKDbq1a3kszk
	 ohVqyEz2GhrbDZH4QklKzqbN2iKyGTVbq2zOJcCdXu6mctzKOoeEpDLsQnv6gCSHhX
	 U+Ms/WtUMndKfnfqH+cpPJjBStifaT5HoDLjGLpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Wendleder <gonsolo@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 0602/1536] wifi: b43: fix use-after-free in b43_bcma_remove()
Date: Sat,  7 Nov 2026 08:43:38 -0500
Message-ID: <20261107135014.450958917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5663,6 +5663,7 @@ static void b43_bcma_remove(struct bcma_
 {
 	struct b43_wldev *wldev = bcma_get_drvdata(core);
 	struct b43_wl *wl = wldev->wl;
+	struct b43_bus_dev *dev = wldev->dev;
 
 	/* We must cancel any work here before unregistering from ieee80211,
 	 * as the ieee80211 unreg will destroy the workqueue. */
@@ -5677,14 +5678,14 @@ static void b43_bcma_remove(struct bcma_
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


