Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210447;
	b=HNH33GSz2jU3CT0T2CTMeU7K0D1MVc/GTfC32xNkfElGk/FkNPzhSbhxuGDw/zkMDzX/
	 K/6dlbBe1/knR6dWk0nz45amDHqBMzgrpbvUQgYEeRxosEDiPBa8excBbFuohbh0tGFGG
	 cEVZZX3qenbgPhhhnPBTRy2UZnJjwJ4ejJOgTbc1dJiUregA5qdU2rwjamHW0+BPouhoZ
	 0AWuzWk967wlSifPmFynSu1KXuDwhUSu7CIktEr2Kn0bj1xBArTnKckXYObXKCSmGVnmR
	 DwlFW+/HQ+SPfEksTQEfkyU/vlBVhHLkiU/I1Rpi/pMx8rEdkm84/hv1+IXU0LT23yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5rqKJnuxe4fgJUweHWn7iZXggJTu0FRLYfLgDFOdm8=;
	b=NorE6fjSJh/gIB+oNyHKQLdA78qPpPFTu5SLDf3oYGHuVJNxt7C+eHsII21iN9+ED/Ab
	 SCDM57WwOcx9auJ4VJgnGSrt8OcTTM/X/VPVH0Df2PCp+eCsoQCOxemkg+6lk5664nNv+
	 K8Ee8l9iV3cQEIWIs6gBVO5K/t4cj35T5geuFUResFe73AH5TmNGzV4NdLxoGgSnzzeEn
	 AEYLegttjjO+AFE4kA/B5XyZ1ohV2qZYVa8O0n3eu8/cCRdhsjRQxL+wNv1szUx0J56/w
	 5cKnuJDon2Zl0TzHuWPJ2BggvNmsZcAM5AAqdzAxmUjhhDbr1CLxPTsBimfasUhSwmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FLuQCU9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A76606A31A;
	Wed, 28 Oct 2026 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0FLuQCU9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D001F01825;
	Wed, 28 Oct 2026 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210446;
	bh=e5rqKJnuxe4fgJUweHWn7iZXggJTu0FRLYfLgDFOdm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FLuQCU9KEPSNtE27GqvB7F44BIYo7kXgWvjSUbHU8wg50/GjLeM9aPD8up31/9Yv
	 gbBfDiePP4q5Tb7T+Ncnbur5FHjWCBvRKoCu9VvgiyADwMXwPs2e1OycNupbBX1Qy6
	 NAcvslqiAGr927ha3ej0Lkts4/oAlgKTz2qREvWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Xu Rao <raoxu@uniontech.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/571] Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev
Date: Wed, 28 Oct 2026 17:52:56 +0100
Message-ID: <20261028170008.714212059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



