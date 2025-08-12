Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792C42F7449;
	Tue, 12 Aug 2025 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023007; cv=none; b=pL9FC6Xa3cHb95hMR4+E5Odq+S+V5OOfcWFfK+SjrbWLAA7jJFBztE1bGvR1LxbxhrCjA09Ecrvhr7350FgE+ClYGl1axrVN/u+htbJYLbAVVU+f4auGDUpAXBE7BjjeAYn+wlBhur+OhDh5YiP+f/JWnZ9hoV6ff9WWIYFoN8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023007; c=relaxed/simple;
	bh=6zOwvI+j7iL3bZngdBVxoTCqIB6hG1SYddwD72S0SSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrnYjDw4Y8I+L277bRtI8lIJtbl6KQcdVO1dW/74yUaa9gytTVEAwi0gBx8Dk+DNK9agl1VF/7W4QfUYR4Qw4AiYASUbIW5x/8xoGBCw9Fkw9vH8gs56cD7sanno/TtmvmhAQP8fxljdSYKBK8uvJlh2wS3iq4BHcId94TeKGSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzZ/6ThZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzZ/6ThZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFEAC4CEF6;
	Tue, 12 Aug 2025 18:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023007;
	bh=6zOwvI+j7iL3bZngdBVxoTCqIB6hG1SYddwD72S0SSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzZ/6ThZtqz2sgKI2pEahjCRGzoqEoCcax3bdOHlnzNiVISthZjHEfHbFLISE5MSO
	 sy5778LokCRGtWqCWA5Mf/KlXFFWee5NcUmXlkoMXsrRE0wU7uNBO6vXKYAIj4GYsd
	 WkXqmgSVahLWpay5ZGDFq6KiMjEE+NnKALoZCKTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/369] net: ipa: add IPA v5.1 and v5.5 to ipa_version_string()
Date: Tue, 12 Aug 2025 19:29:46 +0200
Message-ID: <20250812173027.604117726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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



