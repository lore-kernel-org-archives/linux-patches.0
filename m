Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10B9154B4
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF09C433C7;
	Wed,  9 Aug 2023 11:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579571;
	bh=8XUha/L6l7PJlMLVRXRYAMEApGgPwb5/819+3i3R+Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIQ3/NvOIRht6dxCsA0xHItQjmubooxFcpQR5JIso3ppil91upnmKSADy+HnDxwbo
	 laSl2a0ZO+QZ+k3QdGvkfkQ2MSr8qC0Cz3Retl8EdIqV2EKiVQyBAq1fn1/JORPNgT
	 vgtOtZsz9rtnV0VLX6kR7Rcg6EUkqq0fnOo85JU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/323] wifi: ray_cs: Drop useless status variable in parse_addr()
Date: Wed,  9 Aug 2023 12:37:55 +0200
Message-ID: <20230809103659.823714937@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 4dfc63c002a555a2c3c34d89009532ad803be876 ]

The status variable assigned only once and used also only once.
Replace it's usage by actual value.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220603164414.48436-2-andriy.shevchenko@linux.intel.com
Stable-dep-of: 4f8d66a9fb2e ("wifi: ray_cs: Fix an error handling path in ray_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ray_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index f15714f19d0ff..e5cdcee04615f 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1653,7 +1653,6 @@ static int parse_addr(char *in_str, UCHAR *out)
 {
 	int i, k;
 	int len;
-	int status;
 
 	if (in_str == NULL)
 		return 0;
@@ -1662,7 +1661,6 @@ static int parse_addr(char *in_str, UCHAR *out)
 		return 0;
 	memset(out, 0, ADDRLEN);
 
-	status = 1;
 	i = 5;
 
 	while (len > 0) {
@@ -1680,7 +1678,7 @@ static int parse_addr(char *in_str, UCHAR *out)
 		if (!i--)
 			break;
 	}
-	return status;
+	return 1;
 }
 
 /*===========================================================================*/
-- 
2.39.2



