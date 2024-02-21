Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641179DBF;
	Wed, 21 Feb 2024 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525731; cv=none; b=FZY484oi92s+aS1IscFJ2NwfuKhEomev29t4aQcg9bZgGEjGf7IWNO68/baxaJTCoXNDbwdC58aP5aB1raLGXZ0va8h05B4c+IucOQuluaFv8mz94iQ52z1UIyAB32NDqbBtgtZxUssorvHOsMA5c9uLTjK+ir9VjpcI4ucgvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525731; c=relaxed/simple;
	bh=di+ZQkiXUUGc2RNLwiljhCuUxFVZFlcbp5bJ7o6AQ8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJYXZRlkMJNNlPIBur9gzjek3PVKdQH0qtQdEFuu56pGIVcyed3MG+KXwtDY2garkHHRxqSQLJ84C/wuQy68N6CJL7VUZoS+G5cEaqZh8anuosxOzAMgBf7TzgFtHRSTVaUjXhZN8WOACPI8V23TA3SEKCsUkrzIRmVm75NK7yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiMQdzqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiMQdzqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1491EC433F1;
	Wed, 21 Feb 2024 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525731;
	bh=di+ZQkiXUUGc2RNLwiljhCuUxFVZFlcbp5bJ7o6AQ8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiMQdzqWmg/s8vGyI6IZZ2MqoxTrsS7hwmAe0t7rQcxtE5ncg4uUOtndJwge8jeMB
	 xxWCTNhwJhYJ+AJSSRvN7fA5vehWnTJY3facGeTDbDrwpE8+qIfDMOTWU2n3vEdy67
	 HcxOA0dwf+BdMDd4WJCxNAUf/jM6NHCxXUzuUWgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 246/267] pmdomain: core: Move the unused cleanup to a _sync initcall
Date: Wed, 21 Feb 2024 14:09:47 +0100
Message-ID: <20240221125947.967381296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -920,7 +920,7 @@ static int __init genpd_power_off_unused
 
 	return 0;
 }
-late_initcall(genpd_power_off_unused);
+late_initcall_sync(genpd_power_off_unused);
 
 #if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_GENERIC_DOMAINS_OF)
 


