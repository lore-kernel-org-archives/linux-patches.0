Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FEB33DEE6;
	Wed, 21 Jan 2026 18:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019981; cv=none; b=Gz+jUcobeTmi4WTB4A/28dICCdXKg9VWTeSaMagIEuKhTT7/1iVeGAJ67deAaqILr1ql4GtCYNslgVwfVrLnyovdkf6rQkCJrLbHFWEttjauLgQkRxBkwtYV/fM3v3IZRsz5X4YpdwBK8w8EBmR0lo6q+qanPIZUZFXbU/mxlIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019981; c=relaxed/simple;
	bh=6TC48NabBxS06f9CvX5nRdN3wR3KlmrdfJntvXgWAp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyk0+byVd9c95t7BRuiXrJQ98gq57U1nNfsXt7S7AupqQGr9d7+CG4+th9r+FH05G7iiy42rwmA4UeTVc7lRioDcazt7NRf89qWI6ZbwE/roUKZ8b/Pr0NoJxBPxHctB4MOZNBi7Cx4GLH7zxiP9f5KTXsvKHm1zYPWm7a30kd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=And/ZPeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="And/ZPeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4109C4CEF1;
	Wed, 21 Jan 2026 18:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019981;
	bh=6TC48NabBxS06f9CvX5nRdN3wR3KlmrdfJntvXgWAp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=And/ZPeHAff3lTzhyqjLqbiWVfXqw/ZcOG1i6sQ+LDivUZTvn10AL6YngAXIiriPf
	 VP9S6SXhCvWzmqTrmSDLKhMiqbxYRMJn87MyQy8YciOKOloXkJLMMQvkGcyKppg303
	 a/IHHL2OJBacY4BXZZyNS8cWT6iFZnDspBzi2/lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaxiong Tian <tianyaxiong@kylinos.cn>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/198] PM: EM: Fix incorrect description of the cost field in struct em_perf_state
Date: Wed, 21 Jan 2026 19:14:12 +0100
Message-ID: <20260121181419.423816570@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaxiong Tian <tianyaxiong@kylinos.cn>

[ Upstream commit 54b603f2db6b95495bc33a8f2bde80f044baff9a ]

Due to commit 1b600da51073 ("PM: EM: Optimize em_cpu_energy() and remove
division"), the logic for energy consumption calculation has been modified.
The actual calculation of cost is 10 * power * max_frequency / frequency
instead of power * max_frequency / frequency.

Therefore, the comment for cost has been updated to reflect the correct
content.

Fixes: 1b600da51073 ("PM: EM: Optimize em_cpu_energy() and remove division")
Signed-off-by: Yaxiong Tian <tianyaxiong@kylinos.cn>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
[ rjw: Added Fixes: tag ]
Link: https://patch.msgid.link/20251230061534.816894-1-tianyaxiong@kylinos.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/energy_model.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/energy_model.h b/include/linux/energy_model.h
index 61d50571ad88a..ce2db5447d221 100644
--- a/include/linux/energy_model.h
+++ b/include/linux/energy_model.h
@@ -18,7 +18,7 @@
  * @power:	The power consumed at this level (by 1 CPU or by a registered
  *		device). It can be a total power: static and dynamic.
  * @cost:	The cost coefficient associated with this level, used during
- *		energy calculation. Equal to: power * max_frequency / frequency
+ *		energy calculation. Equal to: 10 * power * max_frequency / frequency
  * @flags:	see "em_perf_state flags" description below.
  */
 struct em_perf_state {
-- 
2.51.0



