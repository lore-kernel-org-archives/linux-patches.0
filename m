Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E9C1096F;
	Tue, 11 Nov 2025 01:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825193; cv=none; b=Qo8X/szd7zCom/4LEGax111UPwd26b3Ch622yrHj0xeafksNE17Aj8MDmpT5suqbhbfsXS+eCX/aH2TAyTualSZBoD+ONBIlefiZagbV9hx9QzFZnaiaLYN/N2R7wk6QNRQg5wn9Jj6dJnnBRPKGCGHM5+V78cA6MP429XynKVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825193; c=relaxed/simple;
	bh=cyGUEoA8c34u38kku1lAnQvJmqF3XwMLC7yACHxZSKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fU8fTuHoql582gxk8hHT+wlP16r1F5NB+3AOLDOV04JnDWGxmea1x3HM2/x5aXqvs+WfEMFVsntYlMzhmEYWrI4bS0O7w08TGmpFxEqG94SHuRY6LLDKCdXbIwRn0zDA5+w6g7nFiopKmoOorbchW/rFM97odoLa0Uy0iSqD1a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8pKNO/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8pKNO/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6021C113D0;
	Tue, 11 Nov 2025 01:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825193;
	bh=cyGUEoA8c34u38kku1lAnQvJmqF3XwMLC7yACHxZSKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8pKNO/SN4TN/IRj/rHTAtLd3K5ZddnUVhlb24vIS6ykFwj6MnUxS6+Prl4g1BPri
	 AuWwzTXY5Vd2+L6HpkRlfPZ+CztsXyxNmikMNthSTSql3DCMyntMkcflG8apXXoVwM
	 vzhyoZXCaQhhOeu7eyoevlx11IrEH6LW1EZcF5hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 699/849] hyperv: Add missing field to hv_output_map_device_interrupt
Date: Tue, 11 Nov 2025 09:44:29 +0900
Message-ID: <20251111004553.333544886@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Das Neves <nunodasneves@linux.microsoft.com>

[ Upstream commit 4cd661c248b6671914ad59e16760bb6d908dfc61 ]

This field is unused, but the correct structure size is needed
when computing the amount of space for the output argument to
reside, so that it does not cross a page boundary.

Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/hyperv/hvhdk_mini.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/hyperv/hvhdk_mini.h b/include/hyperv/hvhdk_mini.h
index 42e7876455b5b..858f6a3925b30 100644
--- a/include/hyperv/hvhdk_mini.h
+++ b/include/hyperv/hvhdk_mini.h
@@ -301,6 +301,7 @@ struct hv_input_map_device_interrupt {
 /* HV_OUTPUT_MAP_DEVICE_INTERRUPT */
 struct hv_output_map_device_interrupt {
 	struct hv_interrupt_entry interrupt_entry;
+	u64 ext_status_deprecated[5];
 } __packed;
 
 /* HV_INPUT_UNMAP_DEVICE_INTERRUPT */
-- 
2.51.0



