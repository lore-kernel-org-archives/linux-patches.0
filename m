Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625A72144A4;
	Tue, 12 Nov 2024 10:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408367; cv=none; b=kGUW+C4j9MCGZOd+HCa9eZA8fMcWJJ9Rd5Ln2yw5VNf5hMYOJiVxMeMXEOhU5gWt33M9GzUSSyinX3BjUtorNHg2Ak6xKctrOB1pA26IrkEib1kkPRGk1VooebjGkyIctEJA0rt4a4Pz4mSnqkfcBXEbzKwDYgIlpPOpCR+EFzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408367; c=relaxed/simple;
	bh=/ilhoi9Y3meSGnG+Pt2xebKZxKblFzGHIjvzb+swLSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYXMrH8RgBnX0g1EsLhgo0Wq+3BVm7IBUxSPJUa7yuCi4KPNNcYFAl3RTkSV5rrg1F1MW3ZykwUnubX1HYfIKETuw83KIum8Q0pjxLTS1sv1WcavhyF7o9bfwLwTGbsw0YOyvv+jN4PjULh9U7oXWbCDqpwlQ9bqpTCAiX/+hSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r96HdaOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r96HdaOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F00C4CECD;
	Tue, 12 Nov 2024 10:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408367;
	bh=/ilhoi9Y3meSGnG+Pt2xebKZxKblFzGHIjvzb+swLSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r96HdaOmnUh/RDismojc7ng9QNcMwJQtSuGv4aGna7Gnzk8YRpObfNRj/v7Dh6Y4r
	 Qi2usKX6au89WTtYidLKBgC9ac75xvmDeVqqhFfSvXwNUZqy1hk6h+BU/77I/WaGFY
	 X6RIiwlz2I7XqcG9HltiCXGMwgLLi0x2HRLoLW0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.11 141/184] platform/x86/amd/pmf: Add SMU metrics table support for 1Ah family 60h model
Date: Tue, 12 Nov 2024 11:21:39 +0100
Message-ID: <20241112101906.283877341@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 8ca8d07857c698503b2b3bf615238c87c02f064e upstream.

Add SMU metrics table support for 1Ah family 60h model. This information
will be used by the PMF driver to alter the system thermals.

Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20241023063245.1404420-2-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmf/core.c |    1 +
 drivers/platform/x86/amd/pmf/spc.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -261,6 +261,7 @@ int amd_pmf_set_dram_addr(struct amd_pmf
 			dev->mtable_size = sizeof(dev->m_table);
 			break;
 		case PCI_DEVICE_ID_AMD_1AH_M20H_ROOT:
+		case PCI_DEVICE_ID_AMD_1AH_M60H_ROOT:
 			dev->mtable_size = sizeof(dev->m_table_v2);
 			break;
 		default:
--- a/drivers/platform/x86/amd/pmf/spc.c
+++ b/drivers/platform/x86/amd/pmf/spc.c
@@ -86,6 +86,7 @@ static void amd_pmf_get_smu_info(struct
 					 ARRAY_SIZE(dev->m_table.avg_core_c0residency), in);
 		break;
 	case PCI_DEVICE_ID_AMD_1AH_M20H_ROOT:
+	case PCI_DEVICE_ID_AMD_1AH_M60H_ROOT:
 		memcpy(&dev->m_table_v2, dev->buf, dev->mtable_size);
 		in->ev_info.socket_power = dev->m_table_v2.apu_power + dev->m_table_v2.dgpu_power;
 		in->ev_info.skin_temperature = dev->m_table_v2.skin_temp;


