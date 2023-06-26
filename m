Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E18134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32072C433C8;
	Mon, 26 Jun 2023 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803574;
	bh=jdYWIxzs82q9RpCJpDa9hlI+5258VOn35quQwpRlC1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKY/99kmrCaWTcH7DbV1HcMBEdWZJ0H7Imm1367h9c4upIjvgOS8qejimhx01BWWZ
	 DBhyqHhQvFB7FbunYz/TnfpVCxFYYWhAkp4WJBFV3EsuKkJwkoT/BzLSeTGfpZT0jL
	 vbDukLl2K31bIgJqxAtuhsjjXEI1UoqHHr2mLkPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Magali Lemes <magali.lemes@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 108/199] selftests: net: vrf-xfrm-tests: change authentication and encryption algos
Date: Mon, 26 Jun 2023 20:10:14 +0200
Message-ID: <20230626180810.393980656@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Magali Lemes <magali.lemes@canonical.com>

[ Upstream commit cb43c60e64ca67fcc9d23bd08f51d2ab8209d9d7 ]

The vrf-xfrm-tests tests use the hmac(md5) and cbc(des3_ede)
algorithms for performing authentication and encryption, respectively.
This causes the tests to fail when fips=1 is set, since these algorithms
are not allowed in FIPS mode. Therefore, switch from hmac(md5) and
cbc(des3_ede) to hmac(sha1) and cbc(aes), which are FIPS compliant.

Fixes: 3f251d741150 ("selftests: Add tests for vrf and xfrms")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/vrf-xfrm-tests.sh | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/net/vrf-xfrm-tests.sh b/tools/testing/selftests/net/vrf-xfrm-tests.sh
index 184da81f554ff..452638ae8aed8 100755
--- a/tools/testing/selftests/net/vrf-xfrm-tests.sh
+++ b/tools/testing/selftests/net/vrf-xfrm-tests.sh
@@ -264,60 +264,60 @@ setup_xfrm()
 	ip -netns host1 xfrm state add src ${HOST1_4} dst ${HOST2_4} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_4} dst ${h2_4} ${devarg}
 
 	ip -netns host2 xfrm state add src ${HOST1_4} dst ${HOST2_4} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_4} dst ${h2_4}
 
 
 	ip -netns host1 xfrm state add src ${HOST2_4} dst ${HOST1_4} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_4} dst ${h1_4} ${devarg}
 
 	ip -netns host2 xfrm state add src ${HOST2_4} dst ${HOST1_4} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_4} dst ${h1_4}
 
 
 	ip -6 -netns host1 xfrm state add src ${HOST1_6} dst ${HOST2_6} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_6} dst ${h2_6} ${devarg}
 
 	ip -6 -netns host2 xfrm state add src ${HOST1_6} dst ${HOST2_6} \
 	    proto esp spi ${SPI_1} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_1} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_1} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_1} 96 \
+	    enc 'cbc(aes)' ${ENC_1} \
 	    sel src ${h1_6} dst ${h2_6}
 
 
 	ip -6 -netns host1 xfrm state add src ${HOST2_6} dst ${HOST1_6} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_6} dst ${h1_6} ${devarg}
 
 	ip -6 -netns host2 xfrm state add src ${HOST2_6} dst ${HOST1_6} \
 	    proto esp spi ${SPI_2} reqid 0 mode tunnel \
 	    replay-window 4 replay-oseq 0x4 \
-	    auth-trunc 'hmac(md5)' ${AUTH_2} 96 \
-	    enc 'cbc(des3_ede)' ${ENC_2} \
+	    auth-trunc 'hmac(sha1)' ${AUTH_2} 96 \
+	    enc 'cbc(aes)' ${ENC_2} \
 	    sel src ${h2_6} dst ${h1_6}
 }
 
-- 
2.39.2



