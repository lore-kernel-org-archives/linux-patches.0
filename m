Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049208;
	b=bgMaxmGEQ8yMH5uBwY0NaCK7d6w0zb8KfHvEGnVVYNiy4yhYtV/HBa3LeqHQ+bxGbYoF
	 TcArbx0bJQL2DZ3yuUc9cj1sWrAZWFb9c75f9as3/9cAS6gFmwLT/oa1iNSbR7NJc2pOd
	 674lox8Iv2YbV7EL92WmVBbulP9/eq9lOWLi9H1JFWTB0sfZ1EG6Or4SH+2XPhrBPgJNL
	 Tjm5CQ0+WlJ1CM7a4jgL67Bwgzsv4NsyrKBKIIXlEUxEcbIPhn6mTBKWlNad478DuLdAe
	 +WbYbl3FwuO49mFjIN3jLV1DnzVFhceoIyEWBukoupAwtW2WiE2pRI+tyaaWy2+JEag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LcFa29UP+SDZg1fhHbmEnNq21l/TIqxVxFOF443WQqs=;
	b=J9g+MxoopuDODIgQm4R74/PKSF3aCnImZ0p4FDiLdtrqi4aCi57Gj0QDUT624SXy99lc
	 L0LAiAgJF9jSAYhQVapd1qDp4nUfhUcEo0y4kYSX4MPgcadYBdNca5xm9CxiVgkFQO3L+
	 g2uYVu6QkVC0TfMnO1/7orY/SHmtbUbS5WNB6NxSH9YaWhFKTvkcw5zl/uSmFfvNjTnNQ
	 8gkuAwumwT3wWrm6XagLy3gtYJCHaXZ3UMEN/f53xA0NNJx5acLekC42Qold2iLdb7X2c
	 6kh3EdwDgCHSgSfVo2axl5yYF/GOMsF7EBp5T3M8MxArQsKA4oh20PW8Ma4m5lS3m5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdYQSh4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCA6606A32A;
	Thu, 19 Nov 2026 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdYQSh4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715441F000C4;
	Thu, 19 Nov 2026 00:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049208;
	bh=LcFa29UP+SDZg1fhHbmEnNq21l/TIqxVxFOF443WQqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdYQSh4tlSgfPvPhJ1zxax14MOUGEaSzLaoovhWuOagRwNLoSxwR4IR9Ci7m/PXN+
	 +591Ht0nGCIN45Oohf8PCdJTDKHr9y4aMiL2kqiQ5cOSBLnaFvWqb/IqpczKoOKH7G
	 PC7Y2P/GB/9s31mjqXtAu7jShZwAzUwXAKMbQU9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2232/2857] cpufreq: sparc-us2e: fix frequency table index copy-paste error
Date: Wed, 18 Nov 2026 15:54:26 +0100
Message-ID: <20261118150321.786633193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit e5b33fa47792375ca7fc49ccadee87d8e4b72929 ]

In us2e_freq_cpu_init(), the last two frequency writes both use
index [2] instead of [3] and [4] respectively, and the terminator
uses [3] instead of [5].  This is a copy-paste error where the index
was not incremented, causing the divider-6 and divider-8 entries to
overwrite the already-written divider-4 entry.

As a result, only three frequency steps (div 1, 2, and 4) are actually
available to the cpufreq core, while the intended dividers 6 and 8 are
silently lost.  The struct us2e_freq_percpu_info::table[6] has room for
5 entries plus a terminator, matching the 5 hardware dividers.

Fix the indices so all five frequency steps are correctly populated:
table[0]=div1, table[1]=div2, table[2]=div4, table[3]=div6,
table[4]=div8, table[5]=TABLE_END.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sparc-us2e-cpufreq.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 92acbb25abb3a..bbf5b3522fa67 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -284,12 +284,11 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	table[1].frequency = clock_tick / 2;
 	table[2].driver_data = 2;
 	table[2].frequency = clock_tick / 4;
-	table[2].driver_data = 3;
-	table[2].frequency = clock_tick / 6;
-	table[2].driver_data = 4;
-	table[2].frequency = clock_tick / 8;
-	table[2].driver_data = 5;
-	table[3].frequency = CPUFREQ_TABLE_END;
+	table[3].driver_data = 3;
+	table[3].frequency = clock_tick / 6;
+	table[4].driver_data = 4;
+	table[4].frequency = clock_tick / 8;
+	table[5].frequency = CPUFREQ_TABLE_END;
 
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
-- 
2.53.0



