Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92E16FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1802CC433CD;
	Sun, 17 Sep 2023 20:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980954;
	bh=Ib/M55cvfB37uLiofTWwMSszBjIXjlgqLRJvZ4US3u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZhzAkjVYslSSWF73n1g50qw8Iz6jomMHBby9gIsw5jfh3G/Oqg96K0mUIot8jQvg
	 G+OPzK4SR2xvUQyoQq9Z2UH+WchM0VWSWygOnymGSvlEawgwS264/KrcRLv8fio7yp
	 8O5ya5T9D/qkiufwXjKx2vx8jov8uIrILj0I/+zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <sboyd@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 027/219] clk: qcom: camcc-sc7180: fix async resume during probe
Date: Sun, 17 Sep 2023 21:12:34 +0200
Message-ID: <20230917191041.977768577@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit c948ff727e25297f3a703eb5349dd66aabf004e4 upstream.

To make sure that the controller is runtime resumed and its power domain
is enabled before accessing its registers during probe, the synchronous
runtime PM interface must be used.

Fixes: 8d4025943e13 ("clk: qcom: camcc-sc7180: Use runtime PM ops instead of clk ones")
Cc: stable@vger.kernel.org      # 5.11
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230718132902.21430-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/camcc-sc7180.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/camcc-sc7180.c
+++ b/drivers/clk/qcom/camcc-sc7180.c
@@ -1664,7 +1664,7 @@ static int cam_cc_sc7180_probe(struct pl
 		return ret;
 	}
 
-	ret = pm_runtime_get(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret)
 		return ret;
 


