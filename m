Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060751;
	b=llEJog/Lyv1rhmUR2P17RZQikD3m0KCAeulP47vtu/5sEQEHNqDmNVOfuVwDz6lnPfY/
	 BcgyppXx1gVx6ET7npkIGZb3koCb3aDo0SxAiAdLr2fu6Ba5f6/lu0VOFI3kas+b15Nx7
	 j1ixQnp2AaKEf+dkU7XvznZ+GUDbrzZ0Ab5El5sjNl2IBEjQ5Z1Mt/wiJ/X4z1iFr94oV
	 /oX0zWPx/KYORvvYsER9d/HAdQN6xx2F7qMzwyMBsE6HQJeYs96FeVPzuXG4KrVQiYBL3
	 5jSOsQRpE3j08l8vjAGc+l9i7//8gV6ucOmr3CVASiWtqM5tGrC4wwPmhY232Qti7CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mXG54rltIFtqonIjB7r0l4BQMUfSQfwrQWOMuZ2JoV0=;
	b=d3zIu7fKZ1Jy8pmgLq6Rw7SHfvaXqJwcKEBVtzjecBOUmZh+8eJF4S3lV6FrdFnshvnV
	 bZW5wTvwhDpbJL7BQRoSqqxx9BxiGezfT8Wqz1r9d+9nWfdj2sMDKIO3lDklnNafB2IKg
	 soyCcXSWJUv2dNFj0WrIoWo7bE0ZQYWnfrmc56xE6yiY55MceOlM9kTov/dNAjux58/Bq
	 +2Ka9h0w6uksqo3bCkqFubLHT7MLz0lM+PWaxNbDt+Xl1Pm0wqk7HtODGTH/z4/kEIdTU
	 DFisJn5P1k2LS2HFuKwV7K+5C8NbvWLRqQFEFW+wkQkaOFSKQpjwCb7Jj7TnbzUFMcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eL9ZJkDa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F225606A32E;
	Sat,  7 Nov 2026 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eL9ZJkDa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70B31F0089F;
	Sat,  7 Nov 2026 14:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060751;
	bh=mXG54rltIFtqonIjB7r0l4BQMUfSQfwrQWOMuZ2JoV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eL9ZJkDa2Y8GJ1pdXoMrtGVLOfetiLFBOcQpL+/o//xfbRrQWvCSn8YG/qmpKOoZG
	 CuMWeUlWDKo+R3159yO/QE6mcAKFXfuZKmLnWzLFhIYGCBJhH+KTq0WomSzfWonh7Q
	 MAlaxy6awkFoAupT+5Ov3R/XLSboILZWd+zdQ8hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jurison Murati <eng.juri@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0126/1536] media: i2c: ov8865: Drop the runtime PM usage count on stream failure
Date: Sat,  7 Nov 2026 08:35:42 -0500
Message-ID: <20261107135001.226777890@linuxfoundation.org>
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

From: Jurison Murati <eng.juri@gmail.com>

[ Upstream commit 3fe797a12bfa9a49aa998ee722e5f25c957b9b15 ]

ov8865_s_stream() takes a runtime PM reference when enabling the
stream, but returns without releasing it if ov8865_sw_standby()
fails, leaving the reference unbalanced and the sensor powered
indefinitely. The same applies to a failure while disabling the
stream, in which case the reference acquired at stream start is
never dropped.

Drop the reference in a single place, both when disabling the
stream and on failure, and only update the streaming state on
success.

Signed-off-by: Jurison Murati <eng.juri@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov8865.c b/drivers/media/i2c/ov8865.c
index 95ffe7536aa6a..1f95c5327d0f3 100644
--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2629,15 +2629,13 @@ static int ov8865_s_stream(struct v4l2_subdev *subdev, int enable)
 	ret = ov8865_sw_standby(sensor, !enable);
 	mutex_unlock(&sensor->mutex);
 
-	if (ret)
-		return ret;
-
-	state->streaming = !!enable;
-
-	if (!enable)
+	if (ret || !enable)
 		pm_runtime_put(sensor->dev);
 
-	return 0;
+	if (!ret)
+		state->streaming = enable;
+
+	return ret;
 }
 
 static const struct v4l2_subdev_video_ops ov8865_subdev_video_ops = {
-- 
2.53.0



