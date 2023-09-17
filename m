Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243CA6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4207FC43395;
	Sun, 17 Sep 2023 20:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981578;
	bh=SG9ZOfLKS9vTjbzpI5rfwGg4C+b6SWdZWQws2uZuyWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm6usNhLklbJ/UFrqJIcXs09sOhII2Qtuowgb3upOW3JsiHmzy21HBhzgxHOcXxdK
	 5jzHu4UA5yis4x8ErNiWnYwhBvLvXlMefJB4LjXph2sMIJtftUrhRRrX4tuchewRZ1
	 tLwC9BOxAavE6ppjo/ZZkVjlr7Upk+92XnewR0Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/511] s390/paes: fix PKEY_TYPE_EP11_AES handling for secure keyblobs
Date: Sun, 17 Sep 2023 21:08:21 +0200
Message-ID: <20230917191115.666050759@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Dengler <dengler@linux.ibm.com>

[ Upstream commit cba33db3fc4dbf2e54294b0e499d2335a3a00d78 ]

Commit 'fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC
private keys")' introduced PKEY_TYPE_EP11_AES securekey blobs as a
supplement to the PKEY_TYPE_EP11 (which won't work in environments
with session-bound keys). This new keyblobs has a different maximum
size, so fix paes crypto module to accept also these larger keyblobs.

Fixes: fa6999e326fe ("s390/pkey: support CCA and EP11 secure ECC private keys")
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/paes_s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index a279b7d23a5e2..621322eb0e681 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -35,7 +35,7 @@
  * and padding is also possible, the limits need to be generous.
  */
 #define PAES_MIN_KEYSIZE 16
-#define PAES_MAX_KEYSIZE 320
+#define PAES_MAX_KEYSIZE MAXEP11AESKEYBLOBSIZE
 
 static u8 *ctrblk;
 static DEFINE_MUTEX(ctrblk_lock);
-- 
2.40.1



