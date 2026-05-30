Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58844320CAD;
	Sat, 30 May 2026 17:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163759; cv=none; b=hqIxnFzHiFJflAo0nFFQFXbTmA672ROCpjRR2GTOQOhQokMZoX+7Q8FzEzvfJDzXwQvuwE+EztU0lwxUHqxMkSaxhjW9lpKrS1YJn3Gvc2ipQPXBWmwgpM7b9VDahXEuhAbfRtHjdkF92nYMJp7F9MLTc/QlZlKuoAcYdhw5j9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163759; c=relaxed/simple;
	bh=JcJFQ2JFUOzCNgOpE6BedvoPAgUc/e9kQJZaKwKitS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMruUEnjv956T/awNJhkSHy/b3RYjzWa/lDgXmqK9rqBkyyXzQHcDHOUz4h04mg0wsRUwLeED5Zm9uXv7ibzlqe49c9T3U078BGM6hgUxohVO7pQsT9MmPounAEeVLKqVZy6XTXFmkS4RBeOhQ7KBshApyZPtqiM1c4z/mlgEvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzL4BVM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzL4BVM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03A41F00893;
	Sat, 30 May 2026 17:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163758;
	bh=UAqN086qs/MX6JRYMR+ULCB1Ko2KXjbwZpLVb4IPNfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzL4BVM13kNykxSY8TKITa4SVARkNrRuxLRYYMYCqoNDlFTD/SSBRyne/pt2eZ/sM
	 g2Hngrg5IX3mgGUiRL2unrvpi/MysWymyVCCITz3LwITkkHqeGtpqfYWe1CQZm8MFA
	 +UToxKgqRj3TjK4jo3ixuI0v67EISKWpyXYCi1vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soufiane Dani <soufianeda@tutanota.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 353/776] staging: media: atomisp: Disallow all private IOCTLs
Date: Sat, 30 May 2026 18:01:07 +0200
Message-ID: <20260530160249.703878437@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 2b7eb2c5dc72f0fc954ac4aa155f9e285e937f7c upstream.

Disallow all private IOCTLs. These aren't quite as safe as one could
assume of IOCTL handlers; disable them for now. Instead of removing the
code, return in the beginning of the function if cmd is non-zero in order
to keep static checkers happy.

Reported-by: Soufiane Dani <soufianeda@tutanota.com>
Closes: https://lore.kernel.org/linux-staging/20260210-atomisp-fix-v1-1-024429cbff31@tutanota.com/
Cc: stable@vger.kernel.org
Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Fixes: ad85094b293e ("Revert "media: staging: atomisp: Remove driver"")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -2865,6 +2865,10 @@ static long atomisp_vidioc_default(struc
 	bool acc_node;
 	int err;
 
+	/* Disable all private IOCTLs for now! */
+	if (cmd)
+		return -EINVAL;
+
 	acc_node = !strcmp(vdev->name, "ATOMISP ISP ACC");
 	if (acc_node)
 		asd = atomisp_to_acc_pipe(vdev)->asd;


