Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039790;
	b=tAtsH443PqaYBWlCYkVXd2H1Olk2PElrV3aw2koVOu+8+bfH2uBbdHv6LLZqvWfne3Te
	 Bshx7sZjeORQVTlsW61afriYjKgBrBmFVeIowkopMgC1NxTrp6Q+9j1/Eat2+4OeW89kR
	 XTwJcbnn+hmxbRawbD+6r7zMrJ4ErMGcfxS/sCmOOpYYhQJVs2emOOGpcbZ3LUkCzguMH
	 Ceud/Ft8Rc7Ixaq7N3QebR9Vm2aJ0a2ly1lCbWTdrCXAjOuy5IvTuGFTXCYQet4emGox6
	 /vRWQJmoWMH2KFbRdeQ34Yzm70HOhvEiYx4/49xVkxB9X4faVB3b3KUo/3E2Nn7L37g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EfpN1KzrfYTonjyVbMDtn00P/6xoQ0awnm3APs3DA6U=;
	b=AQ66uvbjI1PsUTFHsnINb4iqETJ5KYteebcsTLeZPpXJhG3kbvUV2sdI+F5ABn+S3Gah
	 CLdgGZvoSI1Vxu0Iv68UsodVBFm1SNQAC2ZavIqoxCVc9eLXYBB5zQ4PP8+oUtCL6330V
	 ItQVZzekbkQoVVpo44tSMPTt+qE8Ss4FcYgSVDQTux/FPjUXLzF+Yl+jdC5kXzeuu1o18
	 lbi+TLbOFcc8UHzrCe9xb35uEqvEqOLqEiBCGLu5yhpqt1+m0rmNQgtmRU8vqIDaHNUlv
	 MFxXmxqx771BvzbeLTd84BOiYYKZ9IACGjtairp6nHqblWFXJOerBc/Xx9cW0nH6Gmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y/qLxBVd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F8606A32A;
	Wed, 18 Nov 2026 22:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y/qLxBVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965391F000C4;
	Wed, 18 Nov 2026 22:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039790;
	bh=EfpN1KzrfYTonjyVbMDtn00P/6xoQ0awnm3APs3DA6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/qLxBVdUw18onTrtDwoU5xfG00WjhNmXHuRfNCIr+RAW+ZObClNktPCi4Ceik5qa
	 06CQVGIMByE3XsiXUhA2JTZpBvuSs/OWx4cj43l5gME0/Sz1c3gsobz1e5kGIh/0tY
	 p+AzsQkwqToToznTPKFO4IK0POQRmFNVj/z1RfjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2224/3318] media: i2c: ar0521: remove duplicate media entity cleanup
Date: Wed, 18 Nov 2026 15:47:26 +0100
Message-ID: <20261118150428.607664346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 069a0343581bfcaee44bc598e2b95be2e2789807 ]

The error path taken when ar0521_power_on() fails calls
media_entity_cleanup() at the disable label and then falls through to
the entity_cleanup label, where media_entity_cleanup() is called again.

There is no need to clean up the media entity twice. Remove the first
call and let all error paths converge on the common entity_cleanup
label.

This issue was found by manual code inspection.

Fixes: 852b50aeed15 ("media: On Semi AR0521 sensor driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ar0521.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ar0521.c b/drivers/media/i2c/ar0521.c
index 60ab433cafb11..5bbf776e20c21 100644
--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -1159,7 +1159,6 @@ static int ar0521_probe(struct i2c_client *client)
 
 disable:
 	v4l2_async_unregister_subdev(&sensor->sd);
-	media_entity_cleanup(&sensor->sd.entity);
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-- 
2.53.0



