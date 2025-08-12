Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736122C21E3;
	Tue, 12 Aug 2025 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024933; cv=none; b=jHWYwVX1WuCd9ZTy0OnyMMbmHjTpjHARUdxdke70OWmpOa5FZYpZjOc8p9J0jbobCidw2I1FtgEvRHyDVnW0hdPPx6nBSlQoG0gyIzPonaO+6TtD+lKesEv2Ccb3wJrOcme/dgCjAfLz70zvPNfGgElQrfGaLPC+dN75DnjcdRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024933; c=relaxed/simple;
	bh=/t/niAI/6/ajFFkXxZHQ9hvy7L6UrJ3G3UzdoTaz5u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foPOqg9NxYWJOIt1Vg9SdY2s9lXhGquqeh5/J+fwIj5gaIi1ClGNnfLmUQtK5nj23drEdstUN5gBRrusG1Nsycx6E4RGlioAvnMu9DT8O+45o0ff6azopDpzTV/FAzxejoD8T8MjA9og12e6FZoD58FvSI972jM18sboTF6W9os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZvR7pba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZvR7pba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3599C4CEF0;
	Tue, 12 Aug 2025 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024933;
	bh=/t/niAI/6/ajFFkXxZHQ9hvy7L6UrJ3G3UzdoTaz5u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZvR7pbaLeqGRP7eMNPZCSHR8g3VVPkIdh61xwaX8ihFCncqKXwVXvo/lsCjDcLxg
	 ag0x2X0U2mb0vgHzEErjQp/boQZyreXeF7CBLW6/SfCvnqSqSHDQ3CaqnMeMm9zCNh
	 mEAQQ0ja/mg4hwCzl0ApOhzZth4cJETOrsFt1C60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 518/627] net: ipa: add IPA v5.1 and v5.5 to ipa_version_string()
Date: Tue, 12 Aug 2025 19:33:33 +0200
Message-ID: <20250812173450.699743732@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit f2aa00e4f65efcf25ff6bc8198e21f031e7b9b1b ]

Handle the case for v5.1 and v5.5 instead of returning "0.0".

Also reword the comment below since I don't see any evidence of such a
check happening, and - since 5.5 has been missing - can happen.

Fixes: 3aac8ec1c028 ("net: ipa: add some new IPA versions")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20250728-ipa-5-1-5-5-version_string-v1-1-d7a5623d7ece@fairphone.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_sysfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
index a59bd215494c..a53e9e6f6cdf 100644
--- a/drivers/net/ipa/ipa_sysfs.c
+++ b/drivers/net/ipa/ipa_sysfs.c
@@ -37,8 +37,12 @@ static const char *ipa_version_string(struct ipa *ipa)
 		return "4.11";
 	case IPA_VERSION_5_0:
 		return "5.0";
+	case IPA_VERSION_5_1:
+		return "5.1";
+	case IPA_VERSION_5_5:
+		return "5.5";
 	default:
-		return "0.0";	/* Won't happen (checked at probe time) */
+		return "0.0";	/* Should not happen */
 	}
 }
 
-- 
2.39.5



