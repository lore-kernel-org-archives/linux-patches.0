Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FB434104B;
	Sat, 30 May 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160615; cv=none; b=IxuzbRXqmkOIbm2mRJ3i2tS99sIWpuIIaUpCf/nrOPe6HPiU3mKgbhW3es5jyA9mA/3SjU3qhE56wDFtVwFIrn30Gz422fpyPfXEtScLyuJUWJYHfqKbpZaJo1YZ69aVfT/kBKy34JP+j/0dMB0WRDwXdQ9UWLci++YOMzZi9EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160615; c=relaxed/simple;
	bh=90/0eQDqoKo2g4RMN0hX5QvDZsyahx+GkpVRPusZWHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO6kIz41zGTbjTOFHVtrho9k1PcsT8SuPO9MgAwLhJDPQzQUVzdKMQI2MrpvtRIaVV+FqT+CBXOkOLhvT4/RubQ0P4qHHgN+lp7HfjfO+qJ0yshXZZJgoEwzfAlGKb+AwhQZ0myyJbo4reSPPC8zpvVTCDRgtk2axYl+3tzEGLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8aYkghS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8aYkghS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A011F00893;
	Sat, 30 May 2026 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160614;
	bh=PCJNmevvN4XR1NVNAcFd5ST4MdjtI7JIiBzEmRYbFbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8aYkghS9FSV/adK4IL2nj7jsQJywat6z9GRMA1DoTpSpOJn9OpsOSJql0CZSOoX/
	 SnZL6C5xMRjrZaXGPzZhw1D5oX8pZGZWDEKVkGh6nRTYT9ugv5NVkVTR/AANqbT3Jr
	 uc6roL0eYb/elPxg/G5RhIhhardHqR+/sN9rvHZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soufiane Dani <soufianeda@tutanota.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 386/969] staging: media: atomisp: Disallow all private IOCTLs
Date: Sat, 30 May 2026 17:58:30 +0200
Message-ID: <20260530160310.965178924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2456,6 +2456,10 @@ static long atomisp_vidioc_default(struc
 	struct v4l2_subdev *motor;
 	int err;
 
+	/* Disable all private IOCTLs for now! */
+	if (cmd)
+		return -EINVAL;
+
 	if (!IS_ISP2401)
 		motor = isp->inputs[asd->input_curr].motor;
 	else


