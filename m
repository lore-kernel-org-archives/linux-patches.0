Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCD22DF9F;
	Tue, 20 Feb 2024 21:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464185; cv=none; b=P9U0t7ut+E+LbiAJ0cjxlqZ2guU7F4nYGLEQNiE96eJhpLJC/fKqJ4hyFsNknWROy4GaCIt5vtTfSD8hn8ANpIkiJZtbWKkBrG37+hYb/RBBHmL9iddzWdowtaWoI3zZjGpl/2mz2axyu6g/b/L1z0d4+lB0l4m7a/93YgdtrbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464185; c=relaxed/simple;
	bh=4N+W58ybfUxCDjXoUl+wWXv2HzTrpogKDFXtorO3sgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9tmhVcFZDdy14zcC0MBUDlQLewULvyRP6ey75JWUb1CGkosu6zbx6CASfo44woGMv4P+bfvAfkdmOhtHwql4vyNaL3LwnA1b+1swDp8S4TgwNGRlHeRGQai+37pPVIuxjhoAM8woN2K0Be5gugGgeGMt+cRoUmp6EwEi8QD5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCB5Uvoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCB5Uvoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF87CC433F1;
	Tue, 20 Feb 2024 21:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464185;
	bh=4N+W58ybfUxCDjXoUl+wWXv2HzTrpogKDFXtorO3sgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCB5UvoaTBU4hKXcKhaIGtfi+MMqZtJIMtldoHIFK109ke7hUboav4VfIcRK6AnqR
	 AlEekyzHhxrHGvJfok641cNSqr1F3+QaJDtITJWZur7j0VzhuxmxCnIziaoxETGm7K
	 4ESqTab/ERke3L7F5mjiwqY9vnJH1h7X9oKjAeaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 249/331] pmdomain: core: Move the unused cleanup to a _sync initcall
Date: Tue, 20 Feb 2024 21:56:05 +0100
Message-ID: <20240220205645.646799527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1102,7 +1102,7 @@ static int __init genpd_power_off_unused
 
 	return 0;
 }
-late_initcall(genpd_power_off_unused);
+late_initcall_sync(genpd_power_off_unused);
 
 #ifdef CONFIG_PM_SLEEP
 


