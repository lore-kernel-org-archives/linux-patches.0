Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228209;
	b=tKQ4x526m626GIl8BQpS27RJ6notA5+T+y+Cj298O4564cgibGxZcmL08tlyV8wNzI2m
	 WYzzZNNjVW7XTnAubk4rAJs+1wmurabRoTkRqj18eUVgrgwT29y+cbymT7NbPhG3qimEP
	 n/ltzvL1UCUSamx+4fbBxCuwNrYXZmtsqJ9IoIem138t9cO1f7HoigOKE0sbvofVu9beT
	 XOFeKnUZykaGts1bQidwuF8TdTfZPiW3NbJsrtonw80b/Qxf4eTcYM6V5a/Vl5ax5JDXS
	 nUsTJPqlpS6XqlkbpHLwuY5dFqUghnckNb0BF9w7jtHlwh5jTMIakpnE2EJBW7wcN1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228209;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=AqLqbS+yiVL8WmT3FB+pga/9OEv/6i7oY0Cl0Dr0qqo=;
	b=DidePN5yxisy2FfqStfKkhaYapZqOkP5NlxIuw4QpTqrC2WMa73asJEhgcd3gy4jYL5e
	 DdtGKwaXDBgSpRHuLiVTSI/fXYTEKGlcAJ5APkasgqWMAn2qk7EywhuEiTB7N3bmIVgMK
	 hJ1ol6uy+ZflNCeyYjfdjYV0zHWvuuO4LsEpbgjBU/OYumDS3YB87Xi4s0e3XVOvbMFHV
	 7suYNOwA6STga0smggPgmYSolUGk/p3dOsgdo4v72VyGrLkcLpPkJhlaOe3okd9WyDAQG
	 qLbTMQvrDwXTosl8/f1RLXVsfWqea3Av7bLmGxKx0u6VF53zVbtpJV1yJy5gPCcW4iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TItoZtN2;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419D1606A31A;
	Wed, 28 Oct 2026 22:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 419D1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=TItoZtN2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793228208; x=1824764208;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cxsy25zvSVy4ep6G5WTOJhBc59jMiw02/6WOHQ12+Gw=;
  b=TItoZtN2f10aFP0YiBtJe69v8+luzthWEpdikEVRVVikl4vxd58kgaja
   cblxej/0H83xbYxZHho3sf4PzRIAy8fBbJqEtEs3EePfLPrinqznqVmWe
   98xAgDZSp8XAyCGmGmG24EndKilmO1T8Z7R1lmPIIZXxxTmE0NR5HMcG0
   8I6C+PvVFGxXo5Jn3FCm3m3Sr72XH4F/TIflpbuspp+9lXYvxg+rTbmkv
   h+dW3ERMIg/gV+hLMDfBdyPonUK+zq9SSXyymItXoeXaJvDxLQ7KxcSAu
   YU/84DL7JBZwgCIbyYM5c43HbNXYguixklVqbty+68LUe3hQ1WKlaEydl
   g==;
X-CSE-ConnectionGUID: QdguF9NXQSeZH6XLD6XDag==
X-CSE-MsgGUID: kY+5g8nqQ46wkOHngMfQBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1840232"
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="1840232"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 15:56:47 -0700
X-CSE-ConnectionGUID: aHA93GOYQBCN1+loSdv/9A==
X-CSE-MsgGUID: XzOAQOeNSJGsFca37YcBqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,183,1787036400"; 
   d="scan'208";a="4880758"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO [10.125.108.227]) ([10.125.108.227])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 15:56:47 -0700
Message-ID: <9ff72d51-3933-4f2e-a854-c0f9695c0c04@intel.com>
Date: Wed, 28 Oct 2026 15:56:45 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected
 and locked contexts
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Jiri Pirko <jiri@resnulli.us>, Kevin Tian <kevin.tian@intel.com>,
 Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 patches@lists.linux.dev
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261028152618.1356860-9-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/26 8:26 AM, Aneesh Kumar K.V (Arm) wrote:

< -- snip -->

