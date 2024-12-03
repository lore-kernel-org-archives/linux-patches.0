Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297C81E25E3;
	Tue,  3 Dec 2024 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242820; cv=none; b=Nk+2WKH2NqY7+WFfXEKMbEzW/K5cLwanxWLloY2Xim1UyAOBQUhGwHV3NXd/6FV9mvLDQONg3vmeowDas0X2WTyei2v1byn+dRKrgkupfc1+VtWZpJJ9Vfx/utPwu6irXTOcjPaDiGwA3rEICLyS2AftjKvW9PBFVpGiZ9owDEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242820; c=relaxed/simple;
	bh=Qy+BAYcRHE2O6cAvWjZgLj0PVfvbFtLF0E0wQ3KkLmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/aIDDktOsfOc8Fbwj+4q4IfV4fxM48YK9GSqYnDwIf4Y/RMcgMFlILGgaR6/EmB/n6idDkseWJjFnUlbHrSDV6KWWobtdMxEg/U1Z5H5Y9qd/Nca6BZkX6a+pwDsDiZPY/zkTLMx1MyUOg3yh2+Sz5xlemUVTwooCBH8lnBZF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOFJsxDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOFJsxDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C58DC4CECF;
	Tue,  3 Dec 2024 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242820;
	bh=Qy+BAYcRHE2O6cAvWjZgLj0PVfvbFtLF0E0wQ3KkLmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOFJsxDv/bNxXo+4JozOQECQ3aJAhC5s8mMxYwZGVIwOM3XG2qIaUktictBi1g20l
	 ik565XTYeqv+yBKbk8jhbKi4RdZPxZ6wz3wEV2w0yQ86agjlrtJFaqPuPUAED9QgLk
	 lgXASGBM7LEKi+ns2CwTeQMZ7eO9/K7wHnTQ4RF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	v9fs@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 788/826] net/9p/usbg: fix handling of the failed kzalloc() memory allocation
Date: Tue,  3 Dec 2024 15:48:35 +0100
Message-ID: <20241203144814.499396037@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirsad Todorovac <mtodorovac69@gmail.com>

[ Upstream commit ff1060813d9347e8c45c8b8cff93a4dfdb6726ad ]

On the linux-next, next-20241108 vanilla kernel, the coccinelle tool gave the
following error report:

./net/9p/trans_usbg.c:912:5-11: ERROR: allocation function on line 911 returns
NULL not ERR_PTR on failure

kzalloc() failure is fixed to handle the NULL return case on the memory exhaustion.

Fixes: a3be076dc174d ("net/9p/usbg: Add new usb gadget function transport")
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Eric Van Hensbergen <ericvh@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Christian Schoenebeck <linux_oss@crudebyte.com>
Cc: v9fs@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Message-ID: <20241109211840.721226-2-mtodorovac69@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index 975b76839dca1..6b694f117aef2 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -909,9 +909,9 @@ static struct usb_function_instance *usb9pfs_alloc_instance(void)
 	usb9pfs_opts->buflen = DEFAULT_BUFLEN;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (IS_ERR(dev)) {
+	if (!dev) {
 		kfree(usb9pfs_opts);
-		return ERR_CAST(dev);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	usb9pfs_opts->dev = dev;
-- 
2.43.0



