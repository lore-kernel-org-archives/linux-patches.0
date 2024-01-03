Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F261CA96;
	Wed,  3 Jan 2024 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xip+gACu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C39C433C8;
	Wed,  3 Jan 2024 16:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301068;
	bh=ux2DAD8x0gULmepthuyJf9P9pCsdPRCMGDcXEs1XXhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xip+gACuuKmGeRnkQ518Teh/9OM6dGUuOD8sL+4goV2unFYuMWlzD5RCeYohsQ/Sk
	 PzxSOiVYmWY6bi1IBNMibWYJLxe7mie6eXJAQYUs1IYVYcOweC/q46Oi3kmoX/ewDf
	 AmXqLgtXPhtTJozFBOu0KosOArQpHLl68q0pqBVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Hongfei <luhongfei@vivo.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/100] ksmbd: Replace the ternary conditional operator with min()
Date: Wed,  3 Jan 2024 17:54:18 +0100
Message-ID: <20240103164900.449744909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Hongfei <luhongfei@vivo.com>

[ Upstream commit f65fadb0422537d73f9a6472861852dc2f7a6a5b ]

It would be better to replace the traditional ternary conditional
operator with min() in compare_sids.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 8fe2592c5525f..03f19d3de2a17 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -97,7 +97,7 @@ int compare_sids(const struct smb_sid *ctsid, const struct smb_sid *cwsid)
 	/* compare all of the subauth values if any */
 	num_sat = ctsid->num_subauth;
 	num_saw = cwsid->num_subauth;
-	num_subauth = num_sat < num_saw ? num_sat : num_saw;
+	num_subauth = min(num_sat, num_saw);
 	if (num_subauth) {
 		for (i = 0; i < num_subauth; ++i) {
 			if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
-- 
2.43.0



