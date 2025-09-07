Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71C71A9FAA;
	Sun,  7 Sep 2025 20:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276237; cv=none; b=ObcsiVkv1wP/SadYibm2qwLPRKdHAj3qv6ZduJv2iOCAzetuDuZpW0B9KEN6abd6TeEnKXpjAhmigBXvEJ2+8ryy0iwfJ9ZaibhwcViOf1RPGeWHGzRjWTs3wPGmB1HmlB7k8j/pLamUFjgDRXQD/Bee2j21m3ct7gf/MpdSeLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276237; c=relaxed/simple;
	bh=tiwY3ViueI4RmJTYGbxgGRft3v01bNGMIph0FScxpgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8kYh8c8cVZmNDBHWtXcGMVFrbrxAZSKgPuSCapfVEjx9sINQj+/ucHwH3OKimjddWK6q0IxCUeS/4WBkudjGRetwoKIJh32EhWLjzOsFJJ8zuq9+0nZhT1hO1/kySOaSMeYjyuxQ3sQbTIBIMAePH7M7LoX86ByRIklcDGlpUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnLzuXec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnLzuXec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CE4C4CEF0;
	Sun,  7 Sep 2025 20:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276237;
	bh=tiwY3ViueI4RmJTYGbxgGRft3v01bNGMIph0FScxpgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnLzuXec3JtFNKwcy+/OsdLEQ7NMWvTHlrokcOY6R4enb3B3txgz/blfGPUg3rU5I
	 4K8tLqjuJBDvOeYkjwkDR5ypfMjz6r3a7YDG0iipB8oS743Kh56BBediCSQyYLb85+
	 uujWUAOU5EBBh7KioV4A0yYwi8m3et/oHGUbjUN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungbae Yoo <sungbaey@nvidia.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/104] tee: optee: ffa: fix a typo of "optee_ffa_api_is_compatible"
Date: Sun,  7 Sep 2025 21:57:31 +0200
Message-ID: <20250907195608.049582546@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungbae Yoo <sungbaey@nvidia.com>

[ Upstream commit 75dbd4304afe574fcfc4118a5b78776a9f48fdc4 ]

Fixes optee_ffa_api_is_compatbile() to optee_ffa_api_is_compatible()
because compatbile is a typo of compatible.

Fixes: 4615e5a34b95 ("optee: add FF-A support")
Signed-off-by: Sungbae Yoo <sungbaey@nvidia.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index b8ba360e863ed..927c3d7947f9c 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -653,7 +653,7 @@ static int optee_ffa_do_call_with_arg(struct tee_context *ctx,
  * with a matching configuration.
  */
 
-static bool optee_ffa_api_is_compatbile(struct ffa_device *ffa_dev,
+static bool optee_ffa_api_is_compatible(struct ffa_device *ffa_dev,
 					const struct ffa_ops *ops)
 {
 	const struct ffa_msg_ops *msg_ops = ops->msg_ops;
@@ -804,7 +804,7 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 
 	ffa_ops = ffa_dev->ops;
 
-	if (!optee_ffa_api_is_compatbile(ffa_dev, ffa_ops))
+	if (!optee_ffa_api_is_compatible(ffa_dev, ffa_ops))
 		return -EINVAL;
 
 	if (!optee_ffa_exchange_caps(ffa_dev, ffa_ops, &sec_caps,
-- 
2.50.1



