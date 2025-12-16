Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B1A342C8B;
	Tue, 16 Dec 2025 12:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888489; cv=none; b=kWrWl9JVYJALADmz4fQl2ddkYI4omxnYREGR3aDbrOeikN8tsLQPVLkso7gslBqkyv3DlO63JfrbnjkJg6huSmIoIqtanqYExi+64TR+UURxurso0U/7rYDUXa/BOn5cTfpBHrDrKjJENbr0j92naN5+snVU6uofTKTFe4NUY/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888489; c=relaxed/simple;
	bh=kzlC2rngcEXbplvHFLfSOr3xbZIMD1njs/1JpZWogco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdNSRFvpWBcFGR6GDnm8QgK6pT+G1ofaDMRfGjx7mfpGg7vlyMdY6rh1rQjRB618gs9FixoXUYKMtySe1OoJn+rvQnx2kgYfuKWn+Fwcn3/RdK4j6mcq/+RKtfkiR9qUeYMAXtcKnAMJZa82EK6z7094L9dt8TrwM9whge0aDA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fagybsCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fagybsCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8700FC4CEF5;
	Tue, 16 Dec 2025 12:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888489;
	bh=kzlC2rngcEXbplvHFLfSOr3xbZIMD1njs/1JpZWogco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fagybsCMKZD2S5HzTS9mFSamNeaqS/8fiHDtja7H8XiiW3ZtSAl3H1S3US+naZhPl
	 Zhh5kqlo1cpuuOr6YB+sNHYUW/8O+oRWoAS3nUz2MfV/hZEod+o/kn8P/HpDrcz9U5
	 zhYlKLyflTzfUKgV86ZJzSy0MICeBu0DqsFQg46c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alkis Georgopoulos <alkisg@gmail.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 549/614] Revert "nfs: ignore SB_RDONLY when mounting nfs"
Date: Tue, 16 Dec 2025 12:15:16 +0100
Message-ID: <20251216111421.271579704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d4a26d34f1946142f9d32e540490e4926ae9a46b ]

This reverts commit 52cb7f8f177878b4f22397b9c4d2c8f743766be3.

Silently ignoring the "ro" and "rw" mount options causes user confusion,
and regressions.

Reported-by: Alkis Georgopoulos<alkisg@gmail.com>
Cc: Li Lingfeng <lilingfeng3@huawei.com>
Fixes: 52cb7f8f1778 ("nfs: ignore SB_RDONLY when mounting nfs")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 2ecd38e1d17a8..ffd382aa31ac0 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -13,7 +13,7 @@
 #include <linux/nfslocalio.h>
 #include <linux/wait_bit.h>
 
-#define NFS_SB_MASK (SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
+#define NFS_SB_MASK (SB_RDONLY|SB_NOSUID|SB_NODEV|SB_NOEXEC|SB_SYNCHRONOUS)
 
 extern const struct export_operations nfs_export_ops;
 
-- 
2.51.0



