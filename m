Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064654;
	b=V52RfUyBb0NgjChtHdoNqGSBpBDzxAW1z4mmgchNcnRHBE6TFh8S+WUL0bgK5BYLEGcI
	 0+jZQ/zHKbC/LxdZ4T+C7hHWaZWRvwU9V6Nxi2rsKpWgPbjsGI56FP2YMREeHRv8aqgWJ
	 /8Cla5LyPqYCWqEUdv8/AkgQJC75R+tEDm3A5dW6/twOC9xKaf7rIzjJzINt/tMqr/XEd
	 1n+uwftGMl/y2QZMrGHe5R3royysDTKKhGy497y8K/viPcma1rr6GzQuXnBzOVxwNAWwR
	 U7OmFj4+JYupLIFe2OgkjsyJT8xUv9XTNb2im0bPhB3MR75XgpN3fEKGVocmYXSMj1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2HTo0ro6KYhClIlblgX1pV6dWeQe+/OTb3dukItC96E=;
	b=F1Qv0ehjC6uS6Zs4VoRq6QAMeoHaxFB5YsPsNykTimtyi9JDTw825iigI36LvnTkA3Zg
	 mXGsIcIwiG1pWEEY3JZvmmVagr7VNkZ4RBan1Tg+R83q7/OvKxjiD2QG/c+I2njTipuyd
	 69V3+NRNPunPOkrpW+wQ6rEXCLZxlHhXD1RYqIlipTTm7jUVYD9DJ9ehG9Ol+8Q1j8Dvb
	 pNB7/qQbpzyRETJm78TwxOIbw0SWG9CrqM4PmazU3JPKas3Urrd+Si9EBwTK7oUXyI5/V
	 VwTiJnO8wiyapp39+Hj0TL0QnSCezgbAAQhI3s5knuvTLvDWfzNZtQLxZdqPumVruqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkFlmyW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5DF606A9D5;
	Sat,  7 Nov 2026 15:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkFlmyW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2110C1F008A5;
	Sat,  7 Nov 2026 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064654;
	bh=2HTo0ro6KYhClIlblgX1pV6dWeQe+/OTb3dukItC96E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkFlmyW8a1dPmaSGovAUNYgvJv1Ivk/5gIKgTyocjEn1Hmvzt5qnxzuAtCvA9UW2X
	 twgb7T8cdlWioihC0hlMB3hjIG/N159stopDJ9eyNAj87WmMxAjqS6jSg87SIxzUkQ
	 0onpyJR+yOx84Maoh5TBqdwx0YmSOIBRWhhMMNCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0655/1257] mm/damon/core-kunit: test invalid damos filter commits
Date: Sat,  7 Nov 2026 08:49:11 -0500
Message-ID: <20261107134957.352235224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 409d2ab6d98209c30d45123920721710475a30b4 ]

Add test cases for testing the validation of damos filter arguments in
commit time.

Link: https://lore.kernel.org/20260914142327.92510-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0d09a081cd84a..062332fe847ce 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1130,6 +1130,13 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = false,
 			.sz_range = {.min = 234, .max = 345},
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+			.matching = false,
+			.allow = false,
+			.sz_range = {.min = 456, .max = 123},
+			}, true);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_UNMAPPED,
@@ -1143,6 +1150,13 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = false,
 			.addr_range = {.start = 456, .end = 567},
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_ADDR,
+			.matching = false,
+			.allow = false,
+			.addr_range = {.start = 567, .end = 456},
+			}, true);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_TARGET,
-- 
2.53.0



