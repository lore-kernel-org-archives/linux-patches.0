Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F7E21D596;
	Wed, 25 Feb 2026 01:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982863; cv=none; b=nV9TOKPRxzGt5/4HTDLJccl4eVeF8bk/E6qsMtG7c0lMNXjlAtReYNV+5XO5n1fb7bELfEcLRVDYNEHDfrj5m0r8AYBAl5CEwMEFYg77vwkLookBJagikHBolxb4DflGqFWHlsHqJLSlwIlzrdrL8XE5EWoTqWi3AgKn4wtVtKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982863; c=relaxed/simple;
	bh=UHsVzWeXd17KLnznuu+yxX8FMfXyq3YxjOvYwuTuGyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG3PAyROmEuRIfdgTLL7khHWCu4UPdt3GOAd/EqIv8PL/kpHQosAYW4V5+0icdXCZU3KoS115SeZLcl1YLa0t8Elj2+pcvZoBy6c19Yu9llUImCOSl8eDukjgthU2CMW1fr3Q8OPqeePmt7VJrzgW6Iewk8thOgpO3F6W6JVio8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bR49LgPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bR49LgPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748B9C116D0;
	Wed, 25 Feb 2026 01:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982863;
	bh=UHsVzWeXd17KLnznuu+yxX8FMfXyq3YxjOvYwuTuGyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bR49LgPSSyJopJnTuiGCKxbuNKu+2zb9HiLo+usmid8AVvkRdO8ypA0htXPIW6neZ
	 KwaHnZ+iopjm63BYURv5q8XiVYBPq8n4ogip515TwxklW4ReCF7ov81o8v8fzScH4H
	 j4F52+GjbwmKR5i5Qv32q2DFEYp8IeSbb8p5/TT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleks Todorov <aleksbgbg@google.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 050/781] OPP: Return correct value in dev_pm_opp_get_level
Date: Tue, 24 Feb 2026 17:12:39 -0800
Message-ID: <20260225012400.928011207@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleks Todorov <aleksbgbg@google.com>

[ Upstream commit 0b7277e02dabba2a9921a7f4761ae6e627e7297a ]

Commit 073d3d2ca7d4 ("OPP: Level zero is valid") modified the
documentation for this function to indicate that errors should return a
non-zero value to avoid colliding with the OPP level zero, however
forgot to actually update the return.

No in-tree kernel code depends on the error value being 0.

Fixes: 073d3d2ca7d4 ("OPP: Level zero is valid")
Signed-off-by: Aleks Todorov <aleksbgbg@google.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index dbebb8c829bcb..ae43c656f108c 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -241,7 +241,7 @@ unsigned int dev_pm_opp_get_level(struct dev_pm_opp *opp)
 {
 	if (IS_ERR_OR_NULL(opp) || !opp->available) {
 		pr_err("%s: Invalid parameters\n", __func__);
-		return 0;
+		return U32_MAX;
 	}
 
 	return opp->level;
-- 
2.51.0



