Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212124;
	b=AX6UIIaIWraWnWreTqplWqZ4HW9v/cqLny7SNnR/lHwgNNYW2Ij0gA3eRM2u+96pxwwe
	 ZaqA0zKnBoGx9ppIjSIzWXR4jsF0Hm+KhwquruIUfht7Wg1eoI1yrrRsIshTzpfQrBZBP
	 WBI5aCwifeT48tOioHR769UKmoLTasqfI4zrdAfMZgkI69TQXU79Qud68xpMPVMJVPO4u
	 tI+CWmC97FoNv9QlBkyQ6P9+Eon7H6BlgM0a+QY1N0dfI8nSQlWAEAC2y4UDM+NrY2JwV
	 flXvlr8nvQEtdFgAiSQm6/rQEkIsAI7wUfs10ZnAG3517+QLmtm4k8AQ013MM29Rryg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+1GNoLcL3W0yTFqHXRU36vICFVAt0eTrkQOCzgqOIs=;
	b=H58s769kM9J52bV3pMXwDqkdLNxbyS9FxAXJsFnIET3yvNThrn3Mp2ocaZyNBDYMsRTP
	 q9eNo1qtvyW36cJZ8yNrLcLdwnNywNHqO3I5W5msnHqSF5x5pvJe/KAflRx8YfCPtwCAc
	 RpXQVf5gjJVdRJ3oVZ9fwr45R9v0CN9/oywRCcMCZwS9qfd0orIaj9M/UnUNqJivfZvYs
	 8+xg/ZKqCeoKkrewMQwHPPrqCL//t8eob210W0TV55jCxXqxWOArykbRjy6lQNb6te96o
	 w985+JcDDTln3J4JvMRGDmUgmlCtiK9IbQ5vpMVZctl5Se0EssuHsciYDH/oG4p2M7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZlGiKmN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7F8606A31C;
	Wed, 28 Oct 2026 18:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FZlGiKmN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD0B1F01825;
	Wed, 28 Oct 2026 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212123;
	bh=1+1GNoLcL3W0yTFqHXRU36vICFVAt0eTrkQOCzgqOIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZlGiKmNoSc2Q1llvVCgMuidWnhHtGxXB8F9zxR9Bxz0CbV/slGflvme4koyjUN96
	 URlkQ6bvZqxtYf6iweyKBxuZyPTAdNz/3/Qb058gTKUqsBNPfZvuSkOBqTiP/iyFe8
	 XMmC8xxTKi5nf/UZzi9RsdJwwjuGsQDdkaNSk+kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Xu Rao <raoxu@uniontech.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0045/1887] Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev
Date: Wed, 28 Oct 2026 17:35:41 +0100
Message-ID: <20261028170500.251861744@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit f5a427b16e45210dee656b0860728f3d496dee85 ]

The command and ACL RPMsg endpoints store struct btqcomsmd as their
callback private data. The receive callbacks dereference btq->hdev
without taking an hci_dev reference.

The current teardown order frees the hci_dev before destroying the RPMsg
endpoints in both the hci_register_dev() error path and the driver remove
path. If WCNSS delivers data in that window, the endpoint callback can
run with an already freed hci_dev and pass it to the Bluetooth core.

For qcom_smd endpoints, rpmsg_destroy_ept() closes the channel and clears
the callback under the channel recv_lock. The receive path holds the same
lock while invoking the callback, so destroying the endpoints first both
prevents new callbacks and serializes with any callback already running.

Destroy the command and ACL endpoints before hci_free_dev(). Keep
hci_unregister_dev() first during remove so the HCI core stops issuing
operations before the transport endpoints are shut down. In the full
registration-error cleanup path, return directly after freeing the hci_dev
to avoid falling through to the partial-construction labels and destroying
the endpoints twice.

Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
Fixes: 9a39a927be01 ("Bluetooth: btqcomsmd: Fix a resource leak in error handling paths in the probe function")
Cc: stable@vger.kernel.org
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqcomsmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 88dbb2f3fabf9..4ce8354ebb86b 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -188,7 +188,10 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	return 0;
 
 hci_free_dev:
+	rpmsg_destroy_ept(btq->cmd_channel);
+	rpmsg_destroy_ept(btq->acl_channel);
 	hci_free_dev(hdev);
+	return ret;
 destroy_cmd_channel:
 	rpmsg_destroy_ept(btq->cmd_channel);
 destroy_acl_channel:
@@ -202,10 +205,11 @@ static void btqcomsmd_remove(struct platform_device *pdev)
 	struct btqcomsmd *btq = platform_get_drvdata(pdev);
 
 	hci_unregister_dev(btq->hdev);
-	hci_free_dev(btq->hdev);
 
 	rpmsg_destroy_ept(btq->cmd_channel);
 	rpmsg_destroy_ept(btq->acl_channel);
+
+	hci_free_dev(btq->hdev);
 }
 
 static const struct of_device_id btqcomsmd_of_match[] = {
-- 
2.53.0



