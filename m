Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630901B3927;
	Mon, 10 Mar 2025 17:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627697; cv=none; b=szvtHEmJi9LU1nkgEUXzNRnTvpZj3AGb+8hLJKfMqv8NKX2+lufTXbmdtB5R5lTnR/rUFk9drGzyqjsJMtUy7UGohLQzlc2NV7BzpJNIepN3c+AKmy9S5ui6yAkG8An5VzcoyV0yooPzUk0uepo/jF36bBxG9EGN26kvOYNTQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627697; c=relaxed/simple;
	bh=eHgk3VhzWSszhkuPwvlgPrbAL36A4Qk7MpdHOugA5X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3ccotu06hL0a0BVpwJOImdr9HU4+/8ovFpx2Zd+5qm6m0sE4J3ZhRyVy1R5Yzi7z0Xg3sJ4QADhGNml65cfJjEYkFN93URVU8hc3YET5Qdf9E159GLp+i05HYPEDHpJHPHL+5Wsz/njHHBo+42B445lQ1Mbghdx0Tuy5xpwpoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0osXPiXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0osXPiXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D54C4CEE5;
	Mon, 10 Mar 2025 17:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627697;
	bh=eHgk3VhzWSszhkuPwvlgPrbAL36A4Qk7MpdHOugA5X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0osXPiXf9tmNSzKLsL6fxLc6autVWtIPB1bdh9HwE/k9YWSRQYV6bQMIpqjdqzBo0
	 PPSbbIdKtraaRKbTPzpW8um4I1b1ahOFxENmWNSt/Bw4BnP+/IbfUVTK+fAdg803sB
	 KDCxQj7BlDa0PUlX7SV2WdSoivKHiWMmy7KEq9sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/269] net: ipa: Enable checksum for IPA_ENDPOINT_AP_MODEM_{RX,TX} for v4.7
Date: Mon, 10 Mar 2025 18:05:40 +0100
Message-ID: <20250310170505.159662769@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e63dcf8d45567..41f212209993f 100644
--- a/drivers/net/ipa/data/ipa_data-v4.7.c
+++ b/drivers/net/ipa/data/ipa_data-v4.7.c
@@ -104,6 +104,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.filter_support	= true,
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
@@ -127,6 +128,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
-- 
2.39.5



