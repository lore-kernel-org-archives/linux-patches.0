Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217297;
	b=Kex3K0tx6yZQJyRYrKUJBUDLypGZtx1k1rZAK4Niu9cLTEFIdwSVO4zOElbn6Ew3DN9/
	 VY/vxjsie63+WIMM+9iW6DOfYpGKwE85B599CPNt77ccidAnNeBu7WCHG/RPO4BF/4/pV
	 wx4tOL3aGFtK1wD6YvHSbcL6BWUCuXxNX7uA5fi7GAZkL15r2pZ80rKhnr1h64/WBzOEO
	 FfdaUv0fOes1gaQAjqUxQ3EQeNPljyuwlKeSEEaQoYLtDHdyRTU9dwd8nSRcg9M+IayaZ
	 Nh6iQhM/DHkrbws1I04bL8HyYWEpcJXkxgylMVVfVfx+6LM9rFbtUx/g58GqyjkCzMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIecAYwZ43dEsmzcYq6/8haPR3f+8UnaJld/0acLsTo=;
	b=AgmlIzKN7ztdEhQ971n/o0HmkqhwhtkrWZ78fIaJHqK95lXeW0pi/T6xg/U6WiKBuUi+
	 ywmq784wv9oFuHrMOG275NRcSai57AYo7xcjs7P2mI1dkCCiUCyrs97arwbpYZpdJqo5a
	 etiJN9SOQaGlGJh11EXur3H+gF2zjFmxTygj7yBaPfxBHRvOF5/SlkSke6O3uoOFzeUE8
	 x8ZqEo536TdcgYbUWoZhJ+ngUJG0WggdOdqMKGbUjPhMcwDHFEp+K5Rb4AcnbenQjEuXv
	 jJWalsw43Mk+fylbfhP/cJb1u7otSB5DuYjPz7ZVZ2fhbHa8qU7Bszt1szetUSr6hVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/6bQi5p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DBA606A31E;
	Wed, 28 Oct 2026 19:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/6bQi5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A441F01825;
	Wed, 28 Oct 2026 19:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217297;
	bh=zIecAYwZ43dEsmzcYq6/8haPR3f+8UnaJld/0acLsTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/6bQi5ptkyWzFrDIc/U98YAdkqFcSVm25yGekdIQB/pKSolNCu3INJuDJb3MDHa1
	 NBekeXMpVg1f7Gzhffc9K5eDeaFrKeoS1q/2qCsFh8Qh7sWyymjNVTNxYpv3qeGDZy
	 P/LZppWOIIABS+Futq685u1fqvmGs54N7PkCjurE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1855/1887] Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete
Date: Wed, 28 Oct 2026 18:05:51 +0100
Message-ID: <20261028170541.663907976@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5f5fa4cd35f707344f65ce9e225b6528691dbbaa ]

This fixes the condition checking so mgmt_pending_valid is executed
whenever status != -ECANCELED otherwise calling mgmt_pending_free(cmd)
would kfree(cmd) without unlinking it from the list first, leaving a
dangling pointer. Any subsequent list traversal (e.g.,
mgmt_pending_foreach during __mgmt_power_off, or another
mgmt_pending_valid call) would dereference freed memory.

Link: https://lore.kernel.org/linux-bluetooth/20260315132013.75ab40c5@kernel.org/T/#m1418f9c82eeff8510c1beaa21cf53af20db96c06
Fixes: 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index e1c045d1c7887..99226fe3648dc 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5409,7 +5409,7 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 	 * hci_adv_monitors_clear is about to be called which will take care of
 	 * freeing the adv_monitor instances.
 	 */
-	if (status == -ECANCELED && !mgmt_pending_valid(hdev, cmd))
+	if (status == -ECANCELED || !mgmt_pending_valid(hdev, cmd))
 		return;
 
 	monitor = cmd->user_data;
-- 
2.53.0



