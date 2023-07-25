Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5961F165
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7C7C433C7;
	Tue, 25 Jul 2023 11:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284999;
	bh=B/zaJyWRtJTaQig9V1mXmcp0qBFPE/7hjoqWFcup0ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBF97e+4Wo1c/7xcqCbXWavUTLrj2yW7VrNMgEbamep79tpG8novKZoI2l3O4GyVW
	 oe84Tx+6Zt/cHebWOsercD7kOZFhre0BzwzwIJv/0moa9XWbRyI/g37rt3IryX4q6g
	 qwoLXu49rB3Zgp1u1u5JtdlU4R12p3GI9Iv8Qo/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/313] wifi: ray_cs: Drop useless status variable in parse_addr()
Date: Tue, 25 Jul 2023 12:43:20 +0200
Message-ID: <20230725104523.105119956@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index 29dd303a7beae..be2d599536cd5 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1643,7 +1643,6 @@ static int parse_addr(char *in_str, UCHAR *out)
 {
 	int i, k;
 	int len;
-	int status;
 
 	if (in_str == NULL)
 		return 0;
@@ -1652,7 +1651,6 @@ static int parse_addr(char *in_str, UCHAR *out)
 		return 0;
 	memset(out, 0, ADDRLEN);
 
-	status = 1;
 	i = 5;
 
 	while (len > 0) {
@@ -1670,7 +1668,7 @@ static int parse_addr(char *in_str, UCHAR *out)
 		if (!i--)
 			break;
 	}
-	return status;
+	return 1;
 }
 
 /*===========================================================================*/
-- 
2.39.2



