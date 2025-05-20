Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E92124677D;
	Tue, 20 May 2025 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750240; cv=none; b=K5K38vO0RtT/jl451hf7cRc3VC/+MtASsEVoIX0DsmXzI2ZomGs58HdfH1ARF1enYrrtH6zjqBr9n3jj3+iz/SJM41LfWRemn8+VmfekRehsDWj2fDAIqttrxAAmAg0VmSXmGnFMAnV1P6UzOTPCvCSBJyMN57nvaC1yt5JUh/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750240; c=relaxed/simple;
	bh=8R3CPSv9S/Ytf+sSA04ymiLWZVYJrefIq+EdGJtDATQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncxZyrigzyZUfTOBSv7RATz5KTU8A1FK2/8c9JrFjvMtdB6U5eolStlOCdCHQbLy4803VUaAMxOSST9Ja6nJyC4DPfOQUOtzBfBlXmB+bO3X4GAYFcN0MFdcA0eXlXxVF2ACfYhHmEDWGsExXtY6syRu10+FvTvdW6eoKCJAyzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByWLokrj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByWLokrj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C430C4CEE9;
	Tue, 20 May 2025 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750240;
	bh=8R3CPSv9S/Ytf+sSA04ymiLWZVYJrefIq+EdGJtDATQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByWLokrjizafJhJxCjaWZJkPTZOe7c3EqjVJTlc84pGDO3krbM27iRFKgxJ2vh+v9
	 L7Z4hhQ2iTXLAw/33PYasinbd8odBgKmJNtiyIFG23gG5G3VItMrAcMT9eC5te5wGz
	 lD1jFCbW34h+XShSD4natXrJyJ/sBMp7L4pDGQnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Juergen Gross <jgross@suse.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 088/143] MAINTAINERS: Update Alexey Makhalovs email address
Date: Tue, 20 May 2025 15:50:43 +0200
Message-ID: <20250520125813.519478500@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Alexey Makhalov <alexey.makhalov@broadcom.com>

commit 386cd3dcfd63491619b4034b818737fc0219e128 upstream.

Fix a typo in an email address.

Closes: https://lore.kernel.org/all/20240925-rational-succinct-vulture-cca9fb@lemur/T/
Reported-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reported-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Alexey Makhalov <alexey.makhalov@broadcom.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250318004031.2703923-1-alexey.makhalov@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17503,7 +17503,7 @@ F:	include/uapi/linux/ppdev.h
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
 R:	Ajay Kaher <ajay.kaher@broadcom.com>
-R:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+R:	Alexey Makhalov <alexey.makhalov@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	virtualization@lists.linux.dev
 L:	x86@kernel.org
@@ -24729,7 +24729,7 @@ F:	drivers/misc/vmw_balloon.c
 
 VMWARE HYPERVISOR INTERFACE
 M:	Ajay Kaher <ajay.kaher@broadcom.com>
-M:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+M:	Alexey Makhalov <alexey.makhalov@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	virtualization@lists.linux.dev
 L:	x86@kernel.org
@@ -24757,7 +24757,7 @@ F:	drivers/scsi/vmw_pvscsi.h
 VMWARE VIRTUAL PTP CLOCK DRIVER
 M:	Nick Shi <nick.shi@broadcom.com>
 R:	Ajay Kaher <ajay.kaher@broadcom.com>
-R:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+R:	Alexey Makhalov <alexey.makhalov@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported


