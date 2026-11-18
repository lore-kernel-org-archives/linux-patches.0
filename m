Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018280;
	b=Sm/ZmWdqbXySVU0jIoVaD7Dqtvz6yosWN2K/Ag1rGOFkhKkERzyyRT3wbvMqa8sYfZzK
	 VnAPZsYCBhyHcqALrJJIdIyQHYw5Jo5XLVOJMe7P4uei8F2Ot/z2Uw8UMrO9vHKXgO0Qt
	 GwPCj7OhHOapsSqe+8ZRmmIpLavJCrDQo7B730SccmYnSHfWeLYEvYLDJ/oKQJa1DTQWZ
	 wwbGydhaH74UJ2LIdVEXvFEbQEGr1JlcmhLhLZxBFB+PE52Ncki+JBExjYcnw2J+K4QGd
	 gyClDBZQxHJVLP6t8fgrwB2j0onyaAijiIgFYkjHzSKksmMAH5uQd2YfwOY7fwEXj2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+IlMy7yciLFGlKSUJY0Lsc+/HV1iPhgZt+lFvXuK/34=;
	b=ATPCorXy4vMcYAiDoPEjNhfJ3Kg4m1z2angK4lAOc/B8YYnCC5MOD++ZsmTf4t3IJLBk
	 LpCznXGDYe0voYCpfY3N14QoY9/+8dAqf+XKIEJecjxFqNKyFET4MXOUyDCVr9tZojCmR
	 qcGz9n3HFXiQhecn3uDy6kbu9gL/nve0JsI/vT8ASjdrLpqBesqGkn7YBzKMoU/LXGI6e
	 3kv/2fsaV+uJUgOJtyZEuDbL5AiLPiq+g1n/m3jvR3r6kenTAFD2gtHm6wiFYKybYfz4Q
	 Vw+Dx3QfexnvTUtIXxY5/shCNYV3gh1EnU5zJXVLv4yfwY4PzRNMPR0Ix8qoMxFnkyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYQmvL78;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDAB606A334;
	Wed, 18 Nov 2026 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYQmvL78
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807131F000C6;
	Wed, 18 Nov 2026 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018280;
	bh=+IlMy7yciLFGlKSUJY0Lsc+/HV1iPhgZt+lFvXuK/34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYQmvL787pEJzZoaF9ayW6ITidF3qRbTCZoWU1oLby28NrIjp6XPVgI9ksIwmR3vG
	 OWtZ+qy7hbG0Qnle/CCiSEZJ6pePoNIwXQ3OVp1EGCpA47Z9CcPs81DMDtbaAHOflL
	 rQbFXujmdjXZuWAoWfhCr+0TnA/ILOymlRxWVUQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1185/2651] arm_mpam: resctrl: Make read_mon_cdp_safe() self consistent
Date: Wed, 18 Nov 2026 15:40:25 +0100
Message-ID: <20261118150330.664553046@linuxfoundation.org>
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

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 09ff5358c6233c3155c8779c608c24d7f146f532 ]

When read_mon_cdp_safe() is called with cdp_enabled equal to false then the
reading returned in val is the sum of the monitor values for the given
component. However, when cdp_enabled equal to true it is again the sum of
the monitor values but with the initial value of val also added. Both
resctrl_arch_cntr_read() and resctrl_arch_rmid_read() call
read_mon_cdp_safe() and are documented to return the val directly without
consideration of the older value.

The val is always zeroed before read_mon_cdp_safe() is called except in
__check_limbo() and __l3_mon_event_count_sum() but the latter is not
relevant on MPAM systems.  The extra accumulation in __check_limbo() means
when there are multiple RMIDs in limbo some of them may be marked dirty
when they are already clean.

Change the cdp_enabled equals true case to match the false case.

Fixes: fb56b29932ca ("arm_mpam: resctrl: Add resctrl_arch_rmid_read()")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
[morse: fixed commit message indenting and removed stale description]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_resctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index b825bd90d4bdb..321741a702fea 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -497,7 +497,7 @@ static int read_mon_cdp_safe(struct mpam_resctrl_mon *mon, struct mpam_component
 		if (err)
 			return err;
 
-		*val += code_val + data_val;
+		*val = code_val + data_val;
 		return 0;
 	}
 
-- 
2.53.0



