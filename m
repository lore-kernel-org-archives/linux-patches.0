Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFCB1DE89D;
	Tue,  8 Oct 2024 12:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392120; cv=none; b=DqJBnxSOnG/jFsaWzBF1pwoed+lu8T4Uj314Pasgg9gcEwMKeZ2vG3HqM4xyL+mwrABlwu3u5lF1DEtI57op8PY8CC2VvW5qZdWWBQcIoqHEP+vtb9rt00/8f5cc8yKNv0Wx6xjQt1wzQFbffmOoOFVABzuZFxSyVXcBy1BqrzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392120; c=relaxed/simple;
	bh=RIud3jPCw/6Z+L5q6EY4azVHfn7l6dR8XPWNhpXPne4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTGBNSBflWLadSsCv/R2fyxw8Jqf3Av6OBnIC6V/Xtu9idm7rDF8/umB9g/f7y2m6INEt8LyhuVhNUC2U6k7U6h5YQCxHkDkhQiTvRJWb2GzS9QMtKbbmEKGxGWL1mlkmfjOYSAxDJWcoBpLkA6SUX2HXFvjC1I6z7Sl5lUsmAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yij45veL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yij45veL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D286C4CECD;
	Tue,  8 Oct 2024 12:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392120;
	bh=RIud3jPCw/6Z+L5q6EY4azVHfn7l6dR8XPWNhpXPne4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yij45veLFckR/1sEJjRDiayzQG4qEshL9fcdo3BjNISQv+9f9rOgnyTlNtltVbbOO
	 UXgGkuxJn9cMXR57RMGFijtdzNAff7HDwFON0aLDEVnsaVDcHkbIUIqZ5Dru39Z42g
	 STZMQaXNoIuOEX7lNM1iISsL+PgyerSPAsH0c0XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander F. Lent" <lx@xanderlent.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 322/558] accel/ivpu: Add missing MODULE_FIRMWARE metadata
Date: Tue,  8 Oct 2024 14:05:52 +0200
Message-ID: <20241008115714.978618082@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander F. Lent <lx@xanderlent.com>

[ Upstream commit 58b5618ba80a5e5a8d531a70eae12070e5bd713f ]

Modules that load firmware from various paths at runtime must declare
those paths at compile time, via the MODULE_FIRMWARE macro, so that the
firmware paths are included in the module's metadata.

The accel/ivpu driver loads firmware but lacks this metadata,
preventing dracut from correctly locating firmware files. Fix it.

Fixes: 9ab43e95f922 ("accel/ivpu: Switch to generation based FW names")
Fixes: 02d5b0aacd05 ("accel/ivpu: Implement firmware parsing and booting")
Signed-off-by: Alexander F. Lent <lx@xanderlent.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709-fix-ivpu-firmware-metadata-v3-1-55f70bba055b@xanderlent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_fw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_fw.c b/drivers/accel/ivpu/ivpu_fw.c
index de3d661163756..ede6165e09d90 100644
--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -60,6 +60,10 @@ static struct {
 	{ IVPU_HW_IP_40XX, "intel/vpu/vpu_40xx_v0.0.bin" },
 };
 
+/* Production fw_names from the table above */
+MODULE_FIRMWARE("intel/vpu/vpu_37xx_v0.0.bin");
+MODULE_FIRMWARE("intel/vpu/vpu_40xx_v0.0.bin");
+
 static int ivpu_fw_request(struct ivpu_device *vdev)
 {
 	int ret = -ENOENT;
-- 
2.43.0



