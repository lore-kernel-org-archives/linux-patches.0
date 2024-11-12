Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C7520D4E3;
	Tue, 12 Nov 2024 10:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407304; cv=none; b=Lpz3SV4PyvFwRI6Ejm+rCkhVyzoEULXT+N5MURjtBEF/RdM1wBOp0ob0SYRxVS0Y1NBaYioD301iA+f2s3aYN2+PcZZxEbiB7I/EO1840I5w75w35iko78fXIw1Jst8c6FhzgJh9/Z2IESy1yvGHg4GYt1fZ7XpI964v1xvkqw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407304; c=relaxed/simple;
	bh=7sRnyhrDtSkGH7LyN3rEcfMpVpzphGzIhaCKPeFTWLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx4Mt3xZuWIKJqAKwQXYA8wSWi6TOUlZQIQ+RBSMGepIMAUKAFGCRxuei7+hYuWFuzdXEKpGSbfIy1y7nUiOWF5FOkUmPt3XbDOXxtwE6JOebdHZw2b4w7OoRDlQYiuu1baq3rLWr9OIMZXx1BIy1RdWBuzbLKLz/tVK1ST7jps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbQ6zm28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbQ6zm28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5F6C4CECD;
	Tue, 12 Nov 2024 10:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407304;
	bh=7sRnyhrDtSkGH7LyN3rEcfMpVpzphGzIhaCKPeFTWLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbQ6zm28U/95qJrYIENFh5L3sqjKarAs6zubx4ARPg7lkubgPaRuehToiatsWC6is
	 9khGLx3fu9zDcGc5UiK08+O9USyJMdilkxy3ylwc05v5c7yeE2+hXOJ0pjk/BSKYjO
	 IpBg9GAMP51lARXLbcL4DeoKv6OARLoF4LR1DGz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 35/98] media: stb0899_algo: initialize cfr before using it
Date: Tue, 12 Nov 2024 11:20:50 +0100
Message-ID: <20241112101845.610677300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 2d861977e7314f00bf27d0db17c11ff5e85e609a upstream.

The loop at stb0899_search_carrier() starts with a random
value for cfr, as reported by Coverity.

Initialize it to zero, just like stb0899_dvbs_algo() to ensure
that carrier search won't bail out.

Fixes: 8bd135bab91f ("V4L/DVB (9375): Add STB0899 support")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/stb0899_algo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -269,7 +269,7 @@ static enum stb0899_status stb0899_searc
 
 	short int derot_freq = 0, last_derot_freq = 0, derot_limit, next_loop = 3;
 	int index = 0;
-	u8 cfr[2];
+	u8 cfr[2] = {0};
 	u8 reg;
 
 	internal->status = NOCARRIER;


