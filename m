Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD2676C9C;
	Tue, 20 Feb 2024 21:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463315; cv=none; b=ClfBi3sBaeEgFSvAGgPLCgGahqqXlVROLgMsYWoKBUzEbWzdZs0FeQFx6RKcdF3zti0LEOwEC8zDUrVFLYMgFemCWYagxk7cpK/a/fd26ypwby47If+lbV93jWduXozAFvwgp3xaUHh3dOmaAkdBn4MSBaqykNRNYN82K+ksS6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463315; c=relaxed/simple;
	bh=ok6tjuk6OnQBAwfPh8O7AoO/OaBEONb0U+SzdK94hLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHocooM8yR3NhNq/YLMjz9vKtUQFJ9yuCAoSyBfVLb43958wXQfwfh+BTIJ2pedvQD6C8gIyw28BKnwx52hzLCUbYNpSNgcnT/Rnd5yqnS7To8271U9YgCPAKvwxxYz2R+efRkINgBNKf7rInebzMhm9jY3mI4Xw7MimK8eg3pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqPdRY7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqPdRY7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC63C433F1;
	Tue, 20 Feb 2024 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463315;
	bh=ok6tjuk6OnQBAwfPh8O7AoO/OaBEONb0U+SzdK94hLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqPdRY7iDZJEzdEej3ebTiwDj/tvoAiz3VTAe0LclXfJULtqr5yWYCXBSmzJbHbff
	 a3EvU90yByxQiWX5SF8mO0+EL+ptlvh1Il7yjrEs5hdf1NaesjrpQLpWgQfXOxIRy2
	 3Om7QTKt+Pn8vy2inHeIB04PuYFaIlnn03sW3gQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 164/197] pmdomain: core: Move the unused cleanup to a _sync initcall
Date: Tue, 20 Feb 2024 21:52:03 +0100
Message-ID: <20240220204845.982595649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1052,7 +1052,7 @@ static int __init genpd_power_off_unused
 
 	return 0;
 }
-late_initcall(genpd_power_off_unused);
+late_initcall_sync(genpd_power_off_unused);
 
 #ifdef CONFIG_PM_SLEEP
 


