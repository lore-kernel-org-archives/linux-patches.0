Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51C563A1;
	Fri, 24 Nov 2023 19:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOeI0/Cs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E78CC433C8;
	Fri, 24 Nov 2023 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852752;
	bh=LKTEHtTqZBD/+trs5VkWxFLSeJjS57TTjDr0rJTV1tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOeI0/Cs18mWi1Mz5+xGRpBw3y512+87JxWlFQXuwnBHHymGonDf+VJaaQ9Y+iS4x
	 o001WDWvQCfwqC16boEFUevaljoOu+CFi5JUEsrZyCgKf921J2M6gbngbx3AXaahYL
	 anlTQu1ovL8Pd7a0SFJ1Rz7PE2iMMnouvj53dYzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 108/193] parisc/pdc: Add width field to struct pdc_model
Date: Fri, 24 Nov 2023 17:53:55 +0000
Message-ID: <20231124171951.563549257@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


