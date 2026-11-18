Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038682;
	b=MlV/nX9BeJU5/2+LG7bkAd+KwkOsGwvoeyN/iv93w6SxTH1wrScSzf88zD5pZdVq9a80
	 JkKKvS0/9GSeOyqCwZIhqOhC5aK9F4t9sJUNXxxDClTu1k0rjeueDqaf71YrrmpLz46/I
	 gZZHYZ2V8q218gzptn5NH5lxwgqFhlIDNfLtl2e9wGzmitrH7itvXSUdyfxqwVF5hNeAB
	 +a5fgjWm8X3QY/UEgStS+gIdqgaVvzMDo+VhT4LtA5l9hM/p+kH1ZFizpEoU0OBR9MakR
	 k4u5/kVIN+y0X5ykUNUKklggTcry1sWEPCTTo1vj4C5SajznaGly1G36gA7vXfRBRPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MoBw2HkFH8m1tlExhGgEAOVEczK4BBhbqBwTXc4BZm0=;
	b=S9LXP1RbXuEmDrL6m8CFhPO7jZb8+Znu15NpYHflffbcGWg0/Plnx8uCcDZ1gDaI0XBj
	 MqcatXuKNUMpSKrImVutoBklr4uv5WQnETrqG4xtF21s2EOi1GdRjuhICaMBkW5MWx0cP
	 PzGXmj3DoATpTR7qnFtqrafRDRkBy+R9/q1UeqvkeZpFRlyfx/PpwwxhJwZY7lLkrCWG8
	 MnETylr6rpyuMc8iiOoqO2rUcMgPKEAdqvtndpqNgnYuNZZv9s8XX8g1ucn7Kxdg2Us8a
	 +GM5w5bNiot9M4BHhgpwXgrVwnFFUVnnPTlSwrJfNhR/UD3nvQnt1XIeiQ33U79rUKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFgspW1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0453606A325;
	Wed, 18 Nov 2026 21:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFgspW1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EE91F000C4;
	Wed, 18 Nov 2026 21:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038682;
	bh=MoBw2HkFH8m1tlExhGgEAOVEczK4BBhbqBwTXc4BZm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFgspW1br2CwycxUhKiNLRWiOq0WE7yxNwhhD/0QNvPRM2nOMJAthLIeU+OI1tjbM
	 uyOEjMGh8pqBkJMZW3CuQ1Do6tBIydoYsPONmJImqjshgQyzgd1e/YPZPeZwEYLttB
	 VlCKEmnZaXTOrzXb3vOwkj+DZMZjx9xVKEBAWGgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1788/3318] media: qcom: camss: Propagate vfe_reset error up the callstack
Date: Wed, 18 Nov 2026 15:40:10 +0100
Message-ID: <20261118150415.498317747@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 5c07f30bed52ed85673b634f77467e404645785d ]

A previous patch I had removed the returns from vfe_disable() since we
didn't trap any meaningful errors. Konrad pointed out vfe_reset() could
return an error, which is true.

Trap the vfe_reset() error code and throw it up the callstack.

Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: e5d4b0e69a40 ("media: qcom: camss: vfe: Fix VFE reset while another line is streaming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 17dc713b43cd7..f4a4f0fda45db 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -432,8 +432,11 @@ static int vfe_disable_output(struct vfe_line *line)
 int vfe_disable(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
+	int ret;
 
-	vfe_disable_output(line);
+	ret = vfe_disable_output(line);
+	if (ret)
+		goto error;
 
 	vfe_put_output(line);
 
@@ -443,7 +446,8 @@ int vfe_disable(struct vfe_line *line)
 
 	mutex_unlock(&vfe->stream_lock);
 
-	return 0;
+error:
+	return ret;
 }
 
 /**
-- 
2.53.0



