Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DFE274FDB;
	Tue, 15 Jul 2025 13:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585562; cv=none; b=g0l0vCOjCLKhYCRG4hki2vandHYMTVdiotv/Swx1eGTbw8GdechWS2lXusV9ehWnXPlz2jPXb7lDcRvjf3ANFEGf46ZU1eZnkmDcNwwK9CRbKaxSepgP3XFvcvoda2WiCcRvwqPFH3PR7hjwfrteKvootR6XH/qnpCEr05ZXauo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585562; c=relaxed/simple;
	bh=99tNd6ylRt+RELaxf+vIW4jC9kPcdZ3q0i/Q/f8EjTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtdOsmM2Xw39YrPpbVox1AARSiVmb9clMNYfoK00ZNcwa2M8l7RbtEh7vWoe2pPoaquVuTHIyuRkQTwpMDc6IVLV2wWcW/ub3vSKxqznx7D400BKBsr6VIxtTaMA5DynMVWHBqtjOSyQSgxY/dKf6KB3stuBNNPT1mnupXHJG78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0u1x+WXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0u1x+WXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8FAC4CEE3;
	Tue, 15 Jul 2025 13:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585561;
	bh=99tNd6ylRt+RELaxf+vIW4jC9kPcdZ3q0i/Q/f8EjTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0u1x+WXZNEngYi3qMZzx0LDNpicJRtT9HurCBVeVixW8yWtH3Umy0iGuM8L7H9kxs
	 lovL9pxL52p3YphKC3+JxmiwjEcnyr7cwGmznCGk6fOP9W81WGdLx0RpPF0FRNRApS
	 0Y1Bq2oheaVUGz3vgxYKMMZJQ8BI0fMjYPnIqVpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Vaishali Thakkar <vaishali.thakkar@suse.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 055/163] KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
Date: Tue, 15 Jul 2025 15:12:03 +0200
Message-ID: <20250715130810.959622993@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


