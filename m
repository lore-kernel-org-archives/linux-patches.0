Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023308;
	b=EiH3kOGXtl9np4DE0PwxsgJmYK2BusjkILXt1Ek1yESB1DC6uxznnzBPevbnG1QxH7FJ
	 J95SYdRkOg0ZU8OYyVTkQzFCw1omTmVy7D0/obYfpa2/CIXxUwUSyD7VKC16ybZ5ZIjkO
	 uj6w77a66BJ3X0U56oiBSavRfzQBD1irXo1qmnGiwoDjko9gCU8C7B5htV1Qh0Psnm4LS
	 GoUmoVWnHr31fSEsZ8k8L/kVSgIfGnRq/mTtZrS7p7QLqewGEkjiJ8fzo5bZNJHcRXquX
	 XQIAv3dCLM0XhVDyHPBkcoPrVQKZcJl1vxGHEh+dElAz55ScYWoolm9I0qk/kzAfUlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eX4FThhZ42gW5F8FYeyqFJzJLp01s8zcF7yVHoSD8rU=;
	b=mlBHBGa8RC0NZDWopIT9SDyAGsS6YY/4zEspCGs6GjxixEUtJ3mCZJKaK0SA6XsQcArD
	 kj7c7V3cflwmyrTV8u4Dfi7FswITBv7ub896yj0EKm/CQk69xJ0PVfBb3Yv3uYdhMn4yT
	 5lnQqblkkbch2Gv7RzgyvaaDLfLTrHwYfyvtyz6VZbgLCwx0PFt9w6OmH2uvwT9dfwsB/
	 K6bewkZludubBQ8q6aaBv3DKo1hQfCX2WNmWKr2gqR+Kbx/YLi0SaSSny7lZHGWhYe3S6
	 iQHeOrLedJ6b3VXR0ZaUP104KnaVwVYRSH+ONGALiJY7K5Px7ZJWXOWwplXrAfPxZ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA9wuTeS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99618606A32A;
	Wed, 18 Nov 2026 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AA9wuTeS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E751F000C4;
	Wed, 18 Nov 2026 17:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023308;
	bh=eX4FThhZ42gW5F8FYeyqFJzJLp01s8zcF7yVHoSD8rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AA9wuTeSYbX1pbJYTHgu2au9hIyYBlB1NfXTK65EBmp+OJ3USZzphTgE5DhrTmLFo
	 iE50/djvUDJgiV5p9oM8iYLgX64/fd1Gi7cb9RbpP0OoyFeWoUyBiVnMvi/u/+6JcQ
	 uuogb17RlJkREvnr8vwA5cdYQAj2172BdNuwE0SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0322/2151] power: supply: mm8013: Publish the OF module alias
Date: Wed, 18 Nov 2026 15:34:17 +0100
Message-ID: <20261118150133.687737705@linuxfoundation.org>
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
index 93c50cff31bca..6e6ea1d313732 100644
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



