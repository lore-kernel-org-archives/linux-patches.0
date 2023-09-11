Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285441170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CFBC433C7;
	Mon, 11 Sep 2023 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440481;
	bh=3YC5nF9e2UVeVnWln37YGrn56aV2lNII8hCd6uORyxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzonIdVIYtqGHxSo8bmRnvRYlZ6H8NKyP6/s6Efn3O0XuqgoKiTnckyvLBmvMLjsu
	 Wbl+iq6SHU0oFEIiTca8ksseZlfU/o1NbrudYhHp7wEDZn1H+3I3Av/Zvq6eR9RUJs
	 ID7xXmRAwQqw4suDzFQce2U3V2lyedXET9lUYR4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 050/739] s390/paes: fix PKEY_TYPE_EP11_AES handling for secure keyblobs
Date: Mon, 11 Sep 2023 15:37:29 +0200
Message-ID: <20230911134652.517341927@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 38349150c96e8..8b541e44151d4 100644
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



