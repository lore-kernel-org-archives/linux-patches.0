Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA0D1F8915;
	Tue,  3 Dec 2024 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238987; cv=none; b=FmV8F87rp+PDhimn78cFi0j8vwg+FSx+RkwArjzconCDd1xIPWp8wArHaX/l+zeWjmj9V8rKBHmMbF9XZj1GTg3ahj93piAEUhvUb3JazlQpO86ASPnrDzR7SJAYw6EIkOl8WqLW9HUyWRh6V+1/p83JHIyMRD7+RJiFDAlhar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238987; c=relaxed/simple;
	bh=9buIJnb2dEH/l+rFtVTPZYyfBrW4SZE4nnmqYePI9nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AstdAQIyjuz2q1F8WH9qf1VzkXh0C7nHQ1ONbJU65OhQVfHmeomcxZKtag6z9zz4MIUJO41O1bnnHaeDaDbWOM5nik508SWQM7R+NvpnUiPq8MSLaAowIfpwDdf1Fn4PiavN/W9eF2hLDkdn1wdjeoWSzMts0PvOULBiiP2vt+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUWITkRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUWITkRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748C7C4CECF;
	Tue,  3 Dec 2024 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238986;
	bh=9buIJnb2dEH/l+rFtVTPZYyfBrW4SZE4nnmqYePI9nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUWITkRINToK7jCa167HmwxlMxCx+tokPeSt0nR3NhT4hNxNrahICQFRNA6Yzv83q
	 Xa9ShBpgMQOr0u+1yr9kfgCGsSZJSriU9+Sk/sFYIf27aih8u8/w1UFBLPHspkDtGp
	 n92LVuqnKJl8xlDtk3fdODn2exgS3TvP38QnbXjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 465/817] clk: clk-apple-nco: Add NULL check in applnco_probe
Date: Tue,  3 Dec 2024 15:40:37 +0100
Message-ID: <20241203144014.024705188@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 969c765e2b508cca9099d246c010a1e48dcfd089 ]

Add NULL check in applnco_probe, to handle kernel NULL pointer
dereference error.

Fixes: 6641057d5dba ("clk: clk-apple-nco: Add driver for Apple NCO")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241114072820.3071-1-hanchunchao@inspur.com
Reviewed-by: Martin Povišer <povik+lin@cutebit.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-apple-nco.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk-apple-nco.c b/drivers/clk/clk-apple-nco.c
index 39472a51530a3..457a48d489412 100644
--- a/drivers/clk/clk-apple-nco.c
+++ b/drivers/clk/clk-apple-nco.c
@@ -297,6 +297,9 @@ static int applnco_probe(struct platform_device *pdev)
 		memset(&init, 0, sizeof(init));
 		init.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 						"%s-%d", np->name, i);
+		if (!init.name)
+			return -ENOMEM;
+
 		init.ops = &applnco_ops;
 		init.parent_data = &pdata;
 		init.num_parents = 1;
-- 
2.43.0



