Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAA7AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E80C433D2;
	Wed,  4 Jan 2023 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849065;
	bh=/FSi+Pd4WgmdH+wM2uW0IAKt0B3d6mNtqXqVNRzNtSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfhdlEr+27JSF/Cb2QrBaKhUqVfTutW5JdL0cZfgO2ITWRhA8DdZEfzT0XUSdrSQh
	 9rC+5qWcDRjn1iw5lpFGTDRJKgKVKtz4Dk1DKMz8DUfd5APqWc1MD+sEKKU+r70+of
	 2GTa3IALpdXmoJv/C+xlSPqZog3pXQNkuEUZYdDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.0 058/177] ima: Fix hash dependency to correct algorithm
Date: Wed,  4 Jan 2023 17:05:49 +0100
Message-Id: <20230104160509.402099180@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

commit b6018af440a07bd0d74b58c4e18045f4a8dbfe6b upstream.

Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
the SM3 and SM4 stand-alone library and the algorithm implementation for
the Crypto API into the same directory, and the corresponding relationship
of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
algorithm implementation for the Crypto API. Therefore, it is necessary
for this module to depend on the correct algorithm.

Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -112,7 +112,7 @@ choice
 
 	config IMA_DEFAULT_HASH_SM3
 		bool "SM3"
-		depends on CRYPTO_SM3=y
+		depends on CRYPTO_SM3_GENERIC=y
 endchoice
 
 config IMA_DEFAULT_HASH


