Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7908E313E34;
	Sat, 30 May 2026 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166069; cv=none; b=kltAiRBpTQgSll82A2nTV+UiR3u32I/XEQisV7Uw+4d/+RafayOjayk2B3cNrQo+IcmnCMWFVXY9ENmXngao2SNccvVfSgis/AcstnEROedOJH3b4f+ERAuzaZYRYhkwn7faYkIlPdb8PDYUi1op+qAvSb/j5yZQyx3v+smrjLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166069; c=relaxed/simple;
	bh=YYJGqritEJIEtCp7gjITEcLbZTqpDHd74EKXXIbJhcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gzn0VA6LD8TSM7XkI8f3fau7DcjSbejjzagVq7AKMUTMhMaduQAmT5exwB744fEXi2C7mHU9xT3cYWQFfN9WoJnik6Gwz0kEOponlZp4i/fQB4PEIVz5dUtUQYLtyXoHGCmeEPk4kn3jRkoez7CUsbKXglAEVoUmJlqtIqEA+WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjWnuuVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjWnuuVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABCB1F00893;
	Sat, 30 May 2026 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166068;
	bh=vRL0QZFyref9GWQMUMCql2MVNKy0Yqr4WOZ3kPyUya4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjWnuuVEv5jIkh9nDMgsSz2BIYKTKHi8srKwR68lY2/U6/UUiLHzzj3XvLyoJ+5R3
	 V8TMUwrwBb2uIfBPolwDdRBcRPRckREDWpwV8MDdGB03KtWlHKSyNexg532ovZOP0G
	 v4cklmt8vNkc++dmm59txCXmuYaIvKE+oBdyoZsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soufiane Dani <soufianeda@tutanota.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 264/589] staging: media: atomisp: Disallow all private IOCTLs
Date: Sat, 30 May 2026 18:02:25 +0200
Message-ID: <20260530160231.911314756@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


