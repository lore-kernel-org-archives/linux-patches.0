Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017822;
	b=RMuQvvfDbLzEvP7OBwPr2prSgBxLK+F3T9VCLZRIkQiO21q7U9NUddvzBb0J+YvewmIO
	 ow3CA4TxVwlF5zb8aJfQXdUVstomwTBX2Yz8dXx2BapJ0mzx2FbGsFIaqZX5SfE0zYi3T
	 z+0vt6IbS2zorsADjNwZQLkgNR4oJt6wY5v53F/uRZPLPZzWXQ7H28j6sxnkRsTWPyf2X
	 adQv7YnHFe4osvPvcKX1G41LLVo1biSGLvdS51skySTkMf0iduoiwegSl4fZmy/5s72ZE
	 8shWvW9Zq6m9WVcwKFbgxoAv+/n/24d8OPABJ6HVaeNsldI9PJOtQjC73GiXRduC+Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9EUuEYNR6d+3QaCIIDcWRf3EIAI3w7an69IIS1Zyujg=;
	b=3P7Rz2wjj5LoE2XkJNdKAK1M6rsn4Y3hjXt+zt6sSw0oJAe1Jj4ozDPqsV1dq93RIFnD
	 jFUw9yeao9bTXcWFAdaaQuksUSPBjT3RvyeJEBIUFuo/mlbyBgxZAI/Kb3VMq/qwxPjGB
	 EH8a5wN0gocUi9hA+MeSudT20vkPFZw+UMWJ8JOIoB6DOSI8Nw9xnHJVq/IPo+c0SA+Ab
	 8iQIejlSpJJo/mhh/lRCibjkvGnm4aIGaVnUfF5nPU6L2jwiWz99QiAEFl1wf5U92PpIE
	 xTIJwBH6YY5PyKgQ3+/I0Hc/TnHOtyhtnaTCvGb6V3bsGG+kT/JMDGrXYl0GUnxRCIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GInjAClY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55218606A31C;
	Wed, 18 Nov 2026 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GInjAClY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C851F000C4;
	Wed, 18 Nov 2026 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017822;
	bh=9EUuEYNR6d+3QaCIIDcWRf3EIAI3w7an69IIS1Zyujg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GInjAClYyJPMqYptpVSzCSenf9QJ3ONrCi+ELUPgE79IyXRRvpNN35E+0Hqtj9pOh
	 nipHfUH42yTLcwVHG5l+2XcwbQoiq+qrAd91hsR6PXdkjLIP32M76tiY0e2MwBFc2K
	 51dJoR9JYeIRS+bJmKcPf5zX61vfyLnkeuRyFXwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1021/2651] media: iris: take core lock when scanning the instance list
Date: Wed, 18 Nov 2026 15:37:41 +0100
Message-ID: <20261118150324.696872369@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 428e6f95e685a06a73868aee95dd94dca7b3a027 ]

iris_check_session_supported() walks core->instances to confirm the
current instance is registered, but does so without holding core->lock.
A concurrent iris_close() takes core->lock and removes a (possibly
different) instance from the list via list_del_init() before freeing it,
so the lockless traversal can follow a freed pointer and dereference it,
resulting in a use-after-free.

Hold core->lock across the list traversal, matching the other iterators
over core->instances such as iris_check_core_mbpf(). The lock is dropped
before iris_check_core_mbpf() is called so the nesting is unchanged.

Fixes: bdbe1cac0c10 ("media: iris: add check whether the video session is supported or not")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vb2.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vb2.c b/drivers/media/platform/qcom/iris/iris_vb2.c
index a2ea2d67f60d0..8faf709c26c12 100644
--- a/drivers/media/platform/qcom/iris/iris_vb2.c
+++ b/drivers/media/platform/qcom/iris/iris_vb2.c
@@ -56,10 +56,14 @@ static int iris_check_session_supported(struct iris_inst *inst)
 	bool found = false;
 	int ret;
 
+	mutex_lock(&core->lock);
 	list_for_each_entry(instance, &core->instances, list) {
-		if (instance == inst)
+		if (instance == inst) {
 			found = true;
+			break;
+		}
 	}
+	mutex_unlock(&core->lock);
 
 	if (!found) {
 		ret = -EINVAL;
-- 
2.53.0



