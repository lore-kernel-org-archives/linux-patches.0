Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE7924676A;
	Tue, 20 May 2025 13:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749276; cv=none; b=GPeg78VHXJ88FS+gvMk+nhXGOq3RSDZnFzgCAEJ3AeGrAbBTPVP1zIyb5buy69s6gX1P3qkUSLEoRFHhu8XXXuYT0aOcoO6p9CM28LuHlazLCJudes6b9CoLmmXHLqUXuW6gfScLgnCRU0wuIts7xJWrYCQ3+Vb4G64QQuYS678=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749276; c=relaxed/simple;
	bh=NGGNkLP8u1JjTg8eCgVOOmnBT6s1bonr+LQEncJSWgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjXsEiYjKWkjGvn9U5lJbDMGFwpL/ZW2XheizWDLIcgEt6ejJarMyyQnj9AojW8MNb4Dd/TduRULdJpUOhOiA7gD0E8PWGj9iw/46fiQEEdVqcUG6N/9VoHo3Cw19bjkLFX53h7oYRDZl3DY2f7MoOdB0nTFKo7IPzb1eaPljpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSQdsfXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSQdsfXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EB5C4CEEA;
	Tue, 20 May 2025 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749276;
	bh=NGGNkLP8u1JjTg8eCgVOOmnBT6s1bonr+LQEncJSWgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSQdsfXk947nAtfP+KSFAZA9kuPmp05m7RLLDih5ZDPQLcPlblkzAgvVMyb6rDZOR
	 9+5anNiS4CA1ZJhO84xclawVCgfnZD98J6evzRi/KlQ9BaiuUC1sDeOpicm2ZFxMa8
	 gNPqjF2jjrta8+WCKliGEKdqjaEdsynmI61VMa78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	GONG Ruiqi <gongruiqi1@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 51/59] usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()
Date: Tue, 20 May 2025 15:50:42 +0200
Message-ID: <20250520125755.873949941@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GONG Ruiqi <gongruiqi1@huawei.com>

commit b0e525d7a22ea350e75e2aec22e47fcfafa4cacd upstream.

The error handling for the case `con_index == 0` should involve dropping
the pm usage counter, as ucsi_ccg_sync_control() gets it at the
beginning. Fix it.

Cc: stable <stable@kernel.org>
Fixes: e56aac6e5a25 ("usb: typec: fix potential array underflow in ucsi_ccg_sync_control()")
Signed-off-by: GONG Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250107015750.2778646-1-gongruiqi1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Minor context change fixed.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -575,7 +575,7 @@ static int ucsi_ccg_sync_write(struct uc
 				    UCSI_CMD_CONNECTOR_MASK;
 			if (con_index == 0) {
 				ret = -EINVAL;
-				goto unlock;
+				goto err_put;
 			}
 			con = &uc->ucsi->connector[con_index - 1];
 			ucsi_ccg_update_set_new_cam_cmd(uc, con, (u64 *)val);
@@ -591,8 +591,8 @@ static int ucsi_ccg_sync_write(struct uc
 
 err_clear_bit:
 	clear_bit(DEV_CMD_PENDING, &uc->flags);
+err_put:
 	pm_runtime_put_sync(uc->dev);
-unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


