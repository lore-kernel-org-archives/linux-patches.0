Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA6E35C6B8;
	Tue, 21 Jul 2026 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669458; cv=none; b=m1JkjD01Y4B0rAaZddbcx3KoqICUz9OhUrlWjz80mof3EujwvgWSX/RjCQ+WQLTD6p8oRJqcGRbKEpu+7SuXlH1ogzImiunwK4Y+n2S5nzNmowUHtF88tqbf4SiXQW2uLnxA5j1LLqXSA6fgH9Ul0TRCX9WOh06elAi3QqxzfOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669458; c=relaxed/simple;
	bh=OMIlLwnMDM/V3pKlI9Wc6oXcasqY3VO35jPlt0PL6Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4nuEP3P2zXUgJk/0HpS1vwie6C6NJRzGHh/H0VCbpuCWL42HC7LcKWfEjvNPzsPxcmml1eF8/3g64d3AAV1iZBIyxViASNJxN+DUZavLZseXUe406xxX4E8Hrvd9d/2f1Z15l/+Mft0r0yV9A/psAyQDHngOfcVzXhPSB3Pjjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwKUw/tR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwKUw/tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892001F000E9;
	Tue, 21 Jul 2026 21:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669457;
	bh=LsFBkNK4yGReeyeaA9U2H/F9QNBNVn8lJCD8P85XdCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwKUw/tRtrKmfm9sdxsfn7KvbyVdIQIXalvrDiKcqXe8McTuA5BtpWi9iCFebu2IS
	 t6gFKjoB9bbW0hBA0IyVMT2hdaYkzrWaOAnh+BHmCI5NvRvzpXNRabjMOffB3gyB3q
	 /8edSAYKTUjrzzodX36sNlVETuuhiO9c7nFkrRiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0560/1067] apparmor: fix label can not be immediately before a declaration
Date: Tue, 21 Jul 2026 17:19:21 +0200
Message-ID: <20260721152437.133519833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 1ed40bd525c00d22af666016af9aef7167f8085f ]

Fix error reported by kernel test robot

security/apparmor/policy.c:1381:2: error: a label can only be part of
a statement and a declaration is not a statement

All errors (new ones prefixed by >>):

   security/apparmor/policy.c: In function 'aa_replace_profiles':
>> security/apparmor/policy.c:1381:2: error: a label can only be part
   of a statement and a declaration is not a statement
     ssize_t udata_sz = udata->size;
     ^~~~~

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606150525.npax8WiH-lkp@intel.com/
Fixes: 7b42f95813dc9 ("apparmor: fix potential UAF in aa_replace_profiles")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index 0ceb2a381f8f37..257ca96a3d0678 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -1152,9 +1152,10 @@ ssize_t aa_replace_profiles(struct aa_ns *policy_ns, struct aa_label *label,
 	mutex_unlock(&ns->lock);
 
 out:
+	aa_put_ns(ns);
+
 	ssize_t udata_sz = udata->size;
 
-	aa_put_ns(ns);
 	aa_put_profile_loaddata(udata);
 	kfree(ns_name);
 
-- 
2.53.0