> diff --git a/drivers/pci/tsm/attestation.c b/drivers/pci/tsm/attestation.c
> new file mode 100644
> index 000000000000..993c26664498
> --- /dev/null
> +++ b/drivers/pci/tsm/attestation.c
> @@ -0,0 +1,525 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* PCI lifecycle and cached SPDM/TDISP evidence through CTLV attestation. */
> +#include <crypto/hash_info.h>
> +#include <linux/attestation.h>
> +#include <linux/ctlv.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/pci-tsm.h>
> +#include <linux/tsm.h>
> +
> +#include "../pci.h"
> +#include "ctlv_attestation_pci_gen.h"
> +#include "internal.h"
> +
> +struct pci_tsm_attestation {
> +	struct pci_dev *pdev;
> +	struct ctlv_device *ctlvdev;
> +	struct list_head retired;
> +	bool attached;
> +	/* Protected by pci_tsm_rwsem. */
> +	bool active;
> +	bool removing;
> +};
> +
> +static void pci_attestation_update_locked(struct pci_tsm_attestation *pa,
> +		bool att_locked)
> +{
> +	struct pci_dev *pdev = pa->pdev;
> +	struct pci_tsm *tsm = pdev->tsm;
> +	const struct pci_tsm_ops *ops = tsm ? tsm->tsm_dev->pci_ops : NULL;
> +	bool link = tsm && tsm->dsm_dev;
> +	bool devsec = tsm && !link;
> +	bool accepted = device_cc_accepted(&pdev->dev);
> +	bool present = !pa->removing && !pci_dev_is_disconnected(pdev);
> +	unsigned int features = 0;
> +
> +	lockdep_assert_held_write(&pci_tsm_rwsem);
> +
> +	if (devsec) {
> +		ctlv_device_op_state_set(pa->ctlvdev, CTLV_ATTESTATION_PCI_OP_EVIDENCE_REFRESH,
> +					 !present || !tsm || tsm->error ||
> +					 accepted || !ops->refresh_evidence);
> +	}
> +
> +	if (present) {
> +		if (tsm && !tsm->error) {
> +			features |= ATTESTATION_FEATURE_EVIDENCE;
> +			if ((devsec && ops->accept) || (link && is_pci_tsm_pf0(pdev)))
> +				features |= ATTESTATION_FEATURE_EVIDENCE_ACCEPT;
> +		}
> +
> +		if (devsec)
> +			features |= ATTESTATION_FEATURE_TDISP_STATE;
> +	}
> +
> +	if (att_locked)
> +		attestation_features_set_locked(ctlv_priv_parent(pa), features);
> +	else
> +		attestation_features_set(ctlv_priv_parent(pa), features);
> +}
> +
> +void pci_tsm_attestation_update(struct pci_dev *pdev)
> +{
> +	lockdep_assert_held_write(&pci_tsm_rwsem);
> +	if (pdev->tsm_attestation && !pdev->tsm_attestation->removing)
> +		pci_attestation_update_locked(pdev->tsm_attestation, false);
> +}
> +
> +void pci_tsm_attestation_notify_state_change(struct pci_dev *pdev)
> +{
> +	struct pci_tsm_attestation *pa = pdev->tsm_attestation;
> +	struct attestation *att;
> +
> +	lockdep_assert_held_write(&pci_tsm_rwsem);
> +	if (!pa || pa->removing)
> +		return;
> +
> +	att = ctlv_priv_parent(pa);
> +	/* The active CTLV operation already holds this instance's mutex. */
> +	if (pa->active) {
> +		attestation_state_changed_locked(att);
> +		pci_attestation_update_locked(pa, true);
> +		return;
> +	}
> +
> +	/* Native notifications outside dispatch must acquire the mutex. */
> +	attestation_lock(att);
> +	attestation_state_changed_locked(att);
> +	pci_attestation_update_locked(pa, true);
> +	attestation_unlock(att);
> +}
> +
> +void pci_tsm_attestation_remove(struct pci_dev *pdev, struct list_head *retired)
> +{
> +	struct pci_tsm_attestation *pa = pdev->tsm_attestation;
> +
> +	lockdep_assert_held_write(&pci_tsm_rwsem);
> +	if (!pa || pa->removing)
> +		return;
> +
> +	/* Revoke old descriptors before another session can be installed. */
> +	pa->removing = true;
> +	pdev->tsm_attestation_removing = true;
> +	list_add_tail(&pa->retired, retired);
> +}
> +
> +void pci_tsm_attestation_destroy(struct list_head *retired)
> +{
> +	struct pci_tsm_attestation *pa, *next;
> +
> +	/* ctlv_destroy() drains callbacks that may be waiting for pci_tsm_rwsem. */
> +	list_for_each_entry_safe(pa, next, retired, retired) {
> +		struct pci_dev *pdev = pci_dev_get(pa->pdev);
> +
> +		list_del(&pa->retired);
> +		ctlv_destroy(pa->ctlvdev);
> +
> +		/* The common registry has now retired this parent as well. */
> +		scoped_guard(rwsem_write, &pci_tsm_rwsem)
> +			pdev->tsm_attestation_removing = false;
> +
> +		pci_dev_put(pdev);
> +	}
> +}
> +
> +int ctlv_attestation_pci_op_pre(void *priv, struct ctlv_op_ctx *ctx)
> +{
> +	struct pci_tsm_attestation *pa = priv;
> +	int ret;
> +
> +	/* All native paths, including notifications, use PCI -> attestation. */
> +	ret = down_write_killable(&pci_tsm_rwsem);
> +	if (ret)
> +		return ret;
> +
> +	if (pa->removing || !pa->pdev->tsm || pci_dev_is_disconnected(pa->pdev)) {
> +		up_write(&pci_tsm_rwsem);
> +		return -ENODEV;
> +	}
> +
> +	ret = ctlv_attestation_op_pre(ctlv_priv_parent(pa), ctx);
> +	if (ret) {
> +		up_write(&pci_tsm_rwsem);
> +		return ret;
> +	}
> +
> +	pa->active = true;
> +	pci_attestation_update_locked(pa, true);
> +	return 0;
> +}
> +
> +void ctlv_attestation_pci_op_post(void *priv, struct ctlv_op_ctx *ctx)
> +{
> +	struct pci_tsm_attestation *pa = priv;
> +
> +	pci_attestation_update_locked(pa, true);
> +	pa->active = false;
> +	ctlv_attestation_op_post(ctlv_priv_parent(pa), ctx);
> +	up_write(&pci_tsm_rwsem);
> +}
> +
> +static int pci_attestation_prepare(struct pci_tsm_attestation *pa, u64 generation)
> +{
> +	struct attestation *att = ctlv_priv_parent(pa);
> +
> +	if (generation != attestation_get_device_generation(att))
> +		return -ESTALE;
> +
> +	return attestation_state_change_prepare(att);
> +}
> +
> +static int pci_attestation_reply(struct pci_tsm_attestation *pa,
> +		struct ctlv_cursor *reply)
> +{
> +	struct attestation *att = ctlv_priv_parent(pa);
> +
> +	if (!ctlv_attestation_pci_pci_generation_put(reply,
> +				attestation_get_device_generation(att)))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +
> +int ctlv_attestation_pci_evidence_refresh_action(void *priv, struct ctlv_op_ctx *ctx,
> +		const struct ctlv_cursor *request, struct ctlv_cursor *reply)
> +{
> +	struct pci_tsm_attestation *pa = priv;
> +	struct pci_tsm *tsm = pa->pdev->tsm;
> +	const struct pci_tsm_ops *ops;
> +	const void *challenge;
> +	enum pci_tsm_evidence_type type;
> +	u64 object;
> +	u32 length = 0;
> +	int ret;
> +
> +	object = ctlv_attestation_pci_evidence_refresh_object_get(request);
> +	switch (object) {
> +	case CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_SPDM_MEASUREMENTS:
> +		type = PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS;
> +		break;
> +	case CTLV_ATTESTATION_EVIDENCE_BLOB_CLASS_TDISP_REPORT:
> +		type = PCI_TSM_EVIDENCE_TYPE_REPORT;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	challenge = ctlv_attestation_pci_evidence_refresh_challenge_get(request, &length);
> +	if ((type == PCI_TSM_EVIDENCE_TYPE_MEASUREMENTS && length != 32) ||
> +	    (type == PCI_TSM_EVIDENCE_TYPE_REPORT && length))
> +		return -EINVAL;
> +
> +	ret = pci_attestation_prepare(pa,
> +			ctlv_attestation_pci_evidence_refresh_generation_get(request));
> +	if (ret)
> +		return ret;
> +
> +	if (!tsm)
> +		return -ENOTCONN;
> +
> +	if (tsm->error || device_cc_accepted(&pa->pdev->dev))
> +		return -EBUSY;
> +
> +	ops = tsm->tsm_dev->pci_ops;
> +	if (!ops->refresh_evidence)
> +		return -EOPNOTSUPP;
> +
> +	ret = ops->refresh_evidence(tsm, type, 0, (void *)challenge, length);
> +	/* Even a failed refresh may have changed device state. Retire all verdicts. */
> +	if (ret)
> +		tsm->error = true;

Does this make any refresh failure fatal until unlock? The CCA refresh in 11/11 says "failure preserve the old cache", but with tsm->error set I don't think the cache can be read or accepted?

The cached evidence is still the lock's evidence, collected after the lock. And per the cover letter a failed refresh already invalidates the earlier generations. Should the backend decide instead, and set tsm->error itself when it can't tell what happened to the device?

Also, this builds on struct pci_tsm_evidence from Dan's March posting [1]. The TDX guest RFC [2] and AMD's SEV-TIO guest RFC [3] both use
device_evidence_create() from his July posting [4]. Is the plan to go with pci_tsm_evidence and drop device_evidence? Would help to know which one to build the TDX guest side on.

[1] https://lore.kernel.org/all/20260303000207.1836586-1-dan.j.williams@intel.com/
[2] https://lore.kernel.org/all/20260924041032.1096569-1-zhenzhong.duan@intel.com/
[3] https://lore.kernel.org/all/20260916115159.1938195-16-aik@amd.com/
[4] https://lore.kernel.org/all/20260705220819.2472765-1-djbw@kernel.org/

DJ

