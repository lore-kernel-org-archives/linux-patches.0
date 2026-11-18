Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015870;
	b=CCVgV3U6aD+GGrgyYWykYmSZeJIw3zOFbwQDYVkptysVEO6Fe9hhOPtqjvtTmFIMoNWm
	 0bcoqZsGi1+QmMpqvZHfy50/uX4hAWEbb/qQ6kFMBw1uLfMkiksINV0bmHWCZe2RMQbls
	 M/oK5V/MdFjUVvp0I/meSUpJxhWsKV+JNSbWuf+pu9ISJepLYHKS6PFRUga+GO2FkR2B4
	 7PBxIvP5xtX/MEsI31+IVyo5IIm0kMhqVvjDkLYxwm9hVvrgcdeL31D7Sxb54BqaO1uqo
	 6S2ITRXCrG+6LMSg+VIFTGLBN2Q+FRtr2AvwdT9fffZ7TaecsLH+Gnghmg/DzX1eSpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aQ+Rv8ssC1ZsKzG+HwfAttYwqNyxRau4l94icYGW0H4=;
	b=Ba7/HYvWnzD5+16x9NO4QCrwz86HyYDP6+okI7VRz1SXPawRO/6N5QREbZSQJp9aUykE
	 7Ra5yz5N9kJrj2lLCYKinUqQEWqx7Vd0bZN3idD6dWz/Evsm3Q1fe3DqW3r46KxeQKQq8
	 XZMdw0h0THYz2tSSHlJL+MLWt/yYTMvdQNiLXNc0hg36VUW+j9j5akxG2qLBC1+p1dSY5
	 AMrlnjtbXLQalv/Whe8soFBbZWs/V3e+draZWbvMbF/PVT1RQGCZoA3bw/hLVOedBIufF
	 eBqykRow9sv0ctyt6W5leh2DQhY8LGWMiA0/W26+gzMxB1KuDZwhEq3+i7oRDR5CRsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNzlSGd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1001260A261D;
	Wed, 18 Nov 2026 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WNzlSGd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5128D1F000C4;
	Wed, 18 Nov 2026 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015869;
	bh=aQ+Rv8ssC1ZsKzG+HwfAttYwqNyxRau4l94icYGW0H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNzlSGd8k4aKynlou06hTJ1KaA/eLtOOyL0US9cAMHErLgegyq7QSwAafsBUnFEqo
	 RtNI9kJy2XIuKV7XSjg/5MGKvg3Ig8pqJws4SzeWOxqtovE4uaa8Xam99AE6F2n3G4
	 9io3mDrEFZu6LebIATH8OynaCAemLZVdBXqAj2QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0326/2651] power: supply: mm8013: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:26:06 +0100
Message-ID: <20261118150259.599986480@linuxfoundation.org>
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

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit f265940e54d749c77507da083a3c16a481f5f5c5 ]

The MM8013 driver matches mitsumi,mm8013 Device Tree clients, but
exports only its legacy I2C ID table. The I2C core emits an OF modalias
for these clients rather than i2c:mm8013.

Publish the existing OF match table without changing gauge operations.

Fixes: c75f4bf6800b ("power: supply: Introduce MM8013 fuel gauge driver")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905134500.67832-1-hppiscas@163.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/mm8013.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/mm8013.c b/drivers/power/supply/mm8013.c
index 819667a27cad4..c38f48338d42a 100644
--- a/drivers/power/supply/mm8013.c
+++ b/drivers/power/supply/mm8013.c
@@ -293,6 +293,7 @@ static const struct of_device_id mm8013_match_table[] = {
 	{ .compatible = "mitsumi,mm8013" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mm8013_match_table);
 
 static struct i2c_driver mm8013_i2c_driver = {
 	.probe = mm8013_probe,
-- 
2.53.0



