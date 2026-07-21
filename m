Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC06473C6D;
	Tue, 21 Jul 2026 21:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667929; cv=none; b=h7Ey9t8Jw98TNqElUP9GdLkLytBR6ch1ILHTDlhEdatWMwH+NocJ454lM+5MFB4Bl3HhtzznREIQmynL0llcnzQ14TVEw5NPdktNp8jvPfiHGAofq1f1SjG3b3O092Iw2XLPLt7/f6fk0b8BULcPAqzhoBlS/3rj5IiRo80k/U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667929; c=relaxed/simple;
	bh=nL2dPQcWj9I4fHHnIWHVJYRWUCizTqUWjbv6fTxE6hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fuva2TNYuJbnQLicFrqruMpStS9OJT//n3ldrTc8NMaw3euyEOyJnsiiAmOA+xW4Pl8RoJHdx0c4jPOv1mSDeZ7pr5jzLj8dSvvzisi8DJtJv4TL4T6irEiRYs4E69ULlgNoY15YBQYjm6Xe/NyBtB+4UpAx4seTe3XZ0gADfS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XW/s3JlR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XW/s3JlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2021F000E9;
	Tue, 21 Jul 2026 21:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667927;
	bh=ufRv1EX/dOPrPxvhzNtynTOpUjqaJ9EVx+ZVF2RBjVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XW/s3JlRTLpM57yKH/vEAqVWILCZ1I6HRptOwHhrC8NhBvkUt31msRgaholFY+mXu
	 vaWETxSQFEVEjy872Cq7ENTlxflKkMQGKiUOkY3sjCC8UaB+YGZabQ1Hyp3HJwd6mI
	 UypBV6GWxe0z14VCsAMEwL7kDjUfs9bNsgo4IAMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1202/1266] cpufreq: pcc: Remove empty exit() callback
Date: Tue, 21 Jul 2026 17:27:19 +0200
Message-ID: <20260721152508.696970664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit dfd3e8b90b3660b706c3031b0f746377c571b324 ]

The exit() callback is optional, remove the empty one.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Stable-dep-of: bcb8889c4981 ("cpufreq: qcom-cpufreq-hw: Fix possible double free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/pcc-cpufreq.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -564,18 +564,12 @@ out:
 	return result;
 }
 
-static int pcc_cpufreq_cpu_exit(struct cpufreq_policy *policy)
-{
-	return 0;
-}
-
 static struct cpufreq_driver pcc_cpufreq_driver = {
 	.flags = CPUFREQ_CONST_LOOPS,
 	.get = pcc_get_freq,
 	.verify = pcc_cpufreq_verify,
 	.target = pcc_cpufreq_target,
 	.init = pcc_cpufreq_cpu_init,
-	.exit = pcc_cpufreq_cpu_exit,
 	.name = "pcc-cpufreq",
 };
 


