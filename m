Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DB63173F;
	Fri, 24 Nov 2023 19:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IW26LOJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07585C433C8;
	Fri, 24 Nov 2023 19:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853414;
	bh=0CQ0iCpBMh1K6IvoQhyJph/k8THM6yewDMGEdUkk/eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IW26LOJlxkf9iYKVVcQ/aVf9s0kGBR1dyUB8rNQnoBYX4L/mvjO8UVdzVnJ43U/0E
	 Z2EGxHnyzXGDclm/9DWVp5EycMLDvYbbiBrT766YYE1QgtydoHz7NIfIsUr5YUz+Qv
	 VYUfqkC/EXWwHUmuyS1/YvM1eFatJbPm+18SagQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 178/297] parisc/pdc: Add width field to struct pdc_model
Date: Fri, 24 Nov 2023 17:53:40 +0000
Message-ID: <20231124172006.476246187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 6240553b52c475d9fc9674de0521b77e692f3764 upstream.

PDC2.0 specifies the additional PSW-bit field.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/uapi/asm/pdc.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/include/uapi/asm/pdc.h
+++ b/arch/parisc/include/uapi/asm/pdc.h
@@ -465,6 +465,7 @@ struct pdc_model {		/* for PDC_MODEL */
 	unsigned long arch_rev;
 	unsigned long pot_key;
 	unsigned long curr_key;
+	unsigned long width;	/* default of PSW_W bit (1=enabled) */
 };
 
 struct pdc_cache_cf {		/* for PDC_CACHE  (I/D-caches) */


