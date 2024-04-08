Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C9169E1C;
	Mon,  8 Apr 2024 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585090; cv=none; b=ERKtibtb22zdAao7Cn/D2qRvxK2LRlNPMn+8ouqjhdzy5qIcoQm5HuyXiiKT1N68SOs5oKyMCh4N0RbZjxc2/WIIl0bkCmnT7eZqiwv23DBpjDtv6DuYWuM8MJfD4Ib+HE9MzRxYDu6TDY1a+C4SKZE64bdZmz9qWrvM9YzH9ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585090; c=relaxed/simple;
	bh=tc3Ba/m6qUSE+dtP/jyGD0ZMRs4AdfQES8z9QM+aOOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBsonhfB8qtfWEMu8CTp2Ndm94ypAAExsGvOeaYUwokB7Pdh3K6aFMLz073SvSM95cYDBZ63lfx15pzO8S74PHtKr8c5AV36M9drrKQrJyWvQxwDdwsdhyCKsFIc8HuNoQxgcjjbsOtq6TeaT9OBXpGn7DDmAHmUluauKqqMyT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acdMN7yu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acdMN7yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF7DC433F1;
	Mon,  8 Apr 2024 14:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585089;
	bh=tc3Ba/m6qUSE+dtP/jyGD0ZMRs4AdfQES8z9QM+aOOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acdMN7yu1HxnNuMrxcQA2UXYUQqvBnr9D5URrOPEjZbFQujBct7pm1afEprRbLKms
	 eFGMZv+CBWNahXZi+DWZyoHYuFPzeaUnyprejbA+8SN9TY3X2UHe+fayQ4gr1d5ieB
	 7Z2dSK2qOuDKMTIKnbaSuWWWYp1pe8m9w1VhvOzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.15 660/690] i40e: Store the irq number in i40e_q_vector
Date: Mon,  8 Apr 2024 14:58:46 +0200
Message-ID: <20240408125423.590409714@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 6b85a4f39ff7177b2428d4deab1151a31754e391 ]

Make it easy to figure out the IRQ number for a particular i40e_q_vector by
storing the assigned IRQ in the structure itself.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: ea558de7238b ("i40e: Enforce software interrupt during busy-poll exit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 453a85410634e..7282dfba4122e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -973,6 +973,7 @@ struct i40e_q_vector {
 	struct rcu_head rcu;	/* to avoid race with update stats on free */
 	char name[I40E_INT_NAME_STR_LEN];
 	bool arm_wb_state;
+	int irq_num;		/* IRQ assigned to this q_vector */
 } ____cacheline_internodealigned_in_smp;
 
 /* lan device */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index a98b1251b561e..d204c33409c68 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4133,6 +4133,7 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
 		}
 
 		/* register for affinity change notifications */
+		q_vector->irq_num = irq_num;
 		q_vector->affinity_notify.notify = i40e_irq_affinity_notify;
 		q_vector->affinity_notify.release = i40e_irq_affinity_release;
 		irq_set_affinity_notifier(irq_num, &q_vector->affinity_notify);
-- 
2.43.0



