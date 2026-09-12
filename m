Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4047476CEC;
	Sat, 12 Sep 2026 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210851; cv=none; b=EjUCAxxj8UPVhv5rl1WeBboSyjBgTfOe1lldhj36J8ZlIP8OdwT6n4lGZzRe31u09toDVAABar6lziJwgEmGr9wt4ao2PSxTlrkB40MY7etPze3+gMXh9Cdt5JS4QUP8qREQ6e2W1iZXg0iuecc8NecyAfPfEEfyBIy5jFYjTXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210851; c=relaxed/simple;
	bh=VQYtYBODQG8GXjlBKQ6wNinHWnPvzdOVHvyi0ecCXiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJtnv+j0Qhh1cntCrsF/OKTI8naSlY8GcGaZKRi17+8u+afIwacpbdavhGk7E2jS4qAuFRkWEHga76Qlrq+WF+tLj4Qz0ntaztTgVyhJd+D5VCEEyb/fvUhoftz3W4rASWm6I5GUXnA6XZqVczXi07gixZygIKbbCc38OJ9YvXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtAY7VUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtAY7VUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8451F000FF;
	Sat, 12 Sep 2026 11:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210849;
	bh=OmkvfFarE//If2RTkOmq+R9D+AGS98cnP1eBq67NP+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtAY7VUeOc7q1yIaZOQ3fdzxEMr9+pT3XgTdSn//0JI5pOwoQSDCq8zLbLFBhufLS
	 wTPEjLBXm4lhp19OLHRm8+z22RwKpj0wQrffi2NZw8Bajf5fd0DquHumrNnPz/6Jyc
	 G9QolxzdEZXGcJo4sy7GlcwagCPtSBN53ROjn9j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yunje Shin <ioerts@kookmin.ac.kr>,
	Hannes Reinecke <hare@suse.de>,
	Chris Leech <cleech@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1111/1518] nvme: Add the DHCHAP maximum HD IDs
Date: Sat, 12 Sep 2026 08:54:40 +0200
Message-ID: <20260912065648.583146394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 09e8f0f93491c6be867f32d4edc0b16fb5da785e ]

In preperation for using DHCHAP length in upcoming host and target
patches let's add the hash and diffie-hellman ID length macros.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yunje Shin <ioerts@kookmin.ac.kr>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5bb96cc21883 ("nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 655d194f8e722..b9d3dbe2564d7 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2332,4 +2332,8 @@ enum nvme_pr_change_ptpl {
 
 #define NVME_PR_IGNORE_KEY (1 << 3)
 
+/* Section 8.3.4.5.2 of the NVMe 2.1 */
+#define NVME_AUTH_DHCHAP_MAX_HASH_IDS 30
+#define NVME_AUTH_DHCHAP_MAX_DH_IDS 30
+
 #endif /* _LINUX_NVME_H */
-- 
2.53.0



