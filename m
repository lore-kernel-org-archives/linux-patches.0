Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DB09443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B79C433C7;
	Sun, 13 Aug 2023 21:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962141;
	bh=Rh2TGQGR58JyAEMw6gKN8pKeyZNERVshk6O9mH8DsLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRbA096gKRR+Kj/JF5QuovcHeGdAOcTgXXBS12WiQwvB0dIYrAr5fKOEngZJpgtp1
	 ko6nR7a2VoWkq8qvAV3kVX0N2Uaa9OKNBV3BBWkHw07yWnWGJ/Y0RWO2j/p8FIRO//
	 HdWWDemit5eN7OYxYq5AiGaDGfJk5qNG0xZVgKmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.4 098/206] interconnect: qcom: sa8775p: add enable_mask for bcm nodes
Date: Sun, 13 Aug 2023 23:17:48 +0200
Message-ID: <20230813211727.864650101@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

commit 3cb11fe244d516f757c1022cfa971528d525fe65 upstream.

Set the proper enable_mask the ACV node requiring such value
to be used instead of a bandwidth when voting.

The masks was copied from the downstream implementation at [1].

[1] https://git.codelinaro.org/clo/la/kernel/msm-5.15/-/blob/kernel.lnx.5.15.r32-rel/drivers/interconnect/qcom/lemans.c

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230619-topic-sm8550-upstream-interconnect-mask-vote-v2-4-709474b151cc@linaro.org
Fixes: 3655a63f9661 ("interconnect: qcom: add a driver for sa8775p")
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/sa8775p.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/interconnect/qcom/sa8775p.c
+++ b/drivers/interconnect/qcom/sa8775p.c
@@ -1873,6 +1873,7 @@ static struct qcom_icc_node srvc_snoc =
 
 static struct qcom_icc_bcm bcm_acv = {
 	.name = "ACV",
+	.enable_mask = 0x8,
 	.num_nodes = 1,
 	.nodes = { &ebi },
 };


