Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C712E2EE7;
	Tue, 15 Jul 2025 13:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586894; cv=none; b=lWDtJCIaOkCf7HpW9h011fFfqgTW5Oq+T1tjVcYXqt9GIY8Ng5tbTLDdchlNl5OcFq4aznZGa8DBtTiIelRB7K5nSe5QQfNZLTpom/2wFA8IYYpf8UBV65vuQRS2VxVcwVB0SDwVfRCrl0/MHemtuQ19zbfANrBsZmL4ySP8GQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586894; c=relaxed/simple;
	bh=OLmrBTIUoWqWQImsFNLwMIGiUv1RXEibLu6XTkk7yRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3r0PoguCmh3tM3lhR2Shx+hjsM2edqvlrC7+a5GYKWbG5r9oOa4TzbisZIXQ4t9Cf62HV75r4oraQ2v4/nUUV7FYL1DtTewFVJ0CRGg/pPpqjtPtgXk1ORmd4yuR1Fg28BFp8q1h6HuAOid2+gAbxd00X8yH4MhP75APzNwldI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnjA97FH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnjA97FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7B6C4CEE3;
	Tue, 15 Jul 2025 13:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586894;
	bh=OLmrBTIUoWqWQImsFNLwMIGiUv1RXEibLu6XTkk7yRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnjA97FHSCVsSmY8F584LkmxgS4nrN8cdm1bLiQDgsb+3kxV576Zwqk8m2c82u56z
	 NOO4Hvwt0SJAlCJA48p5mvGXS9fcwn2/tZvgHBLHHCGGTcKJnzJ//jxRSJyvDKf3cY
	 JXOIsVhoMe7tBHlVyDWr0/WH/CFgEUJEIQ9SQdyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Vaishali Thakkar <vaishali.thakkar@suse.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.15 058/192] KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
Date: Tue, 15 Jul 2025 15:12:33 +0200
Message-ID: <20250715130817.165985328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikunj A Dadhania <nikunj@amd.com>

commit 51a4273dcab39dd1e850870945ccec664352d383 upstream.

The sev_data_snp_launch_start structure should include a 4-byte
desired_tsc_khz field before the gosvw field, which was missed in the
initial implementation. As a result, the structure is 4 bytes shorter than
expected by the firmware, causing the gosvw field to start 4 bytes early.
Fix this by adding the missing 4-byte member for the desired TSC frequency.

Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
Cc: stable@vger.kernel.org
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Link: https://lore.kernel.org/r/20250408093213.57962-3-nikunj@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/psp-sev.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -594,6 +594,7 @@ struct sev_data_snp_addr {
  * @imi_en: launch flow is launching an IMI (Incoming Migration Image) for the
  *          purpose of guest-assisted migration.
  * @rsvd: reserved
+ * @desired_tsc_khz: hypervisor desired mean TSC freq in kHz of the guest
  * @gosvw: guest OS-visible workarounds, as defined by hypervisor
  */
 struct sev_data_snp_launch_start {
@@ -603,6 +604,7 @@ struct sev_data_snp_launch_start {
 	u32 ma_en:1;				/* In */
 	u32 imi_en:1;				/* In */
 	u32 rsvd:30;
+	u32 desired_tsc_khz;			/* In */
 	u8 gosvw[16];				/* In */
 } __packed;
 


