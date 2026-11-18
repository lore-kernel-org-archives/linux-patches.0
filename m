Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020132;
	b=IGj01WVYO87opVRJ2Ph7C4uMWUDQjDYFgh+QqMdYB/Er4iIEgV9kmzX13FxGG4+O8829
	 GkXlp3UDJkutGAOkw431fONCcxjX3Y4iojiVNUEFJHHrPBYI9MBT04/+UtuIwjBEFfpXZ
	 gtqOW/Yvg0yjQ/0w00Qwz8F9euYgCqg6UsqAFuH0P/iPW0U9qDlNupNkigS4i4lXz/2D2
	 1RKlNcBrv6CKDN+TYgEQVWf5tPQAuLtzge1aGYTMxHi5YlYkWOdUhKdOwrj9kuxUr0V9V
	 VrJN36rq71XEG5MiKf/kyIQKSiRFQQNwxxl4sDpOaW2/iNI3kOVQ20Jg0Me2LweMqxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fV4FtFhae6u74ZwqtZ/CKUGYdpKsb0LaNg1GcBmlUFA=;
	b=ebtbL1Fj+vTJ1PbpoIvcyx4AAqrjNyNwhc0+6QZMdHj+glglUBGUFkgDk0Rf/f8ROinj
	 KZqpKRWZN+c7mNgbcP5YuP1DEP2dbI/zqNHe6J1NxDok0ml4klvSdIMAlpChn+6zkRWc6
	 1jT/PxCyra1WFb03QqTARaQQyiU10Zh7j4faDXq6jnSpvdhmw2+5DJ5zb+8fFt4XuUTZX
	 +lQndTBOIkf5mTk7HdWaam3EgluS/1EBzeKJAmgO5j/E8x9iQxYBL7jG2oAFcioGapcOe
	 xhtss3Gc1s3ArMTuufxjsHyrniyUiTwRNQima6UYj2OB5Frd+7qZ8ioyrXRUbkq4DPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeFi3BTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A3606A325;
	Wed, 18 Nov 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeFi3BTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3DF1F000CC;
	Wed, 18 Nov 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020132;
	bh=fV4FtFhae6u74ZwqtZ/CKUGYdpKsb0LaNg1GcBmlUFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeFi3BTIFfhbRWAuVj1Ij4t8qyKO7OzDfkMcWAIap3NCcHVg2iQbS1la2jTEkCnp3
	 jBa9muG7L9qBfsbA2dihl2BTgaNXWMkbQvmZD85pc8N+CEe44W0BpbB7tz4Iz0YhJw
	 zs1irxRSz2bG4F0fN6MznY/39YKAKqlCsM6lC2ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1844/2651] platform/x86: hp-bioscfg: fix oops on short integer attribute buffer
Date: Wed, 18 Nov 2026 15:51:24 +0100
Message-ID: <20261118150353.450608635@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit fd7545cd398adc09ec2f9b603d72671560ee6bf9 ]

hp_populate_integer_elements_from_buffer() ignores the return value of
hp_get_string_from_buffer(). When fewer than 2 bytes are left in the
buffer, dst_size is 0, kcalloc() returns ZERO_SIZE_PTR and
hp_get_string_from_buffer() fails without writing to it, so
kstrtoint() faults on address 0x10.

Return the error instead.

Compile tested only.

Fixes: 6f2c06d5a467 ("platform/x86: hp-bioscfg: int-attributes")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-10-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/int-attributes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
index a279070664480..14317b7fd479a 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/int-attributes.c
@@ -331,7 +331,12 @@ static int hp_populate_integer_elements_from_buffer(u8 *buffer_ptr, u32 *buffer_
 	// VALUE:
 	integer_data->current_value = 0;
 
-	hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	ret = hp_get_string_from_buffer(&buffer_ptr, buffer_size, dst, dst_size);
+	if (ret < 0) {
+		kfree(dst);
+		return ret;
+	}
+
 	ret = kstrtoint(dst, 10, &integer_data->current_value);
 	if (ret)
 		pr_warn("Unable to convert string to integer: %s\n", dst);
-- 
2.53.0



