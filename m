Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619478;
	b=kMvyIz+k4cmJfZitgyxsdQMMPT2MlJ+vV0lnrmfaNTV6S4NdgdJH9zaCe1Rf6vuPb1aq
	 sBSjjQ6pGiHOznGgvC6TQczrSJCilxczmfYaxajHbHJAPqBnxbPXuW8Fwsn6qotbEOXyS
	 t8eZfWOqjEHkDbFUg7EJ+A7rPxKeZUZWpRbKaPlT8N+05DAf/C+Jvz9IQ7eMj5LB7AxiE
	 7hZ6LnWOuFpe5Hplv1TUN9heRj+PPO9oCRsucGXNxOY8x9Yx+tpjnrz7tJJeL57QzJXDY
	 60/vWBRvA7ty2XRyab1uaCSqY8gKdIlyI0QDSCnhZ95i6nIiowzFYYNlZM2Gq+lFKOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1P3xBQHIxMU6lQTWhhFuu+CgoP8aOzSUZ/3Va1158EQ=;
	b=hR3wN5R+O+T8l0XYe1IEBEfuxqHzD75HUs9VIdW0vcPs9EnjFALgyIe193ZB2np8cd5B
	 3UE/nA8E6HIXLLEUECaQ7wyyADsIeXIpu4CLRGpkPcv0aJUsuKS1aKCRR54NF2J0XaqdM
	 rfvk3yjUa2PPx2AFTl7ZGjhGovtzGCWNGtgVmDvT4PKOn1Df21xqHbkrl01sPoHzjxJI6
	 /1msW+43OWbkA4KqRWhnlwSg8PL7zENII/MfERTMdYSWGNvWF+ToNmVPRIB3CVCfAklH+
	 ROg+Phg5yDYrvOX417KqfEf4c8g4Qfe87DLpsty001N9oqAONdG+4BpYU0SxbaTWSTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FVIDfI6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15C1606A33F;
	Wed, 25 Nov 2026 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FVIDfI6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86011F01568;
	Wed, 25 Nov 2026 15:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619478;
	bh=1P3xBQHIxMU6lQTWhhFuu+CgoP8aOzSUZ/3Va1158EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVIDfI6/3iAjAdTuewgCEb7Zwco/BjPGz9wPCj580UyMfrsynKz28UUsZ1CpOUQe7
	 Mz5Kpxu+GrXmHGE2OCxciP5QaUsQEBt/RRK4TSYn02xjyMq6A/fBFr5zWclTG9Sfoa
	 xsbsAhQ5QdpKGkYLIgCIDo9QCncnY5B28hTlu/Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.3 0610/1005] ACPI: APEI: GHES: Fix severity check in ghes_log_hwerr()
Date: Wed, 25 Nov 2026 15:32:28 +0100
Message-ID: <20261125143836.033408605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit cf12faa1e76d43f97b1486aaec959b16baca498a upstream.

ghes_log_hwerr() is meant to count recoverable GHES errors in
hwerror_data[], but it skips them and counts informational records
instead. As a result, recoverable CPU, memory, CXL and vendor-specific
errors reported through GHES never show up in a vmcore.

ghes_do_proc() passes ghes_log_hwerr() the record severity after
ghes_severity() has converted it to a GHES_SEV_* value.
ghes_log_hwerr() compares it against CPER_SEV_RECOVERABLE, which is 0
in the CPER enum and matches GHES_SEV_NO, so only informational records
pass and GHES_SEV_RECOVERABLE ones return early.

Compare against GHES_SEV_RECOVERABLE instead.

Recoverable PCIe errors that ghes_handle_aer() hands to AER are also
counted by pci_dev_aer_stats_incr(), so with the check fixed they are
counted twice under HWERR_RECOV_PCI. That is not addressed here.

Fixes: 3fa805c37dd4 ("vmcoreinfo: track and log recoverable hardware errors")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://patch.msgid.link/20261030-ghes-hwerr-sev-v1-1-145ceb996c77@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/ghes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -912,7 +912,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_cper_kfifo_get,
 
 static void ghes_log_hwerr(int sev, guid_t *sec_type)
 {
-	if (sev != CPER_SEV_RECOVERABLE)
+	if (sev != GHES_SEV_RECOVERABLE)
 		return;
 
 	if (guid_equal(sec_type, &CPER_SEC_PROC_ARM) ||


