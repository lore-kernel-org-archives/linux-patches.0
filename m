Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A1E19B3FF;
	Tue, 15 Oct 2024 11:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992991; cv=none; b=LlfAQa0b+6if8cPcfo5jqW4Dtp7JFpVsWxY52MrcfsGCe/SBXC+d9E+j16+i8L5mCNgyq4Q9WjvaT+79XFAQzRaS2rM0836niadPy2yYRgg0hFIfp+agZJB7gxXiZmd5PpiJL6ffVZZEl5e1urE4c4tMsKkbxezlOmMwDZMzEY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992991; c=relaxed/simple;
	bh=98ouZD0wfT4IA76vTX8BsHdb0PYvWWz+gMgS2Qu8ABU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+hFoTOkKEBxhlYIwSBqtZNSDYOhiSg5L0WPpzMdiBBVsC7cai65z7eM9DNj++ft1JZWok75B0XDhiQN5mI7OsIglL4u/xuPH4Gj7V2U4TkGUqC/wFYO31oMp6oKPqK8e+ye4GKTNog35WQLqAs3GihJQe6DGO5WhDjT22z94fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpjRynwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpjRynwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E5AC4CEC6;
	Tue, 15 Oct 2024 11:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992991;
	bh=98ouZD0wfT4IA76vTX8BsHdb0PYvWWz+gMgS2Qu8ABU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpjRynwBs6H3M3QqdE/+C4TvFOaWYQdB1tv6BYVqH3G27HMaD/Mxx4kI9O8z7ZFNE
	 lWtYPSOwLlQNkhR4lFdUd08Efg+STzIoX9Lx9L+LZ6yIUYb+yETWeVr33c4k4nZ6kL
	 wTI2MTExiNdXk0oO8rb8dZVjBC5gofz2cLsDBffc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/691] interconnect: qcom: sm8250: Enable sync_state
Date: Tue, 15 Oct 2024 13:23:45 +0200
Message-ID: <20241015112451.338957720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit bfc7db1cb94ad664546d70212699f8cc6c539e8c ]

Add the generic icc sync_state callback to ensure interconnect votes
are taken into account, instead of being pegged at maximum values.

Fixes: b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231130-topic-8250icc_syncstate-v1-1-7ce78ba6e04c@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8250.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8250.c b/drivers/interconnect/qcom/sm8250.c
index aa707582ea016..8dfb5dea562a3 100644
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -551,6 +551,7 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
+		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
-- 
2.43.0



