Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208183;
	b=z7CzlBmlUtv5I9lgt8SiLF6wuSJB489+VhVeRJWAdNyzFyoCIx7PhX4L6JAUykxS5Kv3
	 WhZ5h5ckHqOiUlgt4BM2gC0692gJIzrCF/kvu0Js1GGapaVTVyFEH6OeQiJa44f35/tMK
	 N+8jF4l7JNiy6HS5iGcnPpbefsPFu6qPBruVmiZhcxVlFGKMu21SGaEA1wEmoy8sjzd8a
	 oSCYONWmr7wEurqEjYnNUg+lWldrwVDACkjD3eRuiq/qIM1JHzCQf9kV7Tex9e0HdU6XC
	 D4Y1ObSixfsr7H885LdbpKXWnVF9jxBI5DBsKZ5inCiYK0FOHMK6cKe5nv21EZtF0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/UAf/Kgq9H/h+vOgD7i1MnqBFVCxmR3DNtpDF1Jm50Y=;
	b=YYBKmBgDKkHs2SwxpLxYyLpgsLHjNyeKnepwyrXh/lumEtYgzCT9ScHRpUMr9/xuylYO
	 WcDQXSanF98+sO7E+Z3eTxo6XKPUKVff59aoY/Qxo0ojiH3s/Y6gX+SnRGttTW2rEIo//
	 MBga4AiH4QE7nxmpMgPOd4MbH1n866YcVe/4uOKl3kd8KKswMoiWmM/VXqIhMRJ9YJI/T
	 ZcNd4jWrG41P8yhlW3dKgpU7TVqN5+geWtsBDv4ezSDWCNj1OEQ0iHnCnq8O2FjzHfOVl
	 vu6MEKGbeYxVxyVCepaxDuXAToYAHitfMZEDxgGh4oKXCHNEAzSxoXguZrflM4u9dAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6pv1ZDh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA6606A31C;
	Wed, 28 Oct 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6pv1ZDh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDC41F01825;
	Wed, 28 Oct 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208183;
	bh=/UAf/Kgq9H/h+vOgD7i1MnqBFVCxmR3DNtpDF1Jm50Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6pv1ZDhygfe39Tl5aG/cqrnAb1KuK6l4bj2wJdtzLjhfvL0ZXjCUtF7hC0KcFVk8
	 44kcbHhhOVPICH04SLQp96ShJxQKAoctG8WDtl0QaE0CQLEWN3F4bApbLQB7XdPtLI
	 4nnvoeS5PLDLh1IpWd2Iqv5DAXKu9ESL+wSPXhbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Xu Rao <raoxu@uniontech.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/516] Bluetooth: btqcomsmd: destroy RPMsg endpoints before freeing hci_dev
Date: Wed, 28 Oct 2026 17:53:02 +0100
Message-ID: <20261028170004.242013546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



