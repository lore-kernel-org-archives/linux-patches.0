Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE232D3A94;
	Tue, 12 Aug 2025 19:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026611; cv=none; b=m4MfciOc78T/wAAejZYLPL5bfrv1Cgu4jqyXMc8vZjqO58CA6hUnKpSsHVpj0vqbgWhxJlKZEQp4S8AiWf89xQ0j8MzKdmcFtPVxgL6lcTnBfzfDw8vYgJLs15y3p5p0kmAjxCuNU1sksDxQb80mKXrxA3pa9LUHSy3SwKT/llg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026611; c=relaxed/simple;
	bh=Xn89lo9LrHJV30upVkGBMXpH4lAZu/LaxGoYpFjJe8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzuYw8xtr0SAlPNZv2NwMeDnOSrUg/f69DoPUOK2tzK5IOsyGsvP37R35LzJZDjPQEwZ3A9xyV1hnIDUbtaQMyGrv8hHq5mJiKTdFTawcwNeJ5LoilcROaq6hMHMLJSR3+svtRpiLmWDf3FVGPfip3WI9/37rN4XSg7lonagJDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvj3OKEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvj3OKEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951E4C4CEF9;
	Tue, 12 Aug 2025 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026611;
	bh=Xn89lo9LrHJV30upVkGBMXpH4lAZu/LaxGoYpFjJe8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvj3OKEbVe+tgmGYvRP88Fd8c91bQby1h8wM5Wx1Jh+TnusGicVbk6P901kBhdwsL
	 FwIZFKcVtWZAgTJEX1H1rt23gK5JfbNCavMxKO1Yex25aon4JwvYOb0SLYyYayLLQy
	 XO+8TzxmBDbn6uKLQ/wrGkvRBgzeiaCPuALE/C+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 388/480] net: ipa: add IPA v5.1 and v5.5 to ipa_version_string()
Date: Tue, 12 Aug 2025 19:49:56 +0200
Message-ID: <20250812174413.438821286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



