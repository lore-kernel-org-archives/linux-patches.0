Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A16C27A917;
	Tue, 26 Aug 2025 11:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207175; cv=none; b=e3mF4EeBQAY1kLWd9MyjPvxWf2dCtIrFXwW6MmxjPl4amdgIe8njwF6k+LeYS+OUQy2yBMti8j2vUzxKZUEt7EDwIq941fDpGouajpWDas4v0cSNf4nFL7Gjwy1UcpVBIstA6nUZg9Y8seNhuEUj8k6zMJoIDc7g2xoI4KG4XhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207175; c=relaxed/simple;
	bh=EXnXvDUul4Z6rkJqOHCZAfW8I1c5MKfKm9ZwJ86HJ/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBw2ZsMR4CH4pvMSsCdUDIPEkOrwhPk++uPhfqJPmVHP70ZCIwLSlUEt63vI4V6mYmwDyr/8zySh42MYe2XZhVTITqnbS+7Wuz2anJsNAEnqbVZsfvJfQOiYZ8LDZMnbergJkhpRH2wjJ9ZlUYc7HIkfOKSnGyQcn4uUXtO/ERw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDoKpcLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDoKpcLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1535C4CEF1;
	Tue, 26 Aug 2025 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207175;
	bh=EXnXvDUul4Z6rkJqOHCZAfW8I1c5MKfKm9ZwJ86HJ/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDoKpcLDH6edMJXeK/VivUnaYd6HYUxCCKKLZAzRA51JSYxZlrW3O5LYsVDVxUHxU
	 G5OfOrELzb5oDeUKajqK6+HU2v4pqLBTaH6fklm6uvNa6uwPrFMxAZxEeAdl21hnIj
	 scgoKhPwTkV/adDURAQjBsPGzHO5lbqRcSbixwTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Chan <towinchenmi@gmail.com>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.16 048/457] arm64: dts: apple: t8012-j132: Include touchbar framebuffer node
Date: Tue, 26 Aug 2025 13:05:32 +0200
Message-ID: <20250826110938.536937954@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Chan <towinchenmi@gmail.com>

commit ef68a0e1087882850628000f28078e1c4df917ee upstream.

Apple T2 MacBookPro15,2 (j132) has a touchbar so include the framebuffer
node.

Cc: stable@vger.kernel.org
Fixes: 4efbcb623e9bc ("arm64: dts: apple: Add T2 devices")
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Link: https://lore.kernel.org/stable/20250620-j132-fb-v1-1-bc6937baf0b9%40gmail.com
Link: https://lore.kernel.org/r/20250620-j132-fb-v2-1-65f100182085@gmail.com
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/apple/t8012-j132.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/apple/t8012-j132.dts b/arch/arm64/boot/dts/apple/t8012-j132.dts
index 778a69be18dd..7dcac51703ff 100644
--- a/arch/arm64/boot/dts/apple/t8012-j132.dts
+++ b/arch/arm64/boot/dts/apple/t8012-j132.dts
@@ -7,6 +7,7 @@
 /dts-v1/;
 
 #include "t8012-jxxx.dtsi"
+#include "t8012-touchbar.dtsi"
 
 / {
 	model = "Apple T2 MacBookPro15,2 (j132)";
-- 
2.50.1



