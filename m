Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF1D847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA95C433EF;
	Fri, 10 Mar 2023 13:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456573;
	bh=DOxsvfip4GQt/ADkpiPkMcR8fo+u7bhjEwSFmzwbxIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JW2JIUcNg4zVLgEK2isAz+IiM//z6OhwQFvTN0/H/4zXCpC/qZAlhx9tO+ZPMg8y0
	 D5MOGtaoIxf0mKQxosLl+TJTy4ySmDBSdgwUWQHave9H6lpFif8rLQEA1Z0PKKnlke
	 j4I+WMyH7wpnz36auU9hCp8S9K4jJ6rV832C7PeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 009/211] soc: qcom: socinfo: Fix soc_id order
Date: Fri, 10 Mar 2023 14:36:29 +0100
Message-Id: <20230310133719.011283074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 017a7c11a8a29e266aa40c6d1bf2ba83f880f719 ]

The soc_id array is mostly ordered by the numeric "msm-id" defined in
qcom,ids.h but some recent entries were added at the wrong place.

While it does not make a functional difference it does make it harder
to regenerate the entire array after adding a bunch of new IDs.

Fixes: de320c07da3d ("soc: qcom: socinfo: Add MSM8956/76 SoC IDs to the soc_id table")
Fixes: 147f6534b8ff ("soc: qcom: socinfo: Add SM8550 ID")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230104115348.25046-2-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index ebcbf9b9c18bc..7ce28be9f435e 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -250,8 +250,6 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(MSM8926) },
 	{ qcom_board_id(MSM8326) },
 	{ qcom_board_id(MSM8916) },
-	{ qcom_board_id(MSM8956) },
-	{ qcom_board_id(MSM8976) },
 	{ qcom_board_id(MSM8994) },
 	{ qcom_board_id_named(APQ8074PRO_AA, "APQ8074PRO-AA") },
 	{ qcom_board_id_named(APQ8074PRO_AB, "APQ8074PRO-AB") },
@@ -283,6 +281,8 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(MSM8616) },
 	{ qcom_board_id(MSM8992) },
 	{ qcom_board_id(APQ8094) },
+	{ qcom_board_id(MSM8956) },
+	{ qcom_board_id(MSM8976) },
 	{ qcom_board_id(MDM9607) },
 	{ qcom_board_id(APQ8096) },
 	{ qcom_board_id(MSM8998) },
@@ -341,7 +341,6 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(IPQ6005) },
 	{ qcom_board_id(QRB5165) },
 	{ qcom_board_id(SM8450) },
-	{ qcom_board_id(SM8550) },
 	{ qcom_board_id(SM7225) },
 	{ qcom_board_id(SA8295P) },
 	{ qcom_board_id(SA8540P) },
@@ -352,6 +351,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(SC7280) },
 	{ qcom_board_id(SC7180P) },
 	{ qcom_board_id(SM6375) },
+	{ qcom_board_id(SM8550) },
 	{ qcom_board_id(QRU1000) },
 	{ qcom_board_id(QDU1000) },
 	{ qcom_board_id(QDU1010) },
-- 
2.39.2



