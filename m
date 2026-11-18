Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024859;
	b=wS16cVuTxEa18cmkvmsSc7E28PVaFgyZQrh6JZyTKwqHglxoA3lN5PKqKVukLzMgSqPd
	 Lm9f2jNerMQXrh5aYTArCxPZdA03g7/AFsyyMWgVQ+AkaRpgYHn+VgYCxxpOMVqdQE1Yc
	 2y+83ZJYerj5SudAtD/3ZMc2Xl9m4QFIGX7rXFg4EC8919cfli9ndqBaCq2ZP9OYzmn+d
	 j4Yjg2qlAPuKG8UcPog8g8wPgF7foJp1CL/aCyELNNYgF8CtU+9vwr3216XtkxXB7TXsw
	 GFIgDQ7tFcfRFiY6ucs+b3a2xT4RtiJfR4LiLdTnNWm/Wk7s+UAH42i555yCXPJzD8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6hMBUV+DQEBcfYdlIM27dISbixCW/Y7Xz613B8/2BSo=;
	b=i7q2b7ew3EftKxZrWxWlr0eTV2ReeYNS3CyOeuq7j9TDpO1YtWXtw60ukUeY1x74g0R7
	 5cLuKgV2XVvYi6NjMzqktFFzosHPznSim/2hFONepXHwN56kDkaTLqPmgSBWgEjbQw0k4
	 EeHRv43fVuRldOPZHMwmQlrvwmfgOJIst04zWHp28oZoVHOp8Fc8n9hvRN963/QVLldvH
	 i3F6YByJQIru3BjOzZeCvhRIMkWA/XCAfSoxNyOD2xMbS+l8llnli6cZUvnVtK07q2L4v
	 +H95nF7HKyxmHZWh5bFLLoHQ8QFn+0+vX33d+f46Qut9T/QIq/JFvFgShCe1vJQ28Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOKRXUtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B11606A31C;
	Wed, 18 Nov 2026 18:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOKRXUtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7B91F000C4;
	Wed, 18 Nov 2026 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024858;
	bh=6hMBUV+DQEBcfYdlIM27dISbixCW/Y7Xz613B8/2BSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOKRXUtWYgdizFbZ1yl4G52a6CrB8Wpj62QHdHVBA1S8W5fkmxRyYML9eC69Ij3F2
	 0ju6RUA1MQgUzj1zeVU+NNd+iF7l3uwGr+bk5ybXx6UWGZzqpfFfNwUKd2fJXf8Gt+
	 HazBYo58Ftb2JZVdS85/TfE7kQnZns0Cca//lkeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0867/2151] media: iris: take core lock when scanning the instance list
Date: Wed, 18 Nov 2026 15:43:22 +0100
Message-ID: <20261118150153.794020934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bf0b8400996ec..6cc50750be716 100644
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



