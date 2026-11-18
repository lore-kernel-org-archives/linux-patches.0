Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016189;
	b=rkJHrO9FZytmUNR9MTi/n+yEO5O3UrgD9Abo1pj+nOUFBhPFXAXBdZq0lOr47YRkA2F3
	 qmxUAkdXwjHG3h9njyZEE6Qxb6+XPIX5UP65ci8t45gjMqQX6I00ZvhVrZWczF7yJZymV
	 jZoUKUZzi39HMTfSaHG3nlVw9g5i6UpNTJ+CNS3ZW5goCwtj/iIdg3kV+VZgIYjpB/HxW
	 fxEPDfGq2tVsZNKHAjf+8OMAPGkzdDcheoKNArJVSl/MqVCIkyyOI8yGxnDlU4fXmDiYr
	 aeLGtR5e2urTNzb6bKjmhtMQY4xEaE+J1orVR1HZfQvcMPPhuX7xp46LGXN7hIqnbbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vSSlS4Yr6tErTG9LyptXPJIinM8KkTKrXEyaZhqU2V4=;
	b=p65/ti8QO9VCod7oOZajEryabUQYGr0f9MmvozfR0Tvfvx6m4HLrW8uaPSZAoyseeJx3
	 JQCxHi63cpUb98UfjYrjGBnxSdI4PeYXReNTKuYfErY/Wixn8GG4VmUMZkO6XEcQbC7/O
	 bXDEdTCbRXG7ssZpoMyWZdy8OnNC10Wy74WF1Qes49w7gJTipEoruoOY+AI5dqPOGBLez
	 1v+8acUuJdPuua5+EHhnOOlLIC0138m8J/gF0nh4nB/WM4mbqFwRAKJTzN40NobMmjgM4
	 pLh6zdXHu5OAJAyJHZzwKPbjeE/Ba5K14XSmNMGaOhDmrmst1o4BKrC19daZm+OxsJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eted0oGN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA13606A325;
	Wed, 18 Nov 2026 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eted0oGN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3F91F000C4;
	Wed, 18 Nov 2026 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016189;
	bh=vSSlS4Yr6tErTG9LyptXPJIinM8KkTKrXEyaZhqU2V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eted0oGN2+c4EfLNfKYz1JObPXQnNX2Q1fR4wbp65KmxExYb8tal5IAOdrfvCQ7Bv
	 hTXU+0zlMx8cM7S1QQ7EJgINmx2rzrCl6fX0U3n9LY3SBpai78661V1WWkRmUg1H6E
	 hUyEKEVQYh/ZW007O+B/KxaVWTDTWpFtk7dRRuOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0442/2651] cgroup/dmem: Fix eviction helper reference in dmem_cgroup_try_charge()
Date: Wed, 18 Nov 2026 15:28:02 +0100
Message-ID: <20261118150303.731196049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit e8f69fe59a104b4a97a3365dbb43c72996c2acde ]

The kernel-doc comment of dmem_cgroup_try_charge() refers to
dmem_cgroup_evict_valuable, which does not exist. The name is
dmem_cgroup_state_evict_valuable. Say dmem_cgroup_state_evict_valuable.

Fixes: b168ed458dde ("kernel/cgroup: Add "dmem" memory accounting cgroup")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/dmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4683f3d680226..10e148d64e857 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -706,8 +706,8 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
  *
  * When this function fails with -EAGAIN and @ret_limit_pool is non-null, it
  * will be set to the pool for which the limit is hit. This can be used for
- * eviction as argument to dmem_cgroup_evict_valuable(). This reference must be freed
- * with @dmem_cgroup_pool_state_put().
+ * eviction as argument to dmem_cgroup_state_evict_valuable(). This reference
+ * must be freed with @dmem_cgroup_pool_state_put().
  *
  * Return: 0 on success, -EAGAIN on hitting a limit, or a negative errno on failure.
  */
-- 
2.53.0



