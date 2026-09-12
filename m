Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEE047887F;
	Sat, 12 Sep 2026 11:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212714; cv=none; b=T1gc4hH8ipUSMb+NbZZstiQE+bTTbAQOR4p4qoMk7smqr7Tk0GZo1x21ggw7fzXUR6NeH8YyOD+UJqrQLJkGpzAPNjCc785HHHHjQK3vYKsgmEqV5cFVPyQtN5vqzePdPpQ/mPoX+2jbKbhldVAfLrQeggpQc5ZwdbRkTe3PoqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212714; c=relaxed/simple;
	bh=0pajKlBP4Rq758a7gS24EZrnJOYGfjYS5BJXGwP8x54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEyBc7litZYTbNiRo5L1SRfBAzhotWOvmREanURRp0M/ezbA+247xWI8ENw7tcqgqh2wE+eh/x9DMty+y565JMTOuzLpIJT92LHgS8+aturNLF1LzPglD8oHs3acpdLslxo6E9rYytcrB5S0HNFD2Nkc+AXQ6HNNbDSl8gJc7Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2y6yavA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2y6yavA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581201F00898;
	Sat, 12 Sep 2026 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212711;
	bh=J4+XOdLLJuCxe57rSOxBoXC/yAjCI8ljNZ4Ol4Spx5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2y6yavAaq+4LFVf/wAlUrjQoqx9F18INePIgWEcI/jF83+WQRsSpsxbOcBNgw4Jv
	 pLf+8mtpCVjdNlBvrMq5v61H1bUJbNxqScJ0LUJ92Q7Y7sb1rp2VDnlB2fDaSG40Sn
	 eoHeMxiBGhM+1j6qzgtoHVjtU3ZcQB/bF4jGGeFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1492/1518] apparmor: fix kernel-doc comments for inview
Date: Sat, 12 Sep 2026 09:01:01 +0200
Message-ID: <20260912065657.312609495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 3734b9463bd4fb5ac350842db55e2e0ccbf1b7a5 ]

subns was renamed inview to better reflect the function of the flag.
Unfortunately the kernel-doc was not properly updated in 2 places.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602020737.vGCZFds1-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202602021427.PvvDjgyL-lkp@intel.com/
Fixes: 796c146fa6c82 ("apparmor: split xxx_in_ns into its two separate semantic use cases")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 836a0af44afec..5c42cd01ea473 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1334,7 +1334,7 @@ static int label_compound_match(struct aa_profile *profile,
  * @rules: ruleset to search
  * @label: label to check access permissions for
  * @start: state to start match in
- * @subns: whether to match labels in view or only in scope
+ * @inview: whether to match labels in view or only in scope
  * @request: permissions to request
  * @perms: an initialized perms struct to add accumulation to
  *
@@ -1397,7 +1397,7 @@ static int label_components_match(struct aa_profile *profile,
  * @rules: ruleset to search
  * @label: label to match (NOT NULL)
  * @state: state to start in
- * @subns: whether to match labels in view or only in scope
+ * @inview: whether to match labels in view or only in scope
  * @request: permission request
  * @perms: Returns computed perms (NOT NULL)
  *
-- 
2.53.0



