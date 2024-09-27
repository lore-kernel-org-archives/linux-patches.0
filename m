Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F5317B515;
	Fri, 27 Sep 2024 12:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440084; cv=none; b=lP/ShrNg/hR5RKn0RgCyNeCXRR2AGjQ4kKmRgghmmNA6KAJmKPbySKGQIVbXOgtU2/LAShnQgnP2Ss0dQW8OJAwtxtWBlhlGgZikkKvqze8E/eaePERRKZARG392LvVHPV/4a0LcOq9WXj5sHQ3OTfmf8BSLlAsmNB3X+e5MSKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440084; c=relaxed/simple;
	bh=oAWjfePvNiWGJbz5JYqBxhcHbdiJMV8+V9kKccBwL9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Suy7MzcsoTKIYjhESaV1GE8Q/fS0KCfhcFUklJ0mqNZRmUhBnKQP6qgbJGMMaDSKqtCypIgW8yVAalXf6VtynFj+BKYwU/THZyqUzCcKqparT5UUvFjs5slTbLszweA5NmVgybbONlYfRRg4tw5biBGcpFGu/EdC7mgmRUErL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0P34cTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0P34cTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88325C4CEC4;
	Fri, 27 Sep 2024 12:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440083;
	bh=oAWjfePvNiWGJbz5JYqBxhcHbdiJMV8+V9kKccBwL9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0P34cTEUccpzcQR5iQyTNWgut+8RLzUtRfGE432rUQtvgKcml5ZbcgHiQBbGHHDD
	 ZGa+RGT3TcpQsEjXYn42Ghpituuylb2MeZsnqgGpuUip/kSdz5wDPWGXgdhEXCWPdc
	 +j2XqC+aEGc70RIliknFqtqnIxaCfOh6bjK3+t9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 27/58] ASoC: google: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:29 +0200
Message-ID: <20240927121719.905092832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 8e1bb4a41aa78d6105e59186af3dcd545fc66e70 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240826084924.368387-3-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/google/chv3-i2s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/google/chv3-i2s.c b/sound/soc/google/chv3-i2s.c
index 08e558f24af86..0ff24653d49f4 100644
--- a/sound/soc/google/chv3-i2s.c
+++ b/sound/soc/google/chv3-i2s.c
@@ -322,6 +322,7 @@ static const struct of_device_id chv3_i2s_of_match[] = {
 	{ .compatible = "google,chv3-i2s" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, chv3_i2s_of_match);
 
 static struct platform_driver chv3_i2s_driver = {
 	.probe = chv3_i2s_probe,
-- 
2.43.0



