Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829284;
	b=Mrwb0TUIWls6tK2mXO2Gk9JIhE40HFr0b7PXbafDKxitKz2lfexx1zCN4SOAtDU7kKr8
	 mhTCbaJzXVPLP50uOitQZ23XQdN0RXD8asVuS2VlOGdfWjaPI9xUQ9CBzK+EdgiaFg3fC
	 rNGwRdMTCgA9XxWmxK7YnKJOU6EgQb3MAIqs0t/8Nnv3/DZB+KjTvZAUP2C6khtlwk+hI
	 fy1s7W0kM4JPiIqaLvGHj3FzxeiIZS3bb6zVq5h1beWWUDS52471bTYWHkIGhVpDegXeR
	 VfUDpY33znSQRvcRvBkrr+V7S8wvPdNZdC32jVvdXMmgUP54dYO6lJS/W6UqcYJ933A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f67xlcSibeLLcYREfO8oSPkVzLtpb5LeEKIdZUFh6B4=;
	b=ONb6/qC7MTvqMw8EBdGeuzyR6OCzlHjAdScqru5HpMIB7f+WDD0dqKP42gNnN99yrB1u
	 bl6/BpP9OrilzTPKZuQLOGRpjMeDLA04ad6emla22gee1tgzYYsIOLeAd1VIwHf3w07cB
	 X8O8QNv5PsoTzN4FJ/OzwfWNndeP1qqlbEa3oP8tT+7/RThU/8JRGvjVddgWJKPuidq4e
	 McjyGxj4sGNiTERm0rC9iSuxSxCiLlVVaMiR+sfRBYzlUzRdD59hFlO3prdIBv0shIjIb
	 PGu94zyiYRLFVbW4IgUT1a4EhQSDv7J6J3KFI9RI++DGUhpykvYOhwtTmZIA835b2mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UzgPFdqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EAC60745A8;
	Wed,  4 Nov 2026 21:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UzgPFdqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087391F0093A;
	Wed,  4 Nov 2026 21:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829284;
	bh=f67xlcSibeLLcYREfO8oSPkVzLtpb5LeEKIdZUFh6B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzgPFdqw04y+zomKoz8rgxOJAb/iIR5RSX4LWFdW1gZU+LlF/H79JbfYdALs6MXvM
	 9M4f7KqwABi2paFIrXlL2A/vxdd8GAxbrcFkPMcbSpmZl8hyQkOJIHAZW3lvMhNREt
	 aorBuhfaC3L7N/DHRXHUUoWnQ6ZSRDy/HiMS0IX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kry=C5=A1tof=20=C4=8Cern=C3=BD?= <cleverline1mc@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0028/1005] w1: ds2482: add OF device match table
Date: Wed,  4 Nov 2026 15:56:01 -0500
Message-ID: <20261104211044.347819122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kryštof Černý <cleverline1mc@gmail.com>

[ Upstream commit 53f33fd74d3993af0fbb5494b5be709f6ca6b712 ]

Add an of_device_id table and hook it into the i2c driver so the
ds2482/ds2484 can be matched and auto-probed from Device Tree.

This allows automatic module loading when instantiated via DT.

Signed-off-by: Kryštof Černý <cleverline1mc@gmail.com>
Link: https://patch.msgid.link/20260612-w1-of-autoload-v1-1-74e8a17626e6@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/w1/masters/ds2482.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index 0c93bf338a6ef..e91c7b0f3617c 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -549,9 +549,17 @@ static const struct i2c_device_id ds2482_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ds2482_id);
 
+static const struct of_device_id ds2482_of_match[] = {
+	{ .compatible = "maxim,ds2482", },
+	{ .compatible = "maxim,ds2484", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds2482_of_match);
+
 static struct i2c_driver ds2482_driver = {
 	.driver = {
 		.name	= "ds2482",
+		.of_match_table  = ds2482_of_match,
 	},
 	.probe		= ds2482_probe,
 	.remove		= ds2482_remove,
-- 
2.53.0



