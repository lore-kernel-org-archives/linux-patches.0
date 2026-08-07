Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6583A3E7A;
	Fri,  7 Aug 2026 15:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116555; cv=none; b=trALSLQDzwa6NSxsRLBUY/30Vpbcivac09S6Uz59ECCdnwP0PeEbgnVasti84zg48I0pWuIF1w7HMoYaaxVJSvjGjLee7dUePG6gmFxmktGJlgg0oar85AqDCGgzVfyFbFtzOFSFNi20AVOqhbxPj3cViXFFcjQdhWV+LEGLwi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116555; c=relaxed/simple;
	bh=byJOeyKB9d8qs3W2ML+91/lId2kP+g6t+MHloxHSyW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPAb/9o+UMeYaEstseSaniKyJFDZ3uTWqoIcDa1ZpFU9TeevzlKDrIw2gdLWWwsYtGVzSfKHqkGoegsrIjgtdBACmi2/RHAwtrZN6EJkP6oYqS4tG1Qie6tnOnCwfBl9f8rRpiQ2OjIYD5ugSO58ebxcv+pnp+L6Xavtg5uDv1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR7SKcCn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR7SKcCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BDC1F000E9;
	Fri,  7 Aug 2026 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116554;
	bh=vZ9DUju0NfMgfHA+c8iRVcwkQbsdRysxfNo14gose9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bR7SKcCna1d/YuxL3X+20Y3yx1P42kshmGSeK5XXCZkjNUlHdEFhsInNMfLE4kcNF
	 BCbzErkPFU3mxz0eF5rtH88r97pyJJj67m2LMLX2WYoNGjUWiCvi5Oe4AHm4OeKA4L
	 ePFyAZ2BtuMqHto9O7CL1Q8FVKeVLkni+yAaNu3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 010/438] pinctrl: qcom: sc8280xp: Add missing wakeup entries for GPIO143/151
Date: Fri,  7 Aug 2026 16:33:26 +0200
Message-ID: <20260807143428.232089892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 437a8d2aa1aa442c4a176fdf4700a9b3bb0c8794 ]

Pins 143 and 151 were not included in the PDC wakeup map. They are
normally used for PCIe2A and PCIe3a PERST# respectively, so they're
unlikely to be excercised in practice, but still add them for the sake
of completeness.

Fixes: c0e4c71a9e7c ("pinctrl: qcom: Introduce sc8280xp TLMM driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260626-topic-8280_pinctrl_wakeup-v1-1-2ccb267148f5@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
index 4056b9fa32f8c..e018bd11626ca 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
@@ -1881,16 +1881,17 @@ static const struct msm_gpio_wakeirq_map sc8280xp_pdc_map[] = {
 	{ 126, 200 }, { 127, 225 }, { 128, 262 }, { 129, 201 },
 	{ 130, 209 }, { 131, 173 }, { 132, 202 }, { 136, 210 },
 	{ 138, 171 }, { 139, 226 }, { 140, 227 }, { 142, 228 },
-	{ 144, 229 }, { 145, 230 }, { 146, 231 }, { 148, 232 },
-	{ 149, 233 }, { 150, 234 }, { 152, 235 }, { 154, 212 },
-	{ 157, 213 }, { 161, 219 }, { 170, 236 }, { 171, 221 },
-	{ 174, 222 }, { 175, 237 }, { 176, 223 }, { 177, 170 },
-	{ 180, 238 }, { 181, 239 }, { 182, 240 }, { 183, 241 },
-	{ 184, 242 }, { 185, 243 }, { 190, 178 }, { 193, 184 },
-	{ 196, 185 }, { 198, 186 }, { 200, 174 }, { 201, 175 },
-	{ 205, 176 }, { 206, 177 }, { 208, 187 }, { 210, 198 },
-	{ 211, 199 }, { 212, 204 }, { 215, 205 }, { 220, 188 },
-	{ 221, 194 }, { 223, 195 }, { 225, 196 }, { 227, 197 },
+	{ 143, 261 }, { 144, 229 }, { 145, 230 }, { 146, 231 },
+	{ 148, 232 }, { 149, 233 }, { 150, 234 }, { 151, 264 },
+	{ 152, 235 }, { 154, 212 }, { 157, 213 }, { 161, 219 },
+	{ 170, 236 }, { 171, 221 }, { 174, 222 }, { 175, 237 },
+	{ 176, 223 }, { 177, 170 }, { 180, 238 }, { 181, 239 },
+	{ 182, 240 }, { 183, 241 }, { 184, 242 }, { 185, 243 },
+	{ 190, 178 }, { 193, 184 }, { 196, 185 }, { 198, 186 },
+	{ 200, 174 }, { 201, 175 }, { 205, 176 }, { 206, 177 },
+	{ 208, 187 }, { 210, 198 }, { 211, 199 }, { 212, 204 },
+	{ 215, 205 }, { 220, 188 }, { 221, 194 }, { 223, 195 },
+	{ 225, 196 }, { 227, 197 },
 };
 
 static struct msm_pinctrl_soc_data sc8280xp_pinctrl = {
-- 
2.53.0



