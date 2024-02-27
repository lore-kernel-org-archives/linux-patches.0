Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5D113B7AB;
	Tue, 27 Feb 2024 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043923; cv=none; b=ObcjRvn7hcCKSBOLe2xXsg5WxS77c/ySjSO5xUJUKtpiki4BQLqBM4HwJWNBXi4xQ1iWoysrbbWmywKT1Ku25xDrSvmS4R+nVTVD1V+/RIZvU2qDEif3B7/sBHeTSNC82sbm2nB+9PZ9v7TXJy5oWECGLVMZMG7I/kMwTfOfAPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043923; c=relaxed/simple;
	bh=G4r0macorRXP+Ju/F02ws0p9P7Ed0PhmeX8jdszdUaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn82MjPOAMiBRKHJXKmTG6L/tUq+CMshCarO61h8NUDOUcPJzcFP4OF541xIo87T2Yj7ZeAjaQhdCHeBdnHwDYTADXdRIsQGRD/bHFnInsoIbIMxip6m1m+cv8aNNO2M36Twe0GRZWlXW/arNsl3wwhiG3vF+58zbOMm8JWlp0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTNZTdQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTNZTdQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB04AC433F1;
	Tue, 27 Feb 2024 14:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043923;
	bh=G4r0macorRXP+Ju/F02ws0p9P7Ed0PhmeX8jdszdUaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTNZTdQIcayf6p2OZBo6gFpuucQyvieybuCk/lMXY3PIKHtOe6RVhF0K7qAT5h9H3
	 39DtHFVhQbM+AvdBL6+RG1/PDMIHKX7QhyF8lXCHT3bpRdCAPFSd75LKdqTefZsKEB
	 FJbhx8qUYZitlOmALAD4xyVIN51u900G8ggYEaNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andriin@fb.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 84/84] scripts/bpf: Fix xdp_md forward declaration typo
Date: Tue, 27 Feb 2024 14:27:51 +0100
Message-ID: <20240227131555.612933290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andriin@fb.com>

commit e0b68fb186b251374adbd870f99b1ecea236e770 upstream.

Fix typo in struct xpd_md, generated from bpf_helpers_doc.py, which is
causing compilation warnings for programs using bpf_helpers.h

Fixes: 7a387bed47f7 ("scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191010042534.290562-1-andriin@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/bpf_helpers_doc.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -418,7 +418,7 @@ class PrinterHelpers(Printer):
 
             'struct __sk_buff',
             'struct sk_msg_md',
-            'struct xpd_md',
+            'struct xdp_md',
     ]
     known_types = {
             '...',


