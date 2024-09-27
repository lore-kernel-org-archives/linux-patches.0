Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BD618A92A;
	Fri, 27 Sep 2024 12:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439930; cv=none; b=mbPyzdx65np8WyZisttE1v0ILVkasvnSQ7OmKh9TFLChd5JcN8htBCXOQJx3xIXkMl5o3wcMQDQ35Nn53ityUqhr2TTdWOZM4VLgKn26gLwpa3FDt/YImNVAFwejUFG64yIA42pG8HZ1cqeuLIOrAu43eYdHlBJVhBwV6bY8EBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439930; c=relaxed/simple;
	bh=YpPTq1r0BhgOJsaXomvsI0S+3WNxQedEFH7oJcXNZ24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQt/+6Cri0G6Bx+iuuRIRXs2kfHhrY+lg36RN4ohAQu9hD6BVBp6nhnR2BNmZQNe+vR3eN5tzi1Qm2x944z+/bpUxJLcEp5VM4jhWlir22gsVvnBOHasFufpHlebbhSX58czxAwL3/drD1mJ3LU9qKrE9mW4cUd5mtza+Zd0BxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xE5iHRti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xE5iHRti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ECFC4CEC4;
	Fri, 27 Sep 2024 12:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439930;
	bh=YpPTq1r0BhgOJsaXomvsI0S+3WNxQedEFH7oJcXNZ24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xE5iHRtiASW/YmQywm6IgdOJdcbEpqwDRwnPWALWeY7an/2QUYFNOyMkGr33A4Zpm
	 +oZnRrQZTjn+w1LlhwqwVS22ihlEM7U46klwPhgcSrWtV5nRLQl7b0dBAF0SVxOvh/
	 OyJCvWuNkascr3EWXmmA0li4mYRw8ACITflsHqYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/54] ASoC: fix module autoloading
Date: Fri, 27 Sep 2024 14:23:18 +0200
Message-ID: <20240927121720.784709042@linuxfoundation.org>
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

[ Upstream commit 6ba20539ac6b12ea757b3bfe11adf8de1672d7b8 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240826084924.368387-5-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/chv3-codec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/chv3-codec.c b/sound/soc/codecs/chv3-codec.c
index ab99effa68748..40020500b1fe8 100644
--- a/sound/soc/codecs/chv3-codec.c
+++ b/sound/soc/codecs/chv3-codec.c
@@ -26,6 +26,7 @@ static const struct of_device_id chv3_codec_of_match[] = {
 	{ .compatible = "google,chv3-codec", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, chv3_codec_of_match);
 
 static struct platform_driver chv3_codec_platform_driver = {
 	.driver = {
-- 
2.43.0



