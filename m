Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4E914D2B3;
	Mon, 16 Sep 2024 12:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488524; cv=none; b=L6grINX4Ep7brrny2CHPI6o7aZET302YHSazYjwO531ickCqfJGjsofxIJkTL074E2MGtIubNCccGPhZwEQP7kPwod7TcUKqEmhb/5rZ8adxjt5OuiFbWmcMcBNEbALw6jgQitajfK/dubHXD3VAoYQ4JXA4Lb8to0j4qm7m9Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488524; c=relaxed/simple;
	bh=IARXPRX1eZmmOByUVqq0Z9IKJEg4x30b43Dwedn1ZcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAtfl7LzireZvCeLYJTJysMVtuhFlFttySUDhSEZnCwZLq+hhUAGuSGBxUiBh/IKhPu/UCIDfhd7P3xyo9S5UQWtzogRUkbWfcDr8K+IBzJKxMivJO3znFjiYYlexhvloVEgSFs8Yu3reRzV9Q9xU8Q7wnVkE6Io8xy15gMrOFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+j1a54I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+j1a54I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A81C4CEC4;
	Mon, 16 Sep 2024 12:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488524;
	bh=IARXPRX1eZmmOByUVqq0Z9IKJEg4x30b43Dwedn1ZcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+j1a54Ilv/9YATGtXYzQaEawC9hR4LnGP2RA9v9NEgr9DfdvKVa8N36EqiuTAz8v
	 XLj4EEi6wSYmSIK4H58IgznzBy1emHKdb0FvaZJaGCbAWAl2eHoCRZ0CHj6sgZn04v
	 mzSrAzcWZtzRwXMSnO/FC0ySmmQQIhnm7tMtuN9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Thomson <git@johnthomson.fastmail.com.au>,
	stable <stable@kernel.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/91] nvmem: u-boot-env: error if NVMEM device is too small
Date: Mon, 16 Sep 2024 13:43:45 +0200
Message-ID: <20240916114224.840689383@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Thomson <git@johnthomson.fastmail.com.au>

[ Upstream commit 8679e8b4a1ebdb40c4429e49368d29353e07b601 ]

Verify data size before trying to parse it to avoid reading out of
buffer. This could happen in case of problems at MTD level or invalid DT
bindings.

Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
Cc: stable <stable@kernel.org>
Fixes: d5542923f200 ("nvmem: add driver handling U-Boot environment variables")
[rmilecki: simplify commit description & rebase]
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240902142510.71096-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/u-boot-env.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/nvmem/u-boot-env.c b/drivers/nvmem/u-boot-env.c
index befbab156cda..adabbfdad6fb 100644
--- a/drivers/nvmem/u-boot-env.c
+++ b/drivers/nvmem/u-boot-env.c
@@ -176,6 +176,13 @@ static int u_boot_env_parse(struct u_boot_env *priv)
 		data_offset = offsetof(struct u_boot_env_image_broadcom, data);
 		break;
 	}
+
+	if (dev_size < data_offset) {
+		dev_err(dev, "Device too small for u-boot-env\n");
+		err = -EIO;
+		goto err_kfree;
+	}
+
 	crc32_addr = (__le32 *)(buf + crc32_offset);
 	crc32 = le32_to_cpu(*crc32_addr);
 	crc32_data_len = dev_size - crc32_data_offset;
-- 
2.43.0



