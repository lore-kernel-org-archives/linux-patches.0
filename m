Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052416;
	b=bZG+rHxE4GTd8pRh8g67AYgxLJCkXw5gqcdxzmLAdKeTFtsmoiGFuKNqNtHo+1JFAqhp
	 CQoNkwK9c1T5RJeTaTQmwTcj/HaZ5wE9JZTYv5E91Nm1uk1GaSr072b8lCE7TJKMVNra7
	 KQ+ZSSCouQLF8pgqJ4qt0k5whT25WFPwwKtUXfXQg28NgW693BG/JabzcJ4LMiUAWO+9F
	 FMU9uhFVLM64OGs2YxpplR5U0H6sntRVfwJ0j9ZTLm1f+jAE1ZOeWBE0TOFuuHsvMWGL2
	 7kUbdou/7jmu9Im5RbYfXR7rLstYkV5J5x3X5sbebjorNF3RbN2vUWdadzJt2hbxpPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jz3r4kS1cSH/rtUTHQi+KP03DLZu+FvxeNEJllxz/bc=;
	b=dISSD9wKjkF1aPmezGbizZk18q/vJ34HM+XZZAWDHW3sXFIg8SgWGoT/a6Mfe/mjE/Rb
	 qC+xu2zLx05DyCHp+6v7PKQoe4tbFA99LMc0o7G8ENtTg+01Hlw15odsycthRBXv9nJd/
	 6vkiInanusAtVQan9G2vXyr+DnOcp7ILq95nzWkvSOm0zq4x1b4Cy2nuRFgq0FFAZCyDM
	 QWYfKTHhlOKh26QiTD9/9ZyR0Qw8RDERWVC2Q7L5WQ9SpKNr5JvEKqnBMCFHfqrdh8jZz
	 p7yegcJYsyXP2tCGa12h0j1EwFUVDIHyqCYv57jP/cswGdE3ZY5LZ5oce0vUCpru0lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RY1Kih6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22C7606A32F;
	Thu, 19 Nov 2026 01:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RY1Kih6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290C31F000C9;
	Thu, 19 Nov 2026 01:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052416;
	bh=Jz3r4kS1cSH/rtUTHQi+KP03DLZu+FvxeNEJllxz/bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RY1Kih6gClo8qd+HJFWfDgw2STKwyw5lh/pONqFy9+NtdnCRZnRCh9r0v4GY1KxQO
	 k/Qbomzkyzs7QP2p7x4IRXYECrKvD+L2qgznnqkuMnx5fVZwaV30W9kHExis04zV8g
	 x8uVIzBnToPrkM4XnI6XleS/OX3zerZKB0kUzsuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0555/2214] media: pvrusb2: Fix USB parent device leak in class_dev_create()
Date: Wed, 18 Nov 2026 15:37:11 +0100
Message-ID: <20261118150033.219006070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 02421d7278e4a62c3daf37ad6c45d4af96ee4252 ]

class_dev_create() stores a reference to the USB device obtained with
get_device() in class_dev->parent, which class_dev_destroy() releases.
When device_register() fails the function only drops class_dev, so the
reference to the USB parent device is never released.

Drop the parent reference on the failure path as well.

Fixes: 28c4a5e6d324 ("V4L/DVB: pvrusb2: Fix USB parent device reference count")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
index 3e42e209be374..e638c49b77b2a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
@@ -641,6 +641,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	if (ret) {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "device_register failed");
+		put_device(class_dev->parent);
 		put_device(class_dev);
 		return;
 	}
-- 
2.53.0



