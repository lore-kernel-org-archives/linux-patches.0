Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059548;
	b=fnd7Z1K8K7yk4E2H/+Ipge7IcdgCEEv6XuryfZlVPofnNHUtYJYJ2W18Pkmyd1b3toAo
	 nwIelceTjP9yoqfiI2s9SuWeD1uPJhrUar7MmpRi5CjAdk4aisLTT1wydrQwAxhAOplGm
	 9P0UE3l7wrfanf+VLfpUk2dW8IxaNhgeRvgPXKA8i6k1jGflxDQglVTg66awY/8R+QorO
	 HS4130JWqFhL94jiz2OVPVzmmvVcHXwC7WOwgQtLV7d0XdNjM9EO5na8Tohjx3icBRYI8
	 Ame57WpZ9Acu6jgC7Js4CTobY01VjjoQPyDtHZniENooh2xBV9otKHNd1SuKcGHL+/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+QQ0kahpUtyaU4ltYn4oBm3OzN6wOE5znQtja85Fls=;
	b=rV3hsUbtG7lt4gYQrhDk+dQzbnKrHkvt94HnJFnvdELV4eAzr7iRgv+r1skh7pYbpczm
	 N4sjeLrju3IPdh3nutuh2y4SakQzZi1l49+BAQFK8Nvild4DlnS+VzngZpmrtXDzx1VuX
	 o76Vic7T90RqOV0PF04MTAEERnd7JGPySNSQuSXzJ5HlZK6eoYl1VCbiFM1WdQTu+WrR9
	 UI13atV6IX9kSuxnKE0tBoVlxVFsahYwPt6UChKG1vUINEoJ1gRRW/o/+mTjPnSGqvFo7
	 bMqUjzNKG5XG7tpd0jISl2m1f2m/dinYtFXRnCTyHbWLJTf5S4kvf7Sp9HhlPsZ2zsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYjBudQ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0E1606A320;
	Thu, 19 Nov 2026 03:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYjBudQ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3611F000C4;
	Thu, 19 Nov 2026 03:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059547;
	bh=v+QQ0kahpUtyaU4ltYn4oBm3OzN6wOE5znQtja85Fls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYjBudQ1gmkqS1r9nas2EHbSQgBZMnEesQ9Om1wZ4Ud8elcfsaXTunIEcAiQs2Y4Q
	 p25yz+8Qft/9nn7oHI+UCYt6mSNlUgZ9I4cmyY+4lyFbMc2I6rs+4PAkpUZ9tCWzuH
	 zFSxCwntdXJRoF1NieBtYhdNUgk3UFiWSyXJd1KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0880/1848] mfd: twl-core: Use i2c_check_functionality as boolean value
Date: Wed, 18 Nov 2026 15:48:38 +0100
Message-ID: <20261118145953.219112290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 7ee4fa2674e51a0d100b9240cd8a50355141362f ]

i2c_check_functionality() returns a boolean status rather than an error
code - directly use it as a boolean value.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260505114543.159381-2-thorsten.blum@linux.dev
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 3c5c55d979dd ("mfd: twl-core: Unregister the auxiliary platform device on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/twl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 718ae54f4d6f6..d5e588c68c0c5 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -791,7 +791,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return status;
 	}
 
-	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
 		status = -EIO;
 		goto free;
-- 
2.53.0



