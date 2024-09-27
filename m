Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254B61779BD;
	Fri, 27 Sep 2024 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439925; cv=none; b=psN1Fkp9DFRolYt9svS28Z1Mv5mA9KeF5fzoLDUhn2YVXvDSf0V3NLjFmgfEjR5iE8TXIX10jxhfv5hYb9mg6Ki6mbOMhf2eqq1uxt4vy8SE7dA2VkyObOzE2EKU/qjIsPpkADYnxnjrCsykb8X4GGb9UYzR8gWe4Y81snQFjzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439925; c=relaxed/simple;
	bh=20GpBxfWm3eYlsBMdlclgNzKCEyT8d33Ijrjol6kU/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlnqzQ1ePtJURCZINB1cCxT3jrvnJBmFRs4X+og+t0rzwZMToBtgK59XxkOfl+sOQg3dLEqgw8rOosc4oJZkr2Z5+bXINyYggjYd/18SmIGxCorCjrvvlQV9wYgHVBofE+9cXVhnlKPlhfnEHzTBZYNLiOXxOVb88MUTXgyEcdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhOpmjTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhOpmjTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02BEC4CEC4;
	Fri, 27 Sep 2024 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439925;
	bh=20GpBxfWm3eYlsBMdlclgNzKCEyT8d33Ijrjol6kU/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhOpmjTqXq6NKWQKZAA3PLYY+m8WW9jHNqZkzGPz48f477eShV5skVuBHHYkS3XKE
	 3Y4Bxs4017A2zJYPZaYBCDYnQL72k+AJJAgLL/mDI3AScy/ZwWmVZqwVy4saZQzeKF
	 hOso/TUj6CYDgUvQaAz2IAXBmyDJ3CSMxPlFW+0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/54] ASoC: google: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:16 +0200
Message-ID: <20240927121720.693695728@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f65134449066..462e970b954f1 100644
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



