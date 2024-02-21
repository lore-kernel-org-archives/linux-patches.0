Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C1D79DAE;
	Wed, 21 Feb 2024 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523495; cv=none; b=UJod49tbzoPBIU+//0M9ndM+zR+TvY9RwqCxjYquS2Hnq3AwcMzc9bY9+C5cxpA9jcH/SLtY3z2+j1a951188804fntAzTstzAbRaPy5XtPS8s5mP7VCqYmoR2bjQM8sqLEVJF3ql8zN1a4ePOJIYsY6OzsKAA6MoZCFPjwT4/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523495; c=relaxed/simple;
	bh=skPU2jBzRpS0YJ8IZKH0PmIl/JU+vda100MnNbzOXAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdzOA9X2i6gsghQEE4c3y8rI0toAsKUAnDad9A0TI32gGBmgM/T+Imhj1ZKTKemYNDFhR2/ziT9smjOpIifI40GzD1Pgt67LqpRY1Q6yJrp+325PjmPRDFnWgza7vOzWMYax+kM1fjuBeL0rk6A7s5c5ZDzqClSpJhsxKhCjN4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X8FMdmp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X8FMdmp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A371C433F1;
	Wed, 21 Feb 2024 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523494;
	bh=skPU2jBzRpS0YJ8IZKH0PmIl/JU+vda100MnNbzOXAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8FMdmp/FcriSw1nkcjyGOQdXBUPAY5TzavdBMezcAgVsbXIWMQ5sivR9AScYBChJ
	 xyxa1b9hSx5juoKG15SNxNTezI3pPtFEpdtZ9B0IPovBqf597seYBL/8wXrlGk/eNw
	 KryQnuz4T1v7zgyMdW3j/PnjmLNLhuLfU2AExac4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 423/476] pmdomain: core: Move the unused cleanup to a _sync initcall
Date: Wed, 21 Feb 2024 14:07:54 +0100
Message-ID: <20240221130023.670839120@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit 741ba0134fa7822fcf4e4a0a537a5c4cfd706b20 upstream.

The unused clock cleanup uses the _sync initcall to give all users at
earlier initcalls time to probe. Do the same to avoid leaving some PDs
dangling at "on" (which actually happened on qcom!).

Fixes: 2fe71dcdfd10 ("PM / domains: Add late_initcall to disable unused PM domains")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231227-topic-pmdomain_sync_cleanup-v1-1-5f36769d538b@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1044,7 +1044,7 @@ static int __init genpd_power_off_unused
 
 	return 0;
 }
-late_initcall(genpd_power_off_unused);
+late_initcall_sync(genpd_power_off_unused);
 
 #ifdef CONFIG_PM_SLEEP
 


