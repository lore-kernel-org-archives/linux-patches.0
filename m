Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E576922D7A6;
	Mon, 10 Mar 2025 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628078; cv=none; b=eAWUzvC8lJCZmvBRbaiQmvwIAtn4rj5869pMfY8zZj73T9UPm07ip0ARqJjvoWQ0OzX7K8IWB+45Z5iI/MA/Dve+8UyOHhNX4t0Y7xnH2JXeYgs6GDsF5rnb3Dh242okBBxTlYr8hy36XbfKCUCIG7NpG3qvekhegMu3uUpaZPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628078; c=relaxed/simple;
	bh=2ugbBeV4+QeAMVT+mFwrm8Kzlpss7AbHWkcb006QmLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwQCWpThPT7IoiZ6+uIUjRw4vKz/ulasvvQMRAtUa5oqQ1hD0aKGIUAcYB5yD5LWw7/nLX1bi53abxdJsiVb0bpbh2Wu0pOQpQhctcQeFNai4bX8qX+46QN//S9ogKZGgy06EfpajsEd4hzrBWCt7CnyLTFeAUv+986m+wVKSOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOY/Mzjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOY/Mzjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413B3C4CEE5;
	Mon, 10 Mar 2025 17:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628077;
	bh=2ugbBeV4+QeAMVT+mFwrm8Kzlpss7AbHWkcb006QmLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOY/MzjczXFxFEJDhX+7UgnO2eGV3rpNiPF+xnHstI/Xz1Uy8TcW44AHBtt4JMtsQ
	 HYrEBp/wWTZoA+n9G6w1bp1qYtW9I7+UCjNNAiteHZoteIy6a/ZWPsB8F3COSfp5ur
	 X4o8JDEBE81IIw+ZeTnITRG7T6BZ/Dom+1lSE5Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/145] net: ipa: Enable checksum for IPA_ENDPOINT_AP_MODEM_{RX,TX} for v4.7
Date: Mon, 10 Mar 2025 18:06:14 +0100
Message-ID: <20250310170437.984769282@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 934e69669e32eb653234898424ae007bae2f636e ]

Enable the checksum option for these two endpoints in order to allow
mobile data to actually work. Without this, no packets seem to make it
through the IPA.

Fixes: b310de784bac ("net: ipa: add IPA v4.7 support")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20250227-ipa-v4-7-fixes-v1-3-a88dd8249d8a@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/data/ipa_data-v4.7.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
index 4ff666e98878e..1e4a9f632eddf 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -103,6 +103,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.filter_support	= true,
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
@@ -126,6 +127,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
-- 
2.39.5



