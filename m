Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130A7145B03;
	Tue, 27 Feb 2024 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041586; cv=none; b=jxa27r+w6ixJmu1XswiU/l/rD3029VY41OxYEU/KZikzH/Xe9MMoJVgiWRjzKSKoFt5s2t+GtVIHJAB+3KrtZAjARGOUYk4JLlh4CRe1FevwGm9QX8uw3c29Seoy6KPtppPUMdzP61yZ1IwtsnTlt83W8GhvHN+GCqc9YVNXJEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041586; c=relaxed/simple;
	bh=VqKAOMrDzztLsVFg+ygXEaKDDCj9m7ezS6eb2IJ2Pac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/vnM3R1iUYgZeB8GKWiavP/qehf9HaU/ZnrVZbBVVvLvVrS88vNMVLsP8ArBrlW8bQ5q5D88k28lgnwncA0VqrPfARb+KMVu/wGQfCLYtfnFy8hK4myPANKKtIOvWvVipc3cc+WmYXjw6qSnX4iQnFbTuuZcV1CQNpBuGP/SiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWBj9xpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWBj9xpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914BFC433F1;
	Tue, 27 Feb 2024 13:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041586;
	bh=VqKAOMrDzztLsVFg+ygXEaKDDCj9m7ezS6eb2IJ2Pac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWBj9xpRwK+6uvQ/8Oy0nNJngwzKghcnOBMZGf/p4Aiub0Jaqb2DwBShhuZQGZRw8
	 /SBRyD+Gl+FU2deHe8B0+Jwxh4WXvnkUChBg/Op7/XLvoiBXAraPxkoUzXgEFH5H+q
	 VwV9peR/uvQVORMGK7Y/F2fecznpXCWeI2VtMLPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andriin@fb.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.19 52/52] scripts/bpf: Fix xdp_md forward declaration typo
Date: Tue, 27 Feb 2024 14:26:39 +0100
Message-ID: <20240227131550.242829275@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


