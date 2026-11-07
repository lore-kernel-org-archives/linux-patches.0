Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062417;
	b=BF6kAt94OzFWMd5WQfn0JGd26BLfakKxaNHxsx1s5hhxSU7cR8CaLYcGlG7Rh0YTV0TN
	 Pwdpi044fPSjxucOmQVS1RGoAgK4XfsDKH2W2L3paChvN4We1t6xaUkKma7sF8aeUWfaQ
	 5/KwWo4Gf7FgatIMWAG8AhB8cpRN8KhQBplkN2QoOH0siONl0oyPMsdlTVX9wMG5lK+fm
	 WUU58htuoh3HM+xkkrK3M5EpFgl+cY24nxnlOnMoV7w+rcp4Zol4DZ5cWkcFD/daLKeD9
	 6RsoF0yndVo880hLNNKZhBwlUx5d0LB7w94ol2EcI6fkR90xNinwkzfFTUKHCc7yzUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9GwF04cgIJqttg9vPMgXyhPySSbvbghWXk3sN+oUco=;
	b=t8fMRuWQBPVOkvWGiX4bqSPv/bmuKPXOfnCOWpETgF6ccpYAWwdjWPttRlw6D9BQKQLz
	 iruwx9dQjQx18Fc898CBOs1lBSkFbW492na3z4BFN65xqZgZn/eWJ6RBQLgWK6XOIgCXb
	 ZIF7oDI3eLstWLXGr/u511IKa/vExIaRVTuZ3i6vn37+mKfEftfIb8vNn52ugeak1jkaT
	 zipSIs9VbspVO/WxmS2ZgBeZ4iZsZKynIdZxiRx2xX6+gmyA9RazPq1OwwMJTQCUN/rxY
	 dtRY5bWmNpJbzU2aQqHkDB5bFJFxxgIwmjAYqT0/6WoFxzrVrAjViJM4bnpB2WNYF+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1p9Ih9cQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDAE606A33C;
	Sat,  7 Nov 2026 14:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1p9Ih9cQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4B51F0089F;
	Sat,  7 Nov 2026 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062416;
	bh=u9GwF04cgIJqttg9vPMgXyhPySSbvbghWXk3sN+oUco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1p9Ih9cQjvRoVMktcaJsH0+fTDk2nSD+F0FsAJo2qaRxv0V8hwaJ06JvC1VnMCrCZ
	 3Fpd9pw8/TIWyiCtY5kFRgVd4zZGMrTFzij1NBQ0lUtdo5C3jitIdSjyELDMZpXWG8
	 BQF4frEulaVFULTN0afrCjDW5r0X8HK3z56/HAIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1332/1536] cpufreq: loongson3: Adjust the width of id and val in smc_message
Date: Sat,  7 Nov 2026 08:55:48 -0500
Message-ID: <20261107135035.231305585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 290814d3c22b300eb36b74dc76ad36bd7fdc1220 ]

The id field of smc_message is usually stand for the CPU ID. In the past
this driver was only tested for desktop and laptop productions so 4-bits
are enough. But now we have servers that can have as many as 256 cores,
so we need 8-bits CPU ID.

On the other hand, the val field is usually stand for CPU frequency so
12-bits are enough to represent 4GHz, and for higher frequencies there
is an extra bit to extend (enough for 8GHz).

In theory, this is a incompatible change, but fortunately the old SMC
firmwares are not widely shipped and can be updated on the air, thus we
can safely adjust the widths.

Cc: stable@vger.kernel.org
Fixes: ccf51454145b ("cpufreq: Add Loongson-3 CPUFreq driver support")
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson3_cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/loongson3_cpufreq.c b/drivers/cpufreq/loongson3_cpufreq.c
index a923e196ec86e..ee7c1f2d3e519 100644
--- a/drivers/cpufreq/loongson3_cpufreq.c
+++ b/drivers/cpufreq/loongson3_cpufreq.c
@@ -21,9 +21,9 @@
 union smc_message {
 	u32 value;
 	struct {
-		u32 id		: 4;
+		u32 id		: 8;
 		u32 info	: 4;
-		u32 val		: 16;
+		u32 val		: 12;
 		u32 cmd		: 6;
 		u32 extra	: 1;
 		u32 complete	: 1;
-- 
2.53.0



